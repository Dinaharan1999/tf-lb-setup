variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "ap-south-1"
}

variable "bucket_name" {
  description = "Terraform backend bucket name"
  type        = string
}

variable "dynamodb_table_name" {
  description = "Terraform Lock Table"
  type        = string
}