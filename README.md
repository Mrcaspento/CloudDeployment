# CloudEngineerTestTemplate

A Step by step guide on setting up a simple program and deploying to a Kubernetes environment.

# First step

- Get the client, server, and worker folders ready from a previous repo

# Setting Up the IbmCloud & having it autoGen a application

1. first make sure you are signed up on IBM with an account
2. follow this link to make sure you have the ibm cli [click here](https://cloud.ibm.com/docs/cli?topic=cli-getting-started#step1-install-idt)
3. once installed login inside yout terminal with `ibmcloud login`
4. Then make sure you target a resource group, whcih is usually `Default` or `default`(case-sensitive)
   - `imbcloud target -g Default`
     or
   - `ibmcloud target -g default`
5. you can use a kubernetes starter kit running the command `ibmcloud dev create` into a directory of your choice just follow the prompts
   - Select Backend Service / Web App > Node> Node.js Express App.
   - Enter a unique name for your application such as <your-initials>kubeapp.
   - Select the resource group where your cluster has been created. This might happen automatically.
   - Do not add additional services.
   - Do not add a DevOps toolchain, select manual deployment.
   - Choose "Deploy to Helm-based Kubernetes containers"

- Enabling command parameters

  - config file `imbcloud dev enable --config-file <configFileName>`
    - specify a `cli-config.yaml` file to use for a command
  - force `ibmcloud dev enable -f|--force`
    - parameter that is used to force a reenabling an already enabled app
  - language `ibmcloud dev enable -l|--language <language>`
    - parameter that is used to specify the langugage of the app to be enabled
  - trace `ibmcloud dev enable --trace`
    - use this parameter to provide vebose output
  - get-credintials `ibmcloud dev get-credentails --trace`
    - use this parameter to provide verbose output

- ## List all IBM Cloud apps in a resource group
  - run the following comand `ibmcloud dev lists`

---

# Build the application with IBMCloud

1. Ensure your local Docker engine is started

- `docker ps`

2. Define an environment variable name set with the name of the application you generated in the previous section:

- `export <variableName>=<AppYouGeneratedInPreviousStep>`

3. change to the directory of the generated project

---

# Manually & From Scratch building a simple app and deploying with kubernetes

1. start by creating a K8s folder

2. create a `client-deployment.yaml` file use this template as a guide

```yaml
apiVersion:
kind:
metadata:
  name:
spec:
  replicas:
  selector:
    matchLabels:
      component:
  template:
    metadata:
      labels:
        component:
    spec:
      containers:
        - name:
          image:
          resources: # this is need to prevent a resource limit error
            limits:
              memory:
              cpu:
          ports:
            - containerPort:
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
  replicas: 1
  selector:
    matchLabels:
      component: postgres
  template:
    metadata:
      labels:
        component: postgres
    spec:
      containers:
        - name: postgres
          image: postgres
          resources:
            limits:
              memory: "128Mi"
              cpu: "500m"
          ports:
            - containerPort: 5432
```

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

- ## LoadBalancer:
- ## Ingress:
