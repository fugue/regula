provider "aws" {
  version = "~> 2.41"
  region  = "us-west-2"
}

resource "aws_iam_policy" "invalid_policy" {
  name        = "test_invalid_policy"
  path        = "/"
  description = "Invalid policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "valid_deny_policy" {
  name        = "test_valid_deny_policy"
  path        = "/"
  description = "Valid deny policy"

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

resource "aws_iam_group_policy" "valid_group_policy" {
  name  = "valid_group_policy"
  group = aws_iam_group.my_group.id

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

resource "aws_iam_group" "my_group" {
  name = "my_group"
  path = "/users/"
}

resource "aws_iam_group_policy" "invalid_group_policy" {
  name  = "invalid_group_policy"
  group = aws_iam_group.my_group.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "valid_role_policy" {
  name = "valid_role_policy"
  role = aws_iam_role.my_test_role.id

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

resource "aws_iam_role" "my_test_role" {
  name = "my_test_role"

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

resource "aws_iam_role_policy" "invalid_role_policy" {
  name = "invalid_role_policy"
  role = aws_iam_role.my_test_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_user_policy" "valid_user_policy" {
  name = "valid_user_policy"
  user = aws_iam_user.my_test_user.name

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

resource "aws_iam_user" "my_test_user" {
  name = "my_test_user"
  path = "/system/"
}

resource "aws_iam_user_policy" "invalid_user_policy" {
  name = "invalid_user_policy"
  user = aws_iam_user.my_test_user.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}