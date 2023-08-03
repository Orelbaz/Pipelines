#!/bin/bash

TAG=$1
CLUSTER=$2

export USE_GKE_GCLOUD_AUTH_PLUGIN=True
gcloud container clusters get-credentials --project gke-first-393008 $CLUSTER --zone us-central1-c

cd /var/lib/jenkins/workspace/K8-pipeline/Jenkins/K8-jenkins
sed "s/\${TAG}/$TAG/g" my-app.yaml | kubectl apply -f -

