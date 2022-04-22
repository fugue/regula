# Copyright 2020 Fugue, Inc.
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

package tests.rules.tf.aws.s3.inputs.bucketpolicy_allowlist_infra_json

import data.fugue.resource_view.resource_view_input

mock_input := ret {
  ret = resource_view_input with input as mock_config
}
mock_resources := mock_input.resources
mock_config := {
    "format_version": "0.2",
    "terraform_version": "1.0.8",
    "planned_values": {
      "root_module": {
        "resources": [
          {
            "address": "aws_s3_bucket.allowget-external-policy",
            "mode": "managed",
            "type": "aws_s3_bucket",
            "name": "allowget-external-policy",
            "provider_name": "registry.terraform.io/hashicorp/aws",
            "schema_version": 0,
            "values": {
              "acl": "private",
              "bucket": "allowget-external-policy",
              "bucket_prefix": null,
              "cors_rule": [],
              "force_destroy": false,
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
            }
          },
          {
            "address": "aws_s3_bucket.allowget-inline-policy",
            "mode": "managed",
            "type": "aws_s3_bucket",
            "name": "allowget-inline-policy",
            "provider_name": "registry.terraform.io/hashicorp/aws",
            "schema_version": 0,
            "values": {
              "acl": "private",
              "bucket": "allowget-inline-policy",
              "bucket_prefix": null,
              "cors_rule": [],
              "force_destroy": false,
              "grant": [],
              "lifecycle_rule": [],
              "logging": [],
              "object_lock_configuration": [],
              "policy": "    {\n    \"Id\": \"BucketPolicy\",\n    \"Version\": \"2012-10-17\",\n    \"Statement\": [\n        {\n        \"Sid\": \"AllAccess\",\n        \"Action\": \"s3:GetBucket\",\n        \"Effect\": \"Allow\",\n        \"Resource\": [\n            \"arn:aws:s3:::allowget-inline-policy\"\n        ],\n        \"Principal\": \"*\"\n        }\n    ]\n    }\n",
              "replication_configuration": [],
              "server_side_encryption_configuration": [],
              "tags": null,
              "website": []
            },
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
            }
          },
          {
            "address": "aws_s3_bucket.allowlist-external-policy",
            "mode": "managed",
            "type": "aws_s3_bucket",
            "name": "allowlist-external-policy",
            "provider_name": "registry.terraform.io/hashicorp/aws",
            "schema_version": 0,
            "values": {
              "acl": "private",
              "bucket": "allowlist-external-policy",
              "bucket_prefix": null,
              "cors_rule": [],
              "force_destroy": false,
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
            }
          },
          {
            "address": "aws_s3_bucket.allowlist-inline-policy",
            "mode": "managed",
            "type": "aws_s3_bucket",
            "name": "allowlist-inline-policy",
            "provider_name": "registry.terraform.io/hashicorp/aws",
            "schema_version": 0,
            "values": {
              "acl": "private",
              "bucket": "allowlist-inline-policy",
              "bucket_prefix": null,
              "cors_rule": [],
              "force_destroy": false,
              "grant": [],
              "lifecycle_rule": [],
              "logging": [],
              "object_lock_configuration": [],
              "policy": "    {\n    \"Id\": \"BucketPolicy\",\n    \"Version\": \"2012-10-17\",\n    \"Statement\": [\n        {\n        \"Sid\": \"AllAccess\",\n        \"Action\": \"s3:List*\",\n        \"Effect\": \"Allow\",\n        \"Resource\": [\n            \"arn:aws:s3:::allowlist-inline-policy\"\n        ],\n        \"Principal\": \"*\"\n        }\n    ]\n    }\n",
              "replication_configuration": [],
              "server_side_encryption_configuration": [],
              "tags": null,
              "website": []
            },
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
            }
          },
          {
            "address": "aws_s3_bucket.denylist-external-policy",
            "mode": "managed",
            "type": "aws_s3_bucket",
            "name": "denylist-external-policy",
            "provider_name": "registry.terraform.io/hashicorp/aws",
            "schema_version": 0,
            "values": {
              "acl": "private",
              "bucket": "denylist-external-policy",
              "bucket_prefix": null,
              "cors_rule": [],
              "force_destroy": false,
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
            }
          },
          {
            "address": "aws_s3_bucket.denylist-inline-policy",
            "mode": "managed",
            "type": "aws_s3_bucket",
            "name": "denylist-inline-policy",
            "provider_name": "registry.terraform.io/hashicorp/aws",
            "schema_version": 0,
            "values": {
              "acl": "private",
              "bucket": "denylist-inline-policy",
              "bucket_prefix": null,
              "cors_rule": [],
              "force_destroy": false,
              "grant": [],
              "lifecycle_rule": [],
              "logging": [],
              "object_lock_configuration": [],
              "policy": "    {\n    \"Id\": \"BucketPolicy\",\n    \"Version\": \"2012-10-17\",\n    \"Statement\": [\n        {\n        \"Sid\": \"AllAccess\",\n        \"Action\": \"s3:List*\",\n        \"Effect\": \"Deny\",\n        \"Resource\": [\n            \"arn:aws:s3:::denylist-inline-policy\"\n        ],\n        \"Principal\": \"*\"\n        }\n    ]\n    }\n",
              "replication_configuration": [],
              "server_side_encryption_configuration": [],
              "tags": null,
              "website": []
            },
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
            }
          },
          {
            "address": "aws_s3_bucket.nopolicy-bucket",
            "mode": "managed",
            "type": "aws_s3_bucket",
            "name": "nopolicy-bucket",
            "provider_name": "registry.terraform.io/hashicorp/aws",
            "schema_version": 0,
            "values": {
              "acl": "private",
              "bucket": "nopolicy-bucket",
              "bucket_prefix": null,
              "cors_rule": [],
              "force_destroy": false,
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
            }
          },
          {
            "address": "aws_s3_bucket_policy.allowget-policy",
            "mode": "managed",
            "type": "aws_s3_bucket_policy",
            "name": "allowget-policy",
            "provider_name": "registry.terraform.io/hashicorp/aws",
            "schema_version": 0,
            "values": {
              "policy": "{\"Id\":\"BucketPolicy\",\"Statement\":[{\"Action\":\"*\",\"Effect\":\"Allow\",\"Principal\":{\"AWS\":\"*\"},\"Resource\":[\"arn:aws:s3:::allowget-external-policy\"],\"Sid\":\"AllAccess\"}],\"Version\":\"2012-10-17\"}"
            },
            "sensitive_values": {}
          },
          {
            "address": "aws_s3_bucket_policy.allowlist-policy",
            "mode": "managed",
            "type": "aws_s3_bucket_policy",
            "name": "allowlist-policy",
            "provider_name": "registry.terraform.io/hashicorp/aws",
            "schema_version": 0,
            "values": {
              "policy": "{\"Id\":\"BucketPolicy\",\"Statement\":[{\"Action\":\"s3:ListBucket\",\"Effect\":\"Allow\",\"Principal\":\"*\",\"Resource\":[\"arn:aws:s3:::allowlist-external-policy\"],\"Sid\":\"AllAccess\"}],\"Version\":\"2012-10-17\"}"
            },
            "sensitive_values": {}
          },
          {
            "address": "aws_s3_bucket_policy.denylist-policy",
            "mode": "managed",
            "type": "aws_s3_bucket_policy",
            "name": "denylist-policy",
            "provider_name": "registry.terraform.io/hashicorp/aws",
            "schema_version": 0,
            "values": {
              "policy": "{\"Id\":\"BucketPolicy\",\"Statement\":[{\"Action\":\"*\",\"Effect\":\"Deny\",\"Principal\":\"*\",\"Resource\":[\"arn:aws:s3:::denylist-external-policy\"],\"Sid\":\"AllAccess\"}],\"Version\":\"2012-10-17\"}"
            },
            "sensitive_values": {}
          }
        ]
      }
    },
    "resource_changes": [
      {
        "address": "aws_s3_bucket.allowget-external-policy",
        "mode": "managed",
        "type": "aws_s3_bucket",
        "name": "allowget-external-policy",
        "provider_name": "registry.terraform.io/hashicorp/aws",
        "change": {
          "actions": ["create"],
          "before": null,
          "after": {
            "acl": "private",
            "bucket": "allowget-external-policy",
            "bucket_prefix": null,
            "cors_rule": [],
            "force_destroy": false,
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
          "before_sensitive": false,
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
          }
        }
      },
      {
        "address": "aws_s3_bucket.allowget-inline-policy",
        "mode": "managed",
        "type": "aws_s3_bucket",
        "name": "allowget-inline-policy",
        "provider_name": "registry.terraform.io/hashicorp/aws",
        "change": {
          "actions": ["create"],
          "before": null,
          "after": {
            "acl": "private",
            "bucket": "allowget-inline-policy",
            "bucket_prefix": null,
            "cors_rule": [],
            "force_destroy": false,
            "grant": [],
            "lifecycle_rule": [],
            "logging": [],
            "object_lock_configuration": [],
            "policy": "    {\n    \"Id\": \"BucketPolicy\",\n    \"Version\": \"2012-10-17\",\n    \"Statement\": [\n        {\n        \"Sid\": \"AllAccess\",\n        \"Action\": \"s3:GetBucket\",\n        \"Effect\": \"Allow\",\n        \"Resource\": [\n            \"arn:aws:s3:::allowget-inline-policy\"\n        ],\n        \"Principal\": \"*\"\n        }\n    ]\n    }\n",
            "replication_configuration": [],
            "server_side_encryption_configuration": [],
            "tags": null,
            "website": []
          },
          "after_unknown": {
            "acceleration_status": true,
            "arn": true,
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
          "before_sensitive": false,
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
          }
        }
      },
      {
        "address": "aws_s3_bucket.allowlist-external-policy",
        "mode": "managed",
        "type": "aws_s3_bucket",
        "name": "allowlist-external-policy",
        "provider_name": "registry.terraform.io/hashicorp/aws",
        "change": {
          "actions": ["create"],
          "before": null,
          "after": {
            "acl": "private",
            "bucket": "allowlist-external-policy",
            "bucket_prefix": null,
            "cors_rule": [],
            "force_destroy": false,
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
          "before_sensitive": false,
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
          }
        }
      },
      {
        "address": "aws_s3_bucket.allowlist-inline-policy",
        "mode": "managed",
        "type": "aws_s3_bucket",
        "name": "allowlist-inline-policy",
        "provider_name": "registry.terraform.io/hashicorp/aws",
        "change": {
          "actions": ["create"],
          "before": null,
          "after": {
            "acl": "private",
            "bucket": "allowlist-inline-policy",
            "bucket_prefix": null,
            "cors_rule": [],
            "force_destroy": false,
            "grant": [],
            "lifecycle_rule": [],
            "logging": [],
            "object_lock_configuration": [],
            "policy": "    {\n    \"Id\": \"BucketPolicy\",\n    \"Version\": \"2012-10-17\",\n    \"Statement\": [\n        {\n        \"Sid\": \"AllAccess\",\n        \"Action\": \"s3:List*\",\n        \"Effect\": \"Allow\",\n        \"Resource\": [\n            \"arn:aws:s3:::allowlist-inline-policy\"\n        ],\n        \"Principal\": \"*\"\n        }\n    ]\n    }\n",
            "replication_configuration": [],
            "server_side_encryption_configuration": [],
            "tags": null,
            "website": []
          },
          "after_unknown": {
            "acceleration_status": true,
            "arn": true,
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
          "before_sensitive": false,
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
          }
        }
      },
      {
        "address": "aws_s3_bucket.denylist-external-policy",
        "mode": "managed",
        "type": "aws_s3_bucket",
        "name": "denylist-external-policy",
        "provider_name": "registry.terraform.io/hashicorp/aws",
        "change": {
          "actions": ["create"],
          "before": null,
          "after": {
            "acl": "private",
            "bucket": "denylist-external-policy",
            "bucket_prefix": null,
            "cors_rule": [],
            "force_destroy": false,
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
          "before_sensitive": false,
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
          }
        }
      },
      {
        "address": "aws_s3_bucket.denylist-inline-policy",
        "mode": "managed",
        "type": "aws_s3_bucket",
        "name": "denylist-inline-policy",
        "provider_name": "registry.terraform.io/hashicorp/aws",
        "change": {
          "actions": ["create"],
          "before": null,
          "after": {
            "acl": "private",
            "bucket": "denylist-inline-policy",
            "bucket_prefix": null,
            "cors_rule": [],
            "force_destroy": false,
            "grant": [],
            "lifecycle_rule": [],
            "logging": [],
            "object_lock_configuration": [],
            "policy": "    {\n    \"Id\": \"BucketPolicy\",\n    \"Version\": \"2012-10-17\",\n    \"Statement\": [\n        {\n        \"Sid\": \"AllAccess\",\n        \"Action\": \"s3:List*\",\n        \"Effect\": \"Deny\",\n        \"Resource\": [\n            \"arn:aws:s3:::denylist-inline-policy\"\n        ],\n        \"Principal\": \"*\"\n        }\n    ]\n    }\n",
            "replication_configuration": [],
            "server_side_encryption_configuration": [],
            "tags": null,
            "website": []
          },
          "after_unknown": {
            "acceleration_status": true,
            "arn": true,
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
          "before_sensitive": false,
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
          }
        }
      },
      {
        "address": "aws_s3_bucket.nopolicy-bucket",
        "mode": "managed",
        "type": "aws_s3_bucket",
        "name": "nopolicy-bucket",
        "provider_name": "registry.terraform.io/hashicorp/aws",
        "change": {
          "actions": ["create"],
          "before": null,
          "after": {
            "acl": "private",
            "bucket": "nopolicy-bucket",
            "bucket_prefix": null,
            "cors_rule": [],
            "force_destroy": false,
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
          "before_sensitive": false,
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
          }
        }
      },
      {
        "address": "aws_s3_bucket_policy.allowget-policy",
        "mode": "managed",
        "type": "aws_s3_bucket_policy",
        "name": "allowget-policy",
        "provider_name": "registry.terraform.io/hashicorp/aws",
        "change": {
          "actions": ["create"],
          "before": null,
          "after": {
            "policy": "{\"Id\":\"BucketPolicy\",\"Statement\":[{\"Action\":\"*\",\"Effect\":\"Allow\",\"Principal\":{\"AWS\":\"*\"},\"Resource\":[\"arn:aws:s3:::allowget-external-policy\"],\"Sid\":\"AllAccess\"}],\"Version\":\"2012-10-17\"}"
          },
          "after_unknown": { "bucket": true, "id": true },
          "before_sensitive": false,
          "after_sensitive": {}
        }
      },
      {
        "address": "aws_s3_bucket_policy.allowlist-policy",
        "mode": "managed",
        "type": "aws_s3_bucket_policy",
        "name": "allowlist-policy",
        "provider_name": "registry.terraform.io/hashicorp/aws",
        "change": {
          "actions": ["create"],
          "before": null,
          "after": {
            "policy": "{\"Id\":\"BucketPolicy\",\"Statement\":[{\"Action\":\"s3:ListBucket\",\"Effect\":\"Allow\",\"Principal\":\"*\",\"Resource\":[\"arn:aws:s3:::allowlist-external-policy\"],\"Sid\":\"AllAccess\"}],\"Version\":\"2012-10-17\"}"
          },
          "after_unknown": { "bucket": true, "id": true },
          "before_sensitive": false,
          "after_sensitive": {}
        }
      },
      {
        "address": "aws_s3_bucket_policy.denylist-policy",
        "mode": "managed",
        "type": "aws_s3_bucket_policy",
        "name": "denylist-policy",
        "provider_name": "registry.terraform.io/hashicorp/aws",
        "change": {
          "actions": ["create"],
          "before": null,
          "after": {
            "policy": "{\"Id\":\"BucketPolicy\",\"Statement\":[{\"Action\":\"*\",\"Effect\":\"Deny\",\"Principal\":\"*\",\"Resource\":[\"arn:aws:s3:::denylist-external-policy\"],\"Sid\":\"AllAccess\"}],\"Version\":\"2012-10-17\"}"
          },
          "after_unknown": { "bucket": true, "id": true },
          "before_sensitive": false,
          "after_sensitive": {}
        }
      }
    ],
    "configuration": {
      "provider_config": {
        "aws": {
          "name": "aws",
          "expressions": {
            "region": { "constant_value": "us-east-1" }
          }
        }
      },
      "root_module": {
        "resources": [
          {
            "address": "aws_s3_bucket.allowget-external-policy",
            "mode": "managed",
            "type": "aws_s3_bucket",
            "name": "allowget-external-policy",
            "provider_config_key": "aws",
            "expressions": {
              "bucket": { "constant_value": "allowget-external-policy" }
            },
            "schema_version": 0
          },
          {
            "address": "aws_s3_bucket.allowget-inline-policy",
            "mode": "managed",
            "type": "aws_s3_bucket",
            "name": "allowget-inline-policy",
            "provider_config_key": "aws",
            "expressions": {
              "bucket": { "constant_value": "allowget-inline-policy" },
              "policy": {
                "constant_value": "    {\n    \"Id\": \"BucketPolicy\",\n    \"Version\": \"2012-10-17\",\n    \"Statement\": [\n        {\n        \"Sid\": \"AllAccess\",\n        \"Action\": \"s3:GetBucket\",\n        \"Effect\": \"Allow\",\n        \"Resource\": [\n            \"arn:aws:s3:::allowget-inline-policy\"\n        ],\n        \"Principal\": \"*\"\n        }\n    ]\n    }\n"
              }
            },
            "schema_version": 0
          },
          {
            "address": "aws_s3_bucket.allowlist-external-policy",
            "mode": "managed",
            "type": "aws_s3_bucket",
            "name": "allowlist-external-policy",
            "provider_config_key": "aws",
            "expressions": {
              "bucket": { "constant_value": "allowlist-external-policy" }
            },
            "schema_version": 0
          },
          {
            "address": "aws_s3_bucket.allowlist-inline-policy",
            "mode": "managed",
            "type": "aws_s3_bucket",
            "name": "allowlist-inline-policy",
            "provider_config_key": "aws",
            "expressions": {
              "bucket": { "constant_value": "allowlist-inline-policy" },
              "policy": {
                "constant_value": "    {\n    \"Id\": \"BucketPolicy\",\n    \"Version\": \"2012-10-17\",\n    \"Statement\": [\n        {\n        \"Sid\": \"AllAccess\",\n        \"Action\": \"s3:List*\",\n        \"Effect\": \"Allow\",\n        \"Resource\": [\n            \"arn:aws:s3:::allowlist-inline-policy\"\n        ],\n        \"Principal\": \"*\"\n        }\n    ]\n    }\n"
              }
            },
            "schema_version": 0
          },
          {
            "address": "aws_s3_bucket.denylist-external-policy",
            "mode": "managed",
            "type": "aws_s3_bucket",
            "name": "denylist-external-policy",
            "provider_config_key": "aws",
            "expressions": {
              "bucket": { "constant_value": "denylist-external-policy" }
            },
            "schema_version": 0
          },
          {
            "address": "aws_s3_bucket.denylist-inline-policy",
            "mode": "managed",
            "type": "aws_s3_bucket",
            "name": "denylist-inline-policy",
            "provider_config_key": "aws",
            "expressions": {
              "bucket": { "constant_value": "denylist-inline-policy" },
              "policy": {
                "constant_value": "    {\n    \"Id\": \"BucketPolicy\",\n    \"Version\": \"2012-10-17\",\n    \"Statement\": [\n        {\n        \"Sid\": \"AllAccess\",\n        \"Action\": \"s3:List*\",\n        \"Effect\": \"Deny\",\n        \"Resource\": [\n            \"arn:aws:s3:::denylist-inline-policy\"\n        ],\n        \"Principal\": \"*\"\n        }\n    ]\n    }\n"
              }
            },
            "schema_version": 0
          },
          {
            "address": "aws_s3_bucket.nopolicy-bucket",
            "mode": "managed",
            "type": "aws_s3_bucket",
            "name": "nopolicy-bucket",
            "provider_config_key": "aws",
            "expressions": { "bucket": { "constant_value": "nopolicy-bucket" } },
            "schema_version": 0
          },
          {
            "address": "aws_s3_bucket_policy.allowget-policy",
            "mode": "managed",
            "type": "aws_s3_bucket_policy",
            "name": "allowget-policy",
            "provider_config_key": "aws",
            "expressions": {
              "bucket": {
                "references": [
                  "aws_s3_bucket.allowget-external-policy.id",
                  "aws_s3_bucket.allowget-external-policy"
                ]
              },
              "policy": {}
            },
            "schema_version": 0
          },
          {
            "address": "aws_s3_bucket_policy.allowlist-policy",
            "mode": "managed",
            "type": "aws_s3_bucket_policy",
            "name": "allowlist-policy",
            "provider_config_key": "aws",
            "expressions": {
              "bucket": {
                "references": [
                  "aws_s3_bucket.allowlist-external-policy.id",
                  "aws_s3_bucket.allowlist-external-policy"
                ]
              },
              "policy": {}
            },
            "schema_version": 0
          },
          {
            "address": "aws_s3_bucket_policy.denylist-policy",
            "mode": "managed",
            "type": "aws_s3_bucket_policy",
            "name": "denylist-policy",
            "provider_config_key": "aws",
            "expressions": {
              "bucket": {
                "references": [
                  "aws_s3_bucket.denylist-external-policy.id",
                  "aws_s3_bucket.denylist-external-policy"
                ]
              },
              "policy": {}
            },
            "schema_version": 0
          }
        ]
      }
    }
  }
  