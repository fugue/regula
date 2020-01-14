package tests.rules.security_group_ingress_anywhere

import data.fugue.regula

test_no_ingress_except_80_443 {
  report := regula.report with input as mock_input
  resources := report.rules.security_group_ingress_anywhere.resources

  resources["aws_security_group.invalid_allow_all"].valid == false
  resources["aws_security_group.invalid_include_443"].valid == false
  resources["aws_security_group.invalid_include_80"].valid == false
  resources["aws_security_group.valid_exact_443"].valid == true
  resources["aws_security_group.valid_exact_80"].valid == true
}
