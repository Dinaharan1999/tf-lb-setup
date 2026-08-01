output "vpc_id" {

  description = "VPC ID"

  value = aws_vpc.this.id

}

output "public_subnet_ids" {

  description = "Public Subnet IDs"

  value = aws_subnet.public[*].id

}

output "internet_gateway_id" {

  description = "Internet Gateway"

  value = aws_internet_gateway.this.id

}

output "route_table_id" {

  description = "Public Route Table"

  value = aws_route_table.public.id

}