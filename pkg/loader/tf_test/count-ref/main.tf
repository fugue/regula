variable "aws_region" {
  default = "eu-west-1"
}

provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "not_working_1" {
  count  = var.aws_region == "eu-west-1" ? 1 : 0
  bucket = "not-working-1-random-string"
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "not_working_1_block" {
  count                   = var.aws_region == "eu-west-1" ? 1 : 0
  bucket                  = aws_s3_bucket.not_working_1[count.index].id
  block_public_acls       = aws_s3_bucket.not_working_1[count.index].acl == "private" ? true : false
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
