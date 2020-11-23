#!/bin/bash

set -Ee -u -o pipefail

declare GITEA_HOSTNAME=""
declare TARGET_NAMESPACE="triggers-demo"
declare OPERATOR_IMAGE="quay.io/mhildenb/gitea-operator-minikube"

display_usage() {
cat << EOF
$0: create gitea --

  Usage: ${0##*/} [ OPTIONS ]
  
    -g         [optional] Name of the ingress host to the Gitea Server

EOF
}

is_openshift() {
  # if we get back a line then it's installed
  return "$(kubectl api-resources | grep "route.openshift.io" 2>/dev/null)"
}

while getopts ':og:' option; do
    case "${option}" in
        g  ) g_flag=true; GITEA_HOSTNAME="${OPTARG}";;
        h  ) display_usage; exit;;
        \? ) printf "%s\n\n" "  Invalid option: -${OPTARG}" >&2; display_usage >&2; exit 1;;
        :  ) printf "%s\n\n%s\n\n\n" "  Option -${OPTARG} requires an argument." >&2; display_usage >&2; exit 1;;
    esac
done
shift "$((OPTIND - 1))"


if [[ is_openshift ]]; then
  echo "Targeting an OpenShift cluster."
  OPERATOR_IMAGE="quay.io/mhildenb/gitea-operator:0.1"
fi

# Create the operator and all the necessary resources
echo "Using operator image $OPERATOR_IMAGE"
sed "s#@OPERATOR_IMAGE@#$OPERATOR_IMAGE#g" $TUTORIAL_HOME/install/gitea/gitea-operator-resources.yaml | kubectl apply -f -

# wait for the operator to be rolled out
kubectl rollout status deploy/gitea-operator -n gitea-operator

# create the gitea instance (with sed substitution)
if [[ -n $GITEA_HOSTNAME ]]; then
  sed "s/@GITEA_HOSTNAME@/$GITEA_HOSTNAME/g" $TUTORIAL_HOME/install/gitea/gitea-server-cr.yaml | kubectl apply -n ${TARGET_NAMESPACE} -f -
else
  # remove this from the custom resource and let the operator choose
  sed "/@GITEA_HOSTNAME@/d" $TUTORIAL_HOME/install/gitea/gitea-server-cr.yaml | kubectl apply -n ${TARGET_NAMESPACE} -f -
fi

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