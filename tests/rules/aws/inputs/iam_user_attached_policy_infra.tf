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
  region  = "us-west-2"
}

resource "aws_iam_user" "invalid_normal_policy_user" {
  name = "invalid_normal_policy_user"
}

resource "aws_iam_policy_attachment" "invalid_normal_policy_attachment" {
  name       = "invalid_normal_policy_attachment"
  users      = [aws_iam_user.invalid_normal_policy_user.name]
  policy_arn = aws_iam_policy.invalid_normal_policy.arn
}

resource "aws_iam_policy" "invalid_normal_policy" {
  name        = "invalid_normal_policy"
  description = "Invalid normal policy attached to user"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "*"
      ],
      "Effect": "Deny",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_user" "invalid_user_policy_user" {
  name = "invalid_user_policy_user"
}

resource "aws_iam_user_policy" "invalid_user_policy" {
  name = "invalid_user_policy"
  user = aws_iam_user.invalid_user_policy_user.name

  policy = <<EOF
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

resource "aws_iam_user" "invalid_user_policy_attachment_user" {
  name = "invalid_user_policy_attachment_user"
}

resource "aws_iam_user_policy_attachment" "invalid_user_policy_attachment" {
  user       = aws_iam_user.invalid_user_policy_attachment_user.name
  policy_arn = aws_iam_policy.invalid_user_policy_attachment_policy.arn
}

resource "aws_iam_policy" "invalid_user_policy_attachment_policy" {
  name        = "invalid_user_policy_attachment_policy"
  description = "Invalid user policy attachment policy"

  policy = <<EOF
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

resource "aws_iam_user" "valid_group_blank_user" {
  name = "valid_group_blank_user"
}

resource "aws_iam_group" "valid_group_blank_users" {
  name = "valid_group_blank_users"
}

resource "aws_iam_group_membership" "valid_group_blank_users_membership" {
  name = "valid_group_blank_users_membership"

  users = [
    aws_iam_user.valid_group_blank_user.name
  ]

  group = aws_iam_group.valid_group_blank_users.name
}

resource "aws_iam_policy_attachment" "valid_group_policy_attachment_blank_users" {
  name       = "valid_group_policy_attachment_blank_users"
  groups     = [aws_iam_group.valid_group_blank_users.name]
  users      = [""]
  policy_arn = aws_iam_policy.valid_group_blank_users_policy.arn
}

resource "aws_iam_policy" "valid_group_blank_users_policy" {
  name        = "valid_group_blank_users_policy"
  description = "Valid group blank users policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:Describe*"
      ],
      "Effect": "Deny",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_user" "valid_group_missing_user" {
  name = "valid_group_missing_user"
}

resource "aws_iam_group" "valid_group_missing_users" {
  name = "valid_group_missing_users"
}

resource "aws_iam_group_membership" "valid_group_missing_users_membership" {
  name = "valid_group_missing_users_membership"

  users = [
    aws_iam_user.valid_group_missing_user.name
  ]

  group = aws_iam_group.valid_group_missing_users.name
}

resource "aws_iam_policy_attachment" "valid_group_policy_attachment_missing_users" {
  name       = "valid_group_policy_attachment_missing_users"
  groups     = [aws_iam_group.valid_group_missing_users.name]
  policy_arn = aws_iam_policy.valid_group_missing_users_policy.arn
}

resource "aws_iam_policy" "valid_group_missing_users_policy" {
  name        = "valid_group_missing_users_policy"
  description = "Valid group missing users policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:Describe*"
      ],
      "Effect": "Deny",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_user" "valid_group_empty_list_user" {
  name = "valid_group_empty_list_user"
}

resource "aws_iam_group" "valid_group_empty_list_users" {
  name = "valid_group_empty_list_users"
}

resource "aws_iam_group_membership" "valid_group_empty_list_users_membership" {
  name = "valid_group_empty_list_users_membership"

  users = [
    aws_iam_user.valid_group_empty_list_user.name
  ]

  group = aws_iam_group.valid_group_empty_list_users.name
}

resource "aws_iam_policy_attachment" "valid_group_policy_attachment_empty_list_users" {
  name       = "valid_group_policy_attachment_empty_list_users"
  groups     = [aws_iam_group.valid_group_empty_list_users.name]
  users      = []
  policy_arn = aws_iam_policy.valid_group_empty_list_users_policy.arn
}

resource "aws_iam_policy" "valid_group_empty_list_users_policy" {
  name        = "valid_group_empty_list_users_policy"
  description = "Valid group empty list users policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:Describe*"
      ],
      "Effect": "Deny",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role" "valid_role" {
  name = "valid_role"

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

resource "aws_iam_policy_attachment" "valid_role_policy_attachment" {
  name       = "valid_role_policy_attachment"
  roles      = [aws_iam_role.valid_role.name]
  policy_arn = aws_iam_policy.valid_role_policy.arn
}

resource "aws_iam_policy" "valid_role_policy" {
  name        = "valid_role_policy"
  description = "Valid role policy"

  policy = <<EOF
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