#!/bin/bash

TAG=$1

cd /var/lib/jenkins/workspace/K8-pipeline/Jenkins/K8-jenkins
###kubectl apply -f --set TAG=$TAG my-app-test.yaml

sed "s/\${TAG}/$TAG/g" my-app-test.yaml | kubectl apply -f -

