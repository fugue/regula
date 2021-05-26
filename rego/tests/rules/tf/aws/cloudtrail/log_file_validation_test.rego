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
package rules.tf_aws_cloudtrail_log_file_validation

import data.tests.rules.tf.aws.cloudtrail.inputs.log_file_validation_infra_json

test_cloudtrail_log_file_validation {
  resources = log_file_validation_infra_json.mock_resources
  not allow with input as resources["aws_cloudtrail.invalid_trail"]
  allow with input as resources["aws_cloudtrail.valid_trail"]
}
