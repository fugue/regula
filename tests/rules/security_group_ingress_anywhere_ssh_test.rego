package tests.rules.security_group_ingress_anywhere_ssh

import data.fugue.regula

test_security_group_ingress_anywhere_ssh {
  report := regula.report with input as mock_input
  resources := report.rules.security_group_ingress_anywhere_ssh.resources

  resources["aws_security_group.valid_sg_1"].valid == true
  resources["aws_security_group.valid_sg_2"].valid == true
  resources["aws_security_group.invalid_sg_1"].valid == false
  resources["aws_security_group.invalid_sg_2"].valid == false
}
