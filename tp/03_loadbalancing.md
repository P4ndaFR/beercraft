Voici un tutoriel détaillé expliquant comment déployer Beercraft sur trois machines Ubuntu en utilisant Ansible. Le déploiement inclut :

- **Un serveur Load Balancer (Nginx)**
- **Deux serveurs d'application exécutant Beercraft avec PM2**
  
Ce tutoriel vous guidera étape par étape pour automatiser la configuration avec Ansible.

> **📝 Info :** Les étapes 1️⃣ à 4️⃣ sont à faire sur votre poste local !

---

### 📜 **Prérequis**
1. Trois machines Ubuntu accessibles via SSH.
2. Un utilisateur avec accès `sudo` sur chaque machine.
3. Ansible installé sur votre machine locale.

---

## **1️⃣ Préparer l'inventaire Ansible**
Créez un répertoire `beercraft-deploy` et un fichier d’inventaire Ansible.

```bash
mkdir beercraft-deploy && cd beercraft-deploy
nano inventory.ini
```

Ajoutez ceci :

```
[loadbalancer]
lb ansible_host=iaas-<N>-1.beercraft.cloud ansible_user=ubuntu

[appservers]
app1 ansible_host=iaas-<N>-2.beercraft.cloud ansible_user=ubuntu
app2 ansible_host=iaas-<N>-3.beercraft.cloud ansible_user=ubuntu

[all:vars]
ansible_python_interpreter=/usr/bin/python3
```

> Remplacez \<N\> par le numéro qui vous a été attribué en début de séance
---

## **2️⃣ Créer le Playbook pour les serveurs d’application**
Créez un fichier `appservers.yml` pour configurer les serveurs d’application :

```bash
nano appservers.yml
```

Ajoutez ceci :

```yaml
- hosts: appservers
  become: yes
  tasks:
    - name: Mettre à jour les dépots
      apt:
        update_cache: yes

    - name: Installer Node.js et PM2
      shell: |
        apt install -y nodejs npm
        npm install -g pm2

    - name: Cloner le dépôt Beercraft
      git:
        repo: 'https://github.com/P4ndaFR/beercraft.git'
        dest: /home/ubuntu/beercraft
        version: main

    - name: Installer les dépendances
      shell: |
        cd /home/ubuntu/beercraft
        npm install

    - name: Démarrer l'application avec PM2
      shell: |
        cd /home/ubuntu/beercraft
        pm2 start index.js --name beercraft --no-autorestart
        pm2 startup
        pm2 save
```

---

## **3️⃣ Créer le Playbook pour le Load Balancer**
Créez un fichier `loadbalancer.yml` :

```bash
nano loadbalancer.yml
```

Ajoutez ceci :

```yaml
- hosts: loadbalancer
  become: yes
  tasks:
    - name: Installer Nginx
      apt:
        name: nginx
        state: present

    - name: Configurer Nginx comme Load Balancer
      copy:
        dest: /etc/nginx/sites-available/beercraft
        content: |
          upstream beercraft {
              server iaas-<N>-2.beercraft.cloud:3000;
              server iaas-<N>-3.beercraft.cloud:3000;
          }

          server {
              listen 80;
              server_name iaas-<N>-1.beercraft.cloud;

              location / {
                  proxy_pass http://beercraft;
                  proxy_set_header Host $host;
                  proxy_set_header X-Real-IP $remote_addr;
                  proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              }
          }

    - name: Redémarrer Nginx
      systemd:
        name: nginx
        state: restarted
```

> Remplacez \<N\> par le numéro qui vous a été attribué en début de séance

---

## **4️⃣ Exécuter Ansible pour déployer Beercraft**
Ajoutez vos serveurs à `~/.ssh/config` pour un accès facile :

```bash
Host lb
    HostName iaas-<N>-1.beercraft.cloud
    User ubuntu

Host app1
    HostName iaas-<N>-2.beercraft.cloud
    User ubuntu

Host app2
    HostName iaas-<N>-3.beercraft.cloud
    User ubuntu
```

> Remplacez \<N\> par le numéro qui vous a été attribué en début de séance

Désactivez la verification de la clé :
```
export ANSIBLE_HOST_KEY_CHECKING=False
```

Vérifiez la connexion SSH :

```bash
ansible all -m ping -i inventory.ini
```

Si tout fonctionne, exécutez les playbooks :

```bash
ansible-playbook -i inventory.ini appservers.yml
ansible-playbook -i inventory.ini loadbalancer.yml
```

---

## **5️⃣ Tester le déploiement**
Lancer la commande suivante sur le serveur du Load Balancer pour vérifier que celui-ci redirige bien les requêtes :

```
sudo tcpdump dst port 3000
```

Accédez à l’IP du Load Balancer dans un navigateur :

```
http://iaas-<N>-1.beercraft.cloud
```
> Remplacez \<N\> par le numéro qui vous a été attribué en début de séance

Vous devriez voir votre application Beercraft fonctionner, équilibrée entre les deux serveurs d'application !

---

### 🎯 **Conclusion**
Ce tutoriel a montré comment :
✅ Configurer Ansible pour automatiser l’installation  
✅ Déployer Beercraft sur deux serveurs avec PM2  
✅ Configurer un Load Balancer Nginx  