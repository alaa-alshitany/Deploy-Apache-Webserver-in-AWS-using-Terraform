output "vpc_id" {
  value = aws_vpc.web_vpc.id
  description = "vpc_id"
}

output "private_subnets" {
  value = aws_subnet.private_subnets[*].id
}

output "public_subnet" {
  value = aws_subnet.public_subnet[*].id
}