#!/usr/bin/env bash

set -eu

PROFILE_NAME=${PROFILE_NAME:-tektontutorial}
MEMORY=${MEMORY:-8192}
CPUS=${CPUS:-4}
declare PLATFORM_SPECIFIC_OPTIONS=""

# Enable if you are going to use Tekton with Knative
# EXTRA_CONFIG="apiserver.enable-admission-plugins=\
# LimitRanger,\
# NamespaceExists,\
# NamespaceLifecycle,\
# ResourceQuota,\
# ServiceAccount,\
# DefaultStorageClass,\
# MutatingAdmissionWebhook"

unamestr=$(uname)

if [ "${unamestr}" == "Darwin" ]; then
 # Add MacOS specific options for minikube
 PLATFORM_SPECIFIC_OPTIONS=("--driver=hyperkit" "--apiserver-names=docker.for.mac.localhost")
fi

minikube start -p "$PROFILE_NAME" \
  --memory="$MEMORY" --cpus="$CPUS" \
  --disk-size=50g \
  --kubernetes-version='v1.20.0' \
  --insecure-registry='10.0.0.0/24' \
    "${PLATFORM_SPECIFIC_OPTIONS[@]}"
  
minikube profile "$PROFILE_NAME"

