# This package was automatically generated from:
#
#     tests/rules/inputs/kms_rotate_infra.tf
#
# using `generate_test_inputs.sh` and should not be modified
# directly.
package tests.rules.kms_rotate
mock_input = {
  "format_version": "0.1",
  "terraform_version": "0.12.18",
  "planned_values": {
    "root_module": {
      "resources": [
        {
          "address": "aws_kms_key.blank-invalid",
          "mode": "managed",
          "type": "aws_kms_key",
          "name": "blank-invalid",
          "provider_name": "aws",
          "schema_version": 0,
          "values": {
            "deletion_window_in_days": null,
            "description": "KMS key 3",
            "enable_key_rotation": false,
            "is_enabled": true,
            "tags": null
          }
        },
        {
          "address": "aws_kms_key.invalid",
          "mode": "managed",
          "type": "aws_kms_key",
          "name": "invalid",
          "provider_name": "aws",
          "schema_version": 0,
          "values": {
            "deletion_window_in_days": null,
            "description": "KMS key 2",
            "enable_key_rotation": false,
            "is_enabled": true,
            "tags": null
          }
        },
        {
          "address": "aws_kms_key.valid",
          "mode": "managed",
          "type": "aws_kms_key",
          "name": "valid",
          "provider_name": "aws",
          "schema_version": 0,
          "values": {
            "deletion_window_in_days": null,
            "description": "KMS key 1",
            "enable_key_rotation": true,
            "is_enabled": true,
            "tags": null
          }
        }
      ]
    }
  },
  "resource_changes": [
    {
      "address": "aws_kms_key.blank-invalid",
      "mode": "managed",
      "type": "aws_kms_key",
      "name": "blank-invalid",
      "provider_name": "aws",
      "change": {
        "actions": [
          "create"
        ],
        "before": null,
        "after": {
          "deletion_window_in_days": null,
          "description": "KMS key 3",
          "enable_key_rotation": false,
          "is_enabled": true,
          "tags": null
        },
        "after_unknown": {
          "arn": true,
          "id": true,
          "key_id": true,
          "key_usage": true,
          "policy": true
        }
      }
    },
    {
      "address": "aws_kms_key.invalid",
      "mode": "managed",
      "type": "aws_kms_key",
      "name": "invalid",
      "provider_name": "aws",
      "change": {
        "actions": [
          "create"
        ],
        "before": null,
        "after": {
          "deletion_window_in_days": null,
          "description": "KMS key 2",
          "enable_key_rotation": false,
          "is_enabled": true,
          "tags": null
        },
        "after_unknown": {
          "arn": true,
          "id": true,
          "key_id": true,
          "key_usage": true,
          "policy": true
        }
      }
    },
    {
      "address": "aws_kms_key.valid",
      "mode": "managed",
      "type": "aws_kms_key",
      "name": "valid",
      "provider_name": "aws",
      "change": {
        "actions": [
          "create"
        ],
        "before": null,
        "after": {
          "deletion_window_in_days": null,
          "description": "KMS key 1",
          "enable_key_rotation": true,
          "is_enabled": true,
          "tags": null
        },
        "after_unknown": {
          "arn": true,
          "id": true,
          "key_id": true,
          "key_usage": true,
          "policy": true
        }
      }
    }
  ],
  "configuration": {
    "provider_config": {
      "aws": {
        "name": "aws",
        "version_constraint": "~> 2.41",
        "expressions": {
          "region": {
            "constant_value": "us-west-2"
          }
        }
      }
    },
    "root_module": {
      "resources": [
        {
          "address": "aws_kms_key.blank-invalid",
          "mode": "managed",
          "type": "aws_kms_key",
          "name": "blank-invalid",
          "provider_config_key": "aws",
          "expressions": {
            "description": {
              "constant_value": "KMS key 3"
            }
          },
          "schema_version": 0
        },
        {
          "address": "aws_kms_key.invalid",
          "mode": "managed",
          "type": "aws_kms_key",
          "name": "invalid",
          "provider_config_key": "aws",
          "expressions": {
            "description": {
              "constant_value": "KMS key 2"
            },
            "enable_key_rotation": {
              "constant_value": false
            }
          },
          "schema_version": 0
        },
        {
          "address": "aws_kms_key.valid",
          "mode": "managed",
          "type": "aws_kms_key",
          "name": "valid",
          "provider_config_key": "aws",
          "expressions": {
            "description": {
              "constant_value": "KMS key 1"
            },
            "enable_key_rotation": {
              "constant_value": true
            }
          },
          "schema_version": 0
        }
      ]
    }
  }
}
