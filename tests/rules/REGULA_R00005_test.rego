package tests.rules.REGULA_R00005_infra

import data.fugue.regula

test_REGULA_R00005 {
  report := regula.report with input as mock_input
  resources := report.rules.REGULA_R00005.resources

  resources["aws_security_group.valid_sg_1"].valid == true
  resources["aws_security_group.valid_sg_2"].valid == true
  resources["aws_security_group.invalid_sg_1"].valid == false
  resources["aws_security_group.invalid_sg_2"].valid == false
}