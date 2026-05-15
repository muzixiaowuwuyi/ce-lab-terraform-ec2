#web public ip
output "web_server_public_ip" {
    description = "Public IP addresses of the web server instances"
  value = aws_instance.web_server[*].public_ip
}

#web accessible url
output "web_server_url" {
    description = "URL to access the web server instances"
  value = [for ip in aws_instance.web_server[*].public_ip : "http://${ip}"]
}

#app private ip
output "app_server_private_ip" {
    description = "Private IP addresses of the app server instances"
  value = aws_instance.app_server[*].private_ip
}

#allowed ssh ip
output "allowed_ssh_ip" {
    description = "The IP address allowed to SSH into the instances"
  value = chomp(data.http.my_public_ip.response_body)
}