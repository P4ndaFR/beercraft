Voici un `Dockerfile` qui déploie **Beercraft** sans Nginx. Il utilise uniquement **Node.js** pour servir l’application.

---

### 📌 **Dockerfile**
Ce fichier :
1. **Installe les dépendances**
2. **Construit l’application**
3. **Démarre un serveur léger avec Node.js (serveur intégré ou Express)**

---

```dockerfile
# Étape 1 : Construire l'application avec Node.js
FROM node:18 AS builder

# Définir le répertoire de travail
WORKDIR /app

# Copier les fichiers package.json et package-lock.json
COPY package.json package-lock.json ./

# Installer les dépendances
RUN npm install

# Copier le reste des fichiers
COPY . .

# Étape 2 : Exécuter l'application avec Node.js
FROM node:18

# Définir le répertoire de travail
WORKDIR /app

# Copier les fichiers générés depuis l'étape précédente
COPY --from=builder /app ./

# Exposer le port de l'application (ajuster si nécessaire)
EXPOSE 3000

# Démarrer l'application
CMD ["npm", "start"]
```

---

### 📌 **Instructions de Build et de Déploiement**
1. **Construire l’image Docker :**
   ```sh
   docker build -t beercraft .
   ```
   Si vous avez un problème avec `Docker` sur Ubuntu, installer sur un Windows. Vous pouvez effectuer les commande suivantes :
   Installe docker :
   ```sh
   sudo apt install docker.io
   ```
   Active le service docker :
   ```sh
   sudo /etc/init.d/docker start
   ```

2. **Lancer le conteneur :**
   ```sh
   docker run -d -p 3000:3000 --name beercraft beercraft
   ```
3. **Accéder à l’application :**
   - Ouvrir **http://localhost:3000** dans le navigateur.

---
