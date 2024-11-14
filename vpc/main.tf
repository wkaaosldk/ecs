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

# Create a VPC
resource "aws_vpc" "example" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "example-vpc"
  }
}