provider "aws" {
  region = "us-east-2"
}

resource "aws_iam_account_password_policy" "valid" {
  minimum_password_length = 8
}

resource "aws_iam_account_password_policy" "invalid_1" {
  minimum_password_length = 4
}

resource "aws_iam_account_password_policy" "invalid_2" {
}
