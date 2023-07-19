#!/bin/bash

cd /var/lib/jenkins/workspace/K8-pipeline/Jenkins/K8-jenkins
kubectl apply -f my-app-test.yaml
