# Copyright 2020 Fugue, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
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
