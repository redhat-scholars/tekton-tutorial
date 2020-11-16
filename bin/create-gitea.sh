#!/bin/bash

set -Ee -u -o pipefail

declare GITEA_HOSTNAME=${1:-}
declare TARGET_NAMESPACE="triggers-demo"

if [[ -z "$GITEA_HOSTNAME" ]];  then
    echo "Error: Must provide a hostname for gitea server"
    exit 1
fi

# Create the operator and all the necessary resources
kubectl apply -f $TUTORIAL_HOME/install/gitea/gitea-operator-resources.yaml

# wait for the operator to be rolled out
kubectl rollout status deploy/gitea-operator -n gitea-operator

# create the gitea instance (with sed substitution)
sed "s/@GITEA_HOSTNAME@/$GITEA_HOSTNAME/g" $TUTORIAL_HOME/install/gitea/gitea-server-cr.yaml | kubectl apply -n ${TARGET_NAMESPACE} -f -

# wait for cr
kubectl wait --for=condition=Running Gitea/gitea-server --timeout=6m -n ${TARGET_NAMESPACE}

# wait for the gitea deployment to appear
echo -n "Waiting for gitea deployment to appear..."
  while [[ -z "$(kubectl get deploy gitea -n ${TARGET_NAMESPACE} 2>/dev/null)" ]]; do
    echo -n "."
    sleep 1
  done
  echo "done!"

# At this point the operate should setup all necessary resources.  Setup is complete when the gitea deployment has finished
kubectl rollout status deploy/gitea -n ${TARGET_NAMESPACE}

echo "Gitea server installed and running"