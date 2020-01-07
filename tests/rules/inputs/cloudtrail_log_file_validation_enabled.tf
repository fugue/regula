provider "aws" {
  region = "us-east-2"
}

data "aws_caller_identity" "current" {}

resource "aws_s3_bucket_policy" "policy" {
  bucket = aws_s3_bucket.trail_bucket.id

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Sid1",
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "${aws_s3_bucket.trail_bucket.arn}"
        },
        {
            "Sid": "Sid2",
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "${aws_s3_bucket.trail_bucket.arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
        }
    ]
}
POLICY
}

resource "aws_s3_bucket" "trail_bucket" {
  force_destroy = true
}

resource "aws_cloudtrail" "valid_trail" {
  name = "valid_trail"
  s3_bucket_name = aws_s3_bucket.trail_bucket.id

  enable_log_file_validation = true

  depends_on = [aws_s3_bucket_policy.policy]
}

resource "aws_cloudtrail" "invalid_trail" {
  name = "invalid_trail"
  s3_bucket_name = aws_s3_bucket.trail_bucket.id

  enable_log_file_validation = false

  depends_on = [aws_s3_bucket_policy.policy]
}
