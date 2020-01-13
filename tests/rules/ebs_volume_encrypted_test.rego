package tests.rules.ebs_volume_encrypted

import data.fugue.regula

test_ebs_volume_encrypted {
  report := regula.report with input as mock_input
  resources := report.rules.ebs_volume_encrypted.resources

  resources["aws_ebs_volume.good"].valid == true
  resources["aws_ebs_volume.missing"].valid == false
  resources["aws_ebs_volume.bad"].valid == false
}
