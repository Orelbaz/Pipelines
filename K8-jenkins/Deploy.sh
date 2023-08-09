#!/bin/bash

TAG=$1
CLUSTER=$2
MY_PATH=$3


export USE_GKE_GCLOUD_AUTH_PLUGIN=True
gcloud container clusters get-credentials --project gke-first-393008 $CLUSTER --zone us-central1-c


if [[ $CLUSTER == "eks-test" ]]; then
    cd ${MY_PATH}K8-jenkins/Helm-chart
    helm package .

    if helm list | grep -q -i "stock-site"; then
        echo 'Chart already installed'
        echo 'Performing upgrade...'
        helm upgrade stock-site stock-site-0.2.0.tgz
    else
        echo 'Installing the chart...'
        helm install stock-site stock-site-0.2.0.tgz
    fi


if [[ $CLUSTER == "eks-prod" ]]; then
    if helm list | grep -q -i "stock-site"; then
        echo 'Chart already installed'
        echo 'Performing upgrade...'
        helm upgrade stock-site stock-site-0.2.0.tgz
    else
        echo 'Installing the chart...'
        helm install stock-site stock-site-0.2.0.tgz
    fi


if [[ $2 == "eks-test" ]]; then

    EXTERNAL_IP=$(kubectl get service flask-service -o=jsonpath='{.status.loadBalancer.ingress[0].ip}')

    # Test the http status
    http_response=$(curl -s -o /dev/null -w "%{http_code}" ${EXTERNAL_IP}:80)

    if [[ $http_response == 200 ]]; then
        echo "Flask app returned a 200 status code. Test passed!"
        echo "Uploading Helm chart to the Google Cloud Storage bucket"
        gsutil cp ${MY_PATH}K8-jenkins/Helm-chart/stock-site-0.2.0.tgz gs://stock-site
    else
        echo "Flask app returned a non-200 status code: $http_response. Test failed!"
        exit 1
    fi
fi


