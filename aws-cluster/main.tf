terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.73"
    }
  }

  required_version = ">= 1.1.4"
}

provider "aws" {
  profile = "default"
  region  = "ap-northeast-1"
}

resource "aws_key_pair" "client" {
  key_name   = "client-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_vpc" "k8s" {
  cidr_block           = "10.1.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "k8s-vpc"
  }
}

resource "aws_internet_gateway" "k8s" {
  vpc_id = aws_vpc.k8s.id
  tags = {
    Name = "k8s-gateway"
  }
}

resource "aws_route_table" "k8s" {
  vpc_id = aws_vpc.k8s.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.k8s.id
  }
  tags = {
    Name = "k8s-route-table"
  }
}

resource "aws_subnet" "k8s" {
  vpc_id            = aws_vpc.k8s.id
  cidr_block        = "10.1.1.0/24"
  availability_zone = "ap-northeast-1d"
  tags = {
    Name = "k8s-subnet"
  }
}

resource "aws_route_table_association" "k8s" {
  subnet_id      = aws_subnet.k8s.id
  route_table_id = aws_route_table.k8s.id
}

resource "aws_security_group" "k8s" {
  name   = "k8s-sg"
  vpc_id = aws_vpc.k8s.id
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "k8s-sg"
  }
}

resource "aws_instance" "k8s-master1" {
  ami                         = "ami-088da9557aae42f39"
  instance_type               = "t2.medium"
  iam_instance_profile        = "SessionManagerInstanceProfile"
  subnet_id                   = aws_subnet.k8s.id
  private_ip                  = "10.1.1.10"
  associate_public_ip_address = true
  security_groups = [
    aws_security_group.k8s.id
  ]
  key_name = aws_key_pair.client.id
  tags = {
    Name = "k8s-master1"
  }
}

resource "aws_instance" "k8s-worker1" {
  ami                         = "ami-088da9557aae42f39"
  instance_type               = "t2.medium"
  iam_instance_profile        = "SessionManagerInstanceProfile"
  subnet_id                   = aws_subnet.k8s.id
  private_ip                  = "10.1.1.20"
  associate_public_ip_address = true
  security_groups = [
    aws_security_group.k8s.id
  ]
  key_name                    = aws_key_pair.client.id
  tags = {
    Name = "k8s-worker1"
  }
}

resource "aws_instance" "k8s-worker2" {
  ami                         = "ami-088da9557aae42f39"
  instance_type               = "t2.medium"
  iam_instance_profile        = "SessionManagerInstanceProfile"
  subnet_id                   = aws_subnet.k8s.id
  private_ip                  = "10.1.1.21"
  associate_public_ip_address = true
  security_groups = [
    aws_security_group.k8s.id
  ]
  key_name                    = aws_key_pair.client.id
  tags = {
    Name = "k8s-worker2"
  }
}
