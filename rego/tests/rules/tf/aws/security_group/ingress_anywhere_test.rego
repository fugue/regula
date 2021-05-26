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
package rules.tf_aws_security_group_ingress_anywhere

import data.tests.rules.tf.aws.security_group.inputs.ingress_anywhere_infra_json

test_no_ingress_except_80_443 {
  resources = ingress_anywhere_infra_json.mock_resources
  deny with input as resources["aws_security_group.invalid_allow_all"]
  deny with input as resources["aws_security_group.invalid_include_443"]
  deny with input as resources["aws_security_group.invalid_include_80"]
  not deny with input as resources["aws_security_group.valid_exact_443"]
  not deny with input as resources["aws_security_group.valid_exact_80"]
}
