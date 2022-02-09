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
package cfn.nacl_library

import data.fugue

nacl_entries = fugue.resources("AWS::EC2::NetworkAclEntry")
nacl_ingress_by_id = {nacl_id: entries |
  nacl_id = nacl_entries[_].NetworkAclId
  entries = [entry |
    entry = nacl_entries[_]
    entry.NetworkAclId == nacl_id
    object.get(entry, "Egress", false) == false
  ]
}

# Returns true if the NACL entry has an all-zero CIDR.
nacl_entry_zero_cidr(entry) {
  entry.CidrBlock == "0.0.0.0/0"
} {
  entry.Ipv6CidrBlock == "::/0"
}

# Returns true if the NACL entry includes the given port
nacl_entry_includes_port(entry, port) {
  entry.Protocol == -1
} {
  entry.PortRange.From == 0
  entry.PortRange.To == 0
} {
  entry.PortRange.From <= port
  entry.PortRange.To >= port
}

# Check if there is a NACL entry that allows the given port from an all-zero
# CIDR.
nacl_ingress_zero_cidr_to_port(nacl_id, port) {
  entries := [entry |
    entry = nacl_ingress_by_id[nacl_id][_]
    nacl_entry_zero_cidr(entry)
    nacl_entry_includes_port(entry, port)
  ]

  allows := [entry.RuleNumber | entry = entries[_]; entry.RuleAction == "allow"]
  denies := [entry.RuleNumber | entry = entries[_]; entry.RuleAction == "deny"]

  allow_precedes_denies(allows, denies)
}

allow_precedes_denies(allows, denies) {
  _ = allows[_]
  count(denies) == 0
} {
  min(allows) < min(denies)
}
