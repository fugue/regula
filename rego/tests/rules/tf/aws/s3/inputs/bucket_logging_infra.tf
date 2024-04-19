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

resource "aws_s3_bucket" "deny_no_logging" {
  bucket = "allow-directly-attached-logging"
}

resource "aws_s3_bucket" "allow_inline_logging" {
  bucket = "allow-directly-attached-logging"
  logging {
    target_bucket = aws_s3_bucket.deny_no_logging.id
    target_prefix = "/allow_inline_logging/"
  }
}

resource "aws_s3_bucket" "allow_attached_resource_logging" {
  bucket = "allow-attached-resource-logging"
}

resource "aws_s3_bucket_logging" "allow_attached_resource_logging_name_does_not_match" {
  bucket = aws_s3_bucket.allow_attached_resource_logging.id

  target_bucket = aws_s3_bucket.deny_no_logging.id
  target_prefix = "/allow_attached_resource_logging/"
}

resource "aws_s3_bucket_logging" "not_attached_to_anything" {
  bucket = aws_s3_bucket.allow_attached_resource_logging.id

  target_bucket = aws_s3_bucket.deny_no_logging.id
  target_prefix = "/allow_attached_resource_logging/"
}
