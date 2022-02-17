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
package tests.lib.inputs.resource_view_07_infra_json

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
        "name": "aws"
      }
    },
    "root_module": {
      "resources": [
        {
          "address": "aws_s3_bucket.example",
          "expressions": {
            "bucket_prefix": {
              "constant_value": "example"
            },
            "tags": {
              "constant_value": {
                "Stage": "Prod"
              }
            }
          },
          "mode": "managed",
          "name": "example",
          "provider_config_key": "aws",
          "schema_version": 0,
          "type": "aws_s3_bucket"
        }
      ]
    }
  },
  "format_version": "0.1",
  "planned_values": {
    "root_module": {
      "resources": [
        {
          "address": "aws_s3_bucket.example",
          "mode": "managed",
          "name": "example",
          "provider_name": "registry.terraform.io/hashicorp/aws",
          "schema_version": 0,
          "type": "aws_s3_bucket",
          "values": {
            "bucket_prefix": "example",
            "force_destroy": false,
            "tags": {
              "Stage": "Prod"
            },
            "tags_all": {
              "Stage": "Prod"
            }
          }
        }
      ]
    }
  },
  "resource_changes": [
    {
      "address": "aws_s3_bucket.example",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "bucket_prefix": "example",
          "force_destroy": false,
          "tags": {
            "Stage": "Prod"
          },
          "tags_all": {
            "Stage": "Prod"
          }
        },
        "after_unknown": {
          "acceleration_status": true,
          "acl": true,
          "arn": true,
          "bucket": true,
          "bucket_domain_name": true,
          "bucket_regional_domain_name": true,
          "cors_rule": true,
          "grant": true,
          "hosted_zone_id": true,
          "id": true,
          "lifecycle_rule": true,
          "logging": true,
          "object_lock_configuration": true,
          "policy": true,
          "region": true,
          "replication_configuration": true,
          "request_payer": true,
          "server_side_encryption_configuration": true,
          "tags": {},
          "tags_all": {},
          "versioning": true,
          "website": true,
          "website_domain": true,
          "website_endpoint": true
        },
        "before": null
      },
      "mode": "managed",
      "name": "example",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_s3_bucket"
    }
  ],
  "terraform_version": "0.13.7"
}

