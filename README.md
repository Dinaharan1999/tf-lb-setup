# Terraform AWS Load Balanced Web Server

## Overview

This project provisions a highly available web server environment on AWS using Terraform. The infrastructure is designed with a modular architecture following Infrastructure as Code (IaC) best practices.

The deployment creates:

* Remote Terraform backend using Amazon S3 and DynamoDB (Bootstrap)
* Custom VPC
* Two Public Subnets across two Availability Zones
* Internet Gateway and Route Tables
* Security Groups following the Principle of Least Privilege
* Two Amazon Linux 2023 EC2 instances
* NGINX web server installed automatically using User Data
* Application Load Balancer (ALB)
* Target Group with Health Checks
* IAM Role attached to EC2 with **AmazonSSMManagedInstanceCore**
* Automatic traffic failover if one web server becomes unavailable

No manual configuration is required after Terraform initialization.

---

# Architecture

```
                        Internet
                            │
                            ▼
                 Application Load Balancer
                            │
                  Target Group (HTTP:80)
                  ┌──────────┴──────────┐
                  │                     │
            EC2 Instance 1        EC2 Instance 2
          Amazon Linux 2023     Amazon Linux 2023
                 NGINX                 NGINX
                  │                     │
                  └──────────┬──────────┘
                             │
                           VPC
```

---

# Project Structure

```
terraform-aws-webserver/
│
├── bootstrap/
│   ├── main.tf
│   ├── providers.tf
│   ├── variables.tf
│   ├── versions.tf
│   └── outputs.tf
│
├── infrastructure/
│   ├── backend.tf
│   ├── backend.hcl
│   ├── providers.tf
│   ├── versions.tf
│   ├── variables.tf
│   ├── locals.tf
│   ├── outputs.tf
│   ├── main.tf
│   ├── terraform.tfvars.example
│   │
│   ├── user-data/
│   │   └── nginx.sh
│   │
│   └── modules/
│       ├── network/
│       ├── security/
│       ├── compute/
│       └── alb/
│
├── .gitignore
└── README.md
```

---

# Prerequisites

* Terraform >= 1.6
* AWS CLI configured
* AWS Account
* IAM User/Role with permissions to create:

  * VPC
  * EC2
  * ALB
  * IAM
  * S3
  * DynamoDB

Verify authentication:

```bash
aws sts get-caller-identity
```

---

# Step 1 - Create Remote Backend

Navigate to the bootstrap directory.

```bash
cd bootstrap

terraform init

terraform apply
```

Provide the following values when prompted:

```
bucket_name
dynamodb_table_name
```

Example:

```
Bucket Name         : my-terraform-state-12345
DynamoDB Table Name : terraform-lock-table
```

This creates:

* S3 Bucket (Terraform Remote State)
* DynamoDB Table (State Locking)

---

# Step 2 - Configure Backend

Navigate to the infrastructure directory.

Create a `backend.hcl` file.

Example:

```hcl
bucket         = "my-terraform-state-12345"
key            = "terraform-aws-webserver/terraform.tfstate"
region         = "ap-south-1"
dynamodb_table = "terraform-lock-table"
encrypt        = true
```

Initialize Terraform.

```bash
terraform init -backend-config=backend.hcl
```

---

# Step 3 - Deploy Infrastructure

Review the execution plan.

```bash
terraform plan
```

Deploy the infrastructure.

```bash
terraform apply
```

Terraform provisions:

* Networking
* Security Groups
* IAM Role
* EC2 Instances
* NGINX
* Application Load Balancer

---

# Verify Deployment

Retrieve the Load Balancer DNS.

```bash
terraform output
```

Example:

```
alb_dns_name = my-alb-xxxxxxxx.ap-south-1.elb.amazonaws.com
```

Access the application.

```bash
curl http://<alb_dns_name>
```

Expected response:

```
Hello World

Instance ID : i-xxxxxxxx

Hostname : ip-10-0-x-x

Availability Zone : ap-south-1a
```

Refreshing multiple times will show responses from different EC2 instances.

---

# High Availability Test

Terminate one EC2 instance.

```bash
aws ec2 terminate-instances --instance-ids <instance-id>
```

The Application Load Balancer health checks detect the unhealthy instance and automatically route traffic to the remaining healthy instance.

---

# Systems Manager Access

Instances do not use SSH.

Each EC2 instance is attached to an IAM Role with the managed policy:

```
AmazonSSMManagedInstanceCore
```

This enables secure management through AWS Systems Manager Session Manager without requiring:

* SSH keys
* Port 22
* Bastion Host

---

# Destroy Infrastructure

To remove all infrastructure resources:

```bash
terraform destroy
```

To remove the backend resources:

```bash
cd ../bootstrap

terraform destroy
```

---

# Design Decisions

* Modular Terraform structure for maintainability and reusability.
* Separate bootstrap configuration for remote backend provisioning.
* Remote state stored in Amazon S3 with DynamoDB state locking.
* Least privilege Security Groups.
* IAM Role attached to EC2 instead of SSH key pairs.
* NGINX installation automated through EC2 User Data.
* Application Load Balancer distributes traffic across multiple Availability Zones.
* Health checks provide automatic failover when an instance becomes unavailable.

---

# Technologies Used

* Terraform
* AWS
* Amazon EC2
* Amazon VPC
* Application Load Balancer
* Amazon S3
* Amazon DynamoDB
* IAM
* AWS Systems Manager
* NGINX
* Amazon Linux 2023

---

Thank you for reviewing this project. I would be happy to walk through the architecture, Terraform modules, design decisions, and any implementation details during the review.
