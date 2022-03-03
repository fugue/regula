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
package tests.rules.tf.aws.iam.inputs.admin_policy_infra_tf

import data.fugue.resource_view.resource_view_input

mock_input := ret {
  ret = resource_view_input with input as mock_config
}
mock_resources := mock_input.resources
mock_config := {
  "hcl_resource_view_version": "0.0.1",
  "resources": {
    "aws_iam_group.my_group": {
      "_filepath": "tests/rules/tf/aws/iam/inputs/admin_policy_infra.tf",
      "_provider": "aws",
      "_type": "aws_iam_group",
      "id": "aws_iam_group.my_group",
      "name": "my_group",
      "path": "/users/"
    },
    "aws_iam_group_policy.invalid_group_policy": {
      "_filepath": "tests/rules/tf/aws/iam/inputs/admin_policy_infra.tf",
      "_provider": "aws",
      "_type": "aws_iam_group_policy",
      "group": "aws_iam_group.my_group",
      "id": "aws_iam_group_policy.invalid_group_policy",
      "name": "invalid_group_policy",
      "policy": "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Action\": [\n        \"*\"\n      ],\n      \"Effect\": \"Allow\",\n      \"Resource\": \"*\"\n    }\n  ]\n}\n"
    },
    "aws_iam_group_policy.valid_group_policy": {
      "_filepath": "tests/rules/tf/aws/iam/inputs/admin_policy_infra.tf",
      "_provider": "aws",
      "_type": "aws_iam_group_policy",
      "group": "aws_iam_group.my_group",
      "id": "aws_iam_group_policy.valid_group_policy",
      "name": "valid_group_policy",
      "policy": "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Action\": [\n        \"ec2:Describe*\"\n      ],\n      \"Effect\": \"Allow\",\n      \"Resource\": \"*\"\n    }\n  ]\n}\n"
    },
    "aws_iam_policy.invalid_policy": {
      "_filepath": "tests/rules/tf/aws/iam/inputs/admin_policy_infra.tf",
      "_provider": "aws",
      "_type": "aws_iam_policy",
      "description": "Invalid policy",
      "id": "aws_iam_policy.invalid_policy",
      "name": "test_invalid_policy",
      "path": "/",
      "policy": "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Action\": [\n        \"*\"\n      ],\n      \"Effect\": \"Allow\",\n      \"Resource\": \"*\"\n    }\n  ]\n}\n"
    },
    "aws_iam_policy.valid_deny_policy": {
      "_filepath": "tests/rules/tf/aws/iam/inputs/admin_policy_infra.tf",
      "_provider": "aws",
      "_type": "aws_iam_policy",
      "description": "Valid deny policy",
      "id": "aws_iam_policy.valid_deny_policy",
      "name": "test_valid_deny_policy",
      "path": "/",
      "policy": "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Action\": [\n        \"*\"\n      ],\n      \"Effect\": \"Deny\",\n      \"Resource\": \"*\"\n    }\n  ]\n}\n"
    },
    "aws_iam_role.my_test_role": {
      "_filepath": "tests/rules/tf/aws/iam/inputs/admin_policy_infra.tf",
      "_provider": "aws",
      "_type": "aws_iam_role",
      "assume_role_policy": "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Action\": \"sts:AssumeRole\",\n      \"Principal\": {\n        \"Service\": \"ec2.amazonaws.com\"\n      },\n      \"Effect\": \"Allow\",\n      \"Sid\": \"\"\n    }\n  ]\n}\n",
      "id": "aws_iam_role.my_test_role",
      "name": "my_test_role"
    },
    "aws_iam_role_policy.invalid_role_policy": {
      "_filepath": "tests/rules/tf/aws/iam/inputs/admin_policy_infra.tf",
      "_provider": "aws",
      "_type": "aws_iam_role_policy",
      "id": "aws_iam_role_policy.invalid_role_policy",
      "name": "invalid_role_policy",
      "policy": "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Action\": [\n        \"*\"\n      ],\n      \"Effect\": \"Allow\",\n      \"Resource\": \"*\"\n    }\n  ]\n}\n",
      "role": "aws_iam_role.my_test_role"
    },
    "aws_iam_role_policy.valid_role_policy": {
      "_filepath": "tests/rules/tf/aws/iam/inputs/admin_policy_infra.tf",
      "_provider": "aws",
      "_type": "aws_iam_role_policy",
      "id": "aws_iam_role_policy.valid_role_policy",
      "name": "valid_role_policy",
      "policy": "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Action\": [\n        \"ec2:Describe*\"\n      ],\n      \"Effect\": \"Allow\",\n      \"Resource\": \"*\"\n    }\n  ]\n}\n",
      "role": "aws_iam_role.my_test_role"
    },
    "aws_iam_user.my_test_user": {
      "_filepath": "tests/rules/tf/aws/iam/inputs/admin_policy_infra.tf",
      "_provider": "aws",
      "_type": "aws_iam_user",
      "id": "aws_iam_user.my_test_user",
      "name": "my_test_user",
      "path": "/system/"
    },
    "aws_iam_user_policy.invalid_user_policy": {
      "_filepath": "tests/rules/tf/aws/iam/inputs/admin_policy_infra.tf",
      "_provider": "aws",
      "_type": "aws_iam_user_policy",
      "id": "aws_iam_user_policy.invalid_user_policy",
      "name": "invalid_user_policy",
      "policy": "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Action\": [\n        \"*\"\n      ],\n      \"Effect\": \"Allow\",\n      \"Resource\": \"*\"\n    }\n  ]\n}\n",
      "user": "my_test_user"
    },
    "aws_iam_user_policy.valid_user_policy": {
      "_filepath": "tests/rules/tf/aws/iam/inputs/admin_policy_infra.tf",
      "_provider": "aws",
      "_type": "aws_iam_user_policy",
      "id": "aws_iam_user_policy.valid_user_policy",
      "name": "valid_user_policy",
      "policy": "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Action\": [\n        \"ec2:Describe*\"\n      ],\n      \"Effect\": \"Allow\",\n      \"Resource\": \"*\"\n    }\n  ]\n}\n",
      "user": "my_test_user"
    }
  }
}

