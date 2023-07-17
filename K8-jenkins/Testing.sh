#!/bin/bash

TAG=$2
INSTANCE_NAME="test"
PROJECT_ID="gke-first-393008"
ZONE="us-central1-c"


echo 'Copying docker-compose.yml + .env to instance...'
gcloud compute scp /var/lib/jenkins/workspace/K8-pipeline/Jenkins/K8-jenkins/CoinSite/docker-compose.yml [$INSTANCE_NAME]:/home/ec2-user/docker-compose.yml --project=[PROJECT_ID] --zone=[ZONE]
gcloud compute scp /var/lib/jenkins/workspace/K8-pipeline/Jenkins/K8-jenkins/CoinSite/.env [$INSTANCE_NAME]:/home/ec2-user/docker-compose.yml --project=[PROJECT_ID] --zone=[ZONE]

gcloud compute ssh --project=$PROJECT_ID --zone=$ZONE $INSTANCE_NAME \
--ssh-flag="-o UserKnownHostsFile=/dev/null -o CheckHostIP=no -o StrictHostKeyChecking=no" \
--command "

sudo yum update -y
sudo yum install docker -y
sudo curl -L 'https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)' -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo systemctl enable docker
sudo systemctl start docker
cd /home/ec2-user
sudo docker-compose down
sudo docker rmi \$(sudo docker images -q orelbaz/coinsiteK8)
sudo docker-compose up -d


response=$(curl -s -o /dev/null -w "%{http_code}" ${TEST_IP}:5000)

if [[ $response == 200 ]]; then
    echo "Flask app returned a 200 status code. Test passed!"
else
    echo "Flask app returned a non-200 status code: $response. Test failed!"
    exit 1
fi

"