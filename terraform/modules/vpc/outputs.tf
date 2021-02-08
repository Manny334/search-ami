output "vpc_id" {
  value = aws_vpc.es_vpc.id
}

output "us-east-1a" {
  value = aws_subnet.us-east-1a.id
}

output "us-east-1c" {
  value = aws_subnet.us-east-1c.id
}

output "vpc" {
  value = aws_vpc.es_vpc
}
