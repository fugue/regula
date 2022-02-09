# Copyright 2020-2022 Fugue, Inc.
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
  region = "us-east-1"
}

resource "aws_iam_user" "user" {
  name = "test-user"
}

resource "aws_iam_group" "group" {
  name = "test-group"
}

# Policy A
resource "aws_iam_policy" "policy_a" {
  name        = "test-policy-opa-a"
  description = "A test policy"
  policy      =  <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:Describe*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

# Policy B
resource "aws_iam_policy" "policy_b" {
  name        = "test-policy-opa-b"
  description = "A test policy"
  policy      =  <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "dynamodb:Describe*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role" "role" {
  name = "test-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# Attachment Valid
resource "aws_iam_role_policy_attachment" "test-attach-b" {
  role       = "${aws_iam_role.role.name}"
  policy_arn = "${aws_iam_policy.policy_a.arn}"
}

resource "aws_iam_group_policy_attachment" "test-attach-c" {
  group      = "${aws_iam_group.group.name}"
  policy_arn = "${aws_iam_policy.policy_a.arn}"
}

# Attachment Invalid
resource "aws_iam_user_policy_attachment" "test-attach-invalid-user" {
    user       = "${aws_iam_user.user.name}"
    policy_arn = "${aws_iam_policy.policy_b.arn}"
}
