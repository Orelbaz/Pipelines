#!/bin/bash

TAG=$1

cd /var/lib/jenkins/workspace/K8-pipeline/Jenkins/K8-jenkins
sed "s/\${TAG}/$TAG/g" my-app.yaml | kubectl apply -f -

