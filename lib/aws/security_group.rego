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

# Small utility library for working with AWS security groups and associated
# types.
package fugue.regula.aws.security_group

# Does an ingress block have the zero ("0.0.0.0/0" or "::/0") CIDR?
ingress_zero_cidr(ib) {
  zero_cidr(ib.cidr_blocks[_])
}

zero_cidr(cidr) {cidr == "0.0.0.0/0"} {cidr == "::/0"}

# Does a security group only allow traffic to itself?  This is a common
# exception to rules.
ingress_self_only(ib) {
  ib.self == true
  ib.cidr_blocks == []
  ib.ipv6_cidr_blocks == []
}

# Does an ingress block allow a given port?
ingress_includes_port(ib, port) {
  ib.from_port <= port
  ib.to_port >= port
} {
  ib.from_port == 0
  ib.to_port == 0
}

# Does an ingress block allow access from the zero CIDR to a given port?
ingress_zero_cidr_to_port(ib, port) {
  ingress_zero_cidr(ib)
  ingress_includes_port(ib, port)
  not ingress_self_only(ib)
}
