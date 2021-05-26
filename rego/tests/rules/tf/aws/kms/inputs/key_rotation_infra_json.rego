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
package tests.rules.tf.aws.kms.inputs.key_rotation_infra_json

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
            "constant_value": "us-west-2"
          }
        },
        "name": "aws",
        "version_constraint": "~> 2.41"
      }
    },
    "root_module": {
      "resources": [
        {
          "address": "aws_kms_key.blank-invalid",
          "expressions": {
            "description": {
              "constant_value": "KMS key 3"
            }
          },
          "mode": "managed",
          "name": "blank-invalid",
          "provider_config_key": "aws",
          "schema_version": 0,
          "type": "aws_kms_key"
        },
        {
          "address": "aws_kms_key.invalid",
          "expressions": {
            "description": {
              "constant_value": "KMS key 2"
            },
            "enable_key_rotation": {
              "constant_value": false
            }
          },
          "mode": "managed",
          "name": "invalid",
          "provider_config_key": "aws",
          "schema_version": 0,
          "type": "aws_kms_key"
        },
        {
          "address": "aws_kms_key.valid",
          "expressions": {
            "description": {
              "constant_value": "KMS key 1"
            },
            "enable_key_rotation": {
              "constant_value": true
            }
          },
          "mode": "managed",
          "name": "valid",
          "provider_config_key": "aws",
          "schema_version": 0,
          "type": "aws_kms_key"
        }
      ]
    }
  },
  "format_version": "0.1",
  "planned_values": {
    "root_module": {
      "resources": [
        {
          "address": "aws_kms_key.blank-invalid",
          "mode": "managed",
          "name": "blank-invalid",
          "provider_name": "registry.terraform.io/hashicorp/aws",
          "schema_version": 0,
          "type": "aws_kms_key",
          "values": {
            "customer_master_key_spec": "SYMMETRIC_DEFAULT",
            "deletion_window_in_days": null,
            "description": "KMS key 3",
            "enable_key_rotation": false,
            "is_enabled": true,
            "key_usage": "ENCRYPT_DECRYPT",
            "tags": null
          }
        },
        {
          "address": "aws_kms_key.invalid",
          "mode": "managed",
          "name": "invalid",
          "provider_name": "registry.terraform.io/hashicorp/aws",
          "schema_version": 0,
          "type": "aws_kms_key",
          "values": {
            "customer_master_key_spec": "SYMMETRIC_DEFAULT",
            "deletion_window_in_days": null,
            "description": "KMS key 2",
            "enable_key_rotation": false,
            "is_enabled": true,
            "key_usage": "ENCRYPT_DECRYPT",
            "tags": null
          }
        },
        {
          "address": "aws_kms_key.valid",
          "mode": "managed",
          "name": "valid",
          "provider_name": "registry.terraform.io/hashicorp/aws",
          "schema_version": 0,
          "type": "aws_kms_key",
          "values": {
            "customer_master_key_spec": "SYMMETRIC_DEFAULT",
            "deletion_window_in_days": null,
            "description": "KMS key 1",
            "enable_key_rotation": true,
            "is_enabled": true,
            "key_usage": "ENCRYPT_DECRYPT",
            "tags": null
          }
        }
      ]
    }
  },
  "resource_changes": [
    {
      "address": "aws_kms_key.blank-invalid",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "customer_master_key_spec": "SYMMETRIC_DEFAULT",
          "deletion_window_in_days": null,
          "description": "KMS key 3",
          "enable_key_rotation": false,
          "is_enabled": true,
          "key_usage": "ENCRYPT_DECRYPT",
          "tags": null
        },
        "after_unknown": {
          "arn": true,
          "id": true,
          "key_id": true,
          "policy": true
        },
        "before": null
      },
      "mode": "managed",
      "name": "blank-invalid",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_kms_key"
    },
    {
      "address": "aws_kms_key.invalid",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "customer_master_key_spec": "SYMMETRIC_DEFAULT",
          "deletion_window_in_days": null,
          "description": "KMS key 2",
          "enable_key_rotation": false,
          "is_enabled": true,
          "key_usage": "ENCRYPT_DECRYPT",
          "tags": null
        },
        "after_unknown": {
          "arn": true,
          "id": true,
          "key_id": true,
          "policy": true
        },
        "before": null
      },
      "mode": "managed",
      "name": "invalid",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_kms_key"
    },
    {
      "address": "aws_kms_key.valid",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "customer_master_key_spec": "SYMMETRIC_DEFAULT",
          "deletion_window_in_days": null,
          "description": "KMS key 1",
          "enable_key_rotation": true,
          "is_enabled": true,
          "key_usage": "ENCRYPT_DECRYPT",
          "tags": null
        },
        "after_unknown": {
          "arn": true,
          "id": true,
          "key_id": true,
          "policy": true
        },
        "before": null
      },
      "mode": "managed",
      "name": "valid",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_kms_key"
    }
  ],
  "terraform_version": "0.13.5"
}

