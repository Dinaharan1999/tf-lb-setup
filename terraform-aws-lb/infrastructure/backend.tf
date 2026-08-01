terraform {
  backend "s3" {
    bucket         = "dinaharan-tf-state-bucket"
    key            = "terraform-aws-alb/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-lock-table"
    encrypt        = true
  }
}