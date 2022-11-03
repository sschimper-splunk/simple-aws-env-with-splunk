output "_1_url" {
  description = "Public IP address of the EC2 instance hosted in the public subnet of the VPC."
  value       = "http://${aws_eip.eip.public_ip}/"
}

output "_2_username" {
  description = "Username to log in"
  value       = "admin"
}

output "_3_password" {
  description = "Password to log in"
  value       = module.ec2-instance.id
}

output "_4_ssh_username" {
  description = "SSH username"
  value       = "phantom"
}