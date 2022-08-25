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
module "security-group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.13.0"

  name        = "${var.vpc_name}-security-group"
  description = "Open ports are 8000 (Splunk Web), 22 (SSH), and 443 (SSL/HTTPS)."
  vpc_id      = module.vpc.vpc_id
}

# EC2 Instance
module "ec2-instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "4.1.4"

  name                   = "${var.vpc_name}-ec2-instance"
  ami                    = "ami-036905505de15fea5" # "Splunk Enterprise" AMI ID
  instance_type          = lookup(var.available_ec2_instance_types, var.selected_ec2_instance_type)
  key_name               = var.key_name
  monitoring             = false
  vpc_security_group_ids = [module.security-group.security_group_id]
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
}