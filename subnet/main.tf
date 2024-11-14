terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-west-2"

  default_tags {
    tags = {
      Name         = "dhk"
      environments = "dhk-test"
    }
  }
}


resource "aws_subnet" "Public_Subnet_1" {
  vpc_id            = var.vpc_id  
  availability_zone = "us-west-2a"
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "Public subnet-1"
  }
}

resource "aws_subnet" "Public_Subnet_2" {
  vpc_id            = var.vpc_id  
  availability_zone = "us-west-2b"
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "Public subnet-2"
  }
}

resource "aws_subnet" "private_Subnet_1" {
  vpc_id            = var.vpc_id  
  availability_zone = "us-west-2a"
  cidr_block = "10.0.3.0/24"
  
  tags = {
    Name = "private subnet-1"
  }
}

resource "aws_route_table_association" "my_route_table_assoc_1" {
  subnet_id      = aws_subnet.Public_Subnet_1.id 
  route_table_id = var.public_route_id
}

resource "aws_route_table_association" "my_route_table_assoc_2" {
  subnet_id      = aws_subnet.Public_Subnet_2.id
  route_table_id = var.public_route_id
}