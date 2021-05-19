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
package rules.tf_aws_iam_admin_policy

import data.tests.rules.tf.aws.iam.inputs.admin_policy_infra_json

test_admin_policy {
  pol = policy with input as admin_policy_infra_json.mock_input
  by_resource_id = {p.id: p.valid | pol[p]}
  by_resource_id["aws_iam_group_policy.invalid_group_policy"] == false
  by_resource_id["aws_iam_group_policy.valid_group_policy"] == true
  by_resource_id["aws_iam_policy.invalid_policy"] == false
  by_resource_id["aws_iam_policy.valid_deny_policy"] == true
  by_resource_id["aws_iam_role_policy.invalid_role_policy"] == false
  by_resource_id["aws_iam_role_policy.valid_role_policy"] == true
  by_resource_id["aws_iam_user_policy.invalid_user_policy"] == false
  by_resource_id["aws_iam_user_policy.valid_user_policy"] == true
}
