#!/bin/bash
sudo yum install python -y
sudo yum install python-pip -y
sudo pip install ansible
ansible-playbook /home/ec2-user/Jenkins/Ansible-jenkins/ansible/flask-playbook.yml 
