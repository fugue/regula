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
package rules.iam_password_length

import data.fugue.resource_view.resource_view_input
import data.tests.examples.aws.inputs.iam_password_length_infra_json.mock_input

test_iam_password_length {
  pol = policy with input as mock_input
  by_resource_id = {p.id: p.valid | pol[p]}
  by_resource_id["aws_iam_account_password_policy.valid"] == true
  by_resource_id["aws_iam_account_password_policy.invalid_1"] == false
  by_resource_id["aws_iam_account_password_policy.invalid_2"] == false

  empty_policy = policy with input as empty_input
  empty_policy[_].valid == false
}

empty_input = ret {
  ret = resource_view_input with input as {"terraform_version": "0.12.18"}
}
