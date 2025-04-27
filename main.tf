provider "aws" {
  region = "us-east-1"
  access_key = ""
  secret_key = ""
}

resource "aws_vpc" "my-vpc" {
  cidr_block = var.vpc_cidrblock   
  enable_dns_hostnames = var.vpc_enablednshostname
  enable_dns_support = var.vpc_enablednssupport
   tags = {
     Name=var.vpc_name
   }
}

resource "aws_subnet" "my-subnets" {
  count = length(var.subnets_availabilityzones)
  vpc_id = aws_vpc.my-vpc.id
  availability_zone = element(var.subnets_availabilityzones, count.index)
  cidr_block = element(var.subnets_cidrblocks, count.index)
  tags = {
    Name="subnet-${count.index+1}"
  }
}

resource "aws_internet_gateway" "my-igw" {
  vpc_id = aws_vpc.my-vpc.id
}

resource "aws_route_table" "my-route" {
  vpc_id = aws_vpc.my-vpc.id
  
 
route{
  cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.my-igw.id
 }
}

resource "aws_route_table_association" "my-association" {
  count = length(aws_subnet.my-subnets)
  route_table_id = aws_route_table.my-route.id
  subnet_id = element(aws_subnet.my-subnets[*].id, count.index)
}

resource "aws_security_group" "my-security" {
  vpc_id = aws_vpc.my-vpc.id
  ingress  {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"] 
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "project_key" {
  key_name   = "project-key"   # Give any name you like
  public_key = file("project-key.pub")  # This is the PUBLIC KEY path
}


terraform {
  backend "s3" {
    bucket         = "mymanjunadhabucket"
    key            = "terraform.tfstate"
    region         = "us-east-1"
  
  }
}

