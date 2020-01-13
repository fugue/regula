package tests.rules.ec2_t2_only

import data.fugue.regula

test_t2_only {
  report := regula.report with input as mock_input
  resources := report.rules.ec2_t2_only.resources
  resources["aws_instance.invalid"].valid == false
  resources["aws_instance.valid_micro"].valid == true
  resources["aws_instance.valid_small"].valid == true
  resources["aws_instance.valid_medium"].valid == true
  resources["aws_instance.valid_large"].valid == true
  resources["aws_instance.valid_xlarge"].valid == true
  resources["aws_instance.valid_2xlarge"].valid == true
}
