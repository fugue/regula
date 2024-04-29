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
package tests.rules.tf.aws.s3.inputs.versioning_lifecycle_enabled_infra_json

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
          "address": "aws_s3_bucket.allow_attached_resource_versioning",
          "expressions": {
            "bucket": {
              "constant_value": "allow-attached-resource-versioning"
            }
          },
          "mode": "managed",
          "name": "allow_attached_resource_versioning",
          "provider_config_key": "aws",
          "schema_version": 0,
          "type": "aws_s3_bucket"
        },
        {
          "address": "aws_s3_bucket.allow_inline_versioning_and_lifecycle",
          "expressions": {
            "bucket": {
              "constant_value": "allow-directly-attached-versioning"
            },
            "lifecycle_rule": [
              {
                "enabled": {
                  "constant_value": true
                },
                "expiration": [
                  {
                    "days": {
                      "constant_value": 30
                    }
                  }
                ],
                "transition": [
                  {
                    "days": {
                      "constant_value": 90
                    },
                    "storage_class": {
                      "constant_value": "GLACIER"
                    }
                  },
                  {
                    "days": {
                      "constant_value": 180
                    },
                    "storage_class": {
                      "constant_value": "DEEP_ARCHIVE"
                    }
                  }
                ]
              }
            ],
            "versioning": [
              {
                "enabled": {
                  "constant_value": true
                }
              }
            ]
          },
          "mode": "managed",
          "name": "allow_inline_versioning_and_lifecycle",
          "provider_config_key": "aws",
          "schema_version": 0,
          "type": "aws_s3_bucket"
        },
        {
          "address": "aws_s3_bucket.deny_no_lifecycle",
          "expressions": {
            "bucket": {
              "constant_value": "allow-directly-attached-lifecycle"
            }
          },
          "mode": "managed",
          "name": "deny_no_lifecycle",
          "provider_config_key": "aws",
          "schema_version": 0,
          "type": "aws_s3_bucket"
        },
        {
          "address": "aws_s3_bucket.deny_no_versioning",
          "expressions": {
            "bucket": {
              "constant_value": "allow-directly-attached-versioning"
            }
          },
          "mode": "managed",
          "name": "deny_no_versioning",
          "provider_config_key": "aws",
          "schema_version": 0,
          "type": "aws_s3_bucket"
        },
        {
          "address": "aws_s3_bucket.deny_no_versioning_or_lifecycle",
          "expressions": {
            "bucket": {
              "constant_value": "allow-directly-attached-versioning-or-lifecycle"
            }
          },
          "mode": "managed",
          "name": "deny_no_versioning_or_lifecycle",
          "provider_config_key": "aws",
          "schema_version": 0,
          "type": "aws_s3_bucket"
        },
        {
          "address": "aws_s3_bucket_lifecycle_configuration.allow_attached_resource_versioning",
          "expressions": {
            "bucket": {
              "references": [
                "aws_s3_bucket.allow_attached_resource_versioning.id",
                "aws_s3_bucket.allow_attached_resource_versioning"
              ]
            },
            "rule": [
              {
                "abort_incomplete_multipart_upload": [
                  {
                    "days_after_initiation": {
                      "constant_value": 1
                    }
                  }
                ],
                "expiration": [
                  {
                    "days": {
                      "constant_value": 7
                    }
                  }
                ],
                "id": {
                  "constant_value": "Delete seven days old"
                },
                "noncurrent_version_expiration": [
                  {
                    "noncurrent_days": {
                      "constant_value": 7
                    }
                  }
                ],
                "status": {
                  "constant_value": "Enabled"
                }
              },
              {
                "expiration": [
                  {
                    "expired_object_delete_marker": {
                      "constant_value": true
                    }
                  }
                ],
                "id": {
                  "constant_value": "Delete expired"
                },
                "status": {
                  "constant_value": "Enabled"
                }
              }
            ]
          },
          "mode": "managed",
          "name": "allow_attached_resource_versioning",
          "provider_config_key": "aws",
          "schema_version": 0,
          "type": "aws_s3_bucket_lifecycle_configuration"
        },
        {
          "address": "aws_s3_bucket_versioning.allow_attached_resource_versioning",
          "expressions": {
            "bucket": {
              "references": [
                "aws_s3_bucket.allow_attached_resource_versioning.id",
                "aws_s3_bucket.allow_attached_resource_versioning"
              ]
            },
            "versioning_configuration": [
              {
                "status": {
                  "constant_value": "Enabled"
                }
              }
            ]
          },
          "mode": "managed",
          "name": "allow_attached_resource_versioning",
          "provider_config_key": "aws",
          "schema_version": 0,
          "type": "aws_s3_bucket_versioning"
        }
      ]
    }
  },
  "format_version": "1.2",
  "planned_values": {
    "root_module": {
      "resources": [
        {
          "address": "aws_s3_bucket.allow_attached_resource_versioning",
          "mode": "managed",
          "name": "allow_attached_resource_versioning",
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
            "bucket": "allow-attached-resource-versioning",
            "force_destroy": false,
            "tags": null,
            "timeouts": null
          }
        },
        {
          "address": "aws_s3_bucket.allow_inline_versioning_and_lifecycle",
          "mode": "managed",
          "name": "allow_inline_versioning_and_lifecycle",
          "provider_name": "registry.terraform.io/hashicorp/aws",
          "schema_version": 0,
          "sensitive_values": {
            "cors_rule": [],
            "grant": [],
            "lifecycle_rule": [
              {
                "expiration": [
                  {}
                ],
                "noncurrent_version_expiration": [],
                "noncurrent_version_transition": [],
                "transition": [
                  {},
                  {}
                ]
              }
            ],
            "logging": [],
            "object_lock_configuration": [],
            "replication_configuration": [],
            "server_side_encryption_configuration": [],
            "tags_all": {},
            "versioning": [
              {}
            ],
            "website": []
          },
          "type": "aws_s3_bucket",
          "values": {
            "bucket": "allow-directly-attached-versioning",
            "force_destroy": false,
            "lifecycle_rule": [
              {
                "abort_incomplete_multipart_upload_days": null,
                "enabled": true,
                "expiration": [
                  {
                    "date": null,
                    "days": 30,
                    "expired_object_delete_marker": null
                  }
                ],
                "noncurrent_version_expiration": [],
                "noncurrent_version_transition": [],
                "prefix": null,
                "tags": null,
                "transition": [
                  {
                    "date": "",
                    "days": 180,
                    "storage_class": "DEEP_ARCHIVE"
                  },
                  {
                    "date": "",
                    "days": 90,
                    "storage_class": "GLACIER"
                  }
                ]
              }
            ],
            "tags": null,
            "timeouts": null,
            "versioning": [
              {
                "enabled": true,
                "mfa_delete": false
              }
            ]
          }
        },
        {
          "address": "aws_s3_bucket.deny_no_lifecycle",
          "mode": "managed",
          "name": "deny_no_lifecycle",
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
            "bucket": "allow-directly-attached-lifecycle",
            "force_destroy": false,
            "tags": null,
            "timeouts": null
          }
        },
        {
          "address": "aws_s3_bucket.deny_no_versioning",
          "mode": "managed",
          "name": "deny_no_versioning",
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
            "bucket": "allow-directly-attached-versioning",
            "force_destroy": false,
            "tags": null,
            "timeouts": null
          }
        },
        {
          "address": "aws_s3_bucket.deny_no_versioning_or_lifecycle",
          "mode": "managed",
          "name": "deny_no_versioning_or_lifecycle",
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
            "bucket": "allow-directly-attached-versioning-or-lifecycle",
            "force_destroy": false,
            "tags": null,
            "timeouts": null
          }
        },
        {
          "address": "aws_s3_bucket_lifecycle_configuration.allow_attached_resource_versioning",
          "mode": "managed",
          "name": "allow_attached_resource_versioning",
          "provider_name": "registry.terraform.io/hashicorp/aws",
          "schema_version": 0,
          "sensitive_values": {
            "rule": [
              {
                "abort_incomplete_multipart_upload": [
                  {}
                ],
                "expiration": [
                  {}
                ],
                "filter": [],
                "noncurrent_version_expiration": [
                  {}
                ],
                "noncurrent_version_transition": [],
                "transition": []
              },
              {
                "abort_incomplete_multipart_upload": [],
                "expiration": [
                  {}
                ],
                "filter": [],
                "noncurrent_version_expiration": [],
                "noncurrent_version_transition": [],
                "transition": []
              }
            ]
          },
          "type": "aws_s3_bucket_lifecycle_configuration",
          "values": {
            "expected_bucket_owner": null,
            "rule": [
              {
                "abort_incomplete_multipart_upload": [
                  {
                    "days_after_initiation": 1
                  }
                ],
                "expiration": [
                  {
                    "date": null,
                    "days": 7
                  }
                ],
                "filter": [],
                "id": "Delete seven days old",
                "noncurrent_version_expiration": [
                  {
                    "newer_noncurrent_versions": null,
                    "noncurrent_days": 7
                  }
                ],
                "noncurrent_version_transition": [],
                "prefix": null,
                "status": "Enabled",
                "transition": []
              },
              {
                "abort_incomplete_multipart_upload": [],
                "expiration": [
                  {
                    "date": null,
                    "days": 0,
                    "expired_object_delete_marker": true
                  }
                ],
                "filter": [],
                "id": "Delete expired",
                "noncurrent_version_expiration": [],
                "noncurrent_version_transition": [],
                "prefix": null,
                "status": "Enabled",
                "transition": []
              }
            ],
            "timeouts": null
          }
        },
        {
          "address": "aws_s3_bucket_versioning.allow_attached_resource_versioning",
          "mode": "managed",
          "name": "allow_attached_resource_versioning",
          "provider_name": "registry.terraform.io/hashicorp/aws",
          "schema_version": 0,
          "sensitive_values": {
            "versioning_configuration": [
              {}
            ]
          },
          "type": "aws_s3_bucket_versioning",
          "values": {
            "expected_bucket_owner": null,
            "mfa": null,
            "versioning_configuration": [
              {
                "status": "Enabled"
              }
            ]
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
      "resource": "aws_s3_bucket.allow_attached_resource_versioning"
    }
  ],
  "resource_changes": [
    {
      "address": "aws_s3_bucket.allow_attached_resource_versioning",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "bucket": "allow-attached-resource-versioning",
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
      "name": "allow_attached_resource_versioning",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_s3_bucket"
    },
    {
      "address": "aws_s3_bucket.allow_inline_versioning_and_lifecycle",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "bucket": "allow-directly-attached-versioning",
          "force_destroy": false,
          "lifecycle_rule": [
            {
              "abort_incomplete_multipart_upload_days": null,
              "enabled": true,
              "expiration": [
                {
                  "date": null,
                  "days": 30,
                  "expired_object_delete_marker": null
                }
              ],
              "noncurrent_version_expiration": [],
              "noncurrent_version_transition": [],
              "prefix": null,
              "tags": null,
              "transition": [
                {
                  "date": "",
                  "days": 180,
                  "storage_class": "DEEP_ARCHIVE"
                },
                {
                  "date": "",
                  "days": 90,
                  "storage_class": "GLACIER"
                }
              ]
            }
          ],
          "tags": null,
          "timeouts": null,
          "versioning": [
            {
              "enabled": true,
              "mfa_delete": false
            }
          ]
        },
        "after_sensitive": {
          "cors_rule": [],
          "grant": [],
          "lifecycle_rule": [
            {
              "expiration": [
                {}
              ],
              "noncurrent_version_expiration": [],
              "noncurrent_version_transition": [],
              "transition": [
                {},
                {}
              ]
            }
          ],
          "logging": [],
          "object_lock_configuration": [],
          "replication_configuration": [],
          "server_side_encryption_configuration": [],
          "tags_all": {},
          "versioning": [
            {}
          ],
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
          "lifecycle_rule": [
            {
              "expiration": [
                {}
              ],
              "id": true,
              "noncurrent_version_expiration": [],
              "noncurrent_version_transition": [],
              "transition": [
                {},
                {}
              ]
            }
          ],
          "logging": true,
          "object_lock_configuration": true,
          "object_lock_enabled": true,
          "policy": true,
          "region": true,
          "replication_configuration": true,
          "request_payer": true,
          "server_side_encryption_configuration": true,
          "tags_all": true,
          "versioning": [
            {}
          ],
          "website": true,
          "website_domain": true,
          "website_endpoint": true
        },
        "before": null,
        "before_sensitive": false
      },
      "mode": "managed",
      "name": "allow_inline_versioning_and_lifecycle",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_s3_bucket"
    },
    {
      "address": "aws_s3_bucket.deny_no_lifecycle",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "bucket": "allow-directly-attached-lifecycle",
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
      "name": "deny_no_lifecycle",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_s3_bucket"
    },
    {
      "address": "aws_s3_bucket.deny_no_versioning",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "bucket": "allow-directly-attached-versioning",
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
      "name": "deny_no_versioning",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_s3_bucket"
    },
    {
      "address": "aws_s3_bucket.deny_no_versioning_or_lifecycle",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "bucket": "allow-directly-attached-versioning-or-lifecycle",
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
      "name": "deny_no_versioning_or_lifecycle",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_s3_bucket"
    },
    {
      "address": "aws_s3_bucket_lifecycle_configuration.allow_attached_resource_versioning",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "expected_bucket_owner": null,
          "rule": [
            {
              "abort_incomplete_multipart_upload": [
                {
                  "days_after_initiation": 1
                }
              ],
              "expiration": [
                {
                  "date": null,
                  "days": 7
                }
              ],
              "filter": [],
              "id": "Delete seven days old",
              "noncurrent_version_expiration": [
                {
                  "newer_noncurrent_versions": null,
                  "noncurrent_days": 7
                }
              ],
              "noncurrent_version_transition": [],
              "prefix": null,
              "status": "Enabled",
              "transition": []
            },
            {
              "abort_incomplete_multipart_upload": [],
              "expiration": [
                {
                  "date": null,
                  "days": 0,
                  "expired_object_delete_marker": true
                }
              ],
              "filter": [],
              "id": "Delete expired",
              "noncurrent_version_expiration": [],
              "noncurrent_version_transition": [],
              "prefix": null,
              "status": "Enabled",
              "transition": []
            }
          ],
          "timeouts": null
        },
        "after_sensitive": {
          "rule": [
            {
              "abort_incomplete_multipart_upload": [
                {}
              ],
              "expiration": [
                {}
              ],
              "filter": [],
              "noncurrent_version_expiration": [
                {}
              ],
              "noncurrent_version_transition": [],
              "transition": []
            },
            {
              "abort_incomplete_multipart_upload": [],
              "expiration": [
                {}
              ],
              "filter": [],
              "noncurrent_version_expiration": [],
              "noncurrent_version_transition": [],
              "transition": []
            }
          ]
        },
        "after_unknown": {
          "bucket": true,
          "id": true,
          "rule": [
            {
              "abort_incomplete_multipart_upload": [
                {}
              ],
              "expiration": [
                {
                  "expired_object_delete_marker": true
                }
              ],
              "filter": [],
              "noncurrent_version_expiration": [
                {}
              ],
              "noncurrent_version_transition": [],
              "transition": []
            },
            {
              "abort_incomplete_multipart_upload": [],
              "expiration": [
                {}
              ],
              "filter": [],
              "noncurrent_version_expiration": [],
              "noncurrent_version_transition": [],
              "transition": []
            }
          ]
        },
        "before": null,
        "before_sensitive": false
      },
      "mode": "managed",
      "name": "allow_attached_resource_versioning",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_s3_bucket_lifecycle_configuration"
    },
    {
      "address": "aws_s3_bucket_versioning.allow_attached_resource_versioning",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "expected_bucket_owner": null,
          "mfa": null,
          "versioning_configuration": [
            {
              "status": "Enabled"
            }
          ]
        },
        "after_sensitive": {
          "versioning_configuration": [
            {}
          ]
        },
        "after_unknown": {
          "bucket": true,
          "id": true,
          "versioning_configuration": [
            {
              "mfa_delete": true
            }
          ]
        },
        "before": null,
        "before_sensitive": false
      },
      "mode": "managed",
      "name": "allow_attached_resource_versioning",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_s3_bucket_versioning"
    }
  ],
  "terraform_version": "1.5.7",
  "timestamp": "2024-04-29T17:53:12Z"
}

