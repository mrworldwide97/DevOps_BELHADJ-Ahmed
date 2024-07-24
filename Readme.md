*Ce projet contient le script Terraform 'ec2.tf' qui provisionne une instance EC2 avec l'image Ubuntu 22.04 LTS.
*Le playbook Ansible 'setup.yml' mettra à jour la configuration de la machine et installera Docker.
*Le playbook Ansible 'deploy.yml' construira une image Docker et la déploiera sur le serveur.

**Étapes**

Exécutez le script 'run.sh' qui exécutera le code Terraform puis les playbooks Ansible (si vous ne pouvez pas l'exécuter, exécutez cette commande 'chmod +x ./run.sh').

Vous pouvez accéder au serveur dans votre navigateur en utilisant l'adresse IP dans ip_address.txt.

