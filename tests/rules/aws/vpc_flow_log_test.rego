package tests.rules.vpc_flow_log

import data.fugue.regula

test_vpc_flow_log {
  report := regula.report with input as mock_input
  resources := report.rules.vpc_flow_log.resources

  resources["aws_vpc.valid_vpc"].valid == true
  resources["aws_vpc.invalid_vpc"].valid == false
}
