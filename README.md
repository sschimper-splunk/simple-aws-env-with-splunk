# Splunk POC Automation with Terraform

Todo

## Prerequisites
- An AWS account.

## Set Up
Copy the 'terraform.tfvars.example' and remove the '.example' extension from the copy.
In the now 'terraform.tfvars' edit the variables:

- Set 'aws_access_key_id' and 'aws_secret_access_key' according to your own Access Key that is connected to your AWS user.
- For the EC2 instance, create a key, either with OpenSSL or via the AWS GUI, and set 'key_name' to the name you gave that key.

Edit the remaining variables specific to the AWS infrastructure accordingly.