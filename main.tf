variable "access_key" {
  decription = "aws access key"
}

variable "secret_key" {
  description = "aws secret key"
}

provider "aws" {
  region = "us-east-2"
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_vpc" "development-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
	  Name = "development"
  }
}

variable "subnet_cidr_block" {
  description = "subnet cidr block"
  type = string
}

variable "vpc_cidr_block" {
  description = "vpc cidr block"
}

resource "aws_subnet" "dev-subnet-1" {
  vpc_id = aws_vpc.development-vpc.id
  cidr_block = var.subnet_cidr_block
  availability_zone = "us-east-2a"
  tags = {
	Name = "subnet_1_dev"
  }
}

output "dev-vpc-id" {
  value = aws_vpc.development-vpc.id
}

output "dev-subnet-id" {
  value = aws_subnet.dev-subnet-1.id
}