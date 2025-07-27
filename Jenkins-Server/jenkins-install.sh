#!/bin/bash

# Update system packages
sudo yum update -y

# Add Jenkins repo and import key
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

# Install Java (Jenkins needs Java 17+)
sudo amazon-linux-extras enable corretto17
sudo yum install -y java-17-amazon-corretto

# Install Jenkins
sudo yum install -y jenkins 

# Enable and start Jenkins service
sudo systemctl enable jenkins
sudo systemctl start jenkins

# Check status
sudo systemctl status jenkins

# Update the system
sudo yum update -y

# Install yum-utils to manage repositories
sudo yum install -y yum-utils

# Add HashiCorp's official Linux YUM repo
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo

# Install Terraform
sudo yum install -y terraform






# Download the latest stable release of kubectl
curl -LO "https://dl.k8s.io/release/$(curl -Ls https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

# Make the binary executable
chmod +x kubectl

# Move the binary to your PATH
sudo mv kubectl /usr/local/bin/

# Verify installation
kubectl version --client
