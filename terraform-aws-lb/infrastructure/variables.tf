variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Project Name"
  type        = string
  default     = "terraform-alb-nginx"
}

variable "environment" {
  description = "Deployment Environment"
  type        = string
  default     = "lab"
}

variable "vpc_cidr" {
  description = "VPC CIDR"

  type = string

  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {

  description = "Public Subnets"

  type = list(string)

  default = [

    "10.0.1.0/24",
    "10.0.2.0/24"

  ]
}

variable "instance_type" {

  description = "EC2 Instance Type"

  type = string

  default = "t3.micro"

}

variable "key_name" {

  description = "EC2 Key Pair"

  type = string

  default = ""

}