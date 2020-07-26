#!/usr/bin/env bash

set -eu

PROFILE_NAME=${PROFILE_NAME:-tektontutorial}
MEMORY=${MEMORY:-8192}
CPUS=${CPUS:-4}

# Enable if you are going to use Tekton with Knative
EXTRA_CONFIG="apiserver.enable-admission-plugins=\
LimitRanger,\
NamespaceExists,\
NamespaceLifecycle,\
ResourceQuota,\
ServiceAccount,\
DefaultStorageClass,\
MutatingAdmissionWebhook"

minikube start -p $PROFILE_NAME \
  --memory=$MEMORY --cpus=$CPUS \
  --disk-size=50g \
  --insecure-registry='10.0.0.0/24'
  
minikube profile $PROFILE_NAME
