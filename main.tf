#######################
# Terraform Provider  #
#######################

provider "aws" {
  region     = lookup(var.selected_aws_region, var.available_aws_regions)
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key
}

######################
# AWS Infrastructure #
######################

# VPC
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.2"

  name = var.vpc_name
  cidr = "10.0.0.0/16" # harcoded for now

  enable_dns_hostnames = true

  # Deployment of two subnets (one public and one private) in the AZ specified by the user
  azs             = ["${lookup(var.selected_aws_region, var.available_aws_regions)}a"]
  private_subnets = ["10.0.1.0/24"]   # harcoded for now
  public_subnets  = ["10.0.101.0/24"] # harcoded for now

  public_subnet_tags = {
    Name = "${var.vpc_name}-public-subnet"
  }

  private_subnet_tags = {
    Name = "${var.vpc_name}-private-subnet"
  }

  tags = {
    Owner       = "user"
    Environment = "dev"
  }

  vpc_tags = {
    Name = var.vpc_name
  }
}

# Security Group
resource "aws_security_group" "poc_security_group" {
  name        = "${var.vpc_name}-sg"
  description = "Allowing inbound traffic for ports 8000, 22, and 443"
  vpc_id      = module.vpc.vpc_id
}

# Security Group Outbound Rule - Allows all traffic outbound
resource "aws_security_group_rule" "outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.poc_security_group.id
}

# Security Group Inbound Rule - Port 22 SSH
resource "aws_security_group_rule" "in_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.poc_security_group.id
}

# Security Group Inbound Rule - Port 8000
resource "aws_security_group_rule" "in_8000" {
  type              = "ingress"
  from_port         = 8000
  to_port           = 8000
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.poc_security_group.id
}

# Security Group Inbound Rule - Port 80 HTTP
resource "aws_security_group_rule" "in_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.poc_security_group.id
}

# Security Group Inbound Rule - Port 443 HTTPS
resource "aws_security_group_rule" "in_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.poc_security_group.id
}

# Security Group Inbound Rule - Port 9999
resource "aws_security_group_rule" "in_nine" {
  type              = "ingress"
  from_port         = 9999
  to_port           = 9999
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.poc_security_group.id
}


# EC2 Instance
module "ec2-instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "4.1.4"

  name                   = "${var.vpc_name}-ec2-instance"
  ami                    = "ami-03fa9bf0e042d483d" # "Splunk SOAR" AMI ID
  instance_type          = var.ec2_instance_type
  key_name               = var.key_name
  monitoring             = false
  vpc_security_group_ids = [aws_security_group.poc_security_group.id]
  subnet_id              = module.vpc.public_subnets[0]

  root_block_device = [
    {
      encrypted   = true
      volume_type = "gp3"
      throughput  = 200
      volume_size = tostring(var.root_block_volume_size)
    }
  ]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }

  # Set up Splunk for SSL
  # user_data = file("./enableSplunkWebSSL.sh")
}

# Elastic IP Address
resource "aws_eip" "eip" {
  instance = module.ec2-instance.id
  vpc      = true

  tags = {
    Name = "${var.vpc_name}-eip"
  }
}

/*

######################
# SSL Certificate    #
######################

# Code taken from the example posted here: 
# https://registry.terraform.io/providers/hashicorp/tls/latest/docs

# This example creates a self-signed certificate,
# and uses it to create an AWS IAM Server certificate.
#
# THIS IS NOT RECOMMENDED FOR PRODUCTION SERVICES.
# See the detailed documentation of each resource for further
# security considerations and other practical tradeoffs.

/*
resource "tls_private_key" "tls_key" {
  algorithm = "ECDSA"
}

resource "tls_self_signed_cert" "certificate" {
  private_key_pem = tls_private_key.tls_key.private_key_pem

  # Certificate expires after 720 hours/30 days.
  validity_period_hours = 720

  # Reasonable set of uses for a server SSL certificate.
  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]

  # Note to self: Dunno if this is correct, but seems to work at least for public ip address
  dns_names = ["${aws_eip.eip.public_ip}", "${module.ec2-instance.public_dns}"]

  subject {
    common_name  = "Auto-POC"
    organization = "Splunk"
  }
}

# Register certifiacte with AWS AMI 
resource "aws_iam_server_certificate" "iam_server_certificate" {
  name             = "${var.vpc_name}_self_signed_cert"
  certificate_body = tls_self_signed_cert.certificate.cert_pem
  private_key      = tls_private_key.tls_key.private_key_pem
}
*/