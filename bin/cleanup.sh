#!/bin/bash

kubectl delete pods --field-selector=status.phase=Succeeded
kubectl delete pods --field-selector=status.phase=Failed

kubectl delete -n tektontutorial tasks --all
kubectl delete -n tektontutorial tr --all
kubectl delete -n tektontutorial pipelines --all
kubectl delete -n tektontutorial pr --all
kubectl delete -n tektontutorial pipelineresourcs
kubectl delete -n tektontutorial -f $TUTORIAL_HOME/apps/greeter/java/springboot/k8s
kubectl delete -n tektontutorial -f $TUTORIAL_HOME/pipelines/pipeline-sa-role.yaml
