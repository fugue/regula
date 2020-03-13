# This package was automatically generated from:
#
#     tests/examples/aws/inputs/tag_all_resources_infra.tf
#
# using `generate_test_inputs.sh` and should not be modified
# directly.
package tests.rules.tag_all_resources
mock_input = {
  "format_version": "0.1",
  "terraform_version": "0.12.18",
  "planned_values": {
    "root_module": {
      "resources": [
        {
          "address": "aws_s3_bucket.invalid",
          "mode": "managed",
          "type": "aws_s3_bucket",
          "name": "invalid",
          "provider_name": "aws",
          "schema_version": 0,
          "values": {
            "acl": "private",
            "bucket": "my-tf-test-bucket",
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
            "tags": {
              "Environment": "Dev",
              "Name": "My bucket"
            },
            "website": []
          }
        },
        {
          "address": "aws_vpc.invalid",
          "mode": "managed",
          "type": "aws_vpc",
          "name": "invalid",
          "provider_name": "aws",
          "schema_version": 1,
          "values": {
            "assign_generated_ipv6_cidr_block": false,
            "cidr_block": "10.0.0.0/16",
            "enable_dns_support": true,
            "instance_tenancy": "default",
            "tags": {
              "Name": "12345"
            }
          }
        },
        {
          "address": "aws_vpc.untagged",
          "mode": "managed",
          "type": "aws_vpc",
          "name": "untagged",
          "provider_name": "aws",
          "schema_version": 1,
          "values": {
            "assign_generated_ipv6_cidr_block": false,
            "cidr_block": "10.0.0.0/16",
            "enable_dns_support": true,
            "instance_tenancy": "default",
            "tags": null
          }
        },
        {
          "address": "aws_vpc.valid",
          "mode": "managed",
          "type": "aws_vpc",
          "name": "valid",
          "provider_name": "aws",
          "schema_version": 1,
          "values": {
            "assign_generated_ipv6_cidr_block": false,
            "cidr_block": "10.0.0.0/16",
            "enable_dns_support": true,
            "instance_tenancy": "default",
            "tags": {
              "Name": "123456"
            }
          }
        }
      ]
    }
  },
  "resource_changes": [
    {
      "address": "aws_s3_bucket.invalid",
      "mode": "managed",
      "type": "aws_s3_bucket",
      "name": "invalid",
      "provider_name": "aws",
      "change": {
        "actions": [
          "create"
        ],
        "before": null,
        "after": {
          "acl": "private",
          "bucket": "my-tf-test-bucket",
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
          "tags": {
            "Environment": "Dev",
            "Name": "My bucket"
          },
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
          "tags": {},
          "versioning": true,
          "website": [],
          "website_domain": true,
          "website_endpoint": true
        }
      }
    },
    {
      "address": "aws_vpc.invalid",
      "mode": "managed",
      "type": "aws_vpc",
      "name": "invalid",
      "provider_name": "aws",
      "change": {
        "actions": [
          "create"
        ],
        "before": null,
        "after": {
          "assign_generated_ipv6_cidr_block": false,
          "cidr_block": "10.0.0.0/16",
          "enable_dns_support": true,
          "instance_tenancy": "default",
          "tags": {
            "Name": "12345"
          }
        },
        "after_unknown": {
          "arn": true,
          "default_network_acl_id": true,
          "default_route_table_id": true,
          "default_security_group_id": true,
          "dhcp_options_id": true,
          "enable_classiclink": true,
          "enable_classiclink_dns_support": true,
          "enable_dns_hostnames": true,
          "id": true,
          "ipv6_association_id": true,
          "ipv6_cidr_block": true,
          "main_route_table_id": true,
          "owner_id": true,
          "tags": {}
        }
      }
    },
    {
      "address": "aws_vpc.untagged",
      "mode": "managed",
      "type": "aws_vpc",
      "name": "untagged",
      "provider_name": "aws",
      "change": {
        "actions": [
          "create"
        ],
        "before": null,
        "after": {
          "assign_generated_ipv6_cidr_block": false,
          "cidr_block": "10.0.0.0/16",
          "enable_dns_support": true,
          "instance_tenancy": "default",
          "tags": null
        },
        "after_unknown": {
          "arn": true,
          "default_network_acl_id": true,
          "default_route_table_id": true,
          "default_security_group_id": true,
          "dhcp_options_id": true,
          "enable_classiclink": true,
          "enable_classiclink_dns_support": true,
          "enable_dns_hostnames": true,
          "id": true,
          "ipv6_association_id": true,
          "ipv6_cidr_block": true,
          "main_route_table_id": true,
          "owner_id": true
        }
      }
    },
    {
      "address": "aws_vpc.valid",
      "mode": "managed",
      "type": "aws_vpc",
      "name": "valid",
      "provider_name": "aws",
      "change": {
        "actions": [
          "create"
        ],
        "before": null,
        "after": {
          "assign_generated_ipv6_cidr_block": false,
          "cidr_block": "10.0.0.0/16",
          "enable_dns_support": true,
          "instance_tenancy": "default",
          "tags": {
            "Name": "123456"
          }
        },
        "after_unknown": {
          "arn": true,
          "default_network_acl_id": true,
          "default_route_table_id": true,
          "default_security_group_id": true,
          "dhcp_options_id": true,
          "enable_classiclink": true,
          "enable_classiclink_dns_support": true,
          "enable_dns_hostnames": true,
          "id": true,
          "ipv6_association_id": true,
          "ipv6_cidr_block": true,
          "main_route_table_id": true,
          "owner_id": true,
          "tags": {}
        }
      }
    }
  ],
  "configuration": {
    "provider_config": {
      "aws": {
        "name": "aws",
        "expressions": {
          "region": {
            "constant_value": "us-east-1"
          }
        }
      }
    },
    "root_module": {
      "resources": [
        {
          "address": "aws_s3_bucket.invalid",
          "mode": "managed",
          "type": "aws_s3_bucket",
          "name": "invalid",
          "provider_config_key": "aws",
          "expressions": {
            "acl": {
              "constant_value": "private"
            },
            "bucket": {
              "constant_value": "my-tf-test-bucket"
            },
            "tags": {
              "constant_value": {
                "Environment": "Dev",
                "Name": "My bucket"
              }
            }
          },
          "schema_version": 0
        },
        {
          "address": "aws_vpc.invalid",
          "mode": "managed",
          "type": "aws_vpc",
          "name": "invalid",
          "provider_config_key": "aws",
          "expressions": {
            "cidr_block": {
              "constant_value": "10.0.0.0/16"
            },
            "tags": {
              "constant_value": {
                "Name": "12345"
              }
            }
          },
          "schema_version": 1
        },
        {
          "address": "aws_vpc.untagged",
          "mode": "managed",
          "type": "aws_vpc",
          "name": "untagged",
          "provider_config_key": "aws",
          "expressions": {
            "cidr_block": {
              "constant_value": "10.0.0.0/16"
            }
          },
          "schema_version": 1
        },
        {
          "address": "aws_vpc.valid",
          "mode": "managed",
          "type": "aws_vpc",
          "name": "valid",
          "provider_config_key": "aws",
          "expressions": {
            "cidr_block": {
              "constant_value": "10.0.0.0/16"
            },
            "tags": {
              "constant_value": {
                "Name": "123456"
              }
            }
          },
          "schema_version": 1
        }
      ]
    }
  }
}
