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
package fugue.gcp.compute_firewall

range_includes_port(range, bad_port) {
  is_string(range)
  not contains(range, "-")
  to_number(range) == bad_port
} {
  is_string(range)
  contains(range, "-")
  port_range = regex.split("-", range)
  from_port = port_range[0]
  to_port = port_range[1]
  to_number(from_port) <= bad_port
  to_number(to_port) >= bad_port
}

is_zero_cidr(cidr) {cidr == "0.0.0.0/0"} {cidr == "::/0"}

includes_zero_cidr_to_port(firewall, bad_port) {
  allow_block = firewall.allow[_]
  port_range = allow_block.ports[_]
  range_includes_port(port_range, bad_port)

  ip_range = firewall.source_ranges[_]
  is_zero_cidr(ip_range)
}
