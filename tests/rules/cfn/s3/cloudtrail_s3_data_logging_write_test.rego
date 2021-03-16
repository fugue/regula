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
package rules.cfn_s3_cloudtrail_s3_data_logging_write

import data.tests.rules.cfn.s3.inputs

test_valid_empty_document {
  pol = policy with input as inputs.empty_template_infra.mock_input
  by_resource_id = {p.id: p.valid | pol[p]}
  count(by_resource_id) == 0
}

test_valid_cloudtrail_s3_data_logging_write_all_buckets {
  pol = policy with input as inputs.valid_cloudtrail_s3_data_logging_write_all_buckets_infra.mock_input
  by_resource_id = {p.id: p.valid | pol[p]}
  count(by_resource_id) == 4
  by_resource_id["LoggingBucket"] == true
  by_resource_id["Bucket1"] == true
  by_resource_id["Bucket2"] == true
  by_resource_id["Bucket3"] == true
}

test_valid_cloudtrail_s3_data_logging_all_all_buckets {
  pol = policy with input as inputs.valid_cloudtrail_s3_data_logging_all_all_buckets_infra.mock_input
  by_resource_id = {p.id: p.valid | pol[p]}
  count(by_resource_id) == 4
  by_resource_id["LoggingBucket"] == true
  by_resource_id["Bucket1"] == true
  by_resource_id["Bucket2"] == true
  by_resource_id["Bucket3"] == true
}

test_valid_cloudtrail_s3_data_logging_all_two_buckets {
  pol = policy with input as inputs.valid_cloudtrail_s3_data_logging_all_two_buckets_infra.mock_input
  by_resource_id = {p.id: p.valid | pol[p]}
  count(by_resource_id) == 2
  by_resource_id["LoggingBucket"] == true
  by_resource_id["Bucket1"] == true
}

test_invalid_cloudtrail_s3_data_logging_all_one_bucket {
  pol = policy with input as inputs.invalid_cloudtrail_s3_data_logging_all_one_bucket_infra.mock_input
  by_resource_id = {p.id: p.valid | pol[p]}
  count(by_resource_id) == 2
  by_resource_id["LoggingBucket"] == true
  by_resource_id["Bucket1"] == false
}

test_invalid_cloudtrail_s3_data_logging_write_one_bucket {
  pol = policy with input as inputs.invalid_cloudtrail_s3_data_logging_write_one_bucket_infra.mock_input
  by_resource_id = {p.id: p.valid | pol[p]}
  count(by_resource_id) == 2
  by_resource_id["LoggingBucket"] == true
  by_resource_id["Bucket1"] == false
}

test_invalid_cloudtrail_s3_data_logging_no_trails {
  pol = policy with input as inputs.invalid_cloudtrail_s3_data_logging_no_trails_infra.mock_input
  by_resource_id = {p.id: p.valid | pol[p]}
  # The rule shouldn't evaluate any of the buckets when there are no trails.
  count(by_resource_id) == 0
}

test_invalid_cloudtrail_s3_data_logging_trail_no_data_events {
  pol = policy with input as inputs.invalid_cloudtrail_s3_data_logging_trail_no_data_events_infra.mock_input
  by_resource_id = {p.id: p.valid | pol[p]}
  count(by_resource_id) == 4
  by_resource_id["LoggingBucket"] == false
  by_resource_id["Bucket1"] == false
  by_resource_id["Bucket2"] == false
  by_resource_id["Bucket3"] == false
}

test_invalid_cloudtrail_s3_data_logging_trail_no_selector {
  pol = policy with input as inputs.invalid_cloudtrail_s3_data_logging_trail_no_selector_infra.mock_input
  by_resource_id = {p.id: p.valid | pol[p]}
  count(by_resource_id) == 4
  by_resource_id["LoggingBucket"] == false
  by_resource_id["Bucket1"] == false
  by_resource_id["Bucket2"] == false
  by_resource_id["Bucket3"] == false
}

test_invalid_cloudtrail_s3_data_logging_write_one_bucket_read_all {
  pol = policy with input as inputs.invalid_cloudtrail_s3_data_logging_write_one_bucket_read_all_infra.mock_input
  by_resource_id = {p.id: p.valid | pol[p]}
  count(by_resource_id) == 4
  by_resource_id["LoggingBucket"] == true
  by_resource_id["Bucket1"] == false
  by_resource_id["Bucket2"] == false
  by_resource_id["Bucket3"] == false
}
