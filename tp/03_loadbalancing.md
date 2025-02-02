Voici un tutoriel détaillé expliquant comment déployer Beercraft sur trois machines Ubuntu en utilisant Ansible. Le déploiement inclut :

- **Un serveur Load Balancer (Nginx)**
- **Deux serveurs d'application exécutant Beercraft avec PM2**
  
Ce tutoriel vous guidera étape par étape pour automatiser la configuration avec Ansible.

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
lb ansible_host=IP_DU_LOADBALANCER ansible_user=ubuntu

[appservers]
app1 ansible_host=IP_SERVEUR_APP_1 ansible_user=ubuntu
app2 ansible_host=IP_SERVEUR_APP_2 ansible_user=ubuntu

[all:vars]
ansible_python_interpreter=/usr/bin/python3
```

Remplacez `IP_DU_LOADBALANCER`, `IP_SERVEUR_APP_1` et `IP_SERVEUR_APP_2` par les IP réelles de vos machines.

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
    - name: Mettre à jour le système
      apt:
        update_cache: yes
        upgrade: yes

    - name: Installer Node.js et PM2
      shell: |
        curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
        apt install -y nodejs
        npm install -g pm2

    - name: Cloner le dépôt Beercraft
      git:
        repo: 'https://github.com/VOTRE_REPO_GIT/beercraft.git'
        dest: /home/ubuntu/beercraft
        version: main

    - name: Installer les dépendances
      shell: |
        cd /home/ubuntu/beercraft
        npm install

    - name: Démarrer l'application avec PM2
      shell: |
        cd /home/ubuntu/beercraft
        pm2 start server.js --name beercraft
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
        dest: /etc/nginx/sites-available/default
        content: |
          upstream beercraft {
              server IP_SERVEUR_APP_1:3000;
              server IP_SERVEUR_APP_2:3000;
          }

          server {
              listen 80;

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

Remplacez `IP_SERVEUR_APP_1` et `IP_SERVEUR_APP_2` par leurs adresses IP respectives.

---

## **4️⃣ Exécuter Ansible pour déployer Beercraft**
Ajoutez vos serveurs à `~/.ssh/config` pour un accès facile :

```bash
Host lb
    HostName IP_DU_LOADBALANCER
    User ubuntu

Host app1
    HostName IP_SERVEUR_APP_1
    User ubuntu

Host app2
    HostName IP_SERVEUR_APP_2
    User ubuntu
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
Accédez à l’IP du Load Balancer dans un navigateur :

```
http://IP_DU_LOADBALANCER
```

Vous devriez voir votre application Beercraft fonctionner, équilibrée entre les deux serveurs d'application !

---

### 🎯 **Conclusion**
Ce tutoriel a montré comment :
✅ Configurer Ansible pour automatiser l’installation  
✅ Déployer Beercraft sur deux serveurs avec PM2  
✅ Configurer un Load Balancer Nginx  