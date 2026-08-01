provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "terraform-alb-nginx"
      Environment = "lab"
      ManagedBy   = "Terraform"
      Owner       = "Dinaharan"
    }
  }
}