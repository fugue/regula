variable "foo_count" {
  type = int
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "foo" {
  bucket = "mybucket-${count.index}"
  count = var.foo_count ? 1 : null
}
