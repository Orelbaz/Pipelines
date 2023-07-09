#!/bin/bash

INSTANCE_IP=$1
TAG=$2

echo 'Copying docker-compose.yml to instance...'
scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i /var/lib/jenkins/or.pem /var/lib/jenkins/workspace/docker-pipeline/flask-docker/CoinSite/docker-compose.yml ec2-user@${INSTANCE_IP}:/home/ec2-user
scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i /var/lib/jenkins/or.pem /var/lib/jenkins/workspace/docker-pipeline/flask-docker/CoinSite/.env ec2-user@${INSTANCE_IP}:/home/ec2-user

echo 'Connecting to test-server...'
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i /var/lib/jenkins/or.pem ec2-user@${INSTANCE_IP} "
sudo yum update -y
sudo yum install docker -y
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo systemctl enable docker
sudo systemctl start docker
sudo docker stop \$(sudo docker ps -aq)
sudo docker rm \$(sudo docker ps -aq)
sudo docker rmi \$(sudo docker images -q orelbaz/coinsite)
sudo docker pull orelbaz/coinsite:${TAG}
cd /home/ec2-user
sudo docker-compose up -d
"

