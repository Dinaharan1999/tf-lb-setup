output "alb_sg" {

  description = "ALB Security Group"

  value = aws_security_group.alb.id

}

output "web_sg" {

  description = "Web Security Group"

  value = aws_security_group.web.id

}