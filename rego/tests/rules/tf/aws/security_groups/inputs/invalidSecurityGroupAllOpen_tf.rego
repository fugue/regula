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
package tests.rules.tf.aws.security_groups.inputs.invalidSecurityGroupAllOpen_tf

import data.fugue.resource_view.resource_view_input

mock_input := ret {
  ret = resource_view_input with input as mock_config
}
mock_resources := mock_input.resources
mock_config := {
  "hcl_resource_view_version": "0.0.1",
  "resources": {
    "aws_security_group.allow_all": {
      "_filepath": "tests/rules/tf/aws/security_groups/inputs/invalidSecurityGroupAllOpen.tf",
      "_provider": "aws",
      "_type": "aws_security_group",
      "id": "aws_security_group.allow_all",
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
      "name": "allow_all",
      "vpc_id": "aws_vpc.main"
    },
    "aws_vpc.main": {
      "_filepath": "tests/rules/tf/aws/security_groups/inputs/invalidSecurityGroupAllOpen.tf",
      "_provider": "aws",
      "_type": "aws_vpc",
      "cidr_block": "10.0.0.0/16",
      "id": "aws_vpc.main"
    }
  }
}

