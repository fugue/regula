package tests.rules.tag_all_resources

import data.fugue.regula

test_tag_all_resources {
  report := regula.report with input as mock_input
  resources := report.rules.tag_all_resources.resources
  resources["aws_vpc.invalid"].valid == false
  resources["aws_s3_bucket.invalid"].valid == false
  resources["aws_vpc.valid"].valid == true
}
