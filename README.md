# Cloud Engineering Lab: Deploy EC2 Architecture with Terraform

This repository contains the Terraform infrastructure code to deploy a secure, multi-tier EC2 instance architecture on AWS. The lab demonstrates Infrastructure as Code (IaC) principles, including dynamic data sourcing, automated server initialization, security group linking, and persistent storage management.

## 🎯 Project Objectives

- **Infrastructure as Code**: Deploy 4 EC2 instances (2 Web Servers, 2 App Servers) using Terraform.
- **Multi-Tier Security**: Configure security groups with strict traffic isolation rules.
- **Dynamic Data Sources**: Fetch the latest Amazon Linux 2 AMI and client public IP dynamically.
- **Automated Initialization**: Implement separate shell scripts (`user-data`) for Web and App tiers.
- **Advanced Features**: Attach persistent EBS data volumes and enable detailed CloudWatch monitoring.

---

## 📂 Repository Structure

```text
ce-lab-terraform-ec2/
├── README.md               # Project documentation
├── main.tf                 # AMI data source, EC2 instances, and EBS volumes
├── security-groups.tf      # Security groups for Web and App tiers (with dynamic IP)
├── variables.tf            # Project variables (Project name, Instance type)
├── outputs.tf              # Target IPs and access URLs
├── user-data-web.sh        # Bootstrap script to install Apache and welcome page
└── user-data-app.sh        # Bootstrap script for App tier environment setup
