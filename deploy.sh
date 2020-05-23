#!/usr/bin/env bash
docker build -t johnpolansky/multi-client:latest -t johnpolansky/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t johnpolansky/multi-server:latest -t johnpolansky/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t johnpolansky/multi-worker:latest -t johnpolansky/multi-worker:$SHA -f ./worker/Dockerfile ./worker
docker push johnpolansky/multi-client:latest
docker push johnpolansky/multi-server:latest
docker push johnpolansky/multi-worker:latest

docker push johnpolansky/multi-client:$SHA
docker push johnpolansky/multi-server:$SHA
docker push johnpolansky/multi-worker:$SHA

kubectl apply -f k8s
kubectl set image deployments/client-deployment client=johnpolansky/multi-client:$SHA
kubectl set image deployments/server-deployment server=johnpolansky/multi-server:$SHA
kubectl set image deployments/worker-deployment worker=johnpolansky/multi-worker:$SHA
