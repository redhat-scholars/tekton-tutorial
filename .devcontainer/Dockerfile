FROM quay.io/mhildenb/tekton-tutorial-base:latest

COPY .bashrc /opt/app-root/src
COPY convert-kubeconfig-for-devcontainer.sh /$HOME/bin/convert-kubeconfig-for-devcontainer.sh

USER root
RUN chown -R default $HOME && chmod -R +x $HOME/bin/

USER default