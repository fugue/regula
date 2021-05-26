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
package tests.examples.aws.inputs.ec2_t2_only_infra_json

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
          "address": "aws_instance.invalid",
          "expressions": {
            "ami": {
              "references": [
                "data.aws_ami.ubuntu"
              ]
            },
            "instance_type": {
              "constant_value": "t2.nano"
            }
          },
          "mode": "managed",
          "name": "invalid",
          "provider_config_key": "aws",
          "schema_version": 1,
          "type": "aws_instance"
        },
        {
          "address": "aws_instance.valid_2xlarge",
          "expressions": {
            "ami": {
              "references": [
                "data.aws_ami.ubuntu"
              ]
            },
            "instance_type": {
              "constant_value": "t2.2xlarge"
            }
          },
          "mode": "managed",
          "name": "valid_2xlarge",
          "provider_config_key": "aws",
          "schema_version": 1,
          "type": "aws_instance"
        },
        {
          "address": "aws_instance.valid_large",
          "expressions": {
            "ami": {
              "references": [
                "data.aws_ami.ubuntu"
              ]
            },
            "instance_type": {
              "constant_value": "t2.large"
            }
          },
          "mode": "managed",
          "name": "valid_large",
          "provider_config_key": "aws",
          "schema_version": 1,
          "type": "aws_instance"
        },
        {
          "address": "aws_instance.valid_medium",
          "expressions": {
            "ami": {
              "references": [
                "data.aws_ami.ubuntu"
              ]
            },
            "instance_type": {
              "constant_value": "t2.medium"
            }
          },
          "mode": "managed",
          "name": "valid_medium",
          "provider_config_key": "aws",
          "schema_version": 1,
          "type": "aws_instance"
        },
        {
          "address": "aws_instance.valid_micro",
          "expressions": {
            "ami": {
              "references": [
                "data.aws_ami.ubuntu"
              ]
            },
            "instance_type": {
              "constant_value": "t2.micro"
            }
          },
          "mode": "managed",
          "name": "valid_micro",
          "provider_config_key": "aws",
          "schema_version": 1,
          "type": "aws_instance"
        },
        {
          "address": "aws_instance.valid_small",
          "expressions": {
            "ami": {
              "references": [
                "data.aws_ami.ubuntu"
              ]
            },
            "instance_type": {
              "constant_value": "t2.small"
            }
          },
          "mode": "managed",
          "name": "valid_small",
          "provider_config_key": "aws",
          "schema_version": 1,
          "type": "aws_instance"
        },
        {
          "address": "aws_instance.valid_xlarge",
          "expressions": {
            "ami": {
              "references": [
                "data.aws_ami.ubuntu"
              ]
            },
            "instance_type": {
              "constant_value": "t2.xlarge"
            }
          },
          "mode": "managed",
          "name": "valid_xlarge",
          "provider_config_key": "aws",
          "schema_version": 1,
          "type": "aws_instance"
        },
        {
          "address": "data.aws_ami.ubuntu",
          "expressions": {
            "filter": [
              {
                "name": {
                  "constant_value": "name"
                },
                "values": {
                  "constant_value": [
                    "ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"
                  ]
                }
              },
              {
                "name": {
                  "constant_value": "virtualization-type"
                },
                "values": {
                  "constant_value": [
                    "hvm"
                  ]
                }
              }
            ],
            "most_recent": {
              "constant_value": true
            },
            "owners": {
              "constant_value": [
                "099720109477"
              ]
            }
          },
          "mode": "data",
          "name": "ubuntu",
          "provider_config_key": "aws",
          "schema_version": 0,
          "type": "aws_ami"
        }
      ]
    }
  },
  "format_version": "0.1",
  "planned_values": {
    "root_module": {
      "resources": [
        {
          "address": "aws_instance.invalid",
          "mode": "managed",
          "name": "invalid",
          "provider_name": "registry.terraform.io/hashicorp/aws",
          "schema_version": 1,
          "type": "aws_instance",
          "values": {
            "ami": "ami-0bac6fc47ad07c5f5",
            "credit_specification": [],
            "disable_api_termination": null,
            "ebs_optimized": null,
            "get_password_data": false,
            "hibernation": null,
            "iam_instance_profile": null,
            "instance_type": "t2.nano",
            "monitoring": null,
            "source_dest_check": true,
            "tags": null,
            "timeouts": null,
            "user_data": null,
            "user_data_base64": null,
            "volume_tags": null
          }
        },
        {
          "address": "aws_instance.valid_2xlarge",
          "mode": "managed",
          "name": "valid_2xlarge",
          "provider_name": "registry.terraform.io/hashicorp/aws",
          "schema_version": 1,
          "type": "aws_instance",
          "values": {
            "ami": "ami-0bac6fc47ad07c5f5",
            "credit_specification": [],
            "disable_api_termination": null,
            "ebs_optimized": null,
            "get_password_data": false,
            "hibernation": null,
            "iam_instance_profile": null,
            "instance_type": "t2.2xlarge",
            "monitoring": null,
            "source_dest_check": true,
            "tags": null,
            "timeouts": null,
            "user_data": null,
            "user_data_base64": null,
            "volume_tags": null
          }
        },
        {
          "address": "aws_instance.valid_large",
          "mode": "managed",
          "name": "valid_large",
          "provider_name": "registry.terraform.io/hashicorp/aws",
          "schema_version": 1,
          "type": "aws_instance",
          "values": {
            "ami": "ami-0bac6fc47ad07c5f5",
            "credit_specification": [],
            "disable_api_termination": null,
            "ebs_optimized": null,
            "get_password_data": false,
            "hibernation": null,
            "iam_instance_profile": null,
            "instance_type": "t2.large",
            "monitoring": null,
            "source_dest_check": true,
            "tags": null,
            "timeouts": null,
            "user_data": null,
            "user_data_base64": null,
            "volume_tags": null
          }
        },
        {
          "address": "aws_instance.valid_medium",
          "mode": "managed",
          "name": "valid_medium",
          "provider_name": "registry.terraform.io/hashicorp/aws",
          "schema_version": 1,
          "type": "aws_instance",
          "values": {
            "ami": "ami-0bac6fc47ad07c5f5",
            "credit_specification": [],
            "disable_api_termination": null,
            "ebs_optimized": null,
            "get_password_data": false,
            "hibernation": null,
            "iam_instance_profile": null,
            "instance_type": "t2.medium",
            "monitoring": null,
            "source_dest_check": true,
            "tags": null,
            "timeouts": null,
            "user_data": null,
            "user_data_base64": null,
            "volume_tags": null
          }
        },
        {
          "address": "aws_instance.valid_micro",
          "mode": "managed",
          "name": "valid_micro",
          "provider_name": "registry.terraform.io/hashicorp/aws",
          "schema_version": 1,
          "type": "aws_instance",
          "values": {
            "ami": "ami-0bac6fc47ad07c5f5",
            "credit_specification": [],
            "disable_api_termination": null,
            "ebs_optimized": null,
            "get_password_data": false,
            "hibernation": null,
            "iam_instance_profile": null,
            "instance_type": "t2.micro",
            "monitoring": null,
            "source_dest_check": true,
            "tags": null,
            "timeouts": null,
            "user_data": null,
            "user_data_base64": null,
            "volume_tags": null
          }
        },
        {
          "address": "aws_instance.valid_small",
          "mode": "managed",
          "name": "valid_small",
          "provider_name": "registry.terraform.io/hashicorp/aws",
          "schema_version": 1,
          "type": "aws_instance",
          "values": {
            "ami": "ami-0bac6fc47ad07c5f5",
            "credit_specification": [],
            "disable_api_termination": null,
            "ebs_optimized": null,
            "get_password_data": false,
            "hibernation": null,
            "iam_instance_profile": null,
            "instance_type": "t2.small",
            "monitoring": null,
            "source_dest_check": true,
            "tags": null,
            "timeouts": null,
            "user_data": null,
            "user_data_base64": null,
            "volume_tags": null
          }
        },
        {
          "address": "aws_instance.valid_xlarge",
          "mode": "managed",
          "name": "valid_xlarge",
          "provider_name": "registry.terraform.io/hashicorp/aws",
          "schema_version": 1,
          "type": "aws_instance",
          "values": {
            "ami": "ami-0bac6fc47ad07c5f5",
            "credit_specification": [],
            "disable_api_termination": null,
            "ebs_optimized": null,
            "get_password_data": false,
            "hibernation": null,
            "iam_instance_profile": null,
            "instance_type": "t2.xlarge",
            "monitoring": null,
            "source_dest_check": true,
            "tags": null,
            "timeouts": null,
            "user_data": null,
            "user_data_base64": null,
            "volume_tags": null
          }
        },
        {
          "address": "data.aws_ami.ubuntu",
          "mode": "data",
          "name": "ubuntu",
          "provider_name": "registry.terraform.io/hashicorp/aws",
          "schema_version": 0,
          "type": "aws_ami",
          "values": {
            "architecture": "x86_64",
            "arn": "arn:aws:ec2:us-west-2::image/ami-0bac6fc47ad07c5f5",
            "block_device_mappings": [
              {
                "device_name": "/dev/sda1",
                "ebs": {
                  "delete_on_termination": "true",
                  "encrypted": "false",
                  "iops": "0",
                  "snapshot_id": "snap-013fb4433bd2108c7",
                  "throughput": "0",
                  "volume_size": "8",
                  "volume_type": "gp2"
                },
                "no_device": "",
                "virtual_name": ""
              },
              {
                "device_name": "/dev/sdb",
                "ebs": {},
                "no_device": "",
                "virtual_name": "ephemeral0"
              },
              {
                "device_name": "/dev/sdc",
                "ebs": {},
                "no_device": "",
                "virtual_name": "ephemeral1"
              }
            ],
            "creation_date": "2019-11-11T13:13:47.000Z",
            "description": "Canonical, Ubuntu, 14.04 LTS, amd64 trusty image build on 2019-11-07",
            "ena_support": true,
            "executable_users": null,
            "filter": [
              {
                "name": "name",
                "values": [
                  "ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"
                ]
              },
              {
                "name": "virtualization-type",
                "values": [
                  "hvm"
                ]
              }
            ],
            "hypervisor": "xen",
            "id": "ami-0bac6fc47ad07c5f5",
            "image_id": "ami-0bac6fc47ad07c5f5",
            "image_location": "099720109477/ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-20191107",
            "image_owner_alias": null,
            "image_type": "machine",
            "kernel_id": null,
            "most_recent": true,
            "name": "ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-20191107",
            "name_regex": null,
            "owner_id": "099720109477",
            "owners": [
              "099720109477"
            ],
            "platform": null,
            "platform_details": "Linux/UNIX",
            "product_codes": [],
            "public": true,
            "ramdisk_id": null,
            "root_device_name": "/dev/sda1",
            "root_device_type": "ebs",
            "root_snapshot_id": "snap-013fb4433bd2108c7",
            "sriov_net_support": "simple",
            "state": "available",
            "state_reason": {
              "code": "UNSET",
              "message": "UNSET"
            },
            "tags": {},
            "usage_operation": "RunInstances",
            "virtualization_type": "hvm"
          }
        }
      ]
    }
  },
  "resource_changes": [
    {
      "address": "aws_instance.invalid",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "ami": "ami-0bac6fc47ad07c5f5",
          "credit_specification": [],
          "disable_api_termination": null,
          "ebs_optimized": null,
          "get_password_data": false,
          "hibernation": null,
          "iam_instance_profile": null,
          "instance_type": "t2.nano",
          "monitoring": null,
          "source_dest_check": true,
          "tags": null,
          "timeouts": null,
          "user_data": null,
          "user_data_base64": null,
          "volume_tags": null
        },
        "after_unknown": {
          "arn": true,
          "associate_public_ip_address": true,
          "availability_zone": true,
          "cpu_core_count": true,
          "cpu_threads_per_core": true,
          "credit_specification": [],
          "ebs_block_device": true,
          "enclave_options": true,
          "ephemeral_block_device": true,
          "host_id": true,
          "id": true,
          "instance_initiated_shutdown_behavior": true,
          "instance_state": true,
          "ipv6_address_count": true,
          "ipv6_addresses": true,
          "key_name": true,
          "metadata_options": true,
          "network_interface": true,
          "outpost_arn": true,
          "password_data": true,
          "placement_group": true,
          "primary_network_interface_id": true,
          "private_dns": true,
          "private_ip": true,
          "public_dns": true,
          "public_ip": true,
          "root_block_device": true,
          "secondary_private_ips": true,
          "security_groups": true,
          "subnet_id": true,
          "tags_all": true,
          "tenancy": true,
          "vpc_security_group_ids": true
        },
        "before": null
      },
      "mode": "managed",
      "name": "invalid",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_instance"
    },
    {
      "address": "aws_instance.valid_2xlarge",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "ami": "ami-0bac6fc47ad07c5f5",
          "credit_specification": [],
          "disable_api_termination": null,
          "ebs_optimized": null,
          "get_password_data": false,
          "hibernation": null,
          "iam_instance_profile": null,
          "instance_type": "t2.2xlarge",
          "monitoring": null,
          "source_dest_check": true,
          "tags": null,
          "timeouts": null,
          "user_data": null,
          "user_data_base64": null,
          "volume_tags": null
        },
        "after_unknown": {
          "arn": true,
          "associate_public_ip_address": true,
          "availability_zone": true,
          "cpu_core_count": true,
          "cpu_threads_per_core": true,
          "credit_specification": [],
          "ebs_block_device": true,
          "enclave_options": true,
          "ephemeral_block_device": true,
          "host_id": true,
          "id": true,
          "instance_initiated_shutdown_behavior": true,
          "instance_state": true,
          "ipv6_address_count": true,
          "ipv6_addresses": true,
          "key_name": true,
          "metadata_options": true,
          "network_interface": true,
          "outpost_arn": true,
          "password_data": true,
          "placement_group": true,
          "primary_network_interface_id": true,
          "private_dns": true,
          "private_ip": true,
          "public_dns": true,
          "public_ip": true,
          "root_block_device": true,
          "secondary_private_ips": true,
          "security_groups": true,
          "subnet_id": true,
          "tags_all": true,
          "tenancy": true,
          "vpc_security_group_ids": true
        },
        "before": null
      },
      "mode": "managed",
      "name": "valid_2xlarge",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_instance"
    },
    {
      "address": "aws_instance.valid_large",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "ami": "ami-0bac6fc47ad07c5f5",
          "credit_specification": [],
          "disable_api_termination": null,
          "ebs_optimized": null,
          "get_password_data": false,
          "hibernation": null,
          "iam_instance_profile": null,
          "instance_type": "t2.large",
          "monitoring": null,
          "source_dest_check": true,
          "tags": null,
          "timeouts": null,
          "user_data": null,
          "user_data_base64": null,
          "volume_tags": null
        },
        "after_unknown": {
          "arn": true,
          "associate_public_ip_address": true,
          "availability_zone": true,
          "cpu_core_count": true,
          "cpu_threads_per_core": true,
          "credit_specification": [],
          "ebs_block_device": true,
          "enclave_options": true,
          "ephemeral_block_device": true,
          "host_id": true,
          "id": true,
          "instance_initiated_shutdown_behavior": true,
          "instance_state": true,
          "ipv6_address_count": true,
          "ipv6_addresses": true,
          "key_name": true,
          "metadata_options": true,
          "network_interface": true,
          "outpost_arn": true,
          "password_data": true,
          "placement_group": true,
          "primary_network_interface_id": true,
          "private_dns": true,
          "private_ip": true,
          "public_dns": true,
          "public_ip": true,
          "root_block_device": true,
          "secondary_private_ips": true,
          "security_groups": true,
          "subnet_id": true,
          "tags_all": true,
          "tenancy": true,
          "vpc_security_group_ids": true
        },
        "before": null
      },
      "mode": "managed",
      "name": "valid_large",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_instance"
    },
    {
      "address": "aws_instance.valid_medium",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "ami": "ami-0bac6fc47ad07c5f5",
          "credit_specification": [],
          "disable_api_termination": null,
          "ebs_optimized": null,
          "get_password_data": false,
          "hibernation": null,
          "iam_instance_profile": null,
          "instance_type": "t2.medium",
          "monitoring": null,
          "source_dest_check": true,
          "tags": null,
          "timeouts": null,
          "user_data": null,
          "user_data_base64": null,
          "volume_tags": null
        },
        "after_unknown": {
          "arn": true,
          "associate_public_ip_address": true,
          "availability_zone": true,
          "cpu_core_count": true,
          "cpu_threads_per_core": true,
          "credit_specification": [],
          "ebs_block_device": true,
          "enclave_options": true,
          "ephemeral_block_device": true,
          "host_id": true,
          "id": true,
          "instance_initiated_shutdown_behavior": true,
          "instance_state": true,
          "ipv6_address_count": true,
          "ipv6_addresses": true,
          "key_name": true,
          "metadata_options": true,
          "network_interface": true,
          "outpost_arn": true,
          "password_data": true,
          "placement_group": true,
          "primary_network_interface_id": true,
          "private_dns": true,
          "private_ip": true,
          "public_dns": true,
          "public_ip": true,
          "root_block_device": true,
          "secondary_private_ips": true,
          "security_groups": true,
          "subnet_id": true,
          "tags_all": true,
          "tenancy": true,
          "vpc_security_group_ids": true
        },
        "before": null
      },
      "mode": "managed",
      "name": "valid_medium",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_instance"
    },
    {
      "address": "aws_instance.valid_micro",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "ami": "ami-0bac6fc47ad07c5f5",
          "credit_specification": [],
          "disable_api_termination": null,
          "ebs_optimized": null,
          "get_password_data": false,
          "hibernation": null,
          "iam_instance_profile": null,
          "instance_type": "t2.micro",
          "monitoring": null,
          "source_dest_check": true,
          "tags": null,
          "timeouts": null,
          "user_data": null,
          "user_data_base64": null,
          "volume_tags": null
        },
        "after_unknown": {
          "arn": true,
          "associate_public_ip_address": true,
          "availability_zone": true,
          "cpu_core_count": true,
          "cpu_threads_per_core": true,
          "credit_specification": [],
          "ebs_block_device": true,
          "enclave_options": true,
          "ephemeral_block_device": true,
          "host_id": true,
          "id": true,
          "instance_initiated_shutdown_behavior": true,
          "instance_state": true,
          "ipv6_address_count": true,
          "ipv6_addresses": true,
          "key_name": true,
          "metadata_options": true,
          "network_interface": true,
          "outpost_arn": true,
          "password_data": true,
          "placement_group": true,
          "primary_network_interface_id": true,
          "private_dns": true,
          "private_ip": true,
          "public_dns": true,
          "public_ip": true,
          "root_block_device": true,
          "secondary_private_ips": true,
          "security_groups": true,
          "subnet_id": true,
          "tags_all": true,
          "tenancy": true,
          "vpc_security_group_ids": true
        },
        "before": null
      },
      "mode": "managed",
      "name": "valid_micro",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_instance"
    },
    {
      "address": "aws_instance.valid_small",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "ami": "ami-0bac6fc47ad07c5f5",
          "credit_specification": [],
          "disable_api_termination": null,
          "ebs_optimized": null,
          "get_password_data": false,
          "hibernation": null,
          "iam_instance_profile": null,
          "instance_type": "t2.small",
          "monitoring": null,
          "source_dest_check": true,
          "tags": null,
          "timeouts": null,
          "user_data": null,
          "user_data_base64": null,
          "volume_tags": null
        },
        "after_unknown": {
          "arn": true,
          "associate_public_ip_address": true,
          "availability_zone": true,
          "cpu_core_count": true,
          "cpu_threads_per_core": true,
          "credit_specification": [],
          "ebs_block_device": true,
          "enclave_options": true,
          "ephemeral_block_device": true,
          "host_id": true,
          "id": true,
          "instance_initiated_shutdown_behavior": true,
          "instance_state": true,
          "ipv6_address_count": true,
          "ipv6_addresses": true,
          "key_name": true,
          "metadata_options": true,
          "network_interface": true,
          "outpost_arn": true,
          "password_data": true,
          "placement_group": true,
          "primary_network_interface_id": true,
          "private_dns": true,
          "private_ip": true,
          "public_dns": true,
          "public_ip": true,
          "root_block_device": true,
          "secondary_private_ips": true,
          "security_groups": true,
          "subnet_id": true,
          "tags_all": true,
          "tenancy": true,
          "vpc_security_group_ids": true
        },
        "before": null
      },
      "mode": "managed",
      "name": "valid_small",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_instance"
    },
    {
      "address": "aws_instance.valid_xlarge",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "ami": "ami-0bac6fc47ad07c5f5",
          "credit_specification": [],
          "disable_api_termination": null,
          "ebs_optimized": null,
          "get_password_data": false,
          "hibernation": null,
          "iam_instance_profile": null,
          "instance_type": "t2.xlarge",
          "monitoring": null,
          "source_dest_check": true,
          "tags": null,
          "timeouts": null,
          "user_data": null,
          "user_data_base64": null,
          "volume_tags": null
        },
        "after_unknown": {
          "arn": true,
          "associate_public_ip_address": true,
          "availability_zone": true,
          "cpu_core_count": true,
          "cpu_threads_per_core": true,
          "credit_specification": [],
          "ebs_block_device": true,
          "enclave_options": true,
          "ephemeral_block_device": true,
          "host_id": true,
          "id": true,
          "instance_initiated_shutdown_behavior": true,
          "instance_state": true,
          "ipv6_address_count": true,
          "ipv6_addresses": true,
          "key_name": true,
          "metadata_options": true,
          "network_interface": true,
          "outpost_arn": true,
          "password_data": true,
          "placement_group": true,
          "primary_network_interface_id": true,
          "private_dns": true,
          "private_ip": true,
          "public_dns": true,
          "public_ip": true,
          "root_block_device": true,
          "secondary_private_ips": true,
          "security_groups": true,
          "subnet_id": true,
          "tags_all": true,
          "tenancy": true,
          "vpc_security_group_ids": true
        },
        "before": null
      },
      "mode": "managed",
      "name": "valid_xlarge",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_instance"
    },
    {
      "address": "data.aws_ami.ubuntu",
      "change": {
        "actions": [
          "read"
        ],
        "after": {
          "architecture": "x86_64",
          "arn": "arn:aws:ec2:us-west-2::image/ami-0bac6fc47ad07c5f5",
          "block_device_mappings": [
            {
              "device_name": "/dev/sda1",
              "ebs": {
                "delete_on_termination": "true",
                "encrypted": "false",
                "iops": "0",
                "snapshot_id": "snap-013fb4433bd2108c7",
                "throughput": "0",
                "volume_size": "8",
                "volume_type": "gp2"
              },
              "no_device": "",
              "virtual_name": ""
            },
            {
              "device_name": "/dev/sdb",
              "ebs": {},
              "no_device": "",
              "virtual_name": "ephemeral0"
            },
            {
              "device_name": "/dev/sdc",
              "ebs": {},
              "no_device": "",
              "virtual_name": "ephemeral1"
            }
          ],
          "creation_date": "2019-11-11T13:13:47.000Z",
          "description": "Canonical, Ubuntu, 14.04 LTS, amd64 trusty image build on 2019-11-07",
          "ena_support": true,
          "executable_users": null,
          "filter": [
            {
              "name": "name",
              "values": [
                "ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"
              ]
            },
            {
              "name": "virtualization-type",
              "values": [
                "hvm"
              ]
            }
          ],
          "hypervisor": "xen",
          "id": "ami-0bac6fc47ad07c5f5",
          "image_id": "ami-0bac6fc47ad07c5f5",
          "image_location": "099720109477/ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-20191107",
          "image_owner_alias": null,
          "image_type": "machine",
          "kernel_id": null,
          "most_recent": true,
          "name": "ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-20191107",
          "name_regex": null,
          "owner_id": "099720109477",
          "owners": [
            "099720109477"
          ],
          "platform": null,
          "platform_details": "Linux/UNIX",
          "product_codes": [],
          "public": true,
          "ramdisk_id": null,
          "root_device_name": "/dev/sda1",
          "root_device_type": "ebs",
          "root_snapshot_id": "snap-013fb4433bd2108c7",
          "sriov_net_support": "simple",
          "state": "available",
          "state_reason": {
            "code": "UNSET",
            "message": "UNSET"
          },
          "tags": {},
          "usage_operation": "RunInstances",
          "virtualization_type": "hvm"
        },
        "after_unknown": {},
        "before": null
      },
      "mode": "data",
      "name": "ubuntu",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_ami"
    }
  ],
  "terraform_version": "0.13.5"
}

