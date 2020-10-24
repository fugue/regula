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
package rules.security_group_ingress_anywhere

import data.fugue.regula.aws.security_group as sglib

__rego__metadoc__ := {
  "id": "FG_R00351",
  "title": "VPC security group rules should not permit ingress from '0.0.0.0/0' except to ports 80 and 443",
  "description": "VPC firewall rules should not permit unrestricted access from the internet, with the exception of port 80 (HTTP) and port 443 (HTTPS). Web applications or APIs generally need to be publicly accessible."
}

resource_type = "aws_security_group"

whitelisted_ports = {80, 443}

whitelisted_ingress_block(block) {
  block.from_port == block.to_port
  whitelisted_ports[block.from_port]
}

bad_ingress_block(block) {
  sglib.ingress_zero_cidr(block)
  not sglib.ingress_self_only(block)
  not whitelisted_ingress_block(block)
}

default deny = false

deny {
  block = input.ingress[_]
  bad_ingress_block(block)
}
