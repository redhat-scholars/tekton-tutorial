#!/bin/bash

NS=${1:-tektontutorial}

kubectl delete pods --field-selector=status.phase=Succeeded
kubectl delete pods --field-selector=status.phase=Failed

kubectl delete -n "$NS" pipeline --all
kubectl delete -n "$NS" pr --all
kubectl delete -n "$NS" tr --all
kubectl delete -n "$NS" deploy,svc demo-greeter 2>/dev/null
kubectl delete -n "$NS" httpproxy demo-greeter 2>/dev/null
kubectl delete -n "$NS" deploy,svc greeter 2>/dev/null
kubectl delete -n "$NS" httpproxy greeter 2>/dev/null
kubectl delete -n "$NS" ksvc greeter 2>/dev/null
