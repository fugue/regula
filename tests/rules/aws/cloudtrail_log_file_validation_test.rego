# Copyright 2020 Fugue, Inc.
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
package tests.rules.cloudtrail_log_file_validation

import data.fugue.regula
import data.tests.rules.aws.inputs.cloudtrail_log_file_validation_infra.mock_plan_input

test_cloudtrail_log_file_validation {
  report := regula.report with input as mock_plan_input
  resources := report.rules.cloudtrail_log_file_validation.resources

  resources["aws_cloudtrail.invalid_trail"].valid == false
  resources["aws_cloudtrail.valid_trail"].valid == true
}
