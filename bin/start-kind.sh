#!/bin/bash

set -eu
set -o errexit

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


CLUSTER_NAME=${CLUSTER_NAME:-tektontutorial}
REGISTRY_NAME="registry.local"
REGISTRY_PORT="5000"
CLUSTER_SUFFIX="cluster.local"

#############################################################
#
#    Setup KinD cluster.
#
#############################################################
echo '::group:: Install KinD'

cat >> kind.yaml <<EOF
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
- role: worker
  extraPortMappings:
    - containerPort: 80
      hostPort: 80
      listenAddress: 0.0.0.0
    - containerPort: 443
      hostPort: 443
      listenAddress: 0.0.0.0
kubeadmConfigPatches:
  # This is needed in order to support projected volumes with service account tokens.
  # See: https://kubernetes.slack.com/archives/CEKK1KTN2/p1600268272383600
  - |
    apiVersion: kubeadm.k8s.io/v1beta2
    kind: ClusterConfiguration
    metadata:
      name: config
    apiServer:
      extraArgs:
        "service-account-issuer": "kubernetes.default.svc"
        "service-account-signing-key-file": "/etc/kubernetes/pki/sa.key"
    networking:
      dnsDomain: "${CLUSTER_SUFFIX}"

  # This is needed to avoid filling our disk.
  # See: https://kubernetes.slack.com/archives/CEKK1KTN2/p1603391142276400
  - |
    kind: KubeletConfiguration
    metadata:
      name: config
    imageGCHighThresholdPercent: 90

containerdConfigPatches:
- |-
  # Support a local registry
  [plugins."io.containerd.grpc.v1.cri".registry.mirrors."$REGISTRY_NAME:$REGISTRY_PORT"]
    endpoint = ["http://$REGISTRY_NAME:$REGISTRY_PORT"]
  [plugins."io.containerd.grpc.v1.cri".registry.mirrors."localhost:5000"]
    endpoint = ["http://$REGISTRY_NAME:$REGISTRY_PORT"]
EOF

# Create a cluster!
kind create cluster --name="$CLUSTER_NAME" --config kind.yaml

echo '::endgroup::'

echo '::group:: kind.yaml'
cat kind.yaml
echo '::endgroup::'

#############################################################
#
#    Setup container registry
#
#############################################################
echo '::group:: Setup container registry'

running="$(docker inspect -f '{{.State.Running}}' "${REGISTRY_NAME}" 2>/dev/null || true)"
if [ "${running}" != 'true' ]; then
  docker run \
    -d --restart=always -p "${REGISTRY_PORT}:5000" --name "${REGISTRY_NAME}" \
    registry:2
fi

# connect the registry to the cluster network only for new 
if [ "${running}" != 'true' ]; then
  docker network connect "kind" "${REGISTRY_NAME}"
fi

# Make the $REGISTRY_NAME -> 127.0.0.1, to tell `ko` to publish to
# local reigstry, even when pushing $REGISTRY_NAME:$REGISTRY_PORT/some/image
# sudo echo "127.0.0.1 $REGISTRY_NAME" | sudo tee -a /etc/hosts

echo '::endgroup::'

#############################################################
#
#    Setup Ingress
#
#############################################################
echo '::group:: Install Contour Ingress'

kubectl apply -f https://projectcontour.io/quickstart/contour.yaml

kubectl rollout status ds envoy -n projectcontour

echo '::endgroup::'