output "ec2-public-ip" {
  description = "Public IP address of the EC2 instance hosted in the public subnet of the VPC."
  value       = module.ec2-instance.public_ip
}
