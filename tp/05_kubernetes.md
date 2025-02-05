### 📌 **Prérequis**
Avant de commencer, assurez-vous d’avoir :
- Un cluster **Kubernetes** opérationnel (**AKS, GKE, EKS, Kind, etc.**).
- **kubectl** installé et configuré pour interagir avec votre cluster.
- Un **Ingress Controller** installé (**ex : Nginx**).
- Un accès à **Docker Hub** pour récupérer l’image.
- Un **numéro unique N** attribué pour personnaliser votre déploiement.

**Installation `kubectl` :**

On peut installer kubectl de cette manière *([doc kubernetes](https://kubernetes.io/fr/docs/tasks/tools/install-kubectl/))*:

```sh
curl -LO https://dl.k8s.io/release/$(curl -Ls https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl
chmod u+x kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
```

L'executable `kubectl` nécessite une configuration *(`kubeconfig.yml` envoyé par mail)*.  
Pour passer ce fichier de configuration au programme, il faut soit la déplacer vers `~/.kube/config` *(configuration par défaut)* :

```sh
mv chemin/vers/kubeconfig.yml ~/.kube/config
```

Soit le passer en argument au programme :

```sh
export KUBECONFIG=chemin/vers/kubeconfig.yml
```

> **⚠️ Attention:** Ne pas oublier d'ajouter ce paramètre dans la suite du TP si on passe le kubeconfig en paramètre.  
On considère pour la suite que cette configuration est la configuration par défaut.

---

## 🚀 **Étape 1 : Créer un Namespace personnalisé**
Il est recommandé d’organiser les ressources Kubernetes en **namespace**. Chaque utilisateur doit utiliser un namespace **beercraft-N**, où **N** est le numéro qui lui a été attribué.

🔹 **Exemple : Si votre numéro est *5*, utilisez `beercraft-5`.**  
🔹 **Adaptez le namespace dans toutes les commandes et fichiers YAML ci-dessous.**

```sh
kubectl create namespace beercraft-N
```

Exemple pour **N = 5** :

```sh
kubectl create namespace beercraft-5
```

---

## 🏗 **Étape 2 : Déployer BeerCraft avec un Deployment**
Un **Deployment** assure que notre application tourne en tant que pod répliqué.

📌 **Fichier `deployment.yaml`** : (Remplacez **N** par votre numéro)

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: beercraft
  namespace: beercraft-N
  labels:
    app: beercraft
spec:
  replicas: 2
  selector:
    matchLabels:
      app: beercraft
  template:
    metadata:
      labels:
        app: beercraft
    spec:
      containers:
        - name: beercraft
          image: p4ndafr/beercraft:latest
          ports:
            - containerPort: 3000
```

Appliquer le fichier :

```sh
kubectl apply -f deployment.yaml
```

---

## 🌍 **Étape 3 : Exposer BeerCraft avec un Service**
Un **Service** de type ClusterIP permet la communication interne entre les composants de Kubernetes.

📌 **Fichier `service.yaml`** :

```yaml
apiVersion: v1
kind: Service
metadata:
  name: beercraft-service
  namespace: beercraft-N
spec:
  selector:
    app: beercraft
  ports:
    - protocol: TCP
      port: 3000
      targetPort: 3000
```

Appliquer le fichier :

```sh
kubectl apply -f service.yaml
```

---

## 🌐 **Étape 4 : Configurer l'Ingress**
L’**Ingress** permet d’exposer l’application BeerCraft à l’extérieur du cluster sous l’URL **n.kubernetes.beercraft.cloud**, où **N** est votre numéro attribué.

📌 **Fichier `ingress.yaml`** :

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: beercraft-ingress
  namespace: beercraft-N
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  ingressClassName: nginx
  rules:
    - host: N.kubernetes.beercraft.cloud
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: beercraft-service
                port:
                  number: 3000
```

Appliquer le fichier :

```sh
kubectl apply -f ingress.yaml
```

Exemple pour **N = 5** : l’application sera accessible sur **5.kubernetes.beercraft.cloud**.

---

## 🔍 **Étape 5 : Vérifier le Déploiement**
1. **Vérifiez que tous les pods sont en cours d'exécution :**
   ```sh
   kubectl get pods -n beercraft-N
   ```

2. **Vérifiez que le service est actif :**
   ```sh
   kubectl get svc -n beercraft-N
   ```

3. **Vérifiez l’Ingress :**
   ```sh
   kubectl get ingress -n beercraft-N
   ```

4. **Testez l'accès à votre application :**
   ```sh
   curl http://N.kubernetes.beercraft.cloud
   ```
   Ou ouvrez un navigateur et accédez à `http://N.kubernetes.beercraft.cloud`.

---

## 🎯 **Conclusion**
Félicitations 🎉 ! Vous avez réussi à déployer **BeerCraft** sur **Kubernetes** et à l’exposer via un **Ingress** personnalisé.

**Prochaine étape** : Ajouter un certificat TLS avec Let's Encrypt pour sécuriser l’accès.

Si vous avez des questions, n’hésitez pas ! 🚀🍻