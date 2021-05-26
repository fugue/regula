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
package tests.rules.tf.aws.cloudtrail.inputs.log_file_validation_infra_json

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
          "address": "aws_cloudtrail.invalid_trail",
          "depends_on": [
            "aws_s3_bucket_policy.policy"
          ],
          "expressions": {
            "enable_log_file_validation": {
              "constant_value": false
            },
            "name": {
              "constant_value": "invalid_trail"
            },
            "s3_bucket_name": {
              "references": [
                "aws_s3_bucket.trail_bucket"
              ]
            }
          },
          "mode": "managed",
          "name": "invalid_trail",
          "provider_config_key": "aws",
          "schema_version": 0,
          "type": "aws_cloudtrail"
        },
        {
          "address": "aws_cloudtrail.valid_trail",
          "depends_on": [
            "aws_s3_bucket_policy.policy"
          ],
          "expressions": {
            "enable_log_file_validation": {
              "constant_value": true
            },
            "name": {
              "constant_value": "valid_trail"
            },
            "s3_bucket_name": {
              "references": [
                "aws_s3_bucket.trail_bucket"
              ]
            }
          },
          "mode": "managed",
          "name": "valid_trail",
          "provider_config_key": "aws",
          "schema_version": 0,
          "type": "aws_cloudtrail"
        },
        {
          "address": "aws_s3_bucket.trail_bucket",
          "expressions": {
            "force_destroy": {
              "constant_value": true
            }
          },
          "mode": "managed",
          "name": "trail_bucket",
          "provider_config_key": "aws",
          "schema_version": 0,
          "type": "aws_s3_bucket"
        },
        {
          "address": "aws_s3_bucket_policy.policy",
          "expressions": {
            "bucket": {
              "references": [
                "aws_s3_bucket.trail_bucket"
              ]
            },
            "policy": {
              "references": [
                "aws_s3_bucket.trail_bucket",
                "aws_s3_bucket.trail_bucket",
                "data.aws_caller_identity.current"
              ]
            }
          },
          "mode": "managed",
          "name": "policy",
          "provider_config_key": "aws",
          "schema_version": 0,
          "type": "aws_s3_bucket_policy"
        },
        {
          "address": "data.aws_caller_identity.current",
          "mode": "data",
          "name": "current",
          "provider_config_key": "aws",
          "schema_version": 0,
          "type": "aws_caller_identity"
        }
      ]
    }
  },
  "format_version": "0.1",
  "planned_values": {
    "root_module": {
      "resources": [
        {
          "address": "aws_cloudtrail.invalid_trail",
          "mode": "managed",
          "name": "invalid_trail",
          "provider_name": "registry.terraform.io/hashicorp/aws",
          "schema_version": 0,
          "type": "aws_cloudtrail",
          "values": {
            "cloud_watch_logs_group_arn": null,
            "cloud_watch_logs_role_arn": null,
            "enable_log_file_validation": false,
            "enable_logging": true,
            "event_selector": [],
            "include_global_service_events": true,
            "insight_selector": [],
            "is_multi_region_trail": false,
            "is_organization_trail": false,
            "kms_key_id": null,
            "name": "invalid_trail",
            "s3_key_prefix": null,
            "sns_topic_name": null,
            "tags": null
          }
        },
        {
          "address": "aws_cloudtrail.valid_trail",
          "mode": "managed",
          "name": "valid_trail",
          "provider_name": "registry.terraform.io/hashicorp/aws",
          "schema_version": 0,
          "type": "aws_cloudtrail",
          "values": {
            "cloud_watch_logs_group_arn": null,
            "cloud_watch_logs_role_arn": null,
            "enable_log_file_validation": true,
            "enable_logging": true,
            "event_selector": [],
            "include_global_service_events": true,
            "insight_selector": [],
            "is_multi_region_trail": false,
            "is_organization_trail": false,
            "kms_key_id": null,
            "name": "valid_trail",
            "s3_key_prefix": null,
            "sns_topic_name": null,
            "tags": null
          }
        },
        {
          "address": "aws_s3_bucket.trail_bucket",
          "mode": "managed",
          "name": "trail_bucket",
          "provider_name": "registry.terraform.io/hashicorp/aws",
          "schema_version": 0,
          "type": "aws_s3_bucket",
          "values": {
            "acl": "private",
            "bucket_prefix": null,
            "cors_rule": [],
            "force_destroy": true,
            "grant": [],
            "lifecycle_rule": [],
            "logging": [],
            "object_lock_configuration": [],
            "policy": null,
            "replication_configuration": [],
            "server_side_encryption_configuration": [],
            "tags": null,
            "website": []
          }
        },
        {
          "address": "aws_s3_bucket_policy.policy",
          "mode": "managed",
          "name": "policy",
          "provider_name": "registry.terraform.io/hashicorp/aws",
          "schema_version": 0,
          "type": "aws_s3_bucket_policy"
        },
        {
          "address": "data.aws_caller_identity.current",
          "mode": "data",
          "name": "current",
          "provider_name": "registry.terraform.io/hashicorp/aws",
          "schema_version": 0,
          "type": "aws_caller_identity",
          "values": {
            "account_id": "819995596046",
            "arn": "arn:aws:iam::819995596046:user/jason",
            "id": "819995596046",
            "user_id": "AIDA3524L2UHGTZ7STQ2Y"
          }
        }
      ]
    }
  },
  "resource_changes": [
    {
      "address": "aws_cloudtrail.invalid_trail",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "cloud_watch_logs_group_arn": null,
          "cloud_watch_logs_role_arn": null,
          "enable_log_file_validation": false,
          "enable_logging": true,
          "event_selector": [],
          "include_global_service_events": true,
          "insight_selector": [],
          "is_multi_region_trail": false,
          "is_organization_trail": false,
          "kms_key_id": null,
          "name": "invalid_trail",
          "s3_key_prefix": null,
          "sns_topic_name": null,
          "tags": null
        },
        "after_unknown": {
          "arn": true,
          "event_selector": [],
          "home_region": true,
          "id": true,
          "insight_selector": [],
          "s3_bucket_name": true,
          "tags_all": true
        },
        "before": null
      },
      "mode": "managed",
      "name": "invalid_trail",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_cloudtrail"
    },
    {
      "address": "aws_cloudtrail.valid_trail",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "cloud_watch_logs_group_arn": null,
          "cloud_watch_logs_role_arn": null,
          "enable_log_file_validation": true,
          "enable_logging": true,
          "event_selector": [],
          "include_global_service_events": true,
          "insight_selector": [],
          "is_multi_region_trail": false,
          "is_organization_trail": false,
          "kms_key_id": null,
          "name": "valid_trail",
          "s3_key_prefix": null,
          "sns_topic_name": null,
          "tags": null
        },
        "after_unknown": {
          "arn": true,
          "event_selector": [],
          "home_region": true,
          "id": true,
          "insight_selector": [],
          "s3_bucket_name": true,
          "tags_all": true
        },
        "before": null
      },
      "mode": "managed",
      "name": "valid_trail",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_cloudtrail"
    },
    {
      "address": "aws_s3_bucket.trail_bucket",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "acl": "private",
          "bucket_prefix": null,
          "cors_rule": [],
          "force_destroy": true,
          "grant": [],
          "lifecycle_rule": [],
          "logging": [],
          "object_lock_configuration": [],
          "policy": null,
          "replication_configuration": [],
          "server_side_encryption_configuration": [],
          "tags": null,
          "website": []
        },
        "after_unknown": {
          "acceleration_status": true,
          "arn": true,
          "bucket": true,
          "bucket_domain_name": true,
          "bucket_regional_domain_name": true,
          "cors_rule": [],
          "grant": [],
          "hosted_zone_id": true,
          "id": true,
          "lifecycle_rule": [],
          "logging": [],
          "object_lock_configuration": [],
          "region": true,
          "replication_configuration": [],
          "request_payer": true,
          "server_side_encryption_configuration": [],
          "tags_all": true,
          "versioning": true,
          "website": [],
          "website_domain": true,
          "website_endpoint": true
        },
        "before": null
      },
      "mode": "managed",
      "name": "trail_bucket",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_s3_bucket"
    },
    {
      "address": "aws_s3_bucket_policy.policy",
      "change": {
        "actions": [
          "create"
        ],
        "after": {},
        "after_unknown": {
          "bucket": true,
          "id": true,
          "policy": true
        },
        "before": null
      },
      "mode": "managed",
      "name": "policy",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_s3_bucket_policy"
    },
    {
      "address": "data.aws_caller_identity.current",
      "change": {
        "actions": [
          "read"
        ],
        "after": {
          "account_id": "819995596046",
          "arn": "arn:aws:iam::819995596046:user/jason",
          "id": "819995596046",
          "user_id": "AIDA3524L2UHGTZ7STQ2Y"
        },
        "after_unknown": {},
        "before": null
      },
      "mode": "data",
      "name": "current",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_caller_identity"
    }
  ],
  "terraform_version": "0.13.5"
}

