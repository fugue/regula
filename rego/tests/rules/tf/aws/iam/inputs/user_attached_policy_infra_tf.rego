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
package tests.rules.tf.aws.iam.inputs.user_attached_policy_infra_tf

import data.fugue.resource_view.resource_view_input

mock_input := ret {
  ret = resource_view_input with input as mock_config
}
mock_resources := mock_input.resources
mock_config := {
  "hcl_resource_view_version": "0.0.1",
  "resources": {
    "aws_iam_group.valid_group_blank_users": {
      "_filepath": "tests/rules/tf/aws/iam/inputs/user_attached_policy_infra.tf",
      "_provider": "aws",
      "_type": "aws_iam_group",
      "id": "aws_iam_group.valid_group_blank_users",
      "name": "valid_group_blank_users"
    },
    "aws_iam_group.valid_group_empty_list_users": {
      "_filepath": "tests/rules/tf/aws/iam/inputs/user_attached_policy_infra.tf",
      "_provider": "aws",
      "_type": "aws_iam_group",
      "id": "aws_iam_group.valid_group_empty_list_users",
      "name": "valid_group_empty_list_users"
    },
    "aws_iam_group.valid_group_missing_users": {
      "_filepath": "tests/rules/tf/aws/iam/inputs/user_attached_policy_infra.tf",
      "_provider": "aws",
      "_type": "aws_iam_group",
      "id": "aws_iam_group.valid_group_missing_users",
      "name": "valid_group_missing_users"
    },
    "aws_iam_group_membership.valid_group_blank_users_membership": {
      "_filepath": "tests/rules/tf/aws/iam/inputs/user_attached_policy_infra.tf",
      "_provider": "aws",
      "_type": "aws_iam_group_membership",
      "group": "valid_group_blank_users",
      "id": "aws_iam_group_membership.valid_group_blank_users_membership",
      "name": "valid_group_blank_users_membership",
      "users": [
        "valid_group_blank_user"
      ]
    },
    "aws_iam_group_membership.valid_group_empty_list_users_membership": {
      "_filepath": "tests/rules/tf/aws/iam/inputs/user_attached_policy_infra.tf",
      "_provider": "aws",
      "_type": "aws_iam_group_membership",
      "group": "valid_group_empty_list_users",
      "id": "aws_iam_group_membership.valid_group_empty_list_users_membership",
      "name": "valid_group_empty_list_users_membership",
      "users": [
        "valid_group_empty_list_user"
      ]
    },
    "aws_iam_group_membership.valid_group_missing_users_membership": {
      "_filepath": "tests/rules/tf/aws/iam/inputs/user_attached_policy_infra.tf",
      "_provider": "aws",
      "_type": "aws_iam_group_membership",
      "group": "valid_group_missing_users",
      "id": "aws_iam_group_membership.valid_group_missing_users_membership",
      "name": "valid_group_missing_users_membership",
      "users": [
        "valid_group_missing_user"
      ]
    },
    "aws_iam_policy.invalid_normal_policy": {
      "_filepath": "tests/rules/tf/aws/iam/inputs/user_attached_policy_infra.tf",
      "_provider": "aws",
      "_type": "aws_iam_policy",
      "description": "Invalid normal policy attached to user",
      "id": "aws_iam_policy.invalid_normal_policy",
      "name": "invalid_normal_policy",
      "policy": "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Action\": [\n        \"*\"\n      ],\n      \"Effect\": \"Deny\",\n      \"Resource\": \"*\"\n    }\n  ]\n}\n"
    },
    "aws_iam_policy.invalid_user_policy_attachment_policy": {
      "_filepath": "tests/rules/tf/aws/iam/inputs/user_attached_policy_infra.tf",
      "_provider": "aws",
      "_type": "aws_iam_policy",
      "description": "Invalid user policy attachment policy",
      "id": "aws_iam_policy.invalid_user_policy_attachment_policy",
      "name": "invalid_user_policy_attachment_policy",
      "policy": "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Action\": [\n        \"ec2:Describe*\"\n      ],\n      \"Effect\": \"Allow\",\n      \"Resource\": \"*\"\n    }\n  ]\n}\n"
    },
    "aws_iam_policy.valid_group_blank_users_policy": {
      "_filepath": "tests/rules/tf/aws/iam/inputs/user_attached_policy_infra.tf",
      "_provider": "aws",
      "_type": "aws_iam_policy",
      "description": "Valid group blank users policy",
      "id": "aws_iam_policy.valid_group_blank_users_policy",
      "name": "valid_group_blank_users_policy",
      "policy": "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Action\": [\n        \"ec2:Describe*\"\n      ],\n      \"Effect\": \"Deny\",\n      \"Resource\": \"*\"\n    }\n  ]\n}\n"
    },
    "aws_iam_policy.valid_group_empty_list_users_policy": {
      "_filepath": "tests/rules/tf/aws/iam/inputs/user_attached_policy_infra.tf",
      "_provider": "aws",
      "_type": "aws_iam_policy",
      "description": "Valid group empty list users policy",
      "id": "aws_iam_policy.valid_group_empty_list_users_policy",
      "name": "valid_group_empty_list_users_policy",
      "policy": "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Action\": [\n        \"ec2:Describe*\"\n      ],\n      \"Effect\": \"Deny\",\n      \"Resource\": \"*\"\n    }\n  ]\n}\n"
    },
    "aws_iam_policy.valid_group_missing_users_policy": {
      "_filepath": "tests/rules/tf/aws/iam/inputs/user_attached_policy_infra.tf",
      "_provider": "aws",
      "_type": "aws_iam_policy",
      "description": "Valid group missing users policy",
      "id": "aws_iam_policy.valid_group_missing_users_policy",
      "name": "valid_group_missing_users_policy",
      "policy": "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Action\": [\n        \"ec2:Describe*\"\n      ],\n      \"Effect\": \"Deny\",\n      \"Resource\": \"*\"\n    }\n  ]\n}\n"
    },
    "aws_iam_policy.valid_role_policy": {
      "_filepath": "tests/rules/tf/aws/iam/inputs/user_attached_policy_infra.tf",
      "_provider": "aws",
      "_type": "aws_iam_policy",
      "description": "Valid role policy",
      "id": "aws_iam_policy.valid_role_policy",
      "name": "valid_role_policy",
      "policy": "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Action\": [\n        \"ec2:Describe*\"\n      ],\n      \"Effect\": \"Allow\",\n      \"Resource\": \"*\"\n    }\n  ]\n}\n"
    },
    "aws_iam_policy_attachment.invalid_normal_policy_attachment": {
      "_filepath": "tests/rules/tf/aws/iam/inputs/user_attached_policy_infra.tf",
      "_provider": "aws",
      "_type": "aws_iam_policy_attachment",
      "id": "aws_iam_policy_attachment.invalid_normal_policy_attachment",
      "name": "invalid_normal_policy_attachment",
      "policy_arn": "aws_iam_policy.invalid_normal_policy",
      "users": [
        "invalid_normal_policy_user"
      ]
    },
    "aws_iam_policy_attachment.valid_group_policy_attachment_blank_users": {
      "_filepath": "tests/rules/tf/aws/iam/inputs/user_attached_policy_infra.tf",
      "_provider": "aws",
      "_type": "aws_iam_policy_attachment",
      "groups": [
        "valid_group_blank_users"
      ],
      "id": "aws_iam_policy_attachment.valid_group_policy_attachment_blank_users",
      "name": "valid_group_policy_attachment_blank_users",
      "policy_arn": "aws_iam_policy.valid_group_blank_users_policy",
      "users": [
        ""
      ]
    },
    "aws_iam_policy_attachment.valid_group_policy_attachment_empty_list_users": {
      "_filepath": "tests/rules/tf/aws/iam/inputs/user_attached_policy_infra.tf",
      "_provider": "aws",
      "_type": "aws_iam_policy_attachment",
      "groups": [
        "valid_group_empty_list_users"
      ],
      "id": "aws_iam_policy_attachment.valid_group_policy_attachment_empty_list_users",
      "name": "valid_group_policy_attachment_empty_list_users",
      "policy_arn": "aws_iam_policy.valid_group_empty_list_users_policy",
      "users": []
    },
    "aws_iam_policy_attachment.valid_group_policy_attachment_missing_users": {
      "_filepath": "tests/rules/tf/aws/iam/inputs/user_attached_policy_infra.tf",
      "_provider": "aws",
      "_type": "aws_iam_policy_attachment",
      "groups": [
        "valid_group_missing_users"
      ],
      "id": "aws_iam_policy_attachment.valid_group_policy_attachment_missing_users",
      "name": "valid_group_policy_attachment_missing_users",
      "policy_arn": "aws_iam_policy.valid_group_missing_users_policy"
    },
    "aws_iam_policy_attachment.valid_role_policy_attachment": {
      "_filepath": "tests/rules/tf/aws/iam/inputs/user_attached_policy_infra.tf",
      "_provider": "aws",
      "_type": "aws_iam_policy_attachment",
      "id": "aws_iam_policy_attachment.valid_role_policy_attachment",
      "name": "valid_role_policy_attachment",
      "policy_arn": "aws_iam_policy.valid_role_policy",
      "roles": [
        "valid_role"
      ]
    },
    "aws_iam_role.valid_role": {
      "_filepath": "tests/rules/tf/aws/iam/inputs/user_attached_policy_infra.tf",
      "_provider": "aws",
      "_type": "aws_iam_role",
      "assume_role_policy": "{\n\"Version\": \"2012-10-17\",\n\"Statement\": [\n  {\n    \"Action\": \"sts:AssumeRole\",\n    \"Principal\": {\n      \"Service\": \"ec2.amazonaws.com\"\n    },\n    \"Effect\": \"Allow\",\n    \"Sid\": \"\"\n  }\n ]\n}\n",
      "id": "aws_iam_role.valid_role",
      "name": "valid_role"
    },
    "aws_iam_user.invalid_normal_policy_user": {
      "_filepath": "tests/rules/tf/aws/iam/inputs/user_attached_policy_infra.tf",
      "_provider": "aws",
      "_type": "aws_iam_user",
      "id": "aws_iam_user.invalid_normal_policy_user",
      "name": "invalid_normal_policy_user"
    },
    "aws_iam_user.invalid_user_policy_attachment_user": {
      "_filepath": "tests/rules/tf/aws/iam/inputs/user_attached_policy_infra.tf",
      "_provider": "aws",
      "_type": "aws_iam_user",
      "id": "aws_iam_user.invalid_user_policy_attachment_user",
      "name": "invalid_user_policy_attachment_user"
    },
    "aws_iam_user.invalid_user_policy_user": {
      "_filepath": "tests/rules/tf/aws/iam/inputs/user_attached_policy_infra.tf",
      "_provider": "aws",
      "_type": "aws_iam_user",
      "id": "aws_iam_user.invalid_user_policy_user",
      "name": "invalid_user_policy_user"
    },
    "aws_iam_user.valid_group_blank_user": {
      "_filepath": "tests/rules/tf/aws/iam/inputs/user_attached_policy_infra.tf",
      "_provider": "aws",
      "_type": "aws_iam_user",
      "id": "aws_iam_user.valid_group_blank_user",
      "name": "valid_group_blank_user"
    },
    "aws_iam_user.valid_group_empty_list_user": {
      "_filepath": "tests/rules/tf/aws/iam/inputs/user_attached_policy_infra.tf",
      "_provider": "aws",
      "_type": "aws_iam_user",
      "id": "aws_iam_user.valid_group_empty_list_user",
      "name": "valid_group_empty_list_user"
    },
    "aws_iam_user.valid_group_missing_user": {
      "_filepath": "tests/rules/tf/aws/iam/inputs/user_attached_policy_infra.tf",
      "_provider": "aws",
      "_type": "aws_iam_user",
      "id": "aws_iam_user.valid_group_missing_user",
      "name": "valid_group_missing_user"
    },
    "aws_iam_user_policy.invalid_user_policy": {
      "_filepath": "tests/rules/tf/aws/iam/inputs/user_attached_policy_infra.tf",
      "_provider": "aws",
      "_type": "aws_iam_user_policy",
      "id": "aws_iam_user_policy.invalid_user_policy",
      "name": "invalid_user_policy",
      "policy": "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Action\": [\n        \"ec2:Describe*\"\n      ],\n      \"Effect\": \"Allow\",\n      \"Resource\": \"*\"\n    }\n  ]\n}\n",
      "user": "invalid_user_policy_user"
    },
    "aws_iam_user_policy_attachment.invalid_user_policy_attachment": {
      "_filepath": "tests/rules/tf/aws/iam/inputs/user_attached_policy_infra.tf",
      "_provider": "aws",
      "_type": "aws_iam_user_policy_attachment",
      "id": "aws_iam_user_policy_attachment.invalid_user_policy_attachment",
      "policy_arn": "aws_iam_policy.invalid_user_policy_attachment_policy",
      "user": "invalid_user_policy_attachment_user"
    }
  }
}

