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
package tests.rules.tf.aws.security_group.inputs.ingress_anywhere_infra_tf

import data.fugue.resource_view.resource_view_input

mock_input := ret {
  ret = resource_view_input with input as mock_config
}
mock_resources := mock_input.resources
mock_config := {
  "hcl_resource_view_version": "0.0.1",
  "resources": {
    "aws_security_group.invalid_allow_all": {
      "_filepath": "tests/rules/tf/aws/security_group/inputs/ingress_anywhere_infra.tf",
      "_provider": "aws",
      "_type": "aws_security_group",
      "id": "aws_security_group.invalid_allow_all",
      "ingress": [
        {
          "cidr_blocks": [
            "0.0.0.0/0"
          ],
          "from_port": 0,
          "protocol": "tcp",
          "to_port": 65535
        }
      ],
      "name": "invalid_allow_all"
    },
    "aws_security_group.invalid_include_443": {
      "_filepath": "tests/rules/tf/aws/security_group/inputs/ingress_anywhere_infra.tf",
      "_provider": "aws",
      "_type": "aws_security_group",
      "id": "aws_security_group.invalid_include_443",
      "ingress": [
        {
          "cidr_blocks": [
            "0.0.0.0/0"
          ],
          "from_port": 442,
          "protocol": "tcp",
          "to_port": 444
        }
      ],
      "name": "invalid_include_valid_443"
    },
    "aws_security_group.invalid_include_80": {
      "_filepath": "tests/rules/tf/aws/security_group/inputs/ingress_anywhere_infra.tf",
      "_provider": "aws",
      "_type": "aws_security_group",
      "id": "aws_security_group.invalid_include_80",
      "ingress": [
        {
          "cidr_blocks": [
            "0.0.0.0/0"
          ],
          "from_port": 79,
          "protocol": "tcp",
          "to_port": 81
        }
      ],
      "name": "invalid_include_valid_80"
    },
    "aws_security_group.valid_exact_443": {
      "_filepath": "tests/rules/tf/aws/security_group/inputs/ingress_anywhere_infra.tf",
      "_provider": "aws",
      "_type": "aws_security_group",
      "id": "aws_security_group.valid_exact_443",
      "ingress": [
        {
          "cidr_blocks": [
            "0.0.0.0/0"
          ],
          "from_port": 443,
          "protocol": "tcp",
          "to_port": 443
        }
      ],
      "name": "valid_exact_443"
    },
    "aws_security_group.valid_exact_80": {
      "_filepath": "tests/rules/tf/aws/security_group/inputs/ingress_anywhere_infra.tf",
      "_provider": "aws",
      "_type": "aws_security_group",
      "id": "aws_security_group.valid_exact_80",
      "ingress": [
        {
          "cidr_blocks": [
            "0.0.0.0/0"
          ],
          "from_port": 80,
          "protocol": "tcp",
          "to_port": 80
        }
      ],
      "name": "valid_exact_80"
    }
  }
}

