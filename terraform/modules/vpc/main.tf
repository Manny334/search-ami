terraform {
  required_version = ">=0.12"
}

# Creating a AWS VPC
resource "aws_vpc" "es_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    "Name" = "fw-${var.env}-vpc",
    "ENV"  = var.env
  }
}
# Creating AWS subnet
resource "aws_subnet" "us-east-1a" {
  vpc_id                  = aws_vpc.es_vpc.id
  cidr_block              = var.es_subnets_cidr[0]
  availability_zone       = var.availability_zones[0]
  map_public_ip_on_launch = true

  tags = {
    "Name" = "fw-${var.env}-us-east-1a",
    "ENV"  = var.env
  }
}
resource "aws_subnet" "us-east-1c" {
  vpc_id                  = aws_vpc.es_vpc.id
  cidr_block              = var.es_subnets_cidr[1]
  availability_zone       = var.availability_zones[1]
  map_public_ip_on_launch = true
  tags = {
    "Name" = "fw-${var.env}-us-east-1c",
    "ENV"  = var.env
  }
}
# Creating an Internet Gateway
resource "aws_internet_gateway" "vpc_igw" {
  vpc_id = aws_vpc.es_vpc.id

  tags = {
    "Name" = "fw-${var.env}-vpc_igw",
    "ENV"  = var.env
  }
}

resource "aws_route_table" "public_routes" {
  vpc_id = aws_vpc.es_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc_igw.id
  }

  tags = {
    "Name" = "fw-${var.env}-public-routes",
    "ENV"  = var.env
  }
}
# Associating Route table with respective subnets
resource "aws_route_table_association" "us_east_1a_route" {
  subnet_id      = aws_subnet.us-east-1a.id
  route_table_id = aws_route_table.public_routes.id
}
resource "aws_route_table_association" "us_east_1c_route" {
  subnet_id      = aws_subnet.us-east-1c.id
  route_table_id = aws_route_table.public_routes.id
}
