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
package tests.examples.aws.inputs.iam_password_length_infra_json

import data.fugue.resource_view.resource_view_input

mock_input := ret {
  ret = resource_view_input with input as mock_config
}
mock_resources := mock_input.resources
mock_config := {
  "configuration": {
    "provider_config": {
      "aws": {
        "expressions": {
          "region": {
            "constant_value": "us-east-2"
          }
        },
        "name": "aws"
      }
    },
    "root_module": {
      "resources": [
        {
          "address": "aws_iam_account_password_policy.invalid_1",
          "expressions": {
            "minimum_password_length": {
              "constant_value": 4
            }
          },
          "mode": "managed",
          "name": "invalid_1",
          "provider_config_key": "aws",
          "schema_version": 0,
          "type": "aws_iam_account_password_policy"
        },
        {
          "address": "aws_iam_account_password_policy.invalid_2",
          "mode": "managed",
          "name": "invalid_2",
          "provider_config_key": "aws",
          "schema_version": 0,
          "type": "aws_iam_account_password_policy"
        },
        {
          "address": "aws_iam_account_password_policy.valid",
          "expressions": {
            "minimum_password_length": {
              "constant_value": 8
            }
          },
          "mode": "managed",
          "name": "valid",
          "provider_config_key": "aws",
          "schema_version": 0,
          "type": "aws_iam_account_password_policy"
        }
      ]
    }
  },
  "format_version": "0.1",
  "planned_values": {
    "root_module": {
      "resources": [
        {
          "address": "aws_iam_account_password_policy.invalid_1",
          "mode": "managed",
          "name": "invalid_1",
          "provider_name": "registry.terraform.io/hashicorp/aws",
          "schema_version": 0,
          "type": "aws_iam_account_password_policy",
          "values": {
            "allow_users_to_change_password": true,
            "minimum_password_length": 4
          }
        },
        {
          "address": "aws_iam_account_password_policy.invalid_2",
          "mode": "managed",
          "name": "invalid_2",
          "provider_name": "registry.terraform.io/hashicorp/aws",
          "schema_version": 0,
          "type": "aws_iam_account_password_policy",
          "values": {
            "allow_users_to_change_password": true,
            "minimum_password_length": 6
          }
        },
        {
          "address": "aws_iam_account_password_policy.valid",
          "mode": "managed",
          "name": "valid",
          "provider_name": "registry.terraform.io/hashicorp/aws",
          "schema_version": 0,
          "type": "aws_iam_account_password_policy",
          "values": {
            "allow_users_to_change_password": true,
            "minimum_password_length": 8
          }
        }
      ]
    }
  },
  "resource_changes": [
    {
      "address": "aws_iam_account_password_policy.invalid_1",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "allow_users_to_change_password": true,
          "minimum_password_length": 4
        },
        "after_unknown": {
          "expire_passwords": true,
          "hard_expiry": true,
          "id": true,
          "max_password_age": true,
          "password_reuse_prevention": true,
          "require_lowercase_characters": true,
          "require_numbers": true,
          "require_symbols": true,
          "require_uppercase_characters": true
        },
        "before": null
      },
      "mode": "managed",
      "name": "invalid_1",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_iam_account_password_policy"
    },
    {
      "address": "aws_iam_account_password_policy.invalid_2",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "allow_users_to_change_password": true,
          "minimum_password_length": 6
        },
        "after_unknown": {
          "expire_passwords": true,
          "hard_expiry": true,
          "id": true,
          "max_password_age": true,
          "password_reuse_prevention": true,
          "require_lowercase_characters": true,
          "require_numbers": true,
          "require_symbols": true,
          "require_uppercase_characters": true
        },
        "before": null
      },
      "mode": "managed",
      "name": "invalid_2",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_iam_account_password_policy"
    },
    {
      "address": "aws_iam_account_password_policy.valid",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "allow_users_to_change_password": true,
          "minimum_password_length": 8
        },
        "after_unknown": {
          "expire_passwords": true,
          "hard_expiry": true,
          "id": true,
          "max_password_age": true,
          "password_reuse_prevention": true,
          "require_lowercase_characters": true,
          "require_numbers": true,
          "require_symbols": true,
          "require_uppercase_characters": true
        },
        "before": null
      },
      "mode": "managed",
      "name": "valid",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_iam_account_password_policy"
    }
  ],
  "terraform_version": "0.13.5"
}

