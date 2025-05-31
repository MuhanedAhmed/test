#! /bin/bash

# --------------------------------------------------------------------------------
# Script: install_ansible.sh
# Purpose: Install Ansible and required collections on EC2 (used as User Data)
# Author: Mohaned Ahmed
# --------------------------------------------------------------------------------

# Update the system
sudo apt update

# Install required dependencies
sudo apt install software-properties-common -y

# Add Ansible PPA and install Ansible
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install ansible -y

# Install Docker collection for Ansible
ansible-galaxy collection install community.docker