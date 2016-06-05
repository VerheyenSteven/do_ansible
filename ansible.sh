#!/usr/bin/env bash
apt-add-repository -y ppa:ansible/ansible
apt-get update
apt-get -y install ansible sshpass

rm /etc/ansible/hosts
ln -sf /vagrant/hosts /etc/ansible/hosts


KNOW_HOSTS_FILE="/home/vagrant/.ssh/known_hosts"

[ -f "$KNOW_HOSTS_FILE" ] && rm $KNOW_HOSTS_FILE 

ssh-keyscan 192.168.2.3 >> $KNOW_HOSTS_FILE 
ssh-keyscan 192.168.2.4 >> $KNOW_HOSTS_FILE
ssh-keyscan 192.168.2.5 >> $KNOW_HOSTS_FILE
ssh-keyscan 192.168.2.6 >> $KNOW_HOSTS_FILE
chown vagrant:vagrant $KNOW_HOSTS_FILE 

# TODO: ssh-keyscan can be replaced if a playbook is created that copies the
# files, ssh-agent needs to be implemented as wel.

ssh-keygen -t rsa -b 2048 -N "" -f /home/vagrant/.ssh/id_rsa


ansible-playbook /vagrant/ssh-addkey.yml 
ansible-playbook /vagrant/site.yml 