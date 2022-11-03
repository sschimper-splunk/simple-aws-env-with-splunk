variable "aws_access_key_id" {
  default = []
}

variable "aws_secret_access_key" {
  default = []
}

variable "private_key_path" {
  default = []
}

variable "key_name" {
  default = []
}

variable "vpc_name" {
  # description = "Please provide a name for the VPC. We recommend the following naming convention: customer-poc_type-sesr."
  default = []
}

variable "available_aws_regions" {
  # description = "Please select an AZ: (1:eu-west-1, 2:eu-west-3, 3:eu-central-1, 4:us-east-1, 5:us-east-2, 6:us-west-1, 7:us-west-2, 8:ap-southeast-1, 9:ap-southeast-2, 10:sa-east-1)"
  default = []
}

variable "selected_aws_region" {
  description = "Provide the desired region"
  default = {
    "1"  = "eu-west-1"
    "2"  = "eu-west-3"
    "3"  = "eu-central-1"
    "4"  = "us-east-1"
    "5"  = "us-east-2"
    "6"  = "us-west-1"
    "7"  = "us-west-2"
    "8"  = "ap-southeast-1"
    "9"  = "ap-southeast-2"
    "10" = "sa-east-1"
  }
}

variable "ec2_instance_type" {
  # description = "Provide the desired EC2 instance type"
  default = "m5.xlarge"
}

variable "root_block_volume_size" {
  # description = "Please enter a number for the EC2 instance volume size in GiB: "
  default = "200"
}