# Copyright 2020-2021 Fugue, Inc.
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
  region = "us-west-2"
}

resource "aws_s3_bucket" "example" {
  bucket_prefix = "example"
}

data "aws_iam_policy_document" "example" {
  statement {
    effect = "Allow"
    actions = ["s3:*"]

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    resources = [
      "arn:aws:s3:::some-example-bucket/*",
      "arn:aws:s3:::${aws_s3_bucket.example.id}/*",
    ]
  }
}

resource "aws_iam_policy" "example" {
  policy = "${data.aws_iam_policy_document.example.json}"
}
