package tests.rules.iam_password_length

import data.fugue.regula

test_iam_password_length {
  report := regula.report with input as mock_input
  resources := report.rules.iam_password_length.resources
  resources["aws_iam_account_password_policy.valid"].valid == true
  resources["aws_iam_account_password_policy.invalid_1"].valid == false
  resources["aws_iam_account_password_policy.invalid_2"].valid == false

  empty_report := regula.report with input as {}
  empty_report.rules.iam_password_length.valid == false
}
