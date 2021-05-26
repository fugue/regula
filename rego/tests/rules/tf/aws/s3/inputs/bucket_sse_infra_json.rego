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
package tests.rules.tf.aws.s3.inputs.bucket_sse_infra_json

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
          "address": "aws_kms_key.key",
          "mode": "managed",
          "name": "key",
          "provider_config_key": "aws",
          "schema_version": 0,
          "type": "aws_kms_key"
        },
        {
          "address": "aws_s3_bucket.aes_encrypted",
          "expressions": {
            "force_destroy": {
              "constant_value": true
            },
            "server_side_encryption_configuration": [
              {
                "rule": [
                  {
                    "apply_server_side_encryption_by_default": [
                      {
                        "sse_algorithm": {
                          "constant_value": "AES256"
                        }
                      }
                    ]
                  }
                ]
              }
            ]
          },
          "mode": "managed",
          "name": "aes_encrypted",
          "provider_config_key": "aws",
          "schema_version": 0,
          "type": "aws_s3_bucket"
        },
        {
          "address": "aws_s3_bucket.kms_encrypted",
          "expressions": {
            "force_destroy": {
              "constant_value": true
            },
            "server_side_encryption_configuration": [
              {
                "rule": [
                  {
                    "apply_server_side_encryption_by_default": [
                      {
                        "kms_master_key_id": {
                          "references": [
                            "aws_kms_key.key"
                          ]
                        },
                        "sse_algorithm": {
                          "constant_value": "aws:kms"
                        }
                      }
                    ]
                  }
                ]
              }
            ]
          },
          "mode": "managed",
          "name": "kms_encrypted",
          "provider_config_key": "aws",
          "schema_version": 0,
          "type": "aws_s3_bucket"
        },
        {
          "address": "aws_s3_bucket.unencrypted",
          "expressions": {
            "force_destroy": {
              "constant_value": true
            }
          },
          "mode": "managed",
          "name": "unencrypted",
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
          "address": "aws_kms_key.key",
          "mode": "managed",
          "name": "key",
          "provider_name": "registry.terraform.io/hashicorp/aws",
          "schema_version": 0,
          "type": "aws_kms_key",
          "values": {
            "customer_master_key_spec": "SYMMETRIC_DEFAULT",
            "deletion_window_in_days": null,
            "enable_key_rotation": false,
            "is_enabled": true,
            "key_usage": "ENCRYPT_DECRYPT",
            "tags": null
          }
        },
        {
          "address": "aws_s3_bucket.aes_encrypted",
          "mode": "managed",
          "name": "aes_encrypted",
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
            "server_side_encryption_configuration": [
              {
                "rule": [
                  {
                    "apply_server_side_encryption_by_default": [
                      {
                        "kms_master_key_id": null,
                        "sse_algorithm": "AES256"
                      }
                    ],
                    "bucket_key_enabled": null
                  }
                ]
              }
            ],
            "tags": null,
            "website": []
          }
        },
        {
          "address": "aws_s3_bucket.kms_encrypted",
          "mode": "managed",
          "name": "kms_encrypted",
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
            "server_side_encryption_configuration": [
              {
                "rule": [
                  {
                    "apply_server_side_encryption_by_default": [
                      {
                        "sse_algorithm": "aws:kms"
                      }
                    ],
                    "bucket_key_enabled": null
                  }
                ]
              }
            ],
            "tags": null,
            "website": []
          }
        },
        {
          "address": "aws_s3_bucket.unencrypted",
          "mode": "managed",
          "name": "unencrypted",
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
        }
      ]
    }
  },
  "resource_changes": [
    {
      "address": "aws_kms_key.key",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "customer_master_key_spec": "SYMMETRIC_DEFAULT",
          "deletion_window_in_days": null,
          "enable_key_rotation": false,
          "is_enabled": true,
          "key_usage": "ENCRYPT_DECRYPT",
          "tags": null
        },
        "after_unknown": {
          "arn": true,
          "description": true,
          "id": true,
          "key_id": true,
          "policy": true,
          "tags_all": true
        },
        "before": null
      },
      "mode": "managed",
      "name": "key",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_kms_key"
    },
    {
      "address": "aws_s3_bucket.aes_encrypted",
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
          "server_side_encryption_configuration": [
            {
              "rule": [
                {
                  "apply_server_side_encryption_by_default": [
                    {
                      "kms_master_key_id": null,
                      "sse_algorithm": "AES256"
                    }
                  ],
                  "bucket_key_enabled": null
                }
              ]
            }
          ],
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
          "server_side_encryption_configuration": [
            {
              "rule": [
                {
                  "apply_server_side_encryption_by_default": [
                    {}
                  ]
                }
              ]
            }
          ],
          "tags_all": true,
          "versioning": true,
          "website": [],
          "website_domain": true,
          "website_endpoint": true
        },
        "before": null
      },
      "mode": "managed",
      "name": "aes_encrypted",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_s3_bucket"
    },
    {
      "address": "aws_s3_bucket.kms_encrypted",
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
          "server_side_encryption_configuration": [
            {
              "rule": [
                {
                  "apply_server_side_encryption_by_default": [
                    {
                      "sse_algorithm": "aws:kms"
                    }
                  ],
                  "bucket_key_enabled": null
                }
              ]
            }
          ],
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
          "server_side_encryption_configuration": [
            {
              "rule": [
                {
                  "apply_server_side_encryption_by_default": [
                    {
                      "kms_master_key_id": true
                    }
                  ]
                }
              ]
            }
          ],
          "tags_all": true,
          "versioning": true,
          "website": [],
          "website_domain": true,
          "website_endpoint": true
        },
        "before": null
      },
      "mode": "managed",
      "name": "kms_encrypted",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_s3_bucket"
    },
    {
      "address": "aws_s3_bucket.unencrypted",
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
      "name": "unencrypted",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_s3_bucket"
    }
  ],
  "terraform_version": "0.13.5"
}

