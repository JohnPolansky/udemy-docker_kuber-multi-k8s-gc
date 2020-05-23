#!/usr/bin/env bash
docker build -t johnpolansky/multi-client:latest -t johnpolansky/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t johnpolansky/multi-server:latest -t johnpolansky/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t johnpolansky/multi-worker:latest -t johnpolansky/multi-worker:$SHA -f ./worker/Dockerfile ./worker
dockerpush johnpolansky/multi-client:latest
dockerpush johnpolansky/multi-server:latest
dockerpush johnpolansky/multi-worker:latest

dockerpush johnpolansky/multi-client:$SHA
dockerpush johnpolansky/multi-server:$SHA
dockerpush johnpolansky/multi-worker:$SHA

kubectl apply -f k8s
kubectl set image deployments/client-deployment server=johnpolansky/multi-client:$SHA
kubectl set image deployments/server-deployment server=johnpolansky/multi-server:$SHA
kubectl set image deployments/worker-deployment server=johnpolansky/multi-worker:$SHA
