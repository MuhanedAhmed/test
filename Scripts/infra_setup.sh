#!/bin/bash
set -e  # Exit on error

# Configuration
KEY_NAME="ansible-key"
KEY_FILE="${KEY_NAME}.pem"
TF_VARS_FILE="terraform.tfvars"
ANSIBLE_DIR="./ansible"
JENKINS_USER="ec2-user"

# Step 1: Create AWS Key Pair
echo "Creating AWS Key Pair..."
aws ec2 create-key-pair --key-name $KEY_NAME --query 'KeyMaterial' --output text > $KEY_FILE
chmod 400 $KEY_FILE

# Step 2: Set Key Name as TF Environment Variable
echo "Setting Terraform variables..."
export TF_VAR_instance_key_pair=$KEY_NAME
cat > $TF_VARS_FILE <<EOF
instance_key_pair = "$KEY_NAME"
EOF

# Step 3: Run Terraform
echo "Initializing Terraform..."
terraform init
echo "Applying Terraform configuration..."
terraform apply -auto-approve

# Get Jenkins Public IP from Terraform output
JENKINS_IP=$(terraform output -raw jenkins_public_ip)
echo "Jenkins Server IP: $JENKINS_IP"

# Wait for Jenkins server to be ready
echo "Waiting for Jenkins server to be ready..."
sleep 30  # Simple wait - consider implementing proper health check

# Step 4: Copy Key to Jenkins Server
echo "Copying SSH key to Jenkins server..."
scp -o StrictHostKeyChecking=no -i $KEY_FILE $KEY_FILE $JENKINS_USER@$JENKINS_IP:~/.ssh/
ssh -o StrictHostKeyChecking=no -i $KEY_FILE $JENKINS_USER@$JENKINS_IP "chmod 600 ~/.ssh/$KEY_FILE"

# Step 5: Install Ansible on Jenkins Server
echo "Installing Ansible on Jenkins server..."
ssh -i $KEY_FILE $JENKINS_USER@$JENKINS_IP "sudo amazon-linux-extras install -y ansible2"

# Step 6: Copy Ansible Directory
echo "Copying Ansible configuration to Jenkins server..."
scp -r -i $KEY_FILE $ANSIBLE_DIR $JENKINS_USER@$JENKINS_IP:~/

# Step 7: Run Ansible Playbooks
echo "Running Ansible playbooks..."
ssh -i $KEY_FILE $JENKINS_USER@$JENKINS_IP "cd ~/ansible && ansible-playbook -i inventory playbook.yml"

# Cleanup (optional)
echo "Cleaning up local key file..."
rm -f $KEY_FILE

echo "Infrastructure setup complete!"