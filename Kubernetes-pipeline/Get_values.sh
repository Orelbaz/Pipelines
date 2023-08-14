#!/bin/bash

echo 'Getting Chart.yaml...'
echo "apiVersion: v2
name: stock-site
version: 0.$BUILD_NUMBER.0
description: A Helm chart for deploying Flask and Redis" > Chart.yaml

echo 'Getting values.yaml...'
echo "TAG: $BUILD_NUMBER" > values.yaml