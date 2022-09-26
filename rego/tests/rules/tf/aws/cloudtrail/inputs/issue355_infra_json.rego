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
package tests.rules.tf.aws.cloudtrail.inputs.issue355_infra_json

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
      },
      "random": {
        "name": "random"
      }
    },
    "root_module": {
      "resources": [
        {
          "address": "aws_cloudtrail.cloudtrail",
          "expressions": {
            "include_global_service_events": {
              "constant_value": false
            },
            "name": {
              "references": [
                "random_id.cloudtrail.id",
                "random_id.cloudtrail"
              ]
            },
            "s3_bucket_name": {
              "references": [
                "aws_s3_bucket.cloudtrail.id",
                "aws_s3_bucket.cloudtrail"
              ]
            },
            "s3_key_prefix": {
              "constant_value": "prefix"
            }
          },
          "mode": "managed",
          "name": "cloudtrail",
          "provider_config_key": "aws",
          "schema_version": 0,
          "type": "aws_cloudtrail"
        },
        {
          "address": "aws_s3_bucket.cloudtrail",
          "expressions": {
            "force_destroy": {
              "constant_value": true
            }
          },
          "mode": "managed",
          "name": "cloudtrail",
          "provider_config_key": "aws",
          "schema_version": 0,
          "type": "aws_s3_bucket"
        },
        {
          "address": "aws_s3_bucket.logging",
          "expressions": {
            "acl": {
              "constant_value": "log-delivery-write"
            },
            "force_destroy": {
              "constant_value": true
            }
          },
          "mode": "managed",
          "name": "logging",
          "provider_config_key": "aws",
          "schema_version": 0,
          "type": "aws_s3_bucket"
        },
        {
          "address": "aws_s3_bucket_logging.cloudtrail",
          "expressions": {
            "bucket": {
              "references": [
                "aws_s3_bucket.cloudtrail.id",
                "aws_s3_bucket.cloudtrail"
              ]
            },
            "target_bucket": {
              "references": [
                "aws_s3_bucket.logging.id",
                "aws_s3_bucket.logging"
              ]
            },
            "target_prefix": {
              "constant_value": "log/"
            }
          },
          "mode": "managed",
          "name": "cloudtrail",
          "provider_config_key": "aws",
          "schema_version": 0,
          "type": "aws_s3_bucket_logging"
        },
        {
          "address": "aws_s3_bucket_policy.cloudtrail",
          "expressions": {
            "bucket": {
              "references": [
                "aws_s3_bucket.cloudtrail.id",
                "aws_s3_bucket.cloudtrail"
              ]
            },
            "policy": {
              "references": [
                "aws_s3_bucket.cloudtrail.arn",
                "aws_s3_bucket.cloudtrail",
                "aws_s3_bucket.cloudtrail.arn",
                "aws_s3_bucket.cloudtrail"
              ]
            }
          },
          "mode": "managed",
          "name": "cloudtrail",
          "provider_config_key": "aws",
          "schema_version": 0,
          "type": "aws_s3_bucket_policy"
        },
        {
          "address": "random_id.cloudtrail",
          "expressions": {
            "byte_length": {
              "constant_value": 8
            }
          },
          "mode": "managed",
          "name": "cloudtrail",
          "provider_config_key": "random",
          "schema_version": 0,
          "type": "random_id"
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
  "format_version": "1.0",
  "planned_values": {
    "root_module": {
      "resources": [
        {
          "address": "aws_cloudtrail.cloudtrail",
          "mode": "managed",
          "name": "cloudtrail",
          "provider_name": "registry.terraform.io/hashicorp/aws",
          "schema_version": 0,
          "sensitive_values": {
            "advanced_event_selector": [],
            "event_selector": [],
            "insight_selector": [],
            "tags": {},
            "tags_all": {}
          },
          "type": "aws_cloudtrail",
          "values": {
            "advanced_event_selector": [],
            "arn": "arn:aws:cloudtrail:us-east-2:622401240280:trail/EWV8SPL3cVc",
            "cloud_watch_logs_group_arn": "",
            "cloud_watch_logs_role_arn": "",
            "enable_log_file_validation": false,
            "enable_logging": true,
            "event_selector": [],
            "home_region": "us-east-2",
            "id": "EWV8SPL3cVc",
            "include_global_service_events": false,
            "insight_selector": [],
            "is_multi_region_trail": false,
            "is_organization_trail": false,
            "kms_key_id": "",
            "name": "EWV8SPL3cVc",
            "s3_bucket_name": "terraform-20220923125358263500000001",
            "s3_key_prefix": "prefix",
            "sns_topic_name": "",
            "tags": {},
            "tags_all": {}
          }
        },
        {
          "address": "aws_s3_bucket.cloudtrail",
          "mode": "managed",
          "name": "cloudtrail",
          "provider_name": "registry.terraform.io/hashicorp/aws",
          "schema_version": 0,
          "sensitive_values": {
            "cors_rule": [],
            "grant": [
              {
                "permissions": [
                  false
                ]
              }
            ],
            "lifecycle_rule": [],
            "logging": [
              {}
            ],
            "object_lock_configuration": [],
            "replication_configuration": [],
            "server_side_encryption_configuration": [],
            "tags": {},
            "tags_all": {},
            "versioning": [
              {}
            ],
            "website": []
          },
          "type": "aws_s3_bucket",
          "values": {
            "acceleration_status": "",
            "acl": null,
            "arn": "arn:aws:s3:::terraform-20220923125358263500000001",
            "bucket": "terraform-20220923125358263500000001",
            "bucket_domain_name": "terraform-20220923125358263500000001.s3.amazonaws.com",
            "bucket_prefix": null,
            "bucket_regional_domain_name": "terraform-20220923125358263500000001.s3.us-east-2.amazonaws.com",
            "cors_rule": [],
            "force_destroy": true,
            "grant": [
              {
                "id": "d5c48f20001a6ee7be6d75e69fe2da57d4c273b03ac318bd3d5526018c47ecb5",
                "permissions": [
                  "FULL_CONTROL"
                ],
                "type": "CanonicalUser",
                "uri": ""
              }
            ],
            "hosted_zone_id": "Z2O1EMRO9K5GLX",
            "id": "terraform-20220923125358263500000001",
            "lifecycle_rule": [],
            "logging": [
              {
                "target_bucket": "terraform-20220923125358270800000002",
                "target_prefix": "log/"
              }
            ],
            "object_lock_configuration": [],
            "object_lock_enabled": false,
            "policy": "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Sid\":\"AWSCloudTrailAclCheck\",\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"cloudtrail.amazonaws.com\"},\"Action\":\"s3:GetBucketAcl\",\"Resource\":\"arn:aws:s3:::terraform-20220923125358263500000001\"},{\"Sid\":\"AWSCloudTrailWrite\",\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"cloudtrail.amazonaws.com\"},\"Action\":\"s3:PutObject\",\"Resource\":\"arn:aws:s3:::terraform-20220923125358263500000001/prefix/*\",\"Condition\":{\"StringEquals\":{\"s3:x-amz-acl\":\"bucket-owner-full-control\"}}}]}",
            "region": "us-east-2",
            "replication_configuration": [],
            "request_payer": "BucketOwner",
            "server_side_encryption_configuration": [],
            "tags": {},
            "tags_all": {},
            "timeouts": null,
            "versioning": [
              {
                "enabled": false,
                "mfa_delete": false
              }
            ],
            "website": [],
            "website_domain": null,
            "website_endpoint": null
          }
        },
        {
          "address": "aws_s3_bucket.logging",
          "mode": "managed",
          "name": "logging",
          "provider_name": "registry.terraform.io/hashicorp/aws",
          "schema_version": 0,
          "sensitive_values": {
            "cors_rule": [],
            "grant": [
              {
                "permissions": [
                  false,
                  false
                ]
              },
              {
                "permissions": [
                  false
                ]
              }
            ],
            "lifecycle_rule": [],
            "logging": [],
            "object_lock_configuration": [],
            "replication_configuration": [],
            "server_side_encryption_configuration": [],
            "tags": {},
            "tags_all": {},
            "versioning": [
              {}
            ],
            "website": []
          },
          "type": "aws_s3_bucket",
          "values": {
            "acceleration_status": "",
            "acl": "log-delivery-write",
            "arn": "arn:aws:s3:::terraform-20220923125358270800000002",
            "bucket": "terraform-20220923125358270800000002",
            "bucket_domain_name": "terraform-20220923125358270800000002.s3.amazonaws.com",
            "bucket_prefix": null,
            "bucket_regional_domain_name": "terraform-20220923125358270800000002.s3.us-east-2.amazonaws.com",
            "cors_rule": [],
            "force_destroy": true,
            "grant": [
              {
                "id": "",
                "permissions": [
                  "READ_ACP",
                  "WRITE"
                ],
                "type": "Group",
                "uri": "http://acs.amazonaws.com/groups/s3/LogDelivery"
              },
              {
                "id": "d5c48f20001a6ee7be6d75e69fe2da57d4c273b03ac318bd3d5526018c47ecb5",
                "permissions": [
                  "FULL_CONTROL"
                ],
                "type": "CanonicalUser",
                "uri": ""
              }
            ],
            "hosted_zone_id": "Z2O1EMRO9K5GLX",
            "id": "terraform-20220923125358270800000002",
            "lifecycle_rule": [],
            "logging": [],
            "object_lock_configuration": [],
            "object_lock_enabled": false,
            "policy": "",
            "region": "us-east-2",
            "replication_configuration": [],
            "request_payer": "BucketOwner",
            "server_side_encryption_configuration": [],
            "tags": {},
            "tags_all": {},
            "timeouts": null,
            "versioning": [
              {
                "enabled": false,
                "mfa_delete": false
              }
            ],
            "website": [],
            "website_domain": null,
            "website_endpoint": null
          }
        },
        {
          "address": "aws_s3_bucket_logging.cloudtrail",
          "mode": "managed",
          "name": "cloudtrail",
          "provider_name": "registry.terraform.io/hashicorp/aws",
          "schema_version": 0,
          "sensitive_values": {
            "target_grant": []
          },
          "type": "aws_s3_bucket_logging",
          "values": {
            "bucket": "terraform-20220923125358263500000001",
            "expected_bucket_owner": "",
            "id": "terraform-20220923125358263500000001",
            "target_bucket": "terraform-20220923125358270800000002",
            "target_grant": [],
            "target_prefix": "log/"
          }
        },
        {
          "address": "aws_s3_bucket_policy.cloudtrail",
          "mode": "managed",
          "name": "cloudtrail",
          "provider_name": "registry.terraform.io/hashicorp/aws",
          "schema_version": 0,
          "sensitive_values": {},
          "type": "aws_s3_bucket_policy",
          "values": {
            "bucket": "terraform-20220923125358263500000001",
            "id": "terraform-20220923125358263500000001",
            "policy": "{\"Statement\":[{\"Action\":\"s3:GetBucketAcl\",\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"cloudtrail.amazonaws.com\"},\"Resource\":\"arn:aws:s3:::terraform-20220923125358263500000001\",\"Sid\":\"AWSCloudTrailAclCheck\"},{\"Action\":\"s3:PutObject\",\"Condition\":{\"StringEquals\":{\"s3:x-amz-acl\":\"bucket-owner-full-control\"}},\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"cloudtrail.amazonaws.com\"},\"Resource\":\"arn:aws:s3:::terraform-20220923125358263500000001/prefix/*\",\"Sid\":\"AWSCloudTrailWrite\"}],\"Version\":\"2012-10-17\"}"
          }
        },
        {
          "address": "random_id.cloudtrail",
          "mode": "managed",
          "name": "cloudtrail",
          "provider_name": "registry.terraform.io/hashicorp/random",
          "schema_version": 0,
          "sensitive_values": {},
          "type": "random_id",
          "values": {
            "b64_std": "EWV8SPL3cVc=",
            "b64_url": "EWV8SPL3cVc",
            "byte_length": 8,
            "dec": "1253544724048343383",
            "hex": "11657c48f2f77157",
            "id": "EWV8SPL3cVc",
            "keepers": null,
            "prefix": null
          }
        }
      ]
    }
  },
  "prior_state": {
    "format_version": "1.0",
    "terraform_version": "1.1.9",
    "values": {
      "root_module": {
        "resources": [
          {
            "address": "aws_cloudtrail.cloudtrail",
            "depends_on": [
              "aws_s3_bucket.cloudtrail",
              "random_id.cloudtrail"
            ],
            "mode": "managed",
            "name": "cloudtrail",
            "provider_name": "registry.terraform.io/hashicorp/aws",
            "schema_version": 0,
            "sensitive_values": {
              "advanced_event_selector": [],
              "event_selector": [],
              "insight_selector": [],
              "tags": {},
              "tags_all": {}
            },
            "type": "aws_cloudtrail",
            "values": {
              "advanced_event_selector": [],
              "arn": "arn:aws:cloudtrail:us-east-2:622401240280:trail/EWV8SPL3cVc",
              "cloud_watch_logs_group_arn": "",
              "cloud_watch_logs_role_arn": "",
              "enable_log_file_validation": false,
              "enable_logging": true,
              "event_selector": [],
              "home_region": "us-east-2",
              "id": "EWV8SPL3cVc",
              "include_global_service_events": false,
              "insight_selector": [],
              "is_multi_region_trail": false,
              "is_organization_trail": false,
              "kms_key_id": "",
              "name": "EWV8SPL3cVc",
              "s3_bucket_name": "terraform-20220923125358263500000001",
              "s3_key_prefix": "prefix",
              "sns_topic_name": "",
              "tags": {},
              "tags_all": {}
            }
          },
          {
            "address": "aws_s3_bucket.cloudtrail",
            "mode": "managed",
            "name": "cloudtrail",
            "provider_name": "registry.terraform.io/hashicorp/aws",
            "schema_version": 0,
            "sensitive_values": {
              "cors_rule": [],
              "grant": [
                {
                  "permissions": [
                    false
                  ]
                }
              ],
              "lifecycle_rule": [],
              "logging": [
                {}
              ],
              "object_lock_configuration": [],
              "replication_configuration": [],
              "server_side_encryption_configuration": [],
              "tags": {},
              "tags_all": {},
              "versioning": [
                {}
              ],
              "website": []
            },
            "type": "aws_s3_bucket",
            "values": {
              "acceleration_status": "",
              "acl": null,
              "arn": "arn:aws:s3:::terraform-20220923125358263500000001",
              "bucket": "terraform-20220923125358263500000001",
              "bucket_domain_name": "terraform-20220923125358263500000001.s3.amazonaws.com",
              "bucket_prefix": null,
              "bucket_regional_domain_name": "terraform-20220923125358263500000001.s3.us-east-2.amazonaws.com",
              "cors_rule": [],
              "force_destroy": true,
              "grant": [
                {
                  "id": "d5c48f20001a6ee7be6d75e69fe2da57d4c273b03ac318bd3d5526018c47ecb5",
                  "permissions": [
                    "FULL_CONTROL"
                  ],
                  "type": "CanonicalUser",
                  "uri": ""
                }
              ],
              "hosted_zone_id": "Z2O1EMRO9K5GLX",
              "id": "terraform-20220923125358263500000001",
              "lifecycle_rule": [],
              "logging": [
                {
                  "target_bucket": "terraform-20220923125358270800000002",
                  "target_prefix": "log/"
                }
              ],
              "object_lock_configuration": [],
              "object_lock_enabled": false,
              "policy": "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Sid\":\"AWSCloudTrailAclCheck\",\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"cloudtrail.amazonaws.com\"},\"Action\":\"s3:GetBucketAcl\",\"Resource\":\"arn:aws:s3:::terraform-20220923125358263500000001\"},{\"Sid\":\"AWSCloudTrailWrite\",\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"cloudtrail.amazonaws.com\"},\"Action\":\"s3:PutObject\",\"Resource\":\"arn:aws:s3:::terraform-20220923125358263500000001/prefix/*\",\"Condition\":{\"StringEquals\":{\"s3:x-amz-acl\":\"bucket-owner-full-control\"}}}]}",
              "region": "us-east-2",
              "replication_configuration": [],
              "request_payer": "BucketOwner",
              "server_side_encryption_configuration": [],
              "tags": {},
              "tags_all": {},
              "timeouts": null,
              "versioning": [
                {
                  "enabled": false,
                  "mfa_delete": false
                }
              ],
              "website": [],
              "website_domain": null,
              "website_endpoint": null
            }
          },
          {
            "address": "aws_s3_bucket.logging",
            "mode": "managed",
            "name": "logging",
            "provider_name": "registry.terraform.io/hashicorp/aws",
            "schema_version": 0,
            "sensitive_values": {
              "cors_rule": [],
              "grant": [
                {
                  "permissions": [
                    false,
                    false
                  ]
                },
                {
                  "permissions": [
                    false
                  ]
                }
              ],
              "lifecycle_rule": [],
              "logging": [],
              "object_lock_configuration": [],
              "replication_configuration": [],
              "server_side_encryption_configuration": [],
              "tags": {},
              "tags_all": {},
              "versioning": [
                {}
              ],
              "website": []
            },
            "type": "aws_s3_bucket",
            "values": {
              "acceleration_status": "",
              "acl": "log-delivery-write",
              "arn": "arn:aws:s3:::terraform-20220923125358270800000002",
              "bucket": "terraform-20220923125358270800000002",
              "bucket_domain_name": "terraform-20220923125358270800000002.s3.amazonaws.com",
              "bucket_prefix": null,
              "bucket_regional_domain_name": "terraform-20220923125358270800000002.s3.us-east-2.amazonaws.com",
              "cors_rule": [],
              "force_destroy": true,
              "grant": [
                {
                  "id": "",
                  "permissions": [
                    "READ_ACP",
                    "WRITE"
                  ],
                  "type": "Group",
                  "uri": "http://acs.amazonaws.com/groups/s3/LogDelivery"
                },
                {
                  "id": "d5c48f20001a6ee7be6d75e69fe2da57d4c273b03ac318bd3d5526018c47ecb5",
                  "permissions": [
                    "FULL_CONTROL"
                  ],
                  "type": "CanonicalUser",
                  "uri": ""
                }
              ],
              "hosted_zone_id": "Z2O1EMRO9K5GLX",
              "id": "terraform-20220923125358270800000002",
              "lifecycle_rule": [],
              "logging": [],
              "object_lock_configuration": [],
              "object_lock_enabled": false,
              "policy": "",
              "region": "us-east-2",
              "replication_configuration": [],
              "request_payer": "BucketOwner",
              "server_side_encryption_configuration": [],
              "tags": {},
              "tags_all": {},
              "timeouts": null,
              "versioning": [
                {
                  "enabled": false,
                  "mfa_delete": false
                }
              ],
              "website": [],
              "website_domain": null,
              "website_endpoint": null
            }
          },
          {
            "address": "aws_s3_bucket_logging.cloudtrail",
            "depends_on": [
              "aws_s3_bucket.cloudtrail",
              "aws_s3_bucket.logging"
            ],
            "mode": "managed",
            "name": "cloudtrail",
            "provider_name": "registry.terraform.io/hashicorp/aws",
            "schema_version": 0,
            "sensitive_values": {
              "target_grant": []
            },
            "type": "aws_s3_bucket_logging",
            "values": {
              "bucket": "terraform-20220923125358263500000001",
              "expected_bucket_owner": "",
              "id": "terraform-20220923125358263500000001",
              "target_bucket": "terraform-20220923125358270800000002",
              "target_grant": [],
              "target_prefix": "log/"
            }
          },
          {
            "address": "aws_s3_bucket_policy.cloudtrail",
            "depends_on": [
              "aws_s3_bucket.cloudtrail"
            ],
            "mode": "managed",
            "name": "cloudtrail",
            "provider_name": "registry.terraform.io/hashicorp/aws",
            "schema_version": 0,
            "sensitive_values": {},
            "type": "aws_s3_bucket_policy",
            "values": {
              "bucket": "terraform-20220923125358263500000001",
              "id": "terraform-20220923125358263500000001",
              "policy": "{\"Statement\":[{\"Action\":\"s3:GetBucketAcl\",\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"cloudtrail.amazonaws.com\"},\"Resource\":\"arn:aws:s3:::terraform-20220923125358263500000001\",\"Sid\":\"AWSCloudTrailAclCheck\"},{\"Action\":\"s3:PutObject\",\"Condition\":{\"StringEquals\":{\"s3:x-amz-acl\":\"bucket-owner-full-control\"}},\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"cloudtrail.amazonaws.com\"},\"Resource\":\"arn:aws:s3:::terraform-20220923125358263500000001/prefix/*\",\"Sid\":\"AWSCloudTrailWrite\"}],\"Version\":\"2012-10-17\"}"
            }
          },
          {
            "address": "data.aws_caller_identity.current",
            "mode": "data",
            "name": "current",
            "provider_name": "registry.terraform.io/hashicorp/aws",
            "schema_version": 0,
            "sensitive_values": {},
            "type": "aws_caller_identity",
            "values": {
              "account_id": "622401240280",
              "arn": "arn:aws:iam::622401240280:user/jasper",
              "id": "622401240280",
              "user_id": "AIDAJIMMJZXHZMU5KAPTA"
            }
          },
          {
            "address": "random_id.cloudtrail",
            "mode": "managed",
            "name": "cloudtrail",
            "provider_name": "registry.terraform.io/hashicorp/random",
            "schema_version": 0,
            "sensitive_values": {},
            "type": "random_id",
            "values": {
              "b64_std": "EWV8SPL3cVc=",
              "b64_url": "EWV8SPL3cVc",
              "byte_length": 8,
              "dec": "1253544724048343383",
              "hex": "11657c48f2f77157",
              "id": "EWV8SPL3cVc",
              "keepers": null,
              "prefix": null
            }
          }
        ]
      }
    }
  },
  "resource_changes": [
    {
      "address": "aws_cloudtrail.cloudtrail",
      "change": {
        "actions": [
          "no-op"
        ],
        "after": {
          "advanced_event_selector": [],
          "arn": "arn:aws:cloudtrail:us-east-2:622401240280:trail/EWV8SPL3cVc",
          "cloud_watch_logs_group_arn": "",
          "cloud_watch_logs_role_arn": "",
          "enable_log_file_validation": false,
          "enable_logging": true,
          "event_selector": [],
          "home_region": "us-east-2",
          "id": "EWV8SPL3cVc",
          "include_global_service_events": false,
          "insight_selector": [],
          "is_multi_region_trail": false,
          "is_organization_trail": false,
          "kms_key_id": "",
          "name": "EWV8SPL3cVc",
          "s3_bucket_name": "terraform-20220923125358263500000001",
          "s3_key_prefix": "prefix",
          "sns_topic_name": "",
          "tags": {},
          "tags_all": {}
        },
        "after_sensitive": {
          "advanced_event_selector": [],
          "event_selector": [],
          "insight_selector": [],
          "tags": {},
          "tags_all": {}
        },
        "after_unknown": {},
        "before": {
          "advanced_event_selector": [],
          "arn": "arn:aws:cloudtrail:us-east-2:622401240280:trail/EWV8SPL3cVc",
          "cloud_watch_logs_group_arn": "",
          "cloud_watch_logs_role_arn": "",
          "enable_log_file_validation": false,
          "enable_logging": true,
          "event_selector": [],
          "home_region": "us-east-2",
          "id": "EWV8SPL3cVc",
          "include_global_service_events": false,
          "insight_selector": [],
          "is_multi_region_trail": false,
          "is_organization_trail": false,
          "kms_key_id": "",
          "name": "EWV8SPL3cVc",
          "s3_bucket_name": "terraform-20220923125358263500000001",
          "s3_key_prefix": "prefix",
          "sns_topic_name": "",
          "tags": {},
          "tags_all": {}
        },
        "before_sensitive": {
          "advanced_event_selector": [],
          "event_selector": [],
          "insight_selector": [],
          "tags": {},
          "tags_all": {}
        }
      },
      "mode": "managed",
      "name": "cloudtrail",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_cloudtrail"
    },
    {
      "address": "aws_s3_bucket.cloudtrail",
      "change": {
        "actions": [
          "no-op"
        ],
        "after": {
          "acceleration_status": "",
          "acl": null,
          "arn": "arn:aws:s3:::terraform-20220923125358263500000001",
          "bucket": "terraform-20220923125358263500000001",
          "bucket_domain_name": "terraform-20220923125358263500000001.s3.amazonaws.com",
          "bucket_prefix": null,
          "bucket_regional_domain_name": "terraform-20220923125358263500000001.s3.us-east-2.amazonaws.com",
          "cors_rule": [],
          "force_destroy": true,
          "grant": [
            {
              "id": "d5c48f20001a6ee7be6d75e69fe2da57d4c273b03ac318bd3d5526018c47ecb5",
              "permissions": [
                "FULL_CONTROL"
              ],
              "type": "CanonicalUser",
              "uri": ""
            }
          ],
          "hosted_zone_id": "Z2O1EMRO9K5GLX",
          "id": "terraform-20220923125358263500000001",
          "lifecycle_rule": [],
          "logging": [
            {
              "target_bucket": "terraform-20220923125358270800000002",
              "target_prefix": "log/"
            }
          ],
          "object_lock_configuration": [],
          "object_lock_enabled": false,
          "policy": "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Sid\":\"AWSCloudTrailAclCheck\",\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"cloudtrail.amazonaws.com\"},\"Action\":\"s3:GetBucketAcl\",\"Resource\":\"arn:aws:s3:::terraform-20220923125358263500000001\"},{\"Sid\":\"AWSCloudTrailWrite\",\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"cloudtrail.amazonaws.com\"},\"Action\":\"s3:PutObject\",\"Resource\":\"arn:aws:s3:::terraform-20220923125358263500000001/prefix/*\",\"Condition\":{\"StringEquals\":{\"s3:x-amz-acl\":\"bucket-owner-full-control\"}}}]}",
          "region": "us-east-2",
          "replication_configuration": [],
          "request_payer": "BucketOwner",
          "server_side_encryption_configuration": [],
          "tags": {},
          "tags_all": {},
          "timeouts": null,
          "versioning": [
            {
              "enabled": false,
              "mfa_delete": false
            }
          ],
          "website": [],
          "website_domain": null,
          "website_endpoint": null
        },
        "after_sensitive": {
          "cors_rule": [],
          "grant": [
            {
              "permissions": [
                false
              ]
            }
          ],
          "lifecycle_rule": [],
          "logging": [
            {}
          ],
          "object_lock_configuration": [],
          "replication_configuration": [],
          "server_side_encryption_configuration": [],
          "tags": {},
          "tags_all": {},
          "versioning": [
            {}
          ],
          "website": []
        },
        "after_unknown": {},
        "before": {
          "acceleration_status": "",
          "acl": null,
          "arn": "arn:aws:s3:::terraform-20220923125358263500000001",
          "bucket": "terraform-20220923125358263500000001",
          "bucket_domain_name": "terraform-20220923125358263500000001.s3.amazonaws.com",
          "bucket_prefix": null,
          "bucket_regional_domain_name": "terraform-20220923125358263500000001.s3.us-east-2.amazonaws.com",
          "cors_rule": [],
          "force_destroy": true,
          "grant": [
            {
              "id": "d5c48f20001a6ee7be6d75e69fe2da57d4c273b03ac318bd3d5526018c47ecb5",
              "permissions": [
                "FULL_CONTROL"
              ],
              "type": "CanonicalUser",
              "uri": ""
            }
          ],
          "hosted_zone_id": "Z2O1EMRO9K5GLX",
          "id": "terraform-20220923125358263500000001",
          "lifecycle_rule": [],
          "logging": [
            {
              "target_bucket": "terraform-20220923125358270800000002",
              "target_prefix": "log/"
            }
          ],
          "object_lock_configuration": [],
          "object_lock_enabled": false,
          "policy": "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Sid\":\"AWSCloudTrailAclCheck\",\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"cloudtrail.amazonaws.com\"},\"Action\":\"s3:GetBucketAcl\",\"Resource\":\"arn:aws:s3:::terraform-20220923125358263500000001\"},{\"Sid\":\"AWSCloudTrailWrite\",\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"cloudtrail.amazonaws.com\"},\"Action\":\"s3:PutObject\",\"Resource\":\"arn:aws:s3:::terraform-20220923125358263500000001/prefix/*\",\"Condition\":{\"StringEquals\":{\"s3:x-amz-acl\":\"bucket-owner-full-control\"}}}]}",
          "region": "us-east-2",
          "replication_configuration": [],
          "request_payer": "BucketOwner",
          "server_side_encryption_configuration": [],
          "tags": {},
          "tags_all": {},
          "timeouts": null,
          "versioning": [
            {
              "enabled": false,
              "mfa_delete": false
            }
          ],
          "website": [],
          "website_domain": null,
          "website_endpoint": null
        },
        "before_sensitive": {
          "cors_rule": [],
          "grant": [
            {
              "permissions": [
                false
              ]
            }
          ],
          "lifecycle_rule": [],
          "logging": [
            {}
          ],
          "object_lock_configuration": [],
          "replication_configuration": [],
          "server_side_encryption_configuration": [],
          "tags": {},
          "tags_all": {},
          "versioning": [
            {}
          ],
          "website": []
        }
      },
      "mode": "managed",
      "name": "cloudtrail",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_s3_bucket"
    },
    {
      "address": "aws_s3_bucket.logging",
      "change": {
        "actions": [
          "no-op"
        ],
        "after": {
          "acceleration_status": "",
          "acl": "log-delivery-write",
          "arn": "arn:aws:s3:::terraform-20220923125358270800000002",
          "bucket": "terraform-20220923125358270800000002",
          "bucket_domain_name": "terraform-20220923125358270800000002.s3.amazonaws.com",
          "bucket_prefix": null,
          "bucket_regional_domain_name": "terraform-20220923125358270800000002.s3.us-east-2.amazonaws.com",
          "cors_rule": [],
          "force_destroy": true,
          "grant": [
            {
              "id": "",
              "permissions": [
                "READ_ACP",
                "WRITE"
              ],
              "type": "Group",
              "uri": "http://acs.amazonaws.com/groups/s3/LogDelivery"
            },
            {
              "id": "d5c48f20001a6ee7be6d75e69fe2da57d4c273b03ac318bd3d5526018c47ecb5",
              "permissions": [
                "FULL_CONTROL"
              ],
              "type": "CanonicalUser",
              "uri": ""
            }
          ],
          "hosted_zone_id": "Z2O1EMRO9K5GLX",
          "id": "terraform-20220923125358270800000002",
          "lifecycle_rule": [],
          "logging": [],
          "object_lock_configuration": [],
          "object_lock_enabled": false,
          "policy": "",
          "region": "us-east-2",
          "replication_configuration": [],
          "request_payer": "BucketOwner",
          "server_side_encryption_configuration": [],
          "tags": {},
          "tags_all": {},
          "timeouts": null,
          "versioning": [
            {
              "enabled": false,
              "mfa_delete": false
            }
          ],
          "website": [],
          "website_domain": null,
          "website_endpoint": null
        },
        "after_sensitive": {
          "cors_rule": [],
          "grant": [
            {
              "permissions": [
                false,
                false
              ]
            },
            {
              "permissions": [
                false
              ]
            }
          ],
          "lifecycle_rule": [],
          "logging": [],
          "object_lock_configuration": [],
          "replication_configuration": [],
          "server_side_encryption_configuration": [],
          "tags": {},
          "tags_all": {},
          "versioning": [
            {}
          ],
          "website": []
        },
        "after_unknown": {},
        "before": {
          "acceleration_status": "",
          "acl": "log-delivery-write",
          "arn": "arn:aws:s3:::terraform-20220923125358270800000002",
          "bucket": "terraform-20220923125358270800000002",
          "bucket_domain_name": "terraform-20220923125358270800000002.s3.amazonaws.com",
          "bucket_prefix": null,
          "bucket_regional_domain_name": "terraform-20220923125358270800000002.s3.us-east-2.amazonaws.com",
          "cors_rule": [],
          "force_destroy": true,
          "grant": [
            {
              "id": "",
              "permissions": [
                "READ_ACP",
                "WRITE"
              ],
              "type": "Group",
              "uri": "http://acs.amazonaws.com/groups/s3/LogDelivery"
            },
            {
              "id": "d5c48f20001a6ee7be6d75e69fe2da57d4c273b03ac318bd3d5526018c47ecb5",
              "permissions": [
                "FULL_CONTROL"
              ],
              "type": "CanonicalUser",
              "uri": ""
            }
          ],
          "hosted_zone_id": "Z2O1EMRO9K5GLX",
          "id": "terraform-20220923125358270800000002",
          "lifecycle_rule": [],
          "logging": [],
          "object_lock_configuration": [],
          "object_lock_enabled": false,
          "policy": "",
          "region": "us-east-2",
          "replication_configuration": [],
          "request_payer": "BucketOwner",
          "server_side_encryption_configuration": [],
          "tags": {},
          "tags_all": {},
          "timeouts": null,
          "versioning": [
            {
              "enabled": false,
              "mfa_delete": false
            }
          ],
          "website": [],
          "website_domain": null,
          "website_endpoint": null
        },
        "before_sensitive": {
          "cors_rule": [],
          "grant": [
            {
              "permissions": [
                false,
                false
              ]
            },
            {
              "permissions": [
                false
              ]
            }
          ],
          "lifecycle_rule": [],
          "logging": [],
          "object_lock_configuration": [],
          "replication_configuration": [],
          "server_side_encryption_configuration": [],
          "tags": {},
          "tags_all": {},
          "versioning": [
            {}
          ],
          "website": []
        }
      },
      "mode": "managed",
      "name": "logging",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_s3_bucket"
    },
    {
      "address": "aws_s3_bucket_logging.cloudtrail",
      "change": {
        "actions": [
          "no-op"
        ],
        "after": {
          "bucket": "terraform-20220923125358263500000001",
          "expected_bucket_owner": "",
          "id": "terraform-20220923125358263500000001",
          "target_bucket": "terraform-20220923125358270800000002",
          "target_grant": [],
          "target_prefix": "log/"
        },
        "after_sensitive": {
          "target_grant": []
        },
        "after_unknown": {},
        "before": {
          "bucket": "terraform-20220923125358263500000001",
          "expected_bucket_owner": "",
          "id": "terraform-20220923125358263500000001",
          "target_bucket": "terraform-20220923125358270800000002",
          "target_grant": [],
          "target_prefix": "log/"
        },
        "before_sensitive": {
          "target_grant": []
        }
      },
      "mode": "managed",
      "name": "cloudtrail",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_s3_bucket_logging"
    },
    {
      "address": "aws_s3_bucket_policy.cloudtrail",
      "change": {
        "actions": [
          "no-op"
        ],
        "after": {
          "bucket": "terraform-20220923125358263500000001",
          "id": "terraform-20220923125358263500000001",
          "policy": "{\"Statement\":[{\"Action\":\"s3:GetBucketAcl\",\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"cloudtrail.amazonaws.com\"},\"Resource\":\"arn:aws:s3:::terraform-20220923125358263500000001\",\"Sid\":\"AWSCloudTrailAclCheck\"},{\"Action\":\"s3:PutObject\",\"Condition\":{\"StringEquals\":{\"s3:x-amz-acl\":\"bucket-owner-full-control\"}},\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"cloudtrail.amazonaws.com\"},\"Resource\":\"arn:aws:s3:::terraform-20220923125358263500000001/prefix/*\",\"Sid\":\"AWSCloudTrailWrite\"}],\"Version\":\"2012-10-17\"}"
        },
        "after_sensitive": {},
        "after_unknown": {},
        "before": {
          "bucket": "terraform-20220923125358263500000001",
          "id": "terraform-20220923125358263500000001",
          "policy": "{\"Statement\":[{\"Action\":\"s3:GetBucketAcl\",\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"cloudtrail.amazonaws.com\"},\"Resource\":\"arn:aws:s3:::terraform-20220923125358263500000001\",\"Sid\":\"AWSCloudTrailAclCheck\"},{\"Action\":\"s3:PutObject\",\"Condition\":{\"StringEquals\":{\"s3:x-amz-acl\":\"bucket-owner-full-control\"}},\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"cloudtrail.amazonaws.com\"},\"Resource\":\"arn:aws:s3:::terraform-20220923125358263500000001/prefix/*\",\"Sid\":\"AWSCloudTrailWrite\"}],\"Version\":\"2012-10-17\"}"
        },
        "before_sensitive": {}
      },
      "mode": "managed",
      "name": "cloudtrail",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_s3_bucket_policy"
    },
    {
      "address": "random_id.cloudtrail",
      "change": {
        "actions": [
          "no-op"
        ],
        "after": {
          "b64_std": "EWV8SPL3cVc=",
          "b64_url": "EWV8SPL3cVc",
          "byte_length": 8,
          "dec": "1253544724048343383",
          "hex": "11657c48f2f77157",
          "id": "EWV8SPL3cVc",
          "keepers": null,
          "prefix": null
        },
        "after_sensitive": {},
        "after_unknown": {},
        "before": {
          "b64_std": "EWV8SPL3cVc=",
          "b64_url": "EWV8SPL3cVc",
          "byte_length": 8,
          "dec": "1253544724048343383",
          "hex": "11657c48f2f77157",
          "id": "EWV8SPL3cVc",
          "keepers": null,
          "prefix": null
        },
        "before_sensitive": {}
      },
      "mode": "managed",
      "name": "cloudtrail",
      "provider_name": "registry.terraform.io/hashicorp/random",
      "type": "random_id"
    }
  ],
  "resource_drift": [
    {
      "address": "aws_cloudtrail.cloudtrail",
      "change": {
        "actions": [
          "update"
        ],
        "after": {
          "advanced_event_selector": [],
          "arn": "arn:aws:cloudtrail:us-east-2:622401240280:trail/EWV8SPL3cVc",
          "cloud_watch_logs_group_arn": "",
          "cloud_watch_logs_role_arn": "",
          "enable_log_file_validation": false,
          "enable_logging": true,
          "event_selector": [],
          "home_region": "us-east-2",
          "id": "EWV8SPL3cVc",
          "include_global_service_events": false,
          "insight_selector": [],
          "is_multi_region_trail": false,
          "is_organization_trail": false,
          "kms_key_id": "",
          "name": "EWV8SPL3cVc",
          "s3_bucket_name": "terraform-20220923125358263500000001",
          "s3_key_prefix": "prefix",
          "sns_topic_name": "",
          "tags": {},
          "tags_all": {}
        },
        "after_sensitive": {
          "advanced_event_selector": [],
          "event_selector": [],
          "insight_selector": [],
          "tags": {},
          "tags_all": {}
        },
        "after_unknown": {},
        "before": {
          "advanced_event_selector": [],
          "arn": "arn:aws:cloudtrail:us-east-2:622401240280:trail/EWV8SPL3cVc",
          "cloud_watch_logs_group_arn": "",
          "cloud_watch_logs_role_arn": "",
          "enable_log_file_validation": false,
          "enable_logging": true,
          "event_selector": [],
          "home_region": "us-east-2",
          "id": "EWV8SPL3cVc",
          "include_global_service_events": false,
          "insight_selector": [],
          "is_multi_region_trail": false,
          "is_organization_trail": false,
          "kms_key_id": "",
          "name": "EWV8SPL3cVc",
          "s3_bucket_name": "terraform-20220923125358263500000001",
          "s3_key_prefix": "prefix",
          "sns_topic_name": "",
          "tags": null,
          "tags_all": {}
        },
        "before_sensitive": {
          "advanced_event_selector": [],
          "event_selector": [],
          "insight_selector": [],
          "tags_all": {}
        }
      },
      "mode": "managed",
      "name": "cloudtrail",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_cloudtrail"
    },
    {
      "address": "aws_s3_bucket.cloudtrail",
      "change": {
        "actions": [
          "update"
        ],
        "after": {
          "acceleration_status": "",
          "acl": null,
          "arn": "arn:aws:s3:::terraform-20220923125358263500000001",
          "bucket": "terraform-20220923125358263500000001",
          "bucket_domain_name": "terraform-20220923125358263500000001.s3.amazonaws.com",
          "bucket_prefix": null,
          "bucket_regional_domain_name": "terraform-20220923125358263500000001.s3.us-east-2.amazonaws.com",
          "cors_rule": [],
          "force_destroy": true,
          "grant": [
            {
              "id": "d5c48f20001a6ee7be6d75e69fe2da57d4c273b03ac318bd3d5526018c47ecb5",
              "permissions": [
                "FULL_CONTROL"
              ],
              "type": "CanonicalUser",
              "uri": ""
            }
          ],
          "hosted_zone_id": "Z2O1EMRO9K5GLX",
          "id": "terraform-20220923125358263500000001",
          "lifecycle_rule": [],
          "logging": [
            {
              "target_bucket": "terraform-20220923125358270800000002",
              "target_prefix": "log/"
            }
          ],
          "object_lock_configuration": [],
          "object_lock_enabled": false,
          "policy": "{\"Version\":\"2012-10-17\",\"Statement\":[{\"Sid\":\"AWSCloudTrailAclCheck\",\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"cloudtrail.amazonaws.com\"},\"Action\":\"s3:GetBucketAcl\",\"Resource\":\"arn:aws:s3:::terraform-20220923125358263500000001\"},{\"Sid\":\"AWSCloudTrailWrite\",\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"cloudtrail.amazonaws.com\"},\"Action\":\"s3:PutObject\",\"Resource\":\"arn:aws:s3:::terraform-20220923125358263500000001/prefix/*\",\"Condition\":{\"StringEquals\":{\"s3:x-amz-acl\":\"bucket-owner-full-control\"}}}]}",
          "region": "us-east-2",
          "replication_configuration": [],
          "request_payer": "BucketOwner",
          "server_side_encryption_configuration": [],
          "tags": {},
          "tags_all": {},
          "timeouts": null,
          "versioning": [
            {
              "enabled": false,
              "mfa_delete": false
            }
          ],
          "website": [],
          "website_domain": null,
          "website_endpoint": null
        },
        "after_sensitive": {
          "cors_rule": [],
          "grant": [
            {
              "permissions": [
                false
              ]
            }
          ],
          "lifecycle_rule": [],
          "logging": [
            {}
          ],
          "object_lock_configuration": [],
          "replication_configuration": [],
          "server_side_encryption_configuration": [],
          "tags": {},
          "tags_all": {},
          "versioning": [
            {}
          ],
          "website": []
        },
        "after_unknown": {},
        "before": {
          "acceleration_status": "",
          "acl": null,
          "arn": "arn:aws:s3:::terraform-20220923125358263500000001",
          "bucket": "terraform-20220923125358263500000001",
          "bucket_domain_name": "terraform-20220923125358263500000001.s3.amazonaws.com",
          "bucket_prefix": null,
          "bucket_regional_domain_name": "terraform-20220923125358263500000001.s3.us-east-2.amazonaws.com",
          "cors_rule": [],
          "force_destroy": true,
          "grant": [
            {
              "id": "d5c48f20001a6ee7be6d75e69fe2da57d4c273b03ac318bd3d5526018c47ecb5",
              "permissions": [
                "FULL_CONTROL"
              ],
              "type": "CanonicalUser",
              "uri": ""
            }
          ],
          "hosted_zone_id": "Z2O1EMRO9K5GLX",
          "id": "terraform-20220923125358263500000001",
          "lifecycle_rule": [],
          "logging": [],
          "object_lock_configuration": [],
          "object_lock_enabled": false,
          "policy": "",
          "region": "us-east-2",
          "replication_configuration": [],
          "request_payer": "BucketOwner",
          "server_side_encryption_configuration": [],
          "tags": null,
          "tags_all": {},
          "timeouts": null,
          "versioning": [
            {
              "enabled": false,
              "mfa_delete": false
            }
          ],
          "website": [],
          "website_domain": null,
          "website_endpoint": null
        },
        "before_sensitive": {
          "cors_rule": [],
          "grant": [
            {
              "permissions": [
                false
              ]
            }
          ],
          "lifecycle_rule": [],
          "logging": [],
          "object_lock_configuration": [],
          "replication_configuration": [],
          "server_side_encryption_configuration": [],
          "tags_all": {},
          "versioning": [
            {}
          ],
          "website": []
        }
      },
      "mode": "managed",
      "name": "cloudtrail",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_s3_bucket"
    },
    {
      "address": "aws_s3_bucket.logging",
      "change": {
        "actions": [
          "update"
        ],
        "after": {
          "acceleration_status": "",
          "acl": "log-delivery-write",
          "arn": "arn:aws:s3:::terraform-20220923125358270800000002",
          "bucket": "terraform-20220923125358270800000002",
          "bucket_domain_name": "terraform-20220923125358270800000002.s3.amazonaws.com",
          "bucket_prefix": null,
          "bucket_regional_domain_name": "terraform-20220923125358270800000002.s3.us-east-2.amazonaws.com",
          "cors_rule": [],
          "force_destroy": true,
          "grant": [
            {
              "id": "",
              "permissions": [
                "READ_ACP",
                "WRITE"
              ],
              "type": "Group",
              "uri": "http://acs.amazonaws.com/groups/s3/LogDelivery"
            },
            {
              "id": "d5c48f20001a6ee7be6d75e69fe2da57d4c273b03ac318bd3d5526018c47ecb5",
              "permissions": [
                "FULL_CONTROL"
              ],
              "type": "CanonicalUser",
              "uri": ""
            }
          ],
          "hosted_zone_id": "Z2O1EMRO9K5GLX",
          "id": "terraform-20220923125358270800000002",
          "lifecycle_rule": [],
          "logging": [],
          "object_lock_configuration": [],
          "object_lock_enabled": false,
          "policy": "",
          "region": "us-east-2",
          "replication_configuration": [],
          "request_payer": "BucketOwner",
          "server_side_encryption_configuration": [],
          "tags": {},
          "tags_all": {},
          "timeouts": null,
          "versioning": [
            {
              "enabled": false,
              "mfa_delete": false
            }
          ],
          "website": [],
          "website_domain": null,
          "website_endpoint": null
        },
        "after_sensitive": {
          "cors_rule": [],
          "grant": [
            {
              "permissions": [
                false,
                false
              ]
            },
            {
              "permissions": [
                false
              ]
            }
          ],
          "lifecycle_rule": [],
          "logging": [],
          "object_lock_configuration": [],
          "replication_configuration": [],
          "server_side_encryption_configuration": [],
          "tags": {},
          "tags_all": {},
          "versioning": [
            {}
          ],
          "website": []
        },
        "after_unknown": {},
        "before": {
          "acceleration_status": "",
          "acl": "log-delivery-write",
          "arn": "arn:aws:s3:::terraform-20220923125358270800000002",
          "bucket": "terraform-20220923125358270800000002",
          "bucket_domain_name": "terraform-20220923125358270800000002.s3.amazonaws.com",
          "bucket_prefix": null,
          "bucket_regional_domain_name": "terraform-20220923125358270800000002.s3.us-east-2.amazonaws.com",
          "cors_rule": [],
          "force_destroy": true,
          "grant": [
            {
              "id": "",
              "permissions": [
                "READ_ACP",
                "WRITE"
              ],
              "type": "Group",
              "uri": "http://acs.amazonaws.com/groups/s3/LogDelivery"
            },
            {
              "id": "d5c48f20001a6ee7be6d75e69fe2da57d4c273b03ac318bd3d5526018c47ecb5",
              "permissions": [
                "FULL_CONTROL"
              ],
              "type": "CanonicalUser",
              "uri": ""
            }
          ],
          "hosted_zone_id": "Z2O1EMRO9K5GLX",
          "id": "terraform-20220923125358270800000002",
          "lifecycle_rule": [],
          "logging": [],
          "object_lock_configuration": [],
          "object_lock_enabled": false,
          "policy": "",
          "region": "us-east-2",
          "replication_configuration": [],
          "request_payer": "BucketOwner",
          "server_side_encryption_configuration": [],
          "tags": null,
          "tags_all": {},
          "timeouts": null,
          "versioning": [
            {
              "enabled": false,
              "mfa_delete": false
            }
          ],
          "website": [],
          "website_domain": null,
          "website_endpoint": null
        },
        "before_sensitive": {
          "cors_rule": [],
          "grant": [
            {
              "permissions": [
                false,
                false
              ]
            },
            {
              "permissions": [
                false
              ]
            }
          ],
          "lifecycle_rule": [],
          "logging": [],
          "object_lock_configuration": [],
          "replication_configuration": [],
          "server_side_encryption_configuration": [],
          "tags_all": {},
          "versioning": [
            {}
          ],
          "website": []
        }
      },
      "mode": "managed",
      "name": "logging",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_s3_bucket"
    },
    {
      "address": "aws_s3_bucket_policy.cloudtrail",
      "change": {
        "actions": [
          "update"
        ],
        "after": {
          "bucket": "terraform-20220923125358263500000001",
          "id": "terraform-20220923125358263500000001",
          "policy": "{\"Statement\":[{\"Action\":\"s3:GetBucketAcl\",\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"cloudtrail.amazonaws.com\"},\"Resource\":\"arn:aws:s3:::terraform-20220923125358263500000001\",\"Sid\":\"AWSCloudTrailAclCheck\"},{\"Action\":\"s3:PutObject\",\"Condition\":{\"StringEquals\":{\"s3:x-amz-acl\":\"bucket-owner-full-control\"}},\"Effect\":\"Allow\",\"Principal\":{\"Service\":\"cloudtrail.amazonaws.com\"},\"Resource\":\"arn:aws:s3:::terraform-20220923125358263500000001/prefix/*\",\"Sid\":\"AWSCloudTrailWrite\"}],\"Version\":\"2012-10-17\"}"
        },
        "after_sensitive": {},
        "after_unknown": {},
        "before": {
          "bucket": "terraform-20220923125358263500000001",
          "id": "terraform-20220923125358263500000001",
          "policy": "{\n    \"Version\": \"2012-10-17\",\n    \"Statement\": [\n        {\n            \"Sid\": \"AWSCloudTrailAclCheck\",\n            \"Effect\": \"Allow\",\n            \"Principal\": {\n              \"Service\": \"cloudtrail.amazonaws.com\"\n            },\n            \"Action\": \"s3:GetBucketAcl\",\n            \"Resource\": \"arn:aws:s3:::terraform-20220923125358263500000001\"\n        },\n        {\n            \"Sid\": \"AWSCloudTrailWrite\",\n            \"Effect\": \"Allow\",\n            \"Principal\": {\n              \"Service\": \"cloudtrail.amazonaws.com\"\n            },\n            \"Action\": \"s3:PutObject\",\n            \"Resource\": \"arn:aws:s3:::terraform-20220923125358263500000001/prefix/*\",\n            \"Condition\": {\n                \"StringEquals\": {\n                    \"s3:x-amz-acl\": \"bucket-owner-full-control\"\n                }\n            }\n        }\n    ]\n}\n"
        },
        "before_sensitive": {}
      },
      "mode": "managed",
      "name": "cloudtrail",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_s3_bucket_policy"
    }
  ],
  "terraform_version": "1.1.9"
}

