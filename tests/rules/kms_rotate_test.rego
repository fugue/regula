package tests.rules.kms_rotate_infra

import data.fugue.regula

test_kms_rotate {
  report := regula.report with input as mock_input
  resources := report.rules.kms_rotate.resources

  resources["aws_kms_key.valid"].valid == true
  resources["aws_kms_key.invalid"].valid == false
}