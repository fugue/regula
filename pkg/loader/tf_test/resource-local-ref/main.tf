resource "aws_s3_bucket" "trail_bucket" {
  bucket_prefix = "hello"
  force_destroy = true
  tags = {
    prefix = bucket_prefix
  }
}
