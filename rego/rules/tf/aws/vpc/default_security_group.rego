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
package rules.tf_aws_vpc_default_security_group

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

resource_type = "MULTIPLE"

policy[j] {
  vpcs[id] = vpc
  valid_vpc(vpc)
  j = fugue.allow_resource(vpc)
} {
  vpcs[id] = vpc
  not valid_vpc(vpc)
  j = fugue.deny_resource(vpc)
}

vpcs = fugue.resources("aws_vpc")

security_groups[id] = sg {
  sgs = fugue.resources("aws_security_group")
  sg = sgs[id]
} {
  # We want to take `aws_default_security_group` into account for testing
  # (since that is the only way to really set this in terraform), but
  # generally not in production (since we currently don't survey for this
  # resource type).
  #
  # The solution we use is to only query for this resource type after checking
  # that there is at least one in the input.
  fugue.resource_types_v0["aws_default_security_group"]
  sgs = fugue.resources("aws_default_security_group")
  sg = sgs[id]
}

# Is a security group the default for a VPC?  This can happen in two ways, see
# the note above.
is_default_security_group_for(sg, vpc) {
  sg.id == vpc.default_security_group_id
} {
  sg._type == "aws_default_security_group"
}

valid_vpc(vpc) {
  default_sg = security_groups[_]
  is_default_security_group_for(default_sg, vpc)
  restricts_ingress_traffic(default_sg)
  restricts_egress_traffic(default_sg)
}

has_ingress(sg) {
  _ = sg.ingress[_]
}

restricts_ingress_traffic(sg) {
  # There are no ingress rules.
  not has_ingress(sg)
} {
  # Or, there is a single ingress rule that point to itself.
  count(sg.ingress) == 1
  ig = sg.ingress[_]
  object.get(ig, "cidr_blocks", []) == []
  ig.self == true
}

has_egress(sg) {
  _ = sg.egress[_]
}

restricts_egress_traffic(sg) {
  # There are no egress rules.
  not has_egress(sg)
} {
  # Or there is a single egress rule only allows traffic to "127.0.0.1".
  count(sg.egress) == 1
  eg = sg.egress[_]
  eg.cidr_blocks == ["127.0.0.1/32"]
}

