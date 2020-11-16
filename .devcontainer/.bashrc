export TUTORIAL_HOME=$(pwd)
echo "In .bashrc at directory ${TUTORIAL_HOME}"

declare -r LOCAL_KUBECONFIG=/tmp/config

if [ ! -f ${LOCAL_KUBECONFIG} ]; then
    echo "Creating kubeconfig for use inside container"
    if [ -f ~/.kube/config ]; then
        cp ~/.kube/config ${LOCAL_KUBECONFIG}
        ~/bin/convert-kubeconfig-for-devcontainer.sh "${LOCAL_KUBECONFIG}"
    fi
fi

if [ -f ${LOCAL_KUBECONFIG} ]; then
    echo "Using local kubeconfig at ${LOCAL_KUBECONFIG}"
    export KUBECONFIG=${LOCAL_KUBECONFIG}
fi

echo "Welcome to the Tekton Tutorial!"

