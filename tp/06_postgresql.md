# 📌 **Tutoriel : Se connecter à PostgreSQL et exécuter un fichier SQL (`source.sql`)**

## 🔹 **1. Prérequis**
✅ **PostgreSQL** est installé sur votre machine  
✅ La **base de données existe déjà** (ex: `ma_base`)  
✅ Vous avez un **utilisateur avec un mot de passe** (ex: `user_admin`)  
✅ Vous possédez un fichier **SQL** (`source.sql`) contenant les requêtes à exécuter  

---

## 🔹 **2. Se connecter à PostgreSQL via la ligne de commande (`psql`)**

Ouvrez un terminal et utilisez la commande suivante pour vous connecter avec authentification :  
```bash
psql -U user_admin -d ma_base -h localhost -W
```
🔹 **Explication des options :**  
- `-U user_admin` ➝ Se connecter avec l'utilisateur **user_admin**  
- `-d ma_base` ➝ Se connecter à la base de données **ma_base**  
- `-h localhost` ➝ Se connecter au serveur PostgreSQL local  
- `-W` ➝ Demande le mot de passe de l'utilisateur  

Vous serez invité à entrer votre mot de passe 🔑.  

---

## 🔹 **3. Exécuter le fichier SQL (`source.sql`)**

Si votre fichier `source.sql` est situé dans `/home/user/Documents/`, exécutez la commande suivante :
```bash
psql -U user_admin -d ma_base -h localhost -W -f /home/user/Documents/source.sql
```
📌 **Explication des options supplémentaires :**  
- `-f source.sql` ➝ Exécute le script SQL contenu dans `source.sql`

✅ **Une fois exécuté, le script appliquera ses modifications à la base de données.**  

---

## 🔹 **4. Vérifier l'exécution**
### 🔍 **Lister les tables**
Dans `psql`, utilisez la commande suivante :
```sql
\dt
```
📌 Cela affichera toutes les tables présentes dans `ma_base`.

### 📜 **Vérifier les données**
Si `source.sql` a inséré des données, vérifiez-les avec :
```sql
SELECT * FROM nom_de_la_table;
```

---

## ✅ **Conclusion**
🚀 Vous avez maintenant appris à :  
🔹 Se connecter à PostgreSQL avec authentification  
🔹 Exécuter un fichier SQL pour appliquer des modifications  
🔹 Vérifier l'exécution avec des commandes SQL  