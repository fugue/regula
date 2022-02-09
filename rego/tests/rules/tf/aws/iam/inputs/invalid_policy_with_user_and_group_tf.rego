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
package tests.rules.tf.aws.iam.inputs.invalid_policy_with_user_and_group_tf

import data.fugue.resource_view.resource_view_input

mock_input := ret {
  ret = resource_view_input with input as mock_config
}
mock_resources := mock_input.resources
mock_config := {
  "hcl_resource_view_version": "0.0.1",
  "resources": {
    "aws_iam_group.group": {
      "_filepath": "tests/rules/tf/aws/iam/inputs/invalid_policy_with_user_and_group.tf",
      "_provider": "aws",
      "_type": "aws_iam_group",
      "id": "aws_iam_group.group",
      "name": "test-group"
    },
    "aws_iam_group_policy_attachment.test-attach-b": {
      "_filepath": "tests/rules/tf/aws/iam/inputs/invalid_policy_with_user_and_group.tf",
      "_provider": "aws",
      "_type": "aws_iam_group_policy_attachment",
      "group": "test-group",
      "id": "aws_iam_group_policy_attachment.test-attach-b",
      "policy_arn": "aws_iam_policy.policy"
    },
    "aws_iam_policy.policy": {
      "_filepath": "tests/rules/tf/aws/iam/inputs/invalid_policy_with_user_and_group.tf",
      "_provider": "aws",
      "_type": "aws_iam_policy",
      "description": "A test policy",
      "id": "aws_iam_policy.policy",
      "name": "test-policy",
      "policy": "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Action\": [\n        \"ec2:Describe*\"\n      ],\n      \"Effect\": \"Allow\",\n      \"Resource\": \"*\"\n    }\n  ]\n}\n"
    },
    "aws_iam_user.user": {
      "_filepath": "tests/rules/tf/aws/iam/inputs/invalid_policy_with_user_and_group.tf",
      "_provider": "aws",
      "_type": "aws_iam_user",
      "id": "aws_iam_user.user",
      "name": "test-user"
    },
    "aws_iam_user_policy_attachment.test-attach": {
      "_filepath": "tests/rules/tf/aws/iam/inputs/invalid_policy_with_user_and_group.tf",
      "_provider": "aws",
      "_type": "aws_iam_user_policy_attachment",
      "id": "aws_iam_user_policy_attachment.test-attach",
      "policy_arn": "aws_iam_policy.policy",
      "user": "test-user"
    }
  }
}

