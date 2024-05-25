# Create a VPC
resource "aws_vpc" "prod-vpc" { 
    cidr_block = "10.0.0.0/16"
}
#Create 6 subnets 2-public 2-private 2-db resource
resource "aws_subnet" "public_1a" {
  vpc_id     = aws_vpc.prod-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "eu-central-1a"
}

resource "aws_subnet" "public_1b" {
  vpc_id     = aws_vpc.prod-vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "eu-central-1b"
}
resource "aws_subnet" "private_1a" {
  vpc_id     = aws_vpc.prod-vpc.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "eu-central-1a"
}

resource "aws_subnet" "private_1b" {
  vpc_id     = aws_vpc.prod-vpc.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "eu-central-1b"
}

resource "aws_subnet" "db_1a" {
  vpc_id     = aws_vpc.prod-vpc.id
  cidr_block = "10.0.5.0/24"
  availability_zone = "eu-central-1a"
}

resource "aws_subnet" "db_1b" {
  vpc_id     = aws_vpc.prod-vpc.id
  cidr_block = "10.0.6.0/24"
  availability_zone = "eu-central-1b"
}