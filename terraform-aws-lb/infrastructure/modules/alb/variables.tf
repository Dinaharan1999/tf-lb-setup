variable "project_name" {
  description = "Project Name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnet_ids" {
  description = "Public Subnet IDs"
  type        = list(string)
}

variable "alb_sg" {
  description = "ALB Security Group"
  type        = string
}

variable "instance_ids" {
  description = "EC2 Instance IDs"
  type        = list(string)
}

variable "common_tags" {
  description = "Common Tags"
  type        = map(string)
}