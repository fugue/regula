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
package tests.rules.tf.aws.vpc.inputs.flow_log_infra_json

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
          "address": "aws_cloudwatch_log_group.example",
          "expressions": {
            "name": {
              "constant_value": "example"
            }
          },
          "mode": "managed",
          "name": "example",
          "provider_config_key": "aws",
          "schema_version": 0,
          "type": "aws_cloudwatch_log_group"
        },
        {
          "address": "aws_flow_log.valid_vpc_flow_log",
          "expressions": {
            "iam_role_arn": {
              "references": [
                "aws_iam_role.example"
              ]
            },
            "log_destination": {
              "references": [
                "aws_cloudwatch_log_group.example"
              ]
            },
            "traffic_type": {
              "constant_value": "ALL"
            },
            "vpc_id": {
              "references": [
                "aws_vpc.valid_vpc"
              ]
            }
          },
          "mode": "managed",
          "name": "valid_vpc_flow_log",
          "provider_config_key": "aws",
          "schema_version": 0,
          "type": "aws_flow_log"
        },
        {
          "address": "aws_iam_role.example",
          "expressions": {
            "assume_role_policy": {
              "constant_value": "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Sid\": \"\",\n      \"Effect\": \"Allow\",\n      \"Principal\": {\n        \"Service\": \"vpc-flow-logs.amazonaws.com\"\n      },\n      \"Action\": \"sts:AssumeRole\"\n    }\n  ]\n}\n"
            },
            "name": {
              "constant_value": "example"
            }
          },
          "mode": "managed",
          "name": "example",
          "provider_config_key": "aws",
          "schema_version": 0,
          "type": "aws_iam_role"
        },
        {
          "address": "aws_iam_role_policy.example",
          "expressions": {
            "name": {
              "constant_value": "example"
            },
            "policy": {
              "constant_value": "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Action\": [\n        \"logs:CreateLogGroup\",\n        \"logs:CreateLogStream\",\n        \"logs:PutLogEvents\",\n        \"logs:DescribeLogGroups\",\n        \"logs:DescribeLogStreams\"\n      ],\n      \"Effect\": \"Allow\",\n      \"Resource\": \"*\"\n    }\n  ]\n}\n"
            },
            "role": {
              "references": [
                "aws_iam_role.example"
              ]
            }
          },
          "mode": "managed",
          "name": "example",
          "provider_config_key": "aws",
          "schema_version": 0,
          "type": "aws_iam_role_policy"
        },
        {
          "address": "aws_vpc.invalid_vpc",
          "expressions": {
            "cidr_block": {
              "constant_value": "10.0.0.0/16"
            }
          },
          "mode": "managed",
          "name": "invalid_vpc",
          "provider_config_key": "aws",
          "schema_version": 1,
          "type": "aws_vpc"
        },
        {
          "address": "aws_vpc.valid_vpc",
          "expressions": {
            "cidr_block": {
              "constant_value": "10.0.0.0/16"
            }
          },
          "mode": "managed",
          "name": "valid_vpc",
          "provider_config_key": "aws",
          "schema_version": 1,
          "type": "aws_vpc"
        }
      ]
    }
  },
  "format_version": "0.1",
  "planned_values": {
    "root_module": {
      "resources": [
        {
          "address": "aws_cloudwatch_log_group.example",
          "mode": "managed",
          "name": "example",
          "provider_name": "registry.terraform.io/hashicorp/aws",
          "schema_version": 0,
          "type": "aws_cloudwatch_log_group",
          "values": {
            "kms_key_id": null,
            "name": "example",
            "name_prefix": null,
            "retention_in_days": 0,
            "tags": null
          }
        },
        {
          "address": "aws_flow_log.valid_vpc_flow_log",
          "mode": "managed",
          "name": "valid_vpc_flow_log",
          "provider_name": "registry.terraform.io/hashicorp/aws",
          "schema_version": 0,
          "type": "aws_flow_log",
          "values": {
            "eni_id": null,
            "log_destination_type": "cloud-watch-logs",
            "max_aggregation_interval": 600,
            "subnet_id": null,
            "tags": null,
            "traffic_type": "ALL"
          }
        },
        {
          "address": "aws_iam_role.example",
          "mode": "managed",
          "name": "example",
          "provider_name": "registry.terraform.io/hashicorp/aws",
          "schema_version": 0,
          "type": "aws_iam_role",
          "values": {
            "assume_role_policy": "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Sid\": \"\",\n      \"Effect\": \"Allow\",\n      \"Principal\": {\n        \"Service\": \"vpc-flow-logs.amazonaws.com\"\n      },\n      \"Action\": \"sts:AssumeRole\"\n    }\n  ]\n}\n",
            "description": null,
            "force_detach_policies": false,
            "max_session_duration": 3600,
            "name": "example",
            "name_prefix": null,
            "path": "/",
            "permissions_boundary": null,
            "tags": null
          }
        },
        {
          "address": "aws_iam_role_policy.example",
          "mode": "managed",
          "name": "example",
          "provider_name": "registry.terraform.io/hashicorp/aws",
          "schema_version": 0,
          "type": "aws_iam_role_policy",
          "values": {
            "name": "example",
            "name_prefix": null,
            "policy": "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Action\": [\n        \"logs:CreateLogGroup\",\n        \"logs:CreateLogStream\",\n        \"logs:PutLogEvents\",\n        \"logs:DescribeLogGroups\",\n        \"logs:DescribeLogStreams\"\n      ],\n      \"Effect\": \"Allow\",\n      \"Resource\": \"*\"\n    }\n  ]\n}\n"
          }
        },
        {
          "address": "aws_vpc.invalid_vpc",
          "mode": "managed",
          "name": "invalid_vpc",
          "provider_name": "registry.terraform.io/hashicorp/aws",
          "schema_version": 1,
          "type": "aws_vpc",
          "values": {
            "assign_generated_ipv6_cidr_block": false,
            "cidr_block": "10.0.0.0/16",
            "enable_dns_support": true,
            "instance_tenancy": "default",
            "tags": null
          }
        },
        {
          "address": "aws_vpc.valid_vpc",
          "mode": "managed",
          "name": "valid_vpc",
          "provider_name": "registry.terraform.io/hashicorp/aws",
          "schema_version": 1,
          "type": "aws_vpc",
          "values": {
            "assign_generated_ipv6_cidr_block": false,
            "cidr_block": "10.0.0.0/16",
            "enable_dns_support": true,
            "instance_tenancy": "default",
            "tags": null
          }
        }
      ]
    }
  },
  "resource_changes": [
    {
      "address": "aws_cloudwatch_log_group.example",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "kms_key_id": null,
          "name": "example",
          "name_prefix": null,
          "retention_in_days": 0,
          "tags": null
        },
        "after_unknown": {
          "arn": true,
          "id": true,
          "tags_all": true
        },
        "before": null
      },
      "mode": "managed",
      "name": "example",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_cloudwatch_log_group"
    },
    {
      "address": "aws_flow_log.valid_vpc_flow_log",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "eni_id": null,
          "log_destination_type": "cloud-watch-logs",
          "max_aggregation_interval": 600,
          "subnet_id": null,
          "tags": null,
          "traffic_type": "ALL"
        },
        "after_unknown": {
          "arn": true,
          "iam_role_arn": true,
          "id": true,
          "log_destination": true,
          "log_format": true,
          "log_group_name": true,
          "tags_all": true,
          "vpc_id": true
        },
        "before": null
      },
      "mode": "managed",
      "name": "valid_vpc_flow_log",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_flow_log"
    },
    {
      "address": "aws_iam_role.example",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "assume_role_policy": "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Sid\": \"\",\n      \"Effect\": \"Allow\",\n      \"Principal\": {\n        \"Service\": \"vpc-flow-logs.amazonaws.com\"\n      },\n      \"Action\": \"sts:AssumeRole\"\n    }\n  ]\n}\n",
          "description": null,
          "force_detach_policies": false,
          "max_session_duration": 3600,
          "name": "example",
          "name_prefix": null,
          "path": "/",
          "permissions_boundary": null,
          "tags": null
        },
        "after_unknown": {
          "arn": true,
          "create_date": true,
          "id": true,
          "inline_policy": true,
          "managed_policy_arns": true,
          "tags_all": true,
          "unique_id": true
        },
        "before": null
      },
      "mode": "managed",
      "name": "example",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_iam_role"
    },
    {
      "address": "aws_iam_role_policy.example",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "name": "example",
          "name_prefix": null,
          "policy": "{\n  \"Version\": \"2012-10-17\",\n  \"Statement\": [\n    {\n      \"Action\": [\n        \"logs:CreateLogGroup\",\n        \"logs:CreateLogStream\",\n        \"logs:PutLogEvents\",\n        \"logs:DescribeLogGroups\",\n        \"logs:DescribeLogStreams\"\n      ],\n      \"Effect\": \"Allow\",\n      \"Resource\": \"*\"\n    }\n  ]\n}\n"
        },
        "after_unknown": {
          "id": true,
          "role": true
        },
        "before": null
      },
      "mode": "managed",
      "name": "example",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_iam_role_policy"
    },
    {
      "address": "aws_vpc.invalid_vpc",
      "change": {
        "actions": [
          "create"
        ],
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
          "owner_id": true,
          "tags_all": true
        },
        "before": null
      },
      "mode": "managed",
      "name": "invalid_vpc",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_vpc"
    },
    {
      "address": "aws_vpc.valid_vpc",
      "change": {
        "actions": [
          "create"
        ],
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
          "owner_id": true,
          "tags_all": true
        },
        "before": null
      },
      "mode": "managed",
      "name": "valid_vpc",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_vpc"
    }
  ],
  "terraform_version": "0.13.5"
}

