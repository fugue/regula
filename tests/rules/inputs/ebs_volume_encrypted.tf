provider "aws" {
  region = "us-east-2"
}

resource "aws_ebs_volume" "good" {
  availability_zone = "us-west-2a"
  size              = 40
  encrypted         = true
}

resource "aws_ebs_volume" "missing" {
  availability_zone = "us-west-2a"
  size              = 40
}

resource "aws_ebs_volume" "bad" {
  availability_zone = "us-west-2a"
  size              = 40
  encrypted         = false
}
