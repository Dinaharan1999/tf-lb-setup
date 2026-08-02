variable "project_name" {
  description = "Project Name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "common_tags" {
  description = "Common Tags"
  type        = map(string)
}

variable "ssh_allowed_cidr" {
  description = "CIDR allowed to SSH"
  type        = string
  default     = "0.0.0.0/0"
}