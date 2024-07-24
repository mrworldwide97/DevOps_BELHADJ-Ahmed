#!/bin/bash

terraform apply --auto-approve

IP=$(cat ip_address.txt)

sed -i "s/[0-9]\{1,3\}\(\.[0-9]\{1,3\}\)\{3\}/$IP/" hosts.ini

chmod 600 id_rsa 

sleep 30
ansible-playbook -i hosts.ini setup.yml --ssh-common-args='-o StrictHostKeyChecking=no'
ansible-playbook -i hosts.ini deploy.yml --ssh-common-args='-o StrictHostKeyChecking=no'
