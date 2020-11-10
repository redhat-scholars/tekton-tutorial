export TUTORIAL_HOME=$(pwd)
echo "In .bashrc at directory ${TUTORIAL_HOME}"

if [ ! -f /tmp/config ]; then
    echo "Creating kubeconfig for use inside container"
    if [ -f ~/.kube/config ]; then
        cp ~/.kube/config /tmp/config
        ${TUTORIAL_HOME}/bin/convert-kubeconfig-for-devcontainer.sh "/tmp/config"
    fi
fi

export KUBECONFIG=/tmp/config

