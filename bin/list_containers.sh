#!/bin/bash

echo 'Init Containers'

kubectl get pod $1 -o yaml | yq r - spec.initContainers[*].name

echo 'Containers'

kubectl get pod $1 -o yaml | yq r - spec.containers[*].name

