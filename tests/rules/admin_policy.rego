package tests.rules.admin_policy

import data.fugue.regula

test_admin_policy {
  report := regula.report with input as mock_input
  resources := report.rules.admin_policy.resources
  resources["aws_iam_group_policy.invalid_group_policy"].valid == false
  resources["aws_iam_group_policy.valid_group_policy"].valid == true
  resources["aws_iam_policy.invalid_policy"].valid == false
  resources["aws_iam_policy.valid_deny_policy"].valid == true
  resources["aws_iam_role_policy.invalid_role_policy"].valid == false
  resources["aws_iam_role_policy.valid_role_policy"].valid == true
  resources["aws_iam_user_policy.invalid_user_policy"].valid == false
  resources["aws_iam_user_policy.valid_user_policy"].valid == true
}
