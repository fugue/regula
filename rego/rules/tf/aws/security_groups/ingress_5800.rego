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
package rules.aws_security_groups_ingress_5800

import data.aws.security_groups.library
import data.fugue



__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-Controls_v7.1": [
        "CIS-Controls_v7.1_9.2",
        "CIS-Controls_v7.1_9.4"
      ]
    },
    "severity": "High"
  },
  "description": "VPC security group rules should not permit ingress from '0.0.0.0/0' to TCP/UDP port 5800 (Virtual Network Computing), unless from ELBs. Security groups provide stateful filtering of ingress/egress network traffic to AWS resources. AWS recommends that no security group allows unrestricted ingress access to port 5800, unless it is from AWS Elastic Load Balancer. Removing unfettered connectivity to remote console services reduces a server's exposure to risk.",
  "id": "FG_R00038",
  "title": "VPC security group rules should not permit ingress from '0.0.0.0/0' to TCP/UDP port 5800 (Virtual Network Computing), unless from ELBs"
}

security_groups = fugue.resources("aws_security_group")

resource_type = "MULTIPLE"

policy[j] {
  sg = security_groups[global_sg_id]
  msg = library.deny_security_group_ingress_zero_cidr_to_port_lb(global_sg_id, sg, 5800)
  j = fugue.deny_resource(sg)
} {
  sg = security_groups[global_sg_id]
  not library.deny_security_group_ingress_zero_cidr_to_port_lb(global_sg_id, sg, 5800)
  j = fugue.allow_resource(sg)
}

