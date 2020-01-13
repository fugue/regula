provider "aws" {
  region = "us-east-1"
}
resource "aws_vpc" "valid" {
  cidr_block       = "10.0.0.0/16"

  tags = {
    Name = "123456"
  }
}

resource "aws_vpc" "invalid" {
  cidr_block       = "10.0.0.0/16"

  tags = {
    Name = "12345"
  }
}

resource "aws_s3_bucket" "invalid" {
  bucket = "my-tf-test-bucket"
  acl    = "private"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}