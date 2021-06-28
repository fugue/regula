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
package rules.aws_security_groups_ingress_ec2_389

import data.aws.security_groups.library
import data.fugue



__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-Controls_v7.1": [
        "CIS-Controls_v7.1_12.4",
        "CIS-Controls_v7.1_9.2",
        "CIS-Controls_v7.1_9.4"
      ]
    },
    "severity": "High"
  },
  "description": "VPC security groups attached to EC2 instances should not permit ingress from '0.0.0.0/0' to TCP/UDP port 389 (LDAP). Removing unfettered connectivity to LDAP reduces the chance of exposing critical data.",
  "id": "FG_R00234",
  "title": "VPC security groups attached to EC2 instances should not permit ingress from '0.0.0.0/0' to TCP/UDP port 389 (LDAP)"
}

resource_type = "MULTIPLE"

policy[j] {
  sg = library.ec2_connected_security_groups[_]
  library.security_group_ingress_zero_cidr_to_port(sg, 389)
  j = fugue.deny_resource(sg)
} {
  sg = library.ec2_connected_security_groups[_]
  not library.security_group_ingress_zero_cidr_to_port(sg, 389)
  j = fugue.allow_resource(sg)
}

