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

resource "aws_instance" "k8s-master1" {
  ami                  = "ami-088da9557aae42f39"
  instance_type        = "t2.medium"
  iam_instance_profile = "SessionManagerInstanceProfile"
  key_name             = "client-key"
  tags = {
    Name = "k8s-master1"
  }
}

resource "aws_instance" "k8s-worker1" {
  ami                  = "ami-088da9557aae42f39"
  instance_type        = "t2.medium"
  iam_instance_profile = "SessionManagerInstanceProfile"
  key_name             = "client-key"
  tags = {
    Name = "k8s-worker1"
  }
}

resource "aws_instance" "k8s-worker2" {
  ami                  = "ami-088da9557aae42f39"
  instance_type        = "t2.medium"
  iam_instance_profile = "SessionManagerInstanceProfile"
  key_name             = "client-key"
  tags = {
    Name = "k8s-worker2"
  }
}
