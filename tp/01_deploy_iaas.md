Voici le tutoriel mis à jour avec l'installation de **Node.js et npm** à partir des paquets officiels de la distribution Linux.

---

# 📖 Tutoriel : Déploiement d’une application Node.js sur un serveur Linux

## 🛠 Prérequis
Avant de commencer, assurez-vous d’avoir :
- Un serveur Linux (Ubuntu, Debian, CentOS, etc.)
- Un accès SSH au serveur
- Un nom de domaine (optionnel)
- Un certificat SSL (optionnel, via Let's Encrypt)
- Un reverse proxy (optionnel, via Nginx)

---

## 📌 Étape 1 : Connexion au serveur
Connectez-vous à votre serveur via SSH :

```bash
ssh user@votre-ip-ou-domaine
```

Si vous utilisez une clé SSH :

```bash
ssh -i /chemin/vers/votre/clé.pem user@votre-ip-ou-domaine
```

---

## 📌 Étape 2 : Installation de Node.js et npm à partir des paquets de la distribution

### Vérifiez si Node.js est installé :
```bash
node -v
npm -v
```

Si ce n'est pas le cas, installez-le avec :

**Sur Ubuntu/Debian :**
```bash
sudo apt update
sudo apt install -y nodejs npm
```

**Sur CentOS/RHEL :**
```bash
sudo yum install -y epel-release
sudo yum install -y nodejs npm
```

Vérifiez que l’installation s’est bien déroulée :
```bash
node -v
npm -v
```

---

## 📌 Étape 3 : Cloner et installer l’application
Si votre code est sur GitHub, clonez-le dans le répertoire souhaité :

```bash
git clone https://github.com/votre-repo.git
cd votre-repo
```

Installez les dépendances :
```bash
npm install
```

Testez votre application localement :
```bash
node app.js
```
Si votre application utilise Express, vous verrez quelque chose comme :
```
Server running on port 3000
```

---

## 📌 Étape 4 : Exécuter l’application avec PM2
Pour assurer que votre application tourne en arrière-plan et redémarre après un crash, utilisez **PM2**.

Installez PM2 :
```bash
sudo npm install -g pm2
```

Lancez l’application :
```bash
pm2 start app.js --name mon-app
```

Vérifiez que l’application fonctionne :
```bash
pm2 list
```

Rendre l’application persistante après un redémarrage du serveur :
```bash
pm2 startup
pm2 save
```

---

## 📌 Étape 5 : Configurer un Reverse Proxy avec Nginx (Optionnel mais recommandé)
### Installer Nginx
```bash
sudo apt install nginx  # Ubuntu/Debian
sudo yum install nginx  # CentOS
```

### Configurer un hôte virtuel
Créez un fichier de configuration Nginx :
```bash
sudo nano /etc/nginx/sites-available/mon-app
```

Ajoutez la configuration suivante :
```nginx
server {
    listen 80;
    server_name votre-domaine.com;

    location / {
        proxy_pass http://127.0.0.1:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
```

Activez la configuration :
```bash
sudo ln -s /etc/nginx/sites-available/mon-app /etc/nginx/sites-enabled/
sudo nginx -t  # Vérifier s’il y a des erreurs
sudo systemctl restart nginx
```

---

## 📌 Étape 6 : Sécuriser avec SSL (Let’s Encrypt)
Si vous avez un nom de domaine, vous pouvez sécuriser votre application avec un certificat SSL gratuit via Let's Encrypt.

Installez Certbot :
```bash
sudo apt install certbot python3-certbot-nginx
```

Générez le certificat SSL :
```bash
sudo certbot --nginx -d votre-domaine.com
```

Renouvelez automatiquement les certificats :
```bash
sudo certbot renew --dry-run
```

---

## 📌 Étape 7 : Vérification et monitoring
Vérifiez que votre application fonctionne :
```bash
curl -I http://votre-domaine.com
```

Si vous rencontrez des problèmes, consultez les logs :
```bash
pm2 logs
sudo journalctl -u nginx --no-pager | tail -n 20
```

---

## 🎯 Conclusion
Vous avez maintenant une application Node.js qui fonctionne sur un serveur Linux avec gestion des processus (PM2), un reverse proxy (Nginx) et un certificat SSL (Let's Encrypt).

🎉 **Félicitations !** Votre application est en ligne et sécurisée. 🚀

---