output "splunk_instances" {
  value = [
    for instance in module.ec2-instance : "URL: http://${instance.public_ip}:8000/, Username: admin, Password: SPLUNK-${instance.id}"
  ]
}