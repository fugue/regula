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
package google.compute.firewall_library

import data.fugue

networks = fugue.resources("google_compute_network")
firewalls = fugue.resources("google_compute_firewall")

# 6 is the decimal identifier for tcp
# 17 is the decimal identifier for udp
target_protocols = {"all", "tcp", "udp", "6", "17"}

# Returns true if the given cidr is all zeroes
zero_cidr(cidr) {cidr == "0.0.0.0/0"} {cidr == "::/0"}

network_identifier(network) = ret {
  ret := network.self_link
} else = ret {
  ret := network.name
}

# Creates a new document of all firewalls organized by network
ingress_firewalls_by_network = {nid: fw |
  network = networks[_]
  nid = network_identifier(network)

  fw = [f |
    f = firewalls[_]
    object.get(f, "direction", "INGRESS") == "INGRESS"
    f.network == nid
  ]
}

network_for_firewall(firewall) = ret {
  network = networks[_]
  network_identifier(network) == firewall.network
  ret = network
}

# Creates a new document of all INGRESS from "0.0.0.0/0" firewalls organized by network
ingress_firewalls_zero_cidr_by_network = {nid: fw |
  ret = ingress_firewalls_by_network[nid]
  fw = [f |
    f = ret[_]
    source_ranges = object.get(f, "source_ranges", [])
    zero_cidr(source_ranges[_])
  ]
}

# Returns the lowest priority INGRESS ALLOW firewall for a network for a given port
lowest_allow_ingress_zero_cidr_by_port(network, port) = ret {
  fs = ingress_firewalls_zero_cidr_by_network[network_identifier(network)]
  priorities = [p |
    f = fs[_]
    allow = object.get(f, "allow", [])
    firewall_matches_port(allow[_], port)
    p = object.get(f, "priority", 1000)
  ]
  sorted = sort(priorities)
  ret = sorted[0]
}

# Returns the lowest priority INGRESS DENY firewall for a network for a given port
lowest_deny_ingress_zero_cidr_by_port(network, port) = ret {
  fs = ingress_firewalls_zero_cidr_by_network[network_identifier(network)]
  priorities = [p |
    f = fs[_]
    deny = object.get(f, "deny", [])
    firewall_matches_port(deny[_], port)
    p = object.get(f, "priority", 1000)
  ]
  sorted = sort(priorities)
  ret = sorted[0]
}

# Determines if the specified port is allowed by the firewall rule
firewall_matches_port(rule, port) {
  # Exact match
  rule.ports[_] == port
} {
  # Port range
  res = split(rule.ports[_], "-")
  low = to_number(res[0])
  high = to_number(res[1])
  p = to_number(port)
  low <= p
  high >= p
} {
  # We want to ignore this case if the protocol isn't one that supports
  # port specifications, like icmp.
  target_protocols[rule.protocol]
  count(object.get(rule, "ports", [])) == 0
}

firewalls_by_priority_and_port(network, priority, port) = ret {
  fs = ingress_firewalls_zero_cidr_by_network[network_identifier(network)]
  ret = [f |
    f = fs[_]
    object.get(f, "priority", 1000) == priority
    firewall_matches_port(f.allow[_], port)
  ]
}

is_network_vulnerable(network, port) {
  allow = lowest_allow_ingress_zero_cidr_by_port(network, port)
  deny = lowest_deny_ingress_zero_cidr_by_port(network, port)
  deny <= allow
} {
  not lowest_allow_ingress_zero_cidr_by_port(network, port)
}
