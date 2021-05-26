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
package tests.lib.inputs.resource_view_01_infra_json

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
            }
          },
          "mode": "managed",
          "name": "example",
          "provider_config_key": "aws",
          "schema_version": 0,
          "type": "aws_s3_bucket"
        },
        {
          "address": "aws_s3_bucket_policy.example",
          "expressions": {
            "bucket": {
              "references": [
                "aws_s3_bucket.example"
              ]
            },
            "policy": {
              "references": [
                "data.aws_iam_policy_document.example"
              ]
            }
          },
          "mode": "managed",
          "name": "example",
          "provider_config_key": "aws",
          "schema_version": 0,
          "type": "aws_s3_bucket_policy"
        },
        {
          "address": "data.aws_iam_policy_document.example",
          "expressions": {
            "statement": [
              {
                "actions": {
                  "constant_value": [
                    "s3:*"
                  ]
                },
                "effect": {
                  "constant_value": "Allow"
                },
                "principals": [
                  {
                    "identifiers": {
                      "constant_value": [
                        "*"
                      ]
                    },
                    "type": {
                      "constant_value": "*"
                    }
                  }
                ],
                "resources": {
                  "references": [
                    "aws_s3_bucket.example"
                  ]
                }
              }
            ]
          },
          "mode": "data",
          "name": "example",
          "provider_config_key": "aws",
          "schema_version": 0,
          "type": "aws_iam_policy_document"
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
            "acl": "private",
            "bucket_prefix": "example",
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
          }
        },
        {
          "address": "aws_s3_bucket_policy.example",
          "mode": "managed",
          "name": "example",
          "provider_name": "registry.terraform.io/hashicorp/aws",
          "schema_version": 0,
          "type": "aws_s3_bucket_policy"
        },
        {
          "address": "data.aws_iam_policy_document.example",
          "mode": "data",
          "name": "example",
          "provider_name": "registry.terraform.io/hashicorp/aws",
          "schema_version": 0,
          "type": "aws_iam_policy_document",
          "values": {
            "override_json": null,
            "override_policy_documents": null,
            "policy_id": null,
            "source_json": null,
            "source_policy_documents": null,
            "statement": [
              {
                "actions": [
                  "s3:*"
                ],
                "condition": [],
                "effect": "Allow",
                "not_actions": null,
                "not_principals": [],
                "not_resources": null,
                "principals": [
                  {
                    "identifiers": [
                      "*"
                    ],
                    "type": "*"
                  }
                ],
                "resources": [],
                "sid": null
              }
            ],
            "version": null
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
          "acl": "private",
          "bucket_prefix": "example",
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
      "name": "example",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_s3_bucket"
    },
    {
      "address": "aws_s3_bucket_policy.example",
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
      "name": "example",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_s3_bucket_policy"
    },
    {
      "address": "data.aws_iam_policy_document.example",
      "change": {
        "actions": [
          "read"
        ],
        "after": {
          "override_json": null,
          "override_policy_documents": null,
          "policy_id": null,
          "source_json": null,
          "source_policy_documents": null,
          "statement": [
            {
              "actions": [
                "s3:*"
              ],
              "condition": [],
              "effect": "Allow",
              "not_actions": null,
              "not_principals": [],
              "not_resources": null,
              "principals": [
                {
                  "identifiers": [
                    "*"
                  ],
                  "type": "*"
                }
              ],
              "resources": [],
              "sid": null
            }
          ],
          "version": null
        },
        "after_unknown": {
          "id": true,
          "json": true,
          "statement": [
            {
              "actions": [
                false
              ],
              "condition": [],
              "not_principals": [],
              "principals": [
                {
                  "identifiers": [
                    false
                  ]
                }
              ],
              "resources": [
                true
              ]
            }
          ]
        },
        "before": null
      },
      "mode": "data",
      "name": "example",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_iam_policy_document"
    }
  ],
  "terraform_version": "0.13.5"
}

