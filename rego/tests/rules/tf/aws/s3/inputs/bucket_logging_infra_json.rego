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
package tests.rules.tf.aws.s3.inputs.bucket_logging_infra_json

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
        "full_name": "registry.terraform.io/hashicorp/aws",
        "name": "aws"
      }
    },
    "root_module": {
      "resources": [
        {
          "address": "aws_s3_bucket.allow_attached_resource_logging",
          "expressions": {
            "bucket": {
              "constant_value": "allow-attached-resource-logging"
            }
          },
          "mode": "managed",
          "name": "allow_attached_resource_logging",
          "provider_config_key": "aws",
          "schema_version": 0,
          "type": "aws_s3_bucket"
        },
        {
          "address": "aws_s3_bucket.allow_inline_logging",
          "expressions": {
            "bucket": {
              "constant_value": "allow-directly-attached-logging"
            },
            "logging": [
              {
                "target_bucket": {
                  "references": [
                    "aws_s3_bucket.deny_no_logging.id",
                    "aws_s3_bucket.deny_no_logging"
                  ]
                },
                "target_prefix": {
                  "constant_value": "/allow_inline_logging/"
                }
              }
            ]
          },
          "mode": "managed",
          "name": "allow_inline_logging",
          "provider_config_key": "aws",
          "schema_version": 0,
          "type": "aws_s3_bucket"
        },
        {
          "address": "aws_s3_bucket.deny_no_logging",
          "expressions": {
            "bucket": {
              "constant_value": "allow-directly-attached-logging"
            }
          },
          "mode": "managed",
          "name": "deny_no_logging",
          "provider_config_key": "aws",
          "schema_version": 0,
          "type": "aws_s3_bucket"
        },
        {
          "address": "aws_s3_bucket_logging.allow_attached_resource_logging_name_does_not_match",
          "expressions": {
            "bucket": {
              "references": [
                "aws_s3_bucket.allow_attached_resource_logging.id",
                "aws_s3_bucket.allow_attached_resource_logging"
              ]
            },
            "target_bucket": {
              "references": [
                "aws_s3_bucket.deny_no_logging.id",
                "aws_s3_bucket.deny_no_logging"
              ]
            },
            "target_prefix": {
              "constant_value": "/allow_attached_resource_logging/"
            }
          },
          "mode": "managed",
          "name": "allow_attached_resource_logging_name_does_not_match",
          "provider_config_key": "aws",
          "schema_version": 0,
          "type": "aws_s3_bucket_logging"
        }
      ]
    }
  },
  "format_version": "1.2",
  "planned_values": {
    "root_module": {
      "resources": [
        {
          "address": "aws_s3_bucket.allow_attached_resource_logging",
          "mode": "managed",
          "name": "allow_attached_resource_logging",
          "provider_name": "registry.terraform.io/hashicorp/aws",
          "schema_version": 0,
          "sensitive_values": {
            "cors_rule": [],
            "grant": [],
            "lifecycle_rule": [],
            "logging": [],
            "object_lock_configuration": [],
            "replication_configuration": [],
            "server_side_encryption_configuration": [],
            "tags_all": {},
            "versioning": [],
            "website": []
          },
          "type": "aws_s3_bucket",
          "values": {
            "bucket": "allow-attached-resource-logging",
            "force_destroy": false,
            "tags": null,
            "timeouts": null
          }
        },
        {
          "address": "aws_s3_bucket.allow_inline_logging",
          "mode": "managed",
          "name": "allow_inline_logging",
          "provider_name": "registry.terraform.io/hashicorp/aws",
          "schema_version": 0,
          "sensitive_values": {
            "cors_rule": [],
            "grant": [],
            "lifecycle_rule": [],
            "logging": [
              {}
            ],
            "object_lock_configuration": [],
            "replication_configuration": [],
            "server_side_encryption_configuration": [],
            "tags_all": {},
            "versioning": [],
            "website": []
          },
          "type": "aws_s3_bucket",
          "values": {
            "bucket": "allow-directly-attached-logging",
            "force_destroy": false,
            "logging": [
              {
                "target_prefix": "/allow_inline_logging/"
              }
            ],
            "tags": null,
            "timeouts": null
          }
        },
        {
          "address": "aws_s3_bucket.deny_no_logging",
          "mode": "managed",
          "name": "deny_no_logging",
          "provider_name": "registry.terraform.io/hashicorp/aws",
          "schema_version": 0,
          "sensitive_values": {
            "cors_rule": [],
            "grant": [],
            "lifecycle_rule": [],
            "logging": [],
            "object_lock_configuration": [],
            "replication_configuration": [],
            "server_side_encryption_configuration": [],
            "tags_all": {},
            "versioning": [],
            "website": []
          },
          "type": "aws_s3_bucket",
          "values": {
            "bucket": "allow-directly-attached-logging",
            "force_destroy": false,
            "tags": null,
            "timeouts": null
          }
        },
        {
          "address": "aws_s3_bucket_logging.allow_attached_resource_logging_name_does_not_match",
          "mode": "managed",
          "name": "allow_attached_resource_logging_name_does_not_match",
          "provider_name": "registry.terraform.io/hashicorp/aws",
          "schema_version": 0,
          "sensitive_values": {
            "target_grant": [],
            "target_object_key_format": []
          },
          "type": "aws_s3_bucket_logging",
          "values": {
            "expected_bucket_owner": null,
            "target_grant": [],
            "target_object_key_format": [],
            "target_prefix": "/allow_attached_resource_logging/"
          }
        }
      ]
    }
  },
  "relevant_attributes": [
    {
      "attribute": [
        "id"
      ],
      "resource": "aws_s3_bucket.allow_attached_resource_logging"
    },
    {
      "attribute": [
        "id"
      ],
      "resource": "aws_s3_bucket.deny_no_logging"
    }
  ],
  "resource_changes": [
    {
      "address": "aws_s3_bucket.allow_attached_resource_logging",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "bucket": "allow-attached-resource-logging",
          "force_destroy": false,
          "tags": null,
          "timeouts": null
        },
        "after_sensitive": {
          "cors_rule": [],
          "grant": [],
          "lifecycle_rule": [],
          "logging": [],
          "object_lock_configuration": [],
          "replication_configuration": [],
          "server_side_encryption_configuration": [],
          "tags_all": {},
          "versioning": [],
          "website": []
        },
        "after_unknown": {
          "acceleration_status": true,
          "acl": true,
          "arn": true,
          "bucket_domain_name": true,
          "bucket_prefix": true,
          "bucket_regional_domain_name": true,
          "cors_rule": true,
          "grant": true,
          "hosted_zone_id": true,
          "id": true,
          "lifecycle_rule": true,
          "logging": true,
          "object_lock_configuration": true,
          "object_lock_enabled": true,
          "policy": true,
          "region": true,
          "replication_configuration": true,
          "request_payer": true,
          "server_side_encryption_configuration": true,
          "tags_all": true,
          "versioning": true,
          "website": true,
          "website_domain": true,
          "website_endpoint": true
        },
        "before": null,
        "before_sensitive": false
      },
      "mode": "managed",
      "name": "allow_attached_resource_logging",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_s3_bucket"
    },
    {
      "address": "aws_s3_bucket.allow_inline_logging",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "bucket": "allow-directly-attached-logging",
          "force_destroy": false,
          "logging": [
            {
              "target_prefix": "/allow_inline_logging/"
            }
          ],
          "tags": null,
          "timeouts": null
        },
        "after_sensitive": {
          "cors_rule": [],
          "grant": [],
          "lifecycle_rule": [],
          "logging": [
            {}
          ],
          "object_lock_configuration": [],
          "replication_configuration": [],
          "server_side_encryption_configuration": [],
          "tags_all": {},
          "versioning": [],
          "website": []
        },
        "after_unknown": {
          "acceleration_status": true,
          "acl": true,
          "arn": true,
          "bucket_domain_name": true,
          "bucket_prefix": true,
          "bucket_regional_domain_name": true,
          "cors_rule": true,
          "grant": true,
          "hosted_zone_id": true,
          "id": true,
          "lifecycle_rule": true,
          "logging": [
            {
              "target_bucket": true
            }
          ],
          "object_lock_configuration": true,
          "object_lock_enabled": true,
          "policy": true,
          "region": true,
          "replication_configuration": true,
          "request_payer": true,
          "server_side_encryption_configuration": true,
          "tags_all": true,
          "versioning": true,
          "website": true,
          "website_domain": true,
          "website_endpoint": true
        },
        "before": null,
        "before_sensitive": false
      },
      "mode": "managed",
      "name": "allow_inline_logging",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_s3_bucket"
    },
    {
      "address": "aws_s3_bucket.deny_no_logging",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "bucket": "allow-directly-attached-logging",
          "force_destroy": false,
          "tags": null,
          "timeouts": null
        },
        "after_sensitive": {
          "cors_rule": [],
          "grant": [],
          "lifecycle_rule": [],
          "logging": [],
          "object_lock_configuration": [],
          "replication_configuration": [],
          "server_side_encryption_configuration": [],
          "tags_all": {},
          "versioning": [],
          "website": []
        },
        "after_unknown": {
          "acceleration_status": true,
          "acl": true,
          "arn": true,
          "bucket_domain_name": true,
          "bucket_prefix": true,
          "bucket_regional_domain_name": true,
          "cors_rule": true,
          "grant": true,
          "hosted_zone_id": true,
          "id": true,
          "lifecycle_rule": true,
          "logging": true,
          "object_lock_configuration": true,
          "object_lock_enabled": true,
          "policy": true,
          "region": true,
          "replication_configuration": true,
          "request_payer": true,
          "server_side_encryption_configuration": true,
          "tags_all": true,
          "versioning": true,
          "website": true,
          "website_domain": true,
          "website_endpoint": true
        },
        "before": null,
        "before_sensitive": false
      },
      "mode": "managed",
      "name": "deny_no_logging",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_s3_bucket"
    },
    {
      "address": "aws_s3_bucket_logging.allow_attached_resource_logging_name_does_not_match",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "expected_bucket_owner": null,
          "target_grant": [],
          "target_object_key_format": [],
          "target_prefix": "/allow_attached_resource_logging/"
        },
        "after_sensitive": {
          "target_grant": [],
          "target_object_key_format": []
        },
        "after_unknown": {
          "bucket": true,
          "id": true,
          "target_bucket": true,
          "target_grant": [],
          "target_object_key_format": []
        },
        "before": null,
        "before_sensitive": false
      },
      "mode": "managed",
      "name": "allow_attached_resource_logging_name_does_not_match",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_s3_bucket_logging"
    }
  ],
  "terraform_version": "1.5.7",
  "timestamp": "2024-04-19T20:43:56Z"
}

