#!/bin/bash

BUILD_NUMBER=$1
CLUSTER=$2
MY_PATH=$3


export USE_GKE_GCLOUD_AUTH_PLUGIN=True
gcloud container clusters get-credentials --project gke-first-393008 $CLUSTER --zone us-central1-c


cd ${MY_PATH}Kubernetes-pipeline/Helm-chart


if [[ $CLUSTER == "eks-test" ]]; then

    if helm list | grep -q -i "stock-site"; then
        echo 'Chart already installed'
        echo 'Performing upgrade...'
        helm upgrade stock-site stock-site-${BUILD_NUMBER}.0.tgz --reuse-values -f values.yaml
    else
        echo 'Installing the chart...'
        helm install stock-site stock-site-${BUILD_NUMBER}.0.tgz
    fi

    sleep 60

    EXTERNAL_IP=$(kubectl get service flask-service -o=jsonpath='{.status.loadBalancer.ingress[0].ip}')

    # Test the http status
    http_response=$(curl -s -o /dev/null -w "%{http_code}" ${EXTERNAL_IP}:80)

    if [[ $http_response == 200 ]]; then
        echo "Flask app returned a 200 status code. Test passed!"
        echo "Uploading Helm chart to the Google Cloud Storage bucket"
    else
        echo "Flask app returned a non-200 status code: $http_response. Test failed!"
        exit 1
    fi
fi


if [[ $CLUSTER == "eks-prod" ]]; then

    if helm list | grep -q -i "stock-site"; then
        echo 'Chart already installed'
        echo 'Performing upgrade...'
        helm upgrade stock-site stock-site-${BUILD_NUMBER}.0.tgz --reuse-values -f values.yaml
    else
        echo 'Installing the chart...'
        helm install stock-site stock-site-${BUILD_NUMBER}.0.tgz
    fi
    sleep 15
fi
