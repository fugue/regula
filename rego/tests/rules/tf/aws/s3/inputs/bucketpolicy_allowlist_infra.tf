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

# terraform file that generated bucketpolicy_allowlist_infra.json

provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "allowlist-inline-policy" {
  bucket = "allowlist-inline-policy"
  policy = <<POLICY
    {
    "Id": "BucketPolicy",
    "Version": "2012-10-17",
    "Statement": [
        {
        "Sid": "AllAccess",
        "Action": "s3:List*",
        "Effect": "Allow",
        "Resource": [
            "arn:aws:s3:::allowlist-inline-policy"
        ],
        "Principal": "*"
        }
    ]
    }
    POLICY
}

resource "aws_s3_bucket" "denylist-inline-policy" {
  bucket = "denylist-inline-policy"
  policy = <<POLICY
    {
    "Id": "BucketPolicy",
    "Version": "2012-10-17",
    "Statement": [
        {
        "Sid": "AllAccess",
        "Action": "s3:List*",
        "Effect": "Deny",
        "Resource": [
            "arn:aws:s3:::denylist-inline-policy"
        ],
        "Principal": "*"
        }
    ]
    }
    POLICY
}

resource "aws_s3_bucket" "allowget-inline-policy" {
  bucket = "allowget-inline-policy"
  policy = <<POLICY
    {
    "Id": "BucketPolicy",
    "Version": "2012-10-17",
    "Statement": [
        {
        "Sid": "AllAccess",
        "Action": "s3:GetBucket",
        "Effect": "Allow",
        "Resource": [
            "arn:aws:s3:::allowget-inline-policy"
        ],
        "Principal": "*"
        }
    ]
    }
    POLICY
}

resource "aws_s3_bucket" "nopolicy-bucket" {
  bucket = "nopolicy-bucket"
}

resource "aws_s3_bucket" "allowlist-external-policy" {
  bucket = "allowlist-external-policy"
}

resource "aws_s3_bucket_policy" "allowlist-policy" {
  bucket = aws_s3_bucket.allowlist-external-policy.id
  policy = jsonencode({
    "Id" : "BucketPolicy",
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "AllAccess",
        "Action" : "s3:ListBucket",
        "Effect" : "Allow",
        "Resource" : [
          "arn:aws:s3:::allowlist-external-policy"
        ],
        "Principal" : "*"
      }
    ]
  })
}

resource "aws_s3_bucket" "allowget-external-policy" {
  bucket = "allowget-external-policy"
}

resource "aws_s3_bucket_policy" "allowget-policy" {
  bucket = aws_s3_bucket.allowget-external-policy.id
  policy = jsonencode({
    "Id" : "BucketPolicy",
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "AllAccess",
        "Action" : "*",
        "Effect" : "Allow",
        "Resource" : [
          "arn:aws:s3:::allowget-external-policy"
        ],
        "Principal" : { "AWS" : "*" }
      }
    ]
  })
}

resource "aws_s3_bucket" "denylist-external-policy" {
  bucket = "denylist-external-policy"
}

resource "aws_s3_bucket_policy" "denylist-policy" {
  bucket = aws_s3_bucket.denylist-external-policy.id
  policy = jsonencode({
    "Id" : "BucketPolicy",
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "AllAccess",
        "Action" : "*",
        "Effect" : "Deny",
        "Resource" : [
          "arn:aws:s3:::denylist-external-policy"
        ],
        "Principal" : "*"
      }
    ]
  })
}
