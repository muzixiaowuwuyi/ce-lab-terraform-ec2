#!/bin/bash
yum update -y
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
mkdir -p /var/log/myapp
echo "App Server $INSTANCE_ID initialized at $(date)" > /var/log/myapp/status.log