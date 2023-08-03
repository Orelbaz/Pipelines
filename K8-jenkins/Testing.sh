#!/bin/bash

TAG=$1
CLUSTER=$2

export USE_GKE_GCLOUD_AUTH_PLUGIN=True
gcloud container clusters get-credentials --project gke-first-393008 $CLUSTER --zone us-central1-c

cd /var/lib/jenkins/workspace/K8-pipeline/Jenkins/K8-jenkins
sed "s/\${TAG}/$TAG/g" my-app.yaml | kubectl apply -f -


# Get test instance's IP
INSTANCE_IP=$(gcloud compute instances describe $INSTANCE_NAME --zone=$ZONE --project=$PROJECT_ID --format='get(networkInterfaces[0].accessConfigs[0].natIP)')

# Test the http status
http_response=$(curl -s -o /dev/null -w "%{http_code}" ${INSTANCE_IP}:5000)

if [[ $http_response == 200 ]]; then
    echo "Flask app returned a 200 status code. Test passed!"
else
    echo "Flask app returned a non-200 status code: $http_response. Test failed!"
    exit 1
fi

