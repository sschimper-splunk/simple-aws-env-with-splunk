#######################
# Terraform Providers #
#######################

provider "aws" {
  region     = lookup(var.available_aws_regions, var.chosen_aws_region)
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
  cidr = "10.0.0.0/16"

  azs             = ["${var.chosen_aws_region}a"]
  private_subnets = ["10.0.1.0/24"]
  public_subnets  = ["10.0.101.0/24"]

  # enable_ipv6 = true

  # enable_nat_gateway = false
  # single_nat_gateway = true

  public_subnet_tags = {
    Name = "overridden-name-public"
  }

  tags = {
    Owner       = "user"
    Environment = "dev"
  }

  vpc_tags = {
    Name = "vpc-name"
  }
}

# EC2 Instance 
module "ec2-instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "4.1.4"

  depends_on = [
    module.vpc
  ]

  name = "single-instance"

  ami                    = "ami-ebd02392"
  instance_type          = var.ec2_instance_type
  key_name               = "user1"
  monitoring             = false
  # vpc_security_group_ids = ["sg-12345678"]
  subnet_id              = module.vpc.public_subnets[0]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
  
}