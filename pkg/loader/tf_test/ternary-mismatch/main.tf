variable "foo" {
  type = string
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "foo" {
  bucket = var.foo ? {"foo": "bar"} : [1]
}

resource "aws_s3_bucket" "bar" {
  bucket = var.foo ? {"foo": "bar"} : aws_s3_bucket.foo.bucket
}
