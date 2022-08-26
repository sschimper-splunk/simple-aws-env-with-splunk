output "_1_url" {
  description = "Public IP address of the EC2 instance hosted in the public subnet of the VPC."
  value       = "http://${aws_eip.eip.public_ip}:8000/"
}

output "_2_username" {
  description = "Username to log in"
  value       = "admin"
}

output "_3_password" {
  description = "Password to log in"
  value       = "SPLUNK-${module.ec2-instance.id}"
}