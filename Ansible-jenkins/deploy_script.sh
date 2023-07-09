#!/bin/bash
sudo yum install python -y
sudo yum install python-pip -y
sudo pip install ansible
ansible-playbook /home/ec2-user/jenkins-test/ansible/flask-playbook.yml 
