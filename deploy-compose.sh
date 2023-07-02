#!/bin/bash

INSTANCE_IP=$1

ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i /var/lib/jenkins/or.pem ec2-user@${INSTANCE_IP} "
sudo yum install docker -y
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo systemctl enable docker
sudo systemctl start docker
sudo docker pull orelbaz/flak-docker:1.0
sudo docker stop \$(sudo docker ps -aq)
sudo docker rm \$(sudo docker ps -aq)
sudo docker-compose up
"
