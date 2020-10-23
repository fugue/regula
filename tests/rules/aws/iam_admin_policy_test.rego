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
package tests.rules.iam_admin_policy

import data.fugue.regula
import data.tests.rules.aws.inputs.iam_admin_policy_infra.mock_plan_input

test_admin_policy {
  report := regula.report with input as mock_plan_input
  resources := report.rules.iam_admin_policy.resources
  resources["aws_iam_group_policy.invalid_group_policy"].valid == false
  resources["aws_iam_group_policy.valid_group_policy"].valid == true
  resources["aws_iam_policy.invalid_policy"].valid == false
  resources["aws_iam_policy.valid_deny_policy"].valid == true
  resources["aws_iam_role_policy.invalid_role_policy"].valid == false
  resources["aws_iam_role_policy.valid_role_policy"].valid == true
  resources["aws_iam_user_policy.invalid_user_policy"].valid == false
  resources["aws_iam_user_policy.valid_user_policy"].valid == true
}
