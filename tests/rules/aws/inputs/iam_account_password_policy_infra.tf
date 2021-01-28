provider "aws" {
  region = "us-east-1"
}
resource "aws_iam_account_password_policy" "bad" {
  require_uppercase_characters   = false
  minimum_password_length        = 4
  require_lowercase_characters   = false
  require_numbers                = false
  require_symbols                = false
  allow_users_to_change_password = false
  password_reuse_prevention      = 10
  max_password_age               = 300
}
resource "aws_iam_account_password_policy" "good" {
  require_uppercase_characters   = true
  minimum_password_length        = 14
  require_lowercase_characters   = true
  require_numbers                = true
  require_symbols                = true
  allow_users_to_change_password = true
  password_reuse_prevention      = 24
  max_password_age               = 90
}
