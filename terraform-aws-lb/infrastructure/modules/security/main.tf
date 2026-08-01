##############################################################
# Security Group - Application Load Balancer
##############################################################

resource "aws_security_group" "alb" {

  name        = "${var.project_name}-alb-sg"
  description = "Security Group for ALB"
  vpc_id      = var.vpc_id

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-alb-sg"
    }
  )
}

##############################################################
# HTTP
##############################################################

resource "aws_vpc_security_group_ingress_rule" "alb_http" {

  security_group_id = aws_security_group.alb.id

  ip_protocol = "tcp"

  from_port = 80

  to_port = 80

  cidr_ipv4 = "0.0.0.0/0"

  description = "Allow HTTP"

}

##############################################################
# HTTPS
##############################################################

resource "aws_vpc_security_group_ingress_rule" "alb_https" {

  security_group_id = aws_security_group.alb.id

  ip_protocol = "tcp"

  from_port = 443

  to_port = 443

  cidr_ipv4 = "0.0.0.0/0"

  description = "Allow HTTPS"

}

##############################################################
# Outbound
##############################################################

resource "aws_vpc_security_group_egress_rule" "alb_outbound" {

  security_group_id = aws_security_group.alb.id

  ip_protocol = "-1"

  cidr_ipv4 = "0.0.0.0/0"

}

##############################################################
# Security Group - EC2
##############################################################

resource "aws_security_group" "web" {

  name        = "${var.project_name}-web-sg"

  description = "Web Server Security Group"

  vpc_id = var.vpc_id

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-web-sg"
    }
  )

}

##############################################################
# HTTP ONLY FROM ALB
##############################################################

resource "aws_vpc_security_group_ingress_rule" "web_http" {

  security_group_id = aws_security_group.web.id

  ip_protocol = "tcp"

  from_port = 80

  to_port = 80

  referenced_security_group_id = aws_security_group.alb.id

  description = "Allow HTTP from ALB"

}

##############################################################
# SSH
##############################################################

resource "aws_vpc_security_group_ingress_rule" "web_ssh" {

  security_group_id = aws_security_group.web.id

  ip_protocol = "tcp"

  from_port = 22

  to_port = 22

  cidr_ipv4 = var.ssh_allowed_cidr

  description = "SSH"

}

##############################################################
# Outbound
##############################################################

resource "aws_vpc_security_group_egress_rule" "web_outbound" {

  security_group_id = aws_security_group.web.id

  ip_protocol = "-1"

  cidr_ipv4 = "0.0.0.0/0"

}