output "Username" {
  value = "admin"
}

output "Password" {
  value = "changeme"
}

output "instances" {
  value = [
    for instance in module.ec2-instance : "URL: https://${instance.public_ip}:8000/"
  ]
}

output "note_for_user" {
  value = "Please be patient, and allow the Splunk instance(s) a couple of minutes to set itself up."
}