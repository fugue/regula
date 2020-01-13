package tests.rules.iam_user_attached_policy

import data.fugue.regula

test_user_attached_policy {
  report := regula.report with input as mock_input
  resources := report.rules.iam_user_attached_policy.resources

  resources["aws_iam_policy_attachment.invalid_normal_policy_attachment"].valid == false
  resources["aws_iam_user_policy.invalid_user_policy"].valid == false
  resources["aws_iam_user_policy_attachment.invalid_user_policy_attachment"].valid == false
  resources["aws_iam_policy_attachment.valid_group_policy_attachment_blank_users"].valid == true
  resources["aws_iam_policy_attachment.valid_group_policy_attachment_missing_users"].valid == true
  resources["aws_iam_policy_attachment.valid_group_policy_attachment_empty_list_users"].valid == true
  resources["aws_iam_policy_attachment.valid_role_policy_attachment"].valid == true  
}
