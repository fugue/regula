provider "aws" {
  region = "us-west-2"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "valid_micro" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
}

resource "aws_instance" "valid_small" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.small"
}

resource "aws_instance" "valid_medium" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.medium"
}

resource "aws_instance" "valid_large" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.large"
}

resource "aws_instance" "valid_xlarge" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.xlarge"
}

resource "aws_instance" "valid_2xlarge" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.2xlarge"
}
