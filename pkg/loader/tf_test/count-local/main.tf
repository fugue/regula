locals {
  create_bucket = false
}

resource "aws_s3_bucket" "optional_bucket" {
  count = local.create_bucket? 1 : 0
  force_destroy = true
}
