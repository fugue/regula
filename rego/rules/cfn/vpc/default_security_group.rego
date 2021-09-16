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
package rules.cfn_vpc_default_security_group

import data.fugue

__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-AWS_v1.2.0": [
        "CIS-AWS_v1.2.0_4.3"
      ],
      "CIS-AWS_v1.3.0": [
        "CIS-AWS_v1.3.0_5.3"
      ],
      "CIS-AWS_v1.4.0": [
        "CIS-AWS_v1.4.0_5.3"
      ]
    },
    "severity": "Medium"
  },
  "description": "VPC default security group should restrict all traffic. Configuring all VPC default security groups to restrict all traffic encourages least privilege security group development and mindful placement of AWS resources into security groups which in turn reduces the exposure of those resources.",
  "id": "FG_R00089",
  "title": "VPC default security group should restrict all traffic"
}

input_type = "cfn"
resource_type = "MULTIPLE"

ingress_rules = fugue.resources("AWS::EC2::SecurityGroupIngress")

policy[p] {
  rule = ingress_rules[_]
  rule.GroupId = {"Fn::GetAtt": [_, "DefaultSecurityGroup"]}
  p = fugue.deny_resource(rule)
}
