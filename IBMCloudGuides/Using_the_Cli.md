# Deploying a Simple Application Using the CLI

---

## !!NOTE THE TEMPLATES BELOW ARE NOT USED AT ALL IN THIS REPO!

---

First delete any previous deployments just so its easier to keep track of everything.
And if your like me and have only 2Gbs of memory cause you got a budget laptop with only 128Gbs of hard drive space.
Your in luck with the cloud you install programs to containers and run them out of it.

- `kubectl delte deployments <deploymentName>`
- then create a Yaml file called `webserver.yaml` with the following

```yml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: webserver
  labels:
    app: nginx
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
        - name: nginx
          image: nginx:alpine
          ports:
            - containerPort: 80
```

- using kubectl, we will create the Deployment from the YAml CONFIG FILE. using the -f option with the kubectl create command, we can pass a YAMl file as an object's specification, or a URL to a configuration file from the web. In the following example, we are creating a webserver Deployment:

- `kubectl create -f webserver.yaml`
- This will also create a ReplicaSet and Pods, as defined in the Yaml configuration file.
- kubectl get replicasets
- kubectl get pods

- create a `webserver-svc.yaml file using the template below

```yml
apiVersion: v1
kind: Service
metadata:
  name: web-service
  labels:
    run: web-service
spec:
  type: NodePort
  ports:
    - port: 80
      protocol: TCP
  selector:
    app: nginx
```

- Using kubectl create the Service -`kubectl create -f webserver-svc.yaml`
- Expose a Deployment with the `kubectl expose` command:
- `kubectl expose deployment webserver --name=web-service --type=NodePort`
- List the Services
- `kubectl get services`
- to get more details about the Service
- run `kubectl describe service web-service`

## Liveness Command

-in the following example, liveness command is checking the existence of a file `/tmp/healthy`

```yml
apiVersion: v1
kind: Pod
metadata:
  labels:
    test: liveness
  name: liveness-exec
spec:
  containers:
    - name: liveness
      image: k8s.gcr.io/busybox
      args:
        - /bin/sh
        - -c
        - touch /tmp/healthy; sleep 30; rm -rf /tmp/healthy; sleep 600
      livenessProbe:
        exec:
          command:
            - cat
            - /tmp/healthy
        initialDelaySeconds: 3
        failureThreshold: 1
        periodSeconds: 5
```

- The existence of the `/tmp/healthy` file is configured to be checked every 5 seconds using the periodSeconds parameter. The initialDelaySeconds parameter requests the kubelet to wait for 3 seconds before the first probe. When running the command line argument to the container, we will first create the `/tmp/healthy file`, and then we will remove it after 30 seconds. The removal of the file would trigger a probe failure, while the failureThreshold parameter set to 1 instructs kubelet to declare the container unhealthy after a single probe failure and trigger a container restart as a result.
