```
Error from server (InternalError): an error on the server ("") has prevented the request from succeeding

```

- check your authentication info with `kubectl config view`

## IF Kubernetes keeps "starting"

- open a command line run `docker info`
- for kubernetes run `kubectl cluster-info` if thats not working because of the erro posted above^^^
- use this for more info `kubectl version --client`

Try updating kubectl

- first open Windows Powershell with Admin Privs
- then run `choco install kubernetes-cli`
- go back to docker go to the settings
- then to kubernetes and just reset it

## ImagePullBackOff

The status ImagePullBackOff means that a Pod couldn’t start because Kubernetes could not pull a container image. The ‘BackOff’ part indicates that Kubernetes will keep trying to pull the image, with an increasing back-off delay.

you can you `kubectl describe deployment <deploymentName>` for more info

## Remeber to rebuild a docker image!!

- if running into a issue where the containers arent running in kubernetes
- after making changes to any files you need to re-build the image and push to Docker Hub!!!

- use `docker build -t <username>/<imageName> .`
- then push it to dockerhub with `docker push <userName>/<imageName>`
- Then run `kubectl delete -f k8s`
- then `kubectl apply
