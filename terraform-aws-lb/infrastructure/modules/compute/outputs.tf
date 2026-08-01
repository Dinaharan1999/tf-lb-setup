output "instance_ids" {

  description = "EC2 Instance IDs"

  value = aws_instance.web[*].id

}

output "private_ips" {

  description = "Private IPs"

  value = aws_instance.web[*].private_ip

}

output "public_ips" {

  description = "Public IPs"

  value = aws_instance.web[*].public_ip

}