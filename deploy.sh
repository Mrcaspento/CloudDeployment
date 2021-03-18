# Building images
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