terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}

# Fetch the public IP address of the machine running Terraform
data "http" "my_public_ip" {
  url = "https://checkip.amazonaws.com/"
}

#dynamic fetching aws linux 2 ami
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners = [ "amazon" ]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

#web-sg instance
resource "aws_instance" "web_server" {
    count         = 2
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = var.instance_type
  key_name      = "bootcamp-week2-key"

  security_groups = [aws_security_group.web_sg.name]
  user_data     = file("${path.module}/user-data-web.sh")

    monitoring = true

    associate_public_ip_address = true

  tags = {
    Name = "${var.project_name}-web-server-${count.index + 1}"
    Tier = "Web"
  }
}

#app-sg instance
resource "aws_instance" "app_server" {
  count         = 2
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = var.instance_type
  key_name      = "bootcamp-week2-key"
  security_groups = [aws_security_group.app_sg.name]
  user_data     = file("${path.module}/user-data-app.sh")

  monitoring = true

  tags = {
    Name = "${var.project_name}-app-server-${count.index + 1}"
    Tier = "App"
  }
}

#10GB EBS volume for web servers
resource "aws_ebs_volume" "web_data_volume" {
    count = 2
  availability_zone = aws_instance.web_server[count.index].availability_zone
    size              = 10
    type              = "gp3"

    tags = {
    Name = "${var.project_name}-web-data-volume-${count.index + 1}" 
    }
}

#use aws_volume_attachment to attach the EBS volume to the web server instance
resource "aws_volume_attachment" "web_data_attachment" {
    count = 2
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.web_data_volume[count.index].id
  instance_id = aws_instance.web_server[count.index].id
}

#10GB EBS volume for app servers
resource "aws_ebs_volume" "app_data_volume" {
    count = 2
  availability_zone = aws_instance.app_server[count.index].availability_zone
    size              = 10
    type              = "gp3"

    tags = {
    Name = "${var.project_name}-app-data-volume-${count.index + 1}" 
    }
}

#use aws_volume_attachment to attach the EBS volume to the app server instance
resource "aws_volume_attachment" "app_data_attachment" {
    count = 2
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.app_data_volume[count.index].id
  instance_id = aws_instance.app_server[count.index].id
}