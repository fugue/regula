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
package tests.lib.inputs.volume_encrypted_infra_json

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
      }
    },
    "root_module": {
      "resources": [
        {
          "address": "aws_ebs_volume.bad",
          "expressions": {
            "availability_zone": {
              "constant_value": "us-west-2a"
            },
            "encrypted": {
              "constant_value": false
            },
            "size": {
              "constant_value": 40
            }
          },
          "mode": "managed",
          "name": "bad",
          "provider_config_key": "aws",
          "schema_version": 0,
          "type": "aws_ebs_volume"
        },
        {
          "address": "aws_ebs_volume.good",
          "expressions": {
            "availability_zone": {
              "constant_value": "us-west-2a"
            },
            "encrypted": {
              "constant_value": true
            },
            "size": {
              "constant_value": 40
            }
          },
          "mode": "managed",
          "name": "good",
          "provider_config_key": "aws",
          "schema_version": 0,
          "type": "aws_ebs_volume"
        },
        {
          "address": "aws_ebs_volume.missing",
          "expressions": {
            "availability_zone": {
              "constant_value": "us-west-2a"
            },
            "size": {
              "constant_value": 40
            }
          },
          "mode": "managed",
          "name": "missing",
          "provider_config_key": "aws",
          "schema_version": 0,
          "type": "aws_ebs_volume"
        }
      ]
    }
  },
  "format_version": "0.1",
  "planned_values": {
    "root_module": {
      "resources": [
        {
          "address": "aws_ebs_volume.bad",
          "mode": "managed",
          "name": "bad",
          "provider_name": "registry.terraform.io/hashicorp/aws",
          "schema_version": 0,
          "type": "aws_ebs_volume",
          "values": {
            "availability_zone": "us-west-2a",
            "encrypted": false,
            "multi_attach_enabled": null,
            "outpost_arn": null,
            "size": 40,
            "tags": null
          }
        },
        {
          "address": "aws_ebs_volume.good",
          "mode": "managed",
          "name": "good",
          "provider_name": "registry.terraform.io/hashicorp/aws",
          "schema_version": 0,
          "type": "aws_ebs_volume",
          "values": {
            "availability_zone": "us-west-2a",
            "encrypted": true,
            "multi_attach_enabled": null,
            "outpost_arn": null,
            "size": 40,
            "tags": null
          }
        },
        {
          "address": "aws_ebs_volume.missing",
          "mode": "managed",
          "name": "missing",
          "provider_name": "registry.terraform.io/hashicorp/aws",
          "schema_version": 0,
          "type": "aws_ebs_volume",
          "values": {
            "availability_zone": "us-west-2a",
            "multi_attach_enabled": null,
            "outpost_arn": null,
            "size": 40,
            "tags": null
          }
        }
      ]
    }
  },
  "resource_changes": [
    {
      "address": "aws_ebs_volume.bad",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "availability_zone": "us-west-2a",
          "encrypted": false,
          "multi_attach_enabled": null,
          "outpost_arn": null,
          "size": 40,
          "tags": null
        },
        "after_unknown": {
          "arn": true,
          "id": true,
          "iops": true,
          "kms_key_id": true,
          "snapshot_id": true,
          "tags_all": true,
          "throughput": true,
          "type": true
        },
        "before": null
      },
      "mode": "managed",
      "name": "bad",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_ebs_volume"
    },
    {
      "address": "aws_ebs_volume.good",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "availability_zone": "us-west-2a",
          "encrypted": true,
          "multi_attach_enabled": null,
          "outpost_arn": null,
          "size": 40,
          "tags": null
        },
        "after_unknown": {
          "arn": true,
          "id": true,
          "iops": true,
          "kms_key_id": true,
          "snapshot_id": true,
          "tags_all": true,
          "throughput": true,
          "type": true
        },
        "before": null
      },
      "mode": "managed",
      "name": "good",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_ebs_volume"
    },
    {
      "address": "aws_ebs_volume.missing",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "availability_zone": "us-west-2a",
          "multi_attach_enabled": null,
          "outpost_arn": null,
          "size": 40,
          "tags": null
        },
        "after_unknown": {
          "arn": true,
          "encrypted": true,
          "id": true,
          "iops": true,
          "kms_key_id": true,
          "snapshot_id": true,
          "tags_all": true,
          "throughput": true,
          "type": true
        },
        "before": null
      },
      "mode": "managed",
      "name": "missing",
      "provider_name": "registry.terraform.io/hashicorp/aws",
      "type": "aws_ebs_volume"
    }
  ],
  "terraform_version": "0.13.5"
}

