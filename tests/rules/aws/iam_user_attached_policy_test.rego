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
package tests.rules.iam_user_attached_policy

import data.fugue.regula

test_user_attached_policy {
  report := regula.report with input as mock_input
  resources := report.rules.iam_user_attached_policy.resources

  resources["aws_iam_policy_attachment.invalid_normal_policy_attachment"].valid == false
  resources["aws_iam_user_policy.invalid_user_policy"].valid == false
  resources["aws_iam_user_policy_attachment.invalid_user_policy_attachment"].valid == false
  resources["aws_iam_policy_attachment.valid_group_policy_attachment_blank_users"].valid == true
  resources["aws_iam_policy_attachment.valid_group_policy_attachment_missing_users"].valid == true
  resources["aws_iam_policy_attachment.valid_group_policy_attachment_empty_list_users"].valid == true
  resources["aws_iam_policy_attachment.valid_role_policy_attachment"].valid == true  
}
