# "latest" tag to make sure that if we ever have to re-clone or rebuild our cluster we always know that the latest tag image is truly the latest version, because the deployment config files are always taking the "latest" images
# "$SHA" tag (the value of the SHA environment variable) to make sure that we can correctly update stuff in production inside of our cluster
docker build -t alejotem11/multi-client:latest -t alejotem11/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t alejotem11/multi-server:latest -t alejotem11/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t alejotem11/multi-worker:latest -t alejotem11/multi-worker:$SHA -f ./worker/Dockerfile ./worker
# we already logged in to docker (in the before_install stage) so we don't have to login again to push the images off to docker hub
docker push alejotem11/multi-client:latest
docker push alejotem11/multi-server:latest
docker push alejotem11/multi-worker:latest

docker push alejotem11/multi-client:$SHA
docker push alejotem11/multi-server:$SHA
docker push alejotem11/multi-worker:$SHA
# we make Google Cloud in charge the kubectl in the before_install stage
kubectl apply -f k8s
# Imperatively set latest images on each deployment:
# To force pods to re-pull an image without changing the image tag (to get the latest image), is a big issue due kubernetes does not see changes in the configuration file, so it does nothing. For that reason we use the $SHA tag, to be able to update the pods of our cluster with the latest image
kubectl set image deployment/client-deployment client=alejotem11/multi-client:$SHA
kubectl set image deployment/server-deployment server=alejotem11/multi-server:$SHA
kubectl set image deployment/worker-deployment worker=alejotem11/multi-worker:$SHA