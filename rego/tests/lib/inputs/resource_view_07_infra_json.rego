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
      },
      "google": {
        "name": "google"
      }
    },
    "root_module": {
      "resources": [
        {
          "address": "aws_autoscaling_group.example",
          "expressions": {
            "availability_zones": {
              "constant_value": [
                "us-east-1a"
              ]
            },
            "desired_capacity": {
              "constant_value": 1
            },
            "launch_template": [
              {
                "id": {
                  "references": [
                    "aws_launch_template.example"
                  ]
                },
                "version": {
                  "constant_value": "$Latest"
                }
              }
            ],
            "max_size": {
              "constant_value": 1
            },
            "min_size": {
              "constant_value": 1
            },
            "tag": [
              {
                "key": {
                  "constant_value": "Stage"
                },
                "propagate_at_launch": {
                  "constant_value": true
                },
                "value": {
                  "constant_value": "Dev"
                }
              }
            ]
          },
          "mode": "managed",
          "name": "example",
          "provider_config_key": "aws",
          "schema_version": 0,
          "type": "aws_autoscaling_group"
        },
        {
          "address": "aws_launch_template.example",
          "expressions": {
            "image_id": {
              "constant_value": "ami-1a2b3c"
            },
            "instance_type": {
              "constant_value": "t2.micro"
            },
            "name_prefix": {
              "constant_value": "example"
            }
          },
          "mode": "managed",
          "name": "example",
          "provider_config_key": "aws",
          "schema_version": 0,
          "type": "aws_launch_template"
        },
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
        },
        {
          "address": "google_compute_instance.default",
          "expressions": {
            "boot_disk": [
              {
                "initialize_params": [
                  {
                    "image": {
                      "constant_value": "debian-cloud/debian-9"
                    }
                  }
                ]
              }
            ],
            "machine_type": {
              "constant_value": "e2-medium"
            },
            "name": {
              "constant_value": "test"
            },
            "network_interface": [
              {
                "access_config": [
                  {}
                ],
                "network": {
                  "constant_value": "default"
                }
              }
            ],
            "scratch_disk": [
              {
                "interface": {
                  "constant_value": "SCSI"
                }
              }
            ],
            "tags": {
              "constant_value": [
                "foo",
                "bar"
              ]
            },
            "zone": {
              "constant_value": "us-central1-a"
            }
          },
          "mode": "managed",
          "name": "default",
          "provider_config_key": "google",
          "schema_version": 6,
          "type": "google_compute_instance"
        },
        {
          "address": "google_storage_bucket.example",
          "expressions": {
            "labels": {
              "constant_value": {
                "Stage": "Prod"
              }
            },
            "location": {
              "constant_value": "US"
            },
            "name": {
              "constant_value": "example"
            }
          },
          "mode": "managed",
          "name": "example",
          "provider_config_key": "google",
          "schema_version": 0,
          "type": "google_storage_bucket"
        }
      ]
    }
  },
  "format_version": "0.1",
  "planned_values": {
    "root_module": {
      "resources": [
        {
          "address": "aws_autoscaling_group.example",
          "mode": "managed",
          "name": "example",
          "provider_name": "registry.terraform.io/hashicorp/aws",
          "schema_version": 0,
          "type": "aws_autoscaling_group",
          "values": {
            "availability_zones": [
              "us-east-1a"
            ],
            "capacity_rebalance": null,
            "desired_capacity": 1,
            "enabled_metrics": null,
            "force_delete": false,
            "force_delete_warm_pool": false,
            "health_check_grace_period": 300,
            "initial_lifecycle_hook": [],
            "instance_refresh": [],
            "launch_configuration": null,
            "launch_template": [
              {
                "version": "$Latest"
              }
            ],
            "load_balancers": null,
            "max_instance_lifetime": null,
            "max_size": 1,
            "metrics_granularity": "1Minute",
            "min_elb_capacity": null,
            "min_size": 1,
            "mixed_instances_policy": [],
            "placement_group": null,
            "protect_from_scale_in": false,
            "suspended_processes": null,
            "tag": [
              {
                "key": "Stage",
                "propagate_at_launch": true,
                "value": "Dev"
              }
            ],
            "tags": null,
            "target_group_arns": null,
            "termination_policies": null,
            "timeouts": null,
            "wait_for_capacity_timeout": "10m",
            "wait_for_elb_capacity": null,
            "warm_pool": []
          }
        },
        {
          "address": "aws_launch_template.example",
          "mode": "managed",
          "name": "example",
          "provider_name": "registry.terraform.io/hashicorp/aws",
          "schema_version": 0,
          "type": "aws_launch_template",
          "values": {
            "block_device_mappings": [],
            "capacity_reservation_specification": [],
            "cpu_options": [],
            "credit_specification": [],
            "description": null,
            "disable_api_termination": null,
            "ebs_optimized": null,
            "elastic_gpu_specifications": [],
            "elastic_inference_accelerator": [],
            "enclave_options": [],
            "hibernation_options": [],
            "iam_instance_profile": [],
            "image_id": "ami-1a2b3c",
            "instance_initiated_shutdown_behavior": null,
            "instance_market_options": [],
            "instance_type": "t2.micro",
            "kernel_id": null,
            "key_name": null,
            "license_specification": [],
            "monitoring": [],
            "name_prefix": "example",
            "network_interfaces": [],
            "placement": [],
            "ram_disk_id": null,
            "security_group_names": null,
            "tag_specifications": [],
            "tags": null,
            "update_default_version": null,
            "user_data": null,
            "vpc_security_group_ids": null
          }
        },
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
        },
        {
          "address": "google_compute_instance.default",
          "mode": "managed",
          "name": "default",
          "provider_name": "registry.terraform.io/hashicorp/google",
          "schema_version": 6,
          "type": "google_compute_instance",
          "values": {
            "advanced_machine_features": [],
            "allow_stopping_for_update": null,
            "attached_disk": [],
            "boot_disk": [
              {
                "auto_delete": true,
                "disk_encryption_key_raw": null,
                "initialize_params": [
                  {
                    "image": "debian-cloud/debian-9"
                  }
                ],
                "mode": "READ_WRITE"
              }
            ],
            "can_ip_forward": false,
            "deletion_protection": false,
            "description": null,
            "desired_status": null,
            "enable_display": null,
            "hostname": null,
            "labels": null,
            "machine_type": "e2-medium",
            "metadata": null,
            "metadata_startup_script": null,
            "name": "test",
            "network_interface": [
              {
                "access_config": [
                  {
                    "public_ptr_domain_name": null
                  }
                ],
                "alias_ip_range": [],
                "ipv6_access_config": [],
                "network": "default",
                "nic_type": null,
                "queue_count": null
              }
            ],
            "resource_policies": null,
            "scratch_disk": [
              {
                "interface": "SCSI"
              }
            ],
            "service_account": [],
            "shielded_instance_config": [],
            "tags": [
              "bar",
              "foo"
            ],
            "timeouts": null,
            "zone": "us-central1-a"
          }
        },
        {
          "address": "google_storage_bucket.example",
          "mode": "managed",
          "name": "example",
          "provider_name": "registry.terraform.io/hashicorp/google",
          "schema_version": 0,
          "type": "google_storage_bucket",
          "values": {
            "cors": [],
            "default_event_based_hold": null,
            "encryption": [],
            "force_destroy": false,
            "labels": {
              "Stage": "Prod"
            },
            "lifecycle_rule": [],
            "location": "US",
            "logging": [],
            "name": "example",
            "requester_pays": null,
            "retention_policy": [],
            "storage_class": "STANDARD",
            "timeouts": null,
            "versioning": [],
            "website": []
          }
        }
      ]
    }
  },
  "resource_changes": [
    {
      "address": "aws_autoscaling_group.example",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "availability_zones": [
            "us-east-1a"
          ],
          "capacity_rebalance": null,
          "desired_capacity": 1,
          "enabled_metrics": null,
          "force_delete": false,
          "force_delete_warm_pool": false,
          "health_check_grace_period": 300,
          "initial_lifecycle_hook": [],
          "instance_refresh": [],
          "launch_configuration": null,
          "launch_template": [
            {
              "version": "$Latest"
            }
          ],
          "load_balancers": null,
          "max_instance_lifetime": null,
          "max_size": 1,
          "metrics_granularity": "1Minute",
          "min_elb_capacity": null,
          "min_size": 1,
          "mixed_instances_policy": [],
          "placement_group": null,
          "protect_from_scale_in": false,
          "suspended_processes": null,
          "tag": [
            {
              "key": "Stage",
              "propagate_at_launch": true,
              "value": "Dev"
            }
          ],
          "tags": null,
          "target_group_arns": null,
          "termination_policies": null,
          "timeouts": null,
          "wait_for_capacity_timeout": "10m",
          "wait_for_elb_capacity": null,
          "warm_pool": []
        },
        "after_unknown": {
          "arn": true,
          "availability_zones": [
            false
          ],
          "default_cooldown": true,
          "health_check_type": true,
          "id": true,
          "initial_lifecycle_hook": [],
          "instance_refresh": [],
          "launch_template": [
            {
              "id": true,
              "name": true
            }
          ],
          "mixed_instances_policy": [],
          "name": true,
          "name_prefix": true,
          "service_linked_role_arn": true,
          "tag": [
            {}
          ],
          "vpc_zone_identifier": true,
          "warm_pool": []
        },
        "before": null
      },
      "mode": "managed",
      "name": "example",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_autoscaling_group"
    },
    {
      "address": "aws_launch_template.example",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "block_device_mappings": [],
          "capacity_reservation_specification": [],
          "cpu_options": [],
          "credit_specification": [],
          "description": null,
          "disable_api_termination": null,
          "ebs_optimized": null,
          "elastic_gpu_specifications": [],
          "elastic_inference_accelerator": [],
          "enclave_options": [],
          "hibernation_options": [],
          "iam_instance_profile": [],
          "image_id": "ami-1a2b3c",
          "instance_initiated_shutdown_behavior": null,
          "instance_market_options": [],
          "instance_type": "t2.micro",
          "kernel_id": null,
          "key_name": null,
          "license_specification": [],
          "monitoring": [],
          "name_prefix": "example",
          "network_interfaces": [],
          "placement": [],
          "ram_disk_id": null,
          "security_group_names": null,
          "tag_specifications": [],
          "tags": null,
          "update_default_version": null,
          "user_data": null,
          "vpc_security_group_ids": null
        },
        "after_unknown": {
          "arn": true,
          "block_device_mappings": [],
          "capacity_reservation_specification": [],
          "cpu_options": [],
          "credit_specification": [],
          "default_version": true,
          "elastic_gpu_specifications": [],
          "elastic_inference_accelerator": [],
          "enclave_options": [],
          "hibernation_options": [],
          "iam_instance_profile": [],
          "id": true,
          "instance_market_options": [],
          "latest_version": true,
          "license_specification": [],
          "metadata_options": true,
          "monitoring": [],
          "name": true,
          "network_interfaces": [],
          "placement": [],
          "tag_specifications": [],
          "tags_all": true
        },
        "before": null
      },
      "mode": "managed",
      "name": "example",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_launch_template"
    },
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
    },
    {
      "address": "google_compute_instance.default",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "advanced_machine_features": [],
          "allow_stopping_for_update": null,
          "attached_disk": [],
          "boot_disk": [
            {
              "auto_delete": true,
              "disk_encryption_key_raw": null,
              "initialize_params": [
                {
                  "image": "debian-cloud/debian-9"
                }
              ],
              "mode": "READ_WRITE"
            }
          ],
          "can_ip_forward": false,
          "deletion_protection": false,
          "description": null,
          "desired_status": null,
          "enable_display": null,
          "hostname": null,
          "labels": null,
          "machine_type": "e2-medium",
          "metadata": null,
          "metadata_startup_script": null,
          "name": "test",
          "network_interface": [
            {
              "access_config": [
                {
                  "public_ptr_domain_name": null
                }
              ],
              "alias_ip_range": [],
              "ipv6_access_config": [],
              "network": "default",
              "nic_type": null,
              "queue_count": null
            }
          ],
          "resource_policies": null,
          "scratch_disk": [
            {
              "interface": "SCSI"
            }
          ],
          "service_account": [],
          "shielded_instance_config": [],
          "tags": [
            "bar",
            "foo"
          ],
          "timeouts": null,
          "zone": "us-central1-a"
        },
        "after_unknown": {
          "advanced_machine_features": [],
          "attached_disk": [],
          "boot_disk": [
            {
              "device_name": true,
              "disk_encryption_key_sha256": true,
              "initialize_params": [
                {
                  "labels": true,
                  "size": true,
                  "type": true
                }
              ],
              "kms_key_self_link": true,
              "source": true
            }
          ],
          "confidential_instance_config": true,
          "cpu_platform": true,
          "current_status": true,
          "guest_accelerator": true,
          "id": true,
          "instance_id": true,
          "label_fingerprint": true,
          "metadata_fingerprint": true,
          "min_cpu_platform": true,
          "network_interface": [
            {
              "access_config": [
                {
                  "nat_ip": true,
                  "network_tier": true
                }
              ],
              "alias_ip_range": [],
              "ipv6_access_config": [],
              "ipv6_access_type": true,
              "name": true,
              "network_ip": true,
              "stack_type": true,
              "subnetwork": true,
              "subnetwork_project": true
            }
          ],
          "project": true,
          "reservation_affinity": true,
          "scheduling": true,
          "scratch_disk": [
            {}
          ],
          "self_link": true,
          "service_account": [],
          "shielded_instance_config": [],
          "tags": [
            false,
            false
          ],
          "tags_fingerprint": true
        },
        "before": null
      },
      "mode": "managed",
      "name": "default",
      "provider_name": "registry.terraform.io/hashicorp/google",
      "type": "google_compute_instance"
    },
    {
      "address": "google_storage_bucket.example",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "cors": [],
          "default_event_based_hold": null,
          "encryption": [],
          "force_destroy": false,
          "labels": {
            "Stage": "Prod"
          },
          "lifecycle_rule": [],
          "location": "US",
          "logging": [],
          "name": "example",
          "requester_pays": null,
          "retention_policy": [],
          "storage_class": "STANDARD",
          "timeouts": null,
          "versioning": [],
          "website": []
        },
        "after_unknown": {
          "cors": [],
          "encryption": [],
          "id": true,
          "labels": {},
          "lifecycle_rule": [],
          "logging": [],
          "project": true,
          "retention_policy": [],
          "self_link": true,
          "uniform_bucket_level_access": true,
          "url": true,
          "versioning": [],
          "website": []
        },
        "before": null
      },
      "mode": "managed",
      "name": "example",
      "provider_name": "registry.terraform.io/hashicorp/google",
      "type": "google_storage_bucket"
    }
  ],
  "terraform_version": "0.13.7"
}

