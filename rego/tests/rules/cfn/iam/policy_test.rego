# Copyright 2020-2022 Fugue, Inc.
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
package rules.cfn_iam_policy

import data.tests.rules.cfn.iam.inputs.policy_infra_yaml

test_policy {
  pol = policy with input as policy_infra_yaml.mock_input
  by_resource_id = {p.id: p.valid | pol[p]}
  by_resource_id["User01"] == true
  by_resource_id["ValidPolicy01"] == true
  by_resource_id["InvalidPolicy01"] == false
  by_resource_id["InvalidUser01"] == false
}
