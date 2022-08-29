terraform {
  required_version = ">= 0.13.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.28.0"
    }
    splunk = {
      source  = "splunk/splunk"
      version = "1.4.14"
    }
  }
}