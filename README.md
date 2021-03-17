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

# Build the application

1. Ensure your local Docker engine is started

- `docker ps`

2. Define an environment variable name set with the name of the application you generated in the previous section:

- `export <variableName>=<AppYouGeneratedInPreviousStep>`

3. change to the directory of the generated project

---

# Manually & From Scratch building a simple app and deploying with kubernetes

1. start by creating a K8s folder

2. create a client-deployment.yaml file use this template as a guide

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
          ports:
            - containerPort:
```

3. create a client-cluster-ip-service.yaml file use this template

```

```

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
- ## LoadBalancer:
- ## Ingress:
