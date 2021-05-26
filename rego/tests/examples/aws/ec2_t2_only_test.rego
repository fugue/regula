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
package rules.ec2_t2_only

import data.tests.examples.aws.inputs.ec2_t2_only_infra_json

test_t2_only {
  resources = ec2_t2_only_infra_json.mock_resources
  not allow with input as resources["aws_instance.invalid"]
  allow with input as resources["aws_instance.valid_micro"]
  allow with input as resources["aws_instance.valid_small"]
  allow with input as resources["aws_instance.valid_medium"]
  allow with input as resources["aws_instance.valid_large"]
  allow with input as resources["aws_instance.valid_xlarge"]
  allow with input as resources["aws_instance.valid_2xlarge"]
}
