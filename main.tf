variable "access_key" {
  description = "aws access key"
}

variable "secret_key" {
  description = "aws secret key"
}

provider "aws" {
  region = "us-east-2"
  access_key = var.access_key
  secret_key = var.secret_key
}

variable "avail_zone" {}
variable "vpc_cidr_block" {}
variable "subnet_cidr_block" {}
variable "env_prefix" {}
variable "jade" {}

resource "aws_vpc" "app-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    "Name" = "${var.env_prefix}-vpc"
  }
}

resource "aws_subnet" "app-subnet-1" {
  vpc_id = aws_vpc.app-vpc.id
  cidr_block = var.subnet_cidr_block
  availability_zone = var.avail_zone
  tags = {
    "Name" = "${var.env_prefix}-subnet-1"
  }
}

resource "aws_route_table" "app-router" {
  vpc_id = aws_vpc.app-vpc.id
  route {
          cidr_block = "0.0.0.0/0"
          gateway_id = aws_internet_gateway.app-gateway.id
      }

  tags = {
      Name = "${var.env_prefix}-route-table"
  }
}

resource "aws_internet_gateway" "app-gateway" {
  vpc_id = aws_vpc.app-vpc.id

  tags = {
      Name = "${var.env_prefix}-internet-gateway"
  }
}

resource "aws_route_table_association" "router-association" {
  subnet_id = aws_subnet.app-subnet-1.id
  route_table_id = aws_route_table.app-router.id
}

resource "aws_security_group" "app-sg" {
  name = "app-sg"
  vpc_id = aws_vpc.app-vpc.id

  ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = [var.jade]
  }

  ingress {
      from_port = 8080
      to_port = 8080
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]

  }

  tags = {
      Name = "${var.env_prefix}-sg"
  }
}

