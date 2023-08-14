#!/bin/bash

BUILD_NUMBER=$1
MY_PATH=$2

cd ${MY_PATH}Kubernetes-pipeline/CoinSite
docker build -t orelbaz/coinsitek8s:${BUILD_NUMBER} .
docker push orelbaz/coinsitek8s:${BUILD_NUMBER}

cd ${MY_PATH}Kubernetes-pipeline/Helm-chart
/bin/bash ${MY_PATH}Kubernetes-pipeline/Get_values.sh
helm package .

gsutil cp ${MY_PATH}Kubernetes-pipeline/Helm-chart/stock-site-${BUILD_NUMBER}.0.tgz gs://stock-site