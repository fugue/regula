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
package rules.tf_aws_iam_policy

import data.tests.rules.tf.aws.iam.inputs

import data.fugue

report = fugue.report_v0("", policy)

test_valid_document_with_no_policies {
    report.valid with input as {"modules": [{"resources": {}}]}
}

test_valid_policy_with_role {
    report.valid with input as inputs.valid_policy_with_role_tf.mock_input
}

test_valid_policy_with_group {
    report.valid with input as inputs.valid_policy_with_group_tf.mock_input
}

test_valid_policy_with_group_and_role {
    report.valid with input as inputs.valid_policy_with_group_and_role_tf.mock_input
}

test_valid_policies_with_group_and_role {
    report.valid with input as inputs.valid_policies_with_group_and_role_tf.mock_input
}

test_invalid_policy_with_user {
    not report.valid with input as inputs.invalid_policy_with_user_tf.mock_input
}

test_invalid_policy_with_user_and_group {
    not report.valid with input as inputs.invalid_policy_with_user_and_group_tf.mock_input
}

test_invalid_policy_with_user_and_role {
    not report.valid with input as inputs.invalid_policy_with_user_and_role_tf.mock_input
}

test_invalid_policy_with_user_and_group_and_role {
    not report.valid with input as inputs.invalid_policy_with_user_and_group_and_role_tf.mock_input
}

test_invalid_policy_with_user_and_valid_policy {
    not report.valid with input as inputs.invalid_policy_with_user_and_valid_policy_tf.mock_input
}

test_invalid_policy_multiple_user {
    not report.valid with input as inputs.invalid_policy_multiple_user_tf.mock_input
}

test_valid_policy_multiple_groups {
    report.valid with input as inputs.valid_policy_multiple_groups_tf.mock_input
}

test_invalid_user_policies {
  # More thorough check that all resources involved are marked as invalid.  See
  # also <https://luminal.atlassian.net/browse/RM-3041>.
  fugue.input_type == "tf_runtime"
  r := report with input as inputs.invalid_user_policies_tf.mock_input
  not r.valid
  not any([resource.valid | resource = r.resources[_]])
  count(r.resources) ==  count([res |
    res = inputs.invalid_user_policies_tf.mock_input.resources[_]
    res._type != "aws_iam_user_policy_attachment"
  ])
} else {
  fugue.input_type != "tf_runtime"
}
