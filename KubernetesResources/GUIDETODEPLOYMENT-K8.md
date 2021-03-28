# CloudDeployment

A Step by step guide on setting up a simple program and deploying to a Kubernetes environment.

### Deleteing a docker image

- `docker rmi <imageName> --force`

---

# Manually & From Scratch building a simple app and deploying with kubernetes

1. start by creating a K8s folder
2. build your images
3. create a `client-deployment.yaml` file use this template as a guide

```yaml
apiVersion: apps/v1 # selecting the api version we want to use, we want to us an object defined as v1 in app
kind: Deployment # specify the kind of object we want to use in this deployment,we are making an object type of "Deployment"
metadata:
  name: client-deployment #names the object that will be created by this config file
spec: # going to configure this deployment
  replicas: 3 #specfiing the number of different pods this deployment is to make
  selector: #gives us a handle on the label inside the template
    matchLabels:
      component: web # what it will be managing
  template: #Below we are listing the config that will be used for every pod created by this deployment
    metadata:
      labels:
        component: web
    spec: ## below listing every Pod controlled by this deployment
      containers:
        - name: client
          image: unusualcaspento/multi-client
          ports:
            - containerPort: 3000 # this will be the port that is mapped up to the "multi-client" image
```

3. create a `client-cluster-ip-service.yaml` file use this template

```yaml
apiVersion: v1
kind: Service
metadata:
  name: client-cluster-ip-service
spec:
  type: ClusterIP
  selector:
    component: web
  ports:
    - port: 3000
      targetPort: 3000
```

4. create a `server-deployment.yaml` for Express API Deployment Config use this template

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: server-deployment
spec:
  replicas: 3
  selector:
    matchLabels:
      component: server # indicates that this will be the server
  template:
    metadata:
      labels:
        component: server # remember it has to match
    spec:
      containers:
        - name: server
          image: unusualcaspento/multi-server
          ports:
            - containerPort: 5000
```

5. Create a file called `server-cluster-ip-service.yaml` a Cluster IP for the Express API use this template

```yaml
apiVersion: v1
kind: Service
metadata:
  name: server-cluster-ip-service
spec:
  type: ClusterIP
  selector:
    component: server
  ports:
    - port: 5000
      targetPort: 5000
```

- make sure you have an image built or this wont work when kubernetes trys to pull the image
- you can check the statuses of the pods, deployments, services with `kubectl get <ObjectType>`
- then you can check the status of the object type with `kubectl logs <objectName>`

6. Create a file called `worker-deployment.yaml` You can you this template

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: worker-deployment
spec:
  replicas: 1 #this needs to be scaled
  selector:
    matchLabels:
      component: worker
  template:
    metadata:
      labels:
        component: worker
    spec:
      containers:
        - name: worker
          image: unusualcaspento/multi-worker # replace this with your own <dockerId>/<ImageName>
```

- after that make sure you add it by running `kubectl apply -f <folderName>`

7. create a file called `redis-deployment.yaml` use the template below

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: redis-deployment
spec:
  replicas: 1 # we only want to have one version of it
  selector:
    matchLabels:
      component: redis
  template:
    metadata:
      labels:
        component: redis
    spec:
      containers:
        - name: redis
          image: redis
          resources:
            limits:
              memory: "128Mi"
              cpu: "500m"
          ports:
            - containerPort: 6379 # default port of redis
```

8. create a file called `redis-cluster-ip-service.yaml` use the template below

```yaml
apiVersion: v1
kind: Service
metadata:
  name: redis-cluster-ip-service
spec:
  type: ClusterIP
  selector:
    component: redis
  ports:
    - port: 6379
      targetPort: 6379
      #no need to change the  target port unless its like a nginx server thats supposed redirect to server web traffic on port 80
```

- run `kubectl apply -f <FolderName>` again "<folderName>' is just used to apply all the files in the folder path
- later on we might want to use a different method by decribing the exact file path instead

9. create a file called `postgres-deployment.yaml` use the template below

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: postgres-deployment
spec:
  replicas: 1 # you cant have more then 2 because having two different DB's access the same filesytem without them knowing they have their hands inside the same volume or it will break
  selector:
    matchLabels:
      component: postgres
  template:
    metadata:
      labels:
        component: postgres
    spec:
      volumes:
        - name: postgres-storage
          persistentVolumeClaim:
            claimName: database-persistent-volume-claim
      containers:
        - name: postgres
          image: postgres
          resources:
            limits:
              memory: "2Gi"
              cpu: "500m"
          ports:
            - containerPort: 5432
          volumeMounts:
            - mountPath: /var/lib/postgresql/data
              name: postgres-storage
              subPath: postgres # overwrites the default  and saves the data into a file  called postgres
```

- run `kubectl get pv` to get the persistent Volume that are created
- run `kubectl get pvc` to get all the persistent Volume claims created \*\* think of it as an advertisement
- ## The PostGres Deployment
- inside of the deployment is a pod
- inside the pod is a postgres container
  - inside the postgres container is a File system for Container

10. create a file called `postgres-cluster-ip-service.yaml` use the template below

```yaml
apiVersion: v1
kind: Service
metadata:
  name: postgres-cluster-ip-service
spec:
  type: ClusterIP
  selector:
    component: postgres
  ports:
    - port: 5432
      targetPort: 5432
```

11. create a file called `database-persistent-volume-claim.yaml` you this template below

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: database-persistent-volume-claim
spec:
  resources:
    requests:
      storage: 2Gi
  accessModes:
    - ReadWriteOnce
```

- AccessModes ^^
  - `ReadWriteOnce` can be used by a single node
  - `ReadOnlyMany` Mutliple nodes can read from this
  - `ReadWriteMany` Can be read and written to by many nodes

12. run the command `kubectl get storageclass`
13. Add Environmental Variables to Config
14. ## Setting Up Ingress with Docker

- excute the command noted [here](https://kubernetes.github.io/ingress-nginx/deploy/#docker-for-mac)
  - yes it works for both mac and windows
  - here it is as well if you dont want to open up a link
    `kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.44.0/deploy/static/provider/cloud/deploy.yaml`
  - After Verify the service was enabled by runnign the following
    - `kubectl get pods -n ingress-nginx`

15. create a new file called `ingress-service.yaml` use this template below

```yaml
apiVersion: networking.k8s.io/v1beta1
kind: Ingress
metadata:
  name: ingress-service
  annotations:
    kubernetes.io/ingress.class: nginx #tells kubernetes we want to create a ingress controller based on the nginx
    nginx.ingress.kubernetes.io/use-regex: "true"
    nginx.ingress.kubernetes.io/rewrite-target: /$1 # configures how our copy on nginx behaves
spec:
  rules:
    - http:
        paths:
          - path: /?(.*)
            backend:
              serviceName: client-cluster-ip-service
              servicePort: 3000
          - path: /api/?(.*)
            backend:
              serviceName: server-cluster-ip-service
              servicePort: 5000
```

16. create a `.travis.yml` in the root of the directory use the template below

```yaml
services:
  - docker
before_install:
  - openssl aes-256-cbc -K $<EncryptedKey> -iv $<EncryptedIv> -in super_secret.txt.enc -out super_secret.txt -d
  - curl https://sdk.cloud.google.com | bash > /dev/null; # the curll will download from the cloud then pass it to bash to install
  - source $HOME/google-cloud-sdk/path.bash.inc
  - gcloud components update kubectl
  - gcloud auth activate-service-account --key-file service-account.json # actiavtes a service account then provide a set of credentials that will be placed into the service-account.json
  - gcloud config set project centered-motif-308015 # project id not the name
  - gcloud config set compute/zone us-east4-b # setting the google cloud zone
  - gcloud container clusters get-credentials multi-cluster
  - echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
  - docker build -t unusualCaspento/react-test -f ./client/Dockerfile.dev ./client
script:
  - docker run -e CI=true unusualCaspento/react-test npm test #how start the test

  #kubernetes doesnt have a provider so we make one from scratch
deploy:
  provider: script
  script: bash ./deploy.sh
  on:
    branch: main
```

17. create a `deploy.sh` in the root of the directory use the template below

```sh
docker build -t unusualcaspento/multi-client:latest -t unusualcaspento/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t unusualcaspento/multi-server -f ./server/Dockerfile ./server
docker build -t unusualcaspento/multi-worker -f ./worker/Dockerfile ./worker
#push the images
docker push unusualcaspento/multi-client:latest
docker push unusualcaspento/multi-server:latest
docker push unusualcaspento/multi-worker:latest

docker push unusualcaspento/multi-client:$SHA
docker push unusualcaspento/multi-server:$SHA
docker push unusualcaspento/multi-worker:$SHA
# and now apply all the config files
kubectl apply -f k8s
#set an image forcibly or imperatively
kubectl set image deployments/server-deployment server=unusualcaspento/multi-server:$SHA #I can use a $GIT_SHA if i didnt tag the image with latest
kubectl set image deployments/client-deployment client=unusualcaspento/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=unusualcaspento/multi-worker:$SHA
```

18. Configuring GCloud CLI on Cloud Console

- manually creating a secret for the gCloud
- run the command ` kubectl create secret generic <secret_name> --from-literal PGPASSWORD=<passwordYouChoose>`
- or go to cloud shell and run
  - `gcloud config set project <projectId>`
  - `glcoud config set compute/zone <YourZoneId>`
  - `gcloud container clusters get-credentials`
    Now we can use kubectl in the googleCloud Shell
    then run ` kubectl create secret generic <secret_name> --from-literal PGPASSWORD=<passwordYouChoose>`
    - the secertname is pgpassword
    - refresh the page and check the Configuration it should be there on the page

19. Install Helm v3 on the Google CLI

- run the following

```
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
```

click [here](https://helm.sh/docs/intro/install/#from-script) for docs

---

20. Install Ingress-Nginx

```helm

helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm install my-release ingress-nginx/ingress-nginx

```

if you get an error such as chart requries kubeVersion: >=1.16.0-0

- run the command in the google cli
  - `glcoud container clusters upgrade <YourClusterName> --main --cluster-version 1.16`
    here are links to some docs
    [google](https://cloud.google.com/kubernetes-engine/docs/how-to/upgrading-a-cluster)
    [kubernetes](https://kubernetes.github.io/ingress-nginx/deploy/#using-helm)

21. You can watch the status
    -by running `kubectl --namespace default get services -o wide -w my-release-ingress-nginx-controller`
22. Role Based Access Control (RBAC)

## when ready to check

- run `kubectl apply -f k8s`
  - note when I just use the k8s directory it applys to all the files inside the folder

## Extra Notes

- Pods:
  - run one or more closely related containers
- Services:
  - sets up networking in Kubernetes Cluster
- ClusterIP:
  - Exposes a set of pods to other objects in the cluster
- NodePort:

  - Exposes a set of pods to the outside world( only good for dev purposes!!)

- ## Volume
- "volume" in generic container terminology
  - Some type of mechanism that allows a container to access a filesysytem outside itself
- "volume" in KUBERNETES
  - an Object that allows a container to store data at the pod level

```md
- we want these
  - Persistant Volume Claim
  - Persistant Volume
- we dont want this for data that neeeds to last
  - Volume(not exactly the same thing as a Docker Volume)
```

THe differences between a Persistant

- ## Secrets
  - Securely stores a piece of information in the cluster , such as a database password

## Creating a Secret

- run the command `kubectl create secret generic <secret_name> --from-literal key=value`
  - the `'create'` is an imperative command to create a new object
  - the `'secret'` is the Type of object we are going to create
  - the `'generic'` is the type of secret
  - the `'<secret_name>'` Name of secret, for later reference in a pod config
  - the `'--from-literal'` means we are going to add the secret information into this command, as opposed to from . file
  - the `'key=value'` is Key-value pair of the secret information
    you can check your secrets with `kubectl get secrets`
- ## LoadBalancer:
  - Legacy way of getting network traffic into a cluster
- ## Ingress:
  - Exposes a set of services to the outside world
  - its better then a loadbalancer
    allows outside users to access all the different pods that are running containers that they need
  - using a nginx ingress
  - use ingress-nginx here is the [github](https://github.com/kubernetes/ingress-nginx) use this one!!
    not kubernetes-ingress the [github](https://github.com/nginxinc/kubernetes-ingress) - is a seperate project that does the same thing led by the company
    the setup of ingress-nginx changes depending on you environment(local, GC, AWS, Azure)
    Ingress routing rules to get traffic to services to a Controller for our Ingress
  - Constantly works to make sure these routing rules are setup
- the Ingress Config
  - object that has a set of configuration rules describing how traffic should be routed
- Ingress Controller
  - watches for changes to the ingress and updates the "thing" that handles traffic

---

## Kubernetes Production Deployment

1. create a Github
2. Tie repo to Travis Ci
3. Create a Google Cloud project
4. Enable billing for the Project ! important for it to work (MAKE SURE TO DELETE AFTER!!)
5. add deployment scripts to the repo
