#!/bin/bash
TEST_IP=$(aws ec2 describe-instances --region eu-central-1 --filters Name=tag:tagas,Values=test --query 'Reservations[].Instances[].PublicIpAddress' --output text)

ssh -o StrictHostKeyChecking=no -i /var/lib/jenkins/or.pem ec2-user@${TEST_IP} "sudo systemctl restart flask.service"

response=$(curl -s -o /dev/null -w "%{http_code}" ${TEST_IP}:5000)

if [[ $response == 200 ]]; then
    echo "Flask app returned a 200 status code. Test passed!"
else
    echo "Flask app returned a non-200 status code: $response. Test failed!"
    exit 1
fi
