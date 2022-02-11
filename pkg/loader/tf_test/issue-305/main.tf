resource "aws_s3_bucket" "bucket" {
  bucket = terraform.workspace
}
