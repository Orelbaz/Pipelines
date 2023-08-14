#!/bin/bash
sudo yum install python -y
sudo yum install python-pip -y
sudo pip install ansible
ansible-playbook /home/ec2-user/Jenkins/Ansible-pipeline/ansible/flask-playbook.yml 
