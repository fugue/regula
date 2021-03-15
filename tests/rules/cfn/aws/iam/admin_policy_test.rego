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
package rules.cfn_aws_iam_admin_policy

import data.tests.rules.cfn.aws.iam.inputs.admin_policy_infra

test_admin_policy {
  pol = policy with input as admin_policy_infra.mock_input
  by_resource_id = {p.id: p.valid | pol[p]}
  by_resource_id["InvalidGroup01"] == false
  by_resource_id["InvalidPolicy01"] == false
  by_resource_id["InvalidPolicy02"] == false
  by_resource_id["InvalidPolicy03"] == false
  by_resource_id["InvalidRole01"] == false
  by_resource_id["InvalidUser01"] == false
  by_resource_id["ValidPolicy01"] == true
  by_resource_id["ValidPolicy02"] == true
  by_resource_id["ValidPolicy03"] == true
  by_resource_id["ValidRole01"] == true
}
