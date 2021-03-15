# Copyright 2020-2021 Fugue, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
package tests.rules.cfn_aws_s3_cloudtrail_s3_data_logging_write

import data.fugue.regula
import data.tests.rules.cfn.aws.s3.inputs

test_valid_empty_document {
  report := regula.report with input as inputs.empty_template_infra.mock_plan_input
  resources := report.rules.cfn_aws_s3_cloudtrail_s3_data_logging_write.resources

  count(resources) == 0
}

test_valid_cloudtrail_s3_data_logging_write_all_buckets {
  report := regula.report with input as inputs.valid_cloudtrail_s3_data_logging_write_all_buckets_infra.mock_plan_input
  resources := report.rules.cfn_aws_s3_cloudtrail_s3_data_logging_write.resources

  count(resources) == 4
  resources["LoggingBucket"].valid == true
  resources["Bucket1"].valid == true
  resources["Bucket2"].valid == true
  resources["Bucket3"].valid == true
}

test_valid_cloudtrail_s3_data_logging_all_all_buckets {
  report := regula.report with input as inputs.valid_cloudtrail_s3_data_logging_all_all_buckets_infra.mock_plan_input
  resources := report.rules.cfn_aws_s3_cloudtrail_s3_data_logging_write.resources

  count(resources) == 4
  resources["LoggingBucket"].valid == true
  resources["Bucket1"].valid == true
  resources["Bucket2"].valid == true
  resources["Bucket3"].valid == true
}

test_valid_cloudtrail_s3_data_logging_all_two_buckets {
  report := regula.report with input as inputs.valid_cloudtrail_s3_data_logging_all_two_buckets_infra.mock_plan_input
  resources := report.rules.cfn_aws_s3_cloudtrail_s3_data_logging_write.resources

  count(resources) == 2
  resources["LoggingBucket"].valid == true
  resources["Bucket1"].valid == true
}

test_invalid_cloudtrail_s3_data_logging_all_one_bucket {
  report := regula.report with input as inputs.invalid_cloudtrail_s3_data_logging_all_one_bucket_infra.mock_plan_input
  resources := report.rules.cfn_aws_s3_cloudtrail_s3_data_logging_write.resources

  count(resources) == 2
  resources["LoggingBucket"].valid == true
  resources["Bucket1"].valid == false
}

test_invalid_cloudtrail_s3_data_logging_write_one_bucket {
  report := regula.report with input as inputs.invalid_cloudtrail_s3_data_logging_write_one_bucket_infra.mock_plan_input
  resources := report.rules.cfn_aws_s3_cloudtrail_s3_data_logging_write.resources

  count(resources) == 2
  resources["LoggingBucket"].valid == true
  resources["Bucket1"].valid == false
}

test_invalid_cloudtrail_s3_data_logging_no_trails {
  report := regula.report with input as inputs.invalid_cloudtrail_s3_data_logging_no_trails_infra.mock_plan_input
  resources := report.rules.cfn_aws_s3_cloudtrail_s3_data_logging_write.resources

  # The rule shouldn't evaluate any of the buckets when there are no trails.
  count(resources) == 0
}

test_invalid_cloudtrail_s3_data_logging_trail_no_data_events {
  report := regula.report with input as inputs.invalid_cloudtrail_s3_data_logging_trail_no_data_events_infra.mock_plan_input
  resources := report.rules.cfn_aws_s3_cloudtrail_s3_data_logging_write.resources

  count(resources) == 4
  resources["LoggingBucket"].valid == false
  resources["Bucket1"].valid == false
  resources["Bucket2"].valid == false
  resources["Bucket3"].valid == false
}

test_invalid_cloudtrail_s3_data_logging_trail_no_selector {
  report := regula.report with input as inputs.invalid_cloudtrail_s3_data_logging_trail_no_selector_infra.mock_plan_input
  resources := report.rules.cfn_aws_s3_cloudtrail_s3_data_logging_write.resources

  count(resources) == 4
  resources["LoggingBucket"].valid == false
  resources["Bucket1"].valid == false
  resources["Bucket2"].valid == false
  resources["Bucket3"].valid == false
}

test_invalid_cloudtrail_s3_data_logging_write_one_bucket_read_all {
  report := regula.report with input as inputs.invalid_cloudtrail_s3_data_logging_write_one_bucket_read_all_infra.mock_plan_input
  resources := report.rules.cfn_aws_s3_cloudtrail_s3_data_logging_write.resources

  count(resources) == 4
  resources["LoggingBucket"].valid == true
  resources["Bucket1"].valid == false
  resources["Bucket2"].valid == false
  resources["Bucket3"].valid == false
}
