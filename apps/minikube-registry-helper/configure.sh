#!/usr/bin/env bash

set -eu

set -o pipefail 

minikube -p tektontutorial addons enable registry

sleep 5; 
while (echo && kubectl get pods -n kube-system --selector='kubernetes.io/minikube-addons=registry' \
   | grep -v -E "(Running|Completed|STATUS)"); 
do 
  sleep 5; 
done

kubectl apply -n kube-system \
  -f registry-aliases-sa.yaml \
  -f registry-aliases-sa-crb.yaml \
  -f registry-aliases-config.yaml \
  -f node-etc-hosts-update.yaml \
  -f patch-coredns-job.yaml

sleep 5; 
while (echo && kubectl get pods -n kube-system --selector='job-name=registry-aliases-patch-core-dns' \
   | grep -v -E "(Completed|STATUS)"); 
do 
  sleep 5; 
done

echo "Patch successfully done"

minikube -p tektontutorial  ssh -- sudo cat /etc/hosts

kubectl -n kube-system get cm coredns -o yaml | yq r - data.Corefile
