# Copyright 2020 Fugue, Inc.
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

# This package was automatically generated from:
#
#     tests/rules/aws/inputs/ebs_volume_encrypted_infra.tf
#
# using `generate_test_inputs.sh` and should not be modified
# directly.
package tests.rules.ebs_volume_encrypted
mock_input = {
  "format_version": "0.1",
  "terraform_version": "0.12.18",
  "planned_values": {
    "root_module": {
      "resources": [
        {
          "address": "aws_ebs_volume.bad",
          "mode": "managed",
          "type": "aws_ebs_volume",
          "name": "bad",
          "provider_name": "aws",
          "schema_version": 0,
          "values": {
            "availability_zone": "us-west-2a",
            "encrypted": false,
            "size": 40,
            "tags": null
          }
        },
        {
          "address": "aws_ebs_volume.good",
          "mode": "managed",
          "type": "aws_ebs_volume",
          "name": "good",
          "provider_name": "aws",
          "schema_version": 0,
          "values": {
            "availability_zone": "us-west-2a",
            "encrypted": true,
            "size": 40,
            "tags": null
          }
        },
        {
          "address": "aws_ebs_volume.missing",
          "mode": "managed",
          "type": "aws_ebs_volume",
          "name": "missing",
          "provider_name": "aws",
          "schema_version": 0,
          "values": {
            "availability_zone": "us-west-2a",
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
      "mode": "managed",
      "type": "aws_ebs_volume",
      "name": "bad",
      "provider_name": "aws",
      "change": {
        "actions": [
          "create"
        ],
        "before": null,
        "after": {
          "availability_zone": "us-west-2a",
          "encrypted": false,
          "size": 40,
          "tags": null
        },
        "after_unknown": {
          "arn": true,
          "id": true,
          "iops": true,
          "kms_key_id": true,
          "snapshot_id": true,
          "type": true
        }
      }
    },
    {
      "address": "aws_ebs_volume.good",
      "mode": "managed",
      "type": "aws_ebs_volume",
      "name": "good",
      "provider_name": "aws",
      "change": {
        "actions": [
          "create"
        ],
        "before": null,
        "after": {
          "availability_zone": "us-west-2a",
          "encrypted": true,
          "size": 40,
          "tags": null
        },
        "after_unknown": {
          "arn": true,
          "id": true,
          "iops": true,
          "kms_key_id": true,
          "snapshot_id": true,
          "type": true
        }
      }
    },
    {
      "address": "aws_ebs_volume.missing",
      "mode": "managed",
      "type": "aws_ebs_volume",
      "name": "missing",
      "provider_name": "aws",
      "change": {
        "actions": [
          "create"
        ],
        "before": null,
        "after": {
          "availability_zone": "us-west-2a",
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
          "type": true
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
            "constant_value": "us-east-2"
          }
        }
      }
    },
    "root_module": {
      "resources": [
        {
          "address": "aws_ebs_volume.bad",
          "mode": "managed",
          "type": "aws_ebs_volume",
          "name": "bad",
          "provider_config_key": "aws",
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
          "schema_version": 0
        },
        {
          "address": "aws_ebs_volume.good",
          "mode": "managed",
          "type": "aws_ebs_volume",
          "name": "good",
          "provider_config_key": "aws",
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
          "schema_version": 0
        },
        {
          "address": "aws_ebs_volume.missing",
          "mode": "managed",
          "type": "aws_ebs_volume",
          "name": "missing",
          "provider_config_key": "aws",
          "expressions": {
            "availability_zone": {
              "constant_value": "us-west-2a"
            },
            "size": {
              "constant_value": 40
            }
          },
          "schema_version": 0
        }
      ]
    }
  }
}
