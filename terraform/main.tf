# ================================
# LAB 5 - K3S CLUSTER ON EC2 (Dynamic Networking, AWS Provider v5+)
# ================================
terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

# 1) Default VPC and Subnets
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# 2) SSH Key
resource "aws_key_pair" "lab5_key" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

# 3) Security Group
resource "aws_security_group" "lab5_sg" {
  name        = "lab5-k3s-sg"
  description = "Allow SSH, K3s API, NodePort range, Dashboard, OpenFaaS"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "K3s API server"
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "NodePort range (Dashboard, OpenFaaS, etc.)"
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Optional: HTTPS direct access (reverse proxy, Kong, etc.)"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# 4) Master
resource "aws_instance" "master" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.lab5_key.key_name
  vpc_security_group_ids      = [aws_security_group.lab5_sg.id]
  subnet_id                   = element(data.aws_subnets.default.ids, 0)
  associate_public_ip_address = true
  tags = { Name = "k3s-master", Role = "master", Project = "Lab5-K3s" }
}

# 5) Worker
resource "aws_instance" "worker" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.lab5_key.key_name
  vpc_security_group_ids      = [aws_security_group.lab5_sg.id]
  subnet_id                   = element(data.aws_subnets.default.ids, 1)
  associate_public_ip_address = true
  tags = { Name = "k3s-worker", Role = "worker", Project = "Lab5-K3s" }
}
