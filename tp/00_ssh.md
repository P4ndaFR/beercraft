Voici un tutoriel détaillé en français pour créer une clé SSH sous Linux.

---

# 📌 **Tutoriel : Générer une clé SSH sous Linux**

L'utilisation d'une clé SSH permet de sécuriser l'accès à des serveurs distants sans avoir à saisir de mot de passe à chaque connexion. Ce guide vous montrera comment générer une paire de clés SSH sous Linux et l’utiliser pour s’authentifier sur un serveur distant.

---

## 🛠 **1. Vérifier la présence de SSH sur votre système**
Avant de générer une clé SSH, assurez-vous que le package OpenSSH est installé. Ouvrez un terminal et tapez :

```bash
ssh -V
```

Si SSH est installé, vous verrez une version s'afficher, comme :

```
OpenSSH_8.2p1, OpenSSL 1.1.1f  31 Mar 2020
```

Si SSH n’est pas installé, vous pouvez l’installer avec :

- **Debian/Ubuntu** :
  ```bash
  sudo apt update && sudo apt install openssh-client -y
  ```
- **CentOS/RHEL** :
  ```bash
  sudo yum install openssh-clients -y
  ```
- **Arch Linux** :
  ```bash
  sudo pacman -S openssh
  ```

---

## 🔑 **2. Générer une paire de clés SSH**
Dans votre terminal, exécutez :

```bash
ssh-keygen -t rsa -b 4096 -C "votre_email@example.com"
```

### **Explication des options :**
- `-t rsa` : Utilise l'algorithme **RSA**, un standard en cryptographie.
- `-b 4096` : Spécifie une longueur de clé de **4096 bits** (plus sécurisé que la valeur par défaut de 2048 bits).
- `-C "votre_email@example.com"` : Ajoute un commentaire (facultatif), souvent utilisé pour identifier la clé.

### **Sortie attendue :**
```
Generating public/private rsa key pair.
Enter file in which to save the key (/home/user/.ssh/id_rsa):
```

Appuyez sur **Entrée** pour utiliser le chemin par défaut (`~/.ssh/id_rsa`) ou indiquez un autre chemin si vous voulez personnaliser l’emplacement.

### **3. Saisir une phrase de passe (optionnel)**
Le terminal demandera ensuite une phrase de passe :

```
Enter passphrase (empty for no passphrase):
```

- **Si vous laissez vide**, la connexion SSH se fera sans mot de passe (utile pour les automatisations).
- **Si vous entrez une phrase de passe**, vous devrez la saisir à chaque connexion SSH.

Une fois validé, la clé publique et privée seront créées :

```
Your identification has been saved in /home/user/.ssh/id_rsa.
Your public key has been saved in /home/user/.ssh/id_rsa.pub.
```

---

## 📂 **4. Vérifier les clés générées**
Vous pouvez lister les fichiers dans `~/.ssh/` pour voir vos clés :

```bash
ls -lh ~/.ssh/
```

Vous devriez voir :
```
-rw------- 1 user user 3.2K Feb 1 12:34 id_rsa
-rw-r--r-- 1 user user  746 Feb 1 12:34 id_rsa.pub
```

- **id_rsa** : Clé privée (ne jamais la partager !)
- **id_rsa.pub** : Clé publique (à partager avec les serveurs distants)

---

## 📤 **5. Ajouter la clé publique sur un serveur distant**
Pour utiliser votre clé SSH pour vous connecter à un serveur, ajoutez votre clé publique au fichier `~/.ssh/authorized_keys` du serveur distant.

Si vous avez accès au serveur via SSH, utilisez :

```bash
ssh-copy-id user@serveur-distant
```

Si `ssh-copy-id` n’est pas disponible, copiez manuellement la clé publique :

```bash
cat ~/.ssh/id_rsa.pub
```

Puis ajoutez son contenu dans `/home/user/.ssh/authorized_keys` sur le serveur distant :

```bash
echo "clé_publique_contenu" >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
```

---

## 🔗 **6. Tester la connexion SSH**
Essayez maintenant de vous connecter sans mot de passe :

```bash
ssh user@serveur-distant
```

Si tout est configuré correctement, vous serez directement connecté au serveur distant sans avoir à entrer de mot de passe !

---

## 🎯 **Conclusion**
Vous avez maintenant une paire de clés SSH fonctionnelle qui vous permet d’accéder à des serveurs de manière sécurisée. Cette méthode est utilisée dans de nombreux scénarios comme le déploiement d’applications, l’accès à des serveurs cloud (Clever Cloud, OVHcloud, AWS), ou encore l’authentification Git avec GitHub/GitLab.

🔒 **Bonus** : Pour améliorer la sécurité, vous pouvez utiliser un agent SSH pour éviter d’avoir à entrer votre phrase de passe à chaque connexion :

```bash
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
```

Cela stocke temporairement la clé en mémoire et vous évite de la saisir à chaque session.