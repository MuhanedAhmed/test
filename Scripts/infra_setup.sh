#!/bin/bash
set -e  # Exit on error

# Define color codes
BLUE='\033[0;34m'
GREEN='\033[0;32m'
NC='\033[0m' 

# Configuration
KEY_FILE="$HOME/.ssh/ansible-key.pem"
TERRAFORM_DIR="./Terraform-Part"
ANSIBLE_DIR="./Ansible-Part"
SSH_USER="ubuntu"


echo -e "${GREEN}"
echo "========================================================"
echo "     Welcome to the PetClinic Infrastructure Setup!     "
echo "========================================================"
echo -e "${NC}"

# Step 1: Run Terraform
echo -e "${BLUE}"
echo -e "\n[1/6] Provisioning infrastructure with Terraform..."
echo -e "${NC}"
cd "$TERRAFORM_DIR"
echo "Initializing Terraform..."
terraform init
echo "Applying Terraform configuration..."
terraform apply --auto-approve


# Step 2: Get important info from Terraform output
JENKINS_PUBLIC_IP=$(terraform output -raw Jenkins_Public_IP)
RDS_ENDPOINT=$(terraform output -raw RDS_Endpoint)
ALB_DNS=$(terraform output -raw EXT_ALB_DNS)
cd - > /dev/null


# Step 3: Copy Key to Jenkins Server
echo -e "${BLUE}"
echo -e "\n[2/6] Copying SSH private key to Jenkins server..."
echo -e "${NC}"
scp -o StrictHostKeyChecking=no -i "$KEY_FILE" "$KEY_FILE" "$SSH_USER@$JENKINS_PUBLIC_IP:~/.ssh/ansible-key.pem"
ssh -o StrictHostKeyChecking=no -i "$KEY_FILE" "$SSH_USER@$JENKINS_PUBLIC_IP" "chmod 600 ~/.ssh/ansible-key.pem"


# Step 4: Copy Ansible files to Jenkins Server
echo -e "${BLUE}"
echo -e "\n[3/6] Copying Ansible directory to Jenkins server"
echo -e "${NC}"
scp -i "$KEY_FILE" -r "$ANSIBLE_DIR" "$SSH_USER@$JENKINS_PUBLIC_IP:~/"


# Step 5: Run Ansible Playbooks
echo -e "${BLUE}"
echo -e "\n[4/6] Running Ansible Playbooks remotely on Jenkins server"
echo -e "${NC}"
ssh -i "$KEY_FILE" "$SSH_USER@$JENKINS_PUBLIC_IP" bash <<EOF
  set -e

  echo -e "\nRunning setup_jenkins.yaml"
  cd ~/Ansible-Part
  ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory setup_jenkins.yaml

  echo -e "\nRunning setup_backend.yaml"
  ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i inventory setup_backend.yaml --tags docker
EOF


# Step 6: Copy Key to Jenkins Directory
echo -e "${BLUE}"
echo -e "\n[5/6] Copying SSH private key to Jenkins home directory..."
echo -e "${NC}"
ssh -i "$KEY_FILE" "$SSH_USER@$JENKINS_PUBLIC_IP" "sudo mv ~/.ssh/ansible-key.pem /var/lib/jenkins/.ssh/ansible-key.pem && sudo chown -R jenkins:jenkins /var/lib/jenkins/.ssh && sudo chmod 600 /var/lib/jenkins/.ssh/ansible-key.pem"


# Step 7: Get Jenkins Credentials
echo -e "${BLUE}"
echo -e "\n[6/6] Getting Jenkins Credentials from Jenkins server"
echo -e "${NC}"
JENKINS_PASS=$(ssh -o StrictHostKeyChecking=no -i "$KEY_FILE" "$SSH_USER@$JENKINS_PUBLIC_IP" "sudo cat /var/lib/jenkins/secrets/initialAdminPassword")

echo -e "\n\n===================================================================================\n\n"

echo -e "${GREEN}"
echo -e "\nAll tasks completed successfully!"
echo -e "${NC}"
echo -e "\nNow, open jenkins at http://$JENKINS_PUBLIC_IP:8080 with password '$JENKINS_PASS' and create the job."
echo -e "\nAfter the execution of the pipeline, access the application from http://$ALB_DNS:80"