provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "valid_sg_1" {
  name        = "valid_sg_1"
  
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "valid_sg_2" {
  name        = "valid_sg_2"
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.10.0.0/16"]
  }
}

resource "aws_security_group" "invalid_sg_1" {
  name        = "invalid_sg_1"
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "invalid_sg_2" {
  name        = "invalid_sg_2"
  
  ingress {
    from_port   = 20
    to_port     = 25
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}