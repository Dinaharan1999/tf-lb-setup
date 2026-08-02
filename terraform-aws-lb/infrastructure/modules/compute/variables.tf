variable "project_name" {
  description = "Project Name"
  type        = string
}

variable "instance_type" {
  description = "EC2 Instance Type"
  type        = string
}

variable "key_name" {
  description = "SSH Key Pair"
  type        = string
  default     = ""
}

variable "subnet_ids" {
  description = "Public Subnet IDs"
  type        = list(string)
}

variable "web_sg" {
  description = "Web Security Group"
  type        = string
}

variable "common_tags" {
  description = "Common Tags"
  type        = map(string)
}