# Copyright 2020-2022 Fugue, Inc.
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
package rules.tf_aws_vpc_nacl_ingress_22

import data.aws.vpc.nacl_library as lib
import data.fugue

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule

__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-AWS_v1.3.0": [
        "CIS-AWS_v1.3.0_5.1"
      ]
    },
    "severity": "High"
  },
  "description": "VPC network ACLs should not allow ingress from 0.0.0.0/0 to port 22. Public access to remote server administration ports, such as 22 and 3389, increases resource attack surface and unnecessarily raises the risk of resource compromise.",
  "id": "FG_R00357",
  "title": "VPC network ACLs should not allow ingress from 0.0.0.0/0 to port 22"
}

resource_type := "MULTIPLE"

nacls = fugue.resources("aws_network_acl")

# Return true if deny rule is lower (aka takes precedence)
lower_deny(deny, allow) {
  deny < allow
}

# Good nacl rules either:
#   - Have no ALLOW rules
#   - Have DENY rules before any ALLOW rules
is_good_nacl(nacl) {
  allow = lib.lowest_allow_ingress_zero_cidr_by_port(nacl, 22)
  deny = lib.lowest_deny_ingress_zero_cidr_by_port(nacl, 22)
  lower_deny(deny, allow)
} {
  not lib.lowest_allow_ingress_zero_cidr_by_port(nacl, 22)
}

policy[j] {
  nacl = nacls[_]
  is_good_nacl(nacl)
  j = fugue.allow_resource(nacl)
} {
  nacl = nacls[_]
  not is_good_nacl(nacl)
  j = fugue.deny_resource(nacl)
}
