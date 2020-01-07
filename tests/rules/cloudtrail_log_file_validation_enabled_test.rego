package tests.rules.cloudtrail_log_file_validation_enabled

import data.fugue.regula

test_cloudtrail_log_file_validation {
  report := regula.report with input as mock_input
  resources := report.rules.cloudtrail_log_file_validation_enabled.resources

  resources["aws_cloudtrail.invalid_trail"].valid == false
  resources["aws_cloudtrail.valid_trail"].valid == true
}
