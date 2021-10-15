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
package tests.lib.inputs.resource_view_05_tf_v0_15_infra_json

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
            "constant_value": "us-east-1"
          }
        },
        "name": "aws"
      }
    },
    "root_module": {
      "resources": [
        {
          "address": "aws_cloudwatch_log_group.fargate-logs",
          "expressions": {
            "kms_key_id": {
              "references": [
                "aws_kms_key.cloudwatch"
              ]
            },
            "name": {
              "constant_value": "/ecs/fargate-task-definition"
            },
            "tags": {
              "references": [
                "local.tag_name",
                "local.tag_poc"
              ]
            }
          },
          "mode": "managed",
          "name": "fargate-logs",
          "provider_config_key": "aws",
          "schema_version": 0,
          "type": "aws_cloudwatch_log_group"
        },
        {
          "address": "aws_kms_key.cloudwatch",
          "expressions": {
            "deletion_window_in_days": {
              "constant_value": 10
            },
            "description": {
              "constant_value": "cloudwatch kms key"
            },
            "enable_key_rotation": {
              "constant_value": true
            },
            "tags": {
              "references": [
                "local.tag_name",
                "local.tag_poc"
              ]
            }
          },
          "mode": "managed",
          "name": "cloudwatch",
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
          "address": "aws_cloudwatch_log_group.fargate-logs",
          "mode": "managed",
          "name": "fargate-logs",
          "provider_name": "registry.terraform.io/hashicorp/aws",
          "schema_version": 0,
          "type": "aws_cloudwatch_log_group",
          "values": {
            "name": "/ecs/fargate-task-definition",
            "name_prefix": null,
            "retention_in_days": 0,
            "tags": {
              "Name": "foo",
              "POC": "bar"
            },
            "tags_all": {
              "Name": "foo",
              "POC": "bar"
            }
          }
        },
        {
          "address": "aws_kms_key.cloudwatch",
          "mode": "managed",
          "name": "cloudwatch",
          "provider_name": "registry.terraform.io/hashicorp/aws",
          "schema_version": 0,
          "type": "aws_kms_key",
          "values": {
            "bypass_policy_lockout_safety_check": false,
            "customer_master_key_spec": "SYMMETRIC_DEFAULT",
            "deletion_window_in_days": 10,
            "description": "cloudwatch kms key",
            "enable_key_rotation": true,
            "is_enabled": true,
            "key_usage": "ENCRYPT_DECRYPT",
            "tags": {
              "Name": "foo",
              "POC": "bar"
            },
            "tags_all": {
              "Name": "foo",
              "POC": "bar"
            }
          }
        }
      ]
    }
  },
  "resource_changes": [
    {
      "address": "aws_cloudwatch_log_group.fargate-logs",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "name": "/ecs/fargate-task-definition",
          "name_prefix": null,
          "retention_in_days": 0,
          "tags": {
            "Name": "foo",
            "POC": "bar"
          },
          "tags_all": {
            "Name": "foo",
            "POC": "bar"
          }
        },
        "after_sensitive": {
          "tags": {},
          "tags_all": {}
        },
        "after_unknown": {
          "arn": true,
          "id": true,
          "kms_key_id": true,
          "tags": {},
          "tags_all": {}
        },
        "before": null,
        "before_sensitive": false
      },
      "mode": "managed",
      "name": "fargate-logs",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_cloudwatch_log_group"
    },
    {
      "address": "aws_kms_key.cloudwatch",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "bypass_policy_lockout_safety_check": false,
          "customer_master_key_spec": "SYMMETRIC_DEFAULT",
          "deletion_window_in_days": 10,
          "description": "cloudwatch kms key",
          "enable_key_rotation": true,
          "is_enabled": true,
          "key_usage": "ENCRYPT_DECRYPT",
          "tags": {
            "Name": "foo",
            "POC": "bar"
          },
          "tags_all": {
            "Name": "foo",
            "POC": "bar"
          }
        },
        "after_sensitive": {
          "tags": {},
          "tags_all": {}
        },
        "after_unknown": {
          "arn": true,
          "id": true,
          "key_id": true,
          "policy": true,
          "tags": {},
          "tags_all": {}
        },
        "before": null,
        "before_sensitive": false
      },
      "mode": "managed",
      "name": "cloudwatch",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_kms_key"
    }
  ],
  "terraform_version": "0.15.3"
}

