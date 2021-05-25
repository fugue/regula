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
package rules.cfn_vpc_nacl_ingress_3389

import data.cfn.nacl_library
import data.fugue

__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-AWS_v1.3.0": [
        "CIS-AWS_v1.3.0_5.1"
      ]
    },
    "severity": "High"
  },
  "description": "VPC network ACLs should not allow ingress from 0.0.0.0/0 to port 3389. Public access to remote server administration ports, such as 22 and 3389, increases resource attack surface and unnecessarily raises the risk of resource compromise.",
  "id": "FG_R00359",
  "title": "VPC network ACLs should not allow ingress from 0.0.0.0/0 to port 3389"
}

nacls = fugue.resources("AWS::EC2::NetworkAcl")

policy[p] {
  nacl = nacls[_]
  not nacl_library.nacl_ingress_zero_cidr_to_port(nacl.id, 3389)
  p = fugue.allow_resource(nacl)
} {
  nacl = nacls[_]
  nacl_library.nacl_ingress_zero_cidr_to_port(nacl.id, 3389)
  p = fugue.deny_resource(nacl)
}
