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
# This is a version of `aws.security_groups.inbound_all` that does not have the
# public CIDR check, so it will flag more resources as invalid.  However, it has
# a lower severity (Medium rather than High).
package rules.tf_aws_security_groups_inbound_all_private

import data.fugue
import data.aws.security_groups.library

__rego__metadoc__ := {
  "custom": {
    "severity": "Medium"
  },
  "description": "VPC security group inbound rules should not permit ingress from any address to all ports and protocols. Security groups provide stateful filtering of ingress/egress network traffic to AWS resources. AWS recommends that no security groups explicitly allow inbound ports.",
  "id": "FG_R00350",
  "title": "VPC security group inbound rules should not permit ingress from any address to all ports and protocols"
}

resource_type := "aws_security_group"

default deny = false

deny {
  b = input.ingress[_]
  not library.rule_self_only(b)
  library.rule_all_ports(b)
}
