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
package rules.tf_google_compute_firewall_port_3389

import data.google.compute.firewall_library as lib
import data.fugue

__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-Google_v1.1.0": [
        "CIS-Google_v1.1.0_3.7"
      ],
      "CIS-Google_v1.2.0": [
        "CIS-Google_v1.2.0_3.7"
      ]
    },
    "severity": "High"
  },
  "description": "Network firewall rules should not permit ingress from 0.0.0.0/0 to port 3389 (RDP). If RDP is open to the internet, attackers can attempt to gain access to VM instances. Removing unfettered connectivity to remote console services, such as RDP, reduces a server's exposure to risk.",
  "id": "FG_R00408",
  "title": "Network firewall rules should not permit ingress from 0.0.0.0/0 to port 3389 (RDP)"
}

firewalls = fugue.resources("google_compute_firewall")

resource_type := "MULTIPLE"

port = "3389"

policy[j] {
  firewall = firewalls[_]
  network = lib.network_for_firewall(firewall)
  lib.is_network_vulnerable(network, port)
  j = fugue.allow_resource(firewall)
} {
  firewall = firewalls[_]
  network = lib.network_for_firewall(firewall)
  not lib.is_network_vulnerable(network, port)
  p = lib.lowest_allow_ingress_zero_cidr_by_port(network, port)
  f = lib.firewalls_by_priority_and_port(network, p, port)[_]
  j = fugue.deny_resource(f)
}

policy[j] {
  # No network info found; simpler implementation.
  firewall = firewalls[_]
  not lib.network_for_firewall(firewall)
  lib.firewall_zero_cidr_to_port(firewall, port)
  j = fugue.deny_resource(firewall)
} {
  # No network info found; simpler implementation.
  firewall = firewalls[_]
  not lib.network_for_firewall(firewall)
  not lib.firewall_zero_cidr_to_port(firewall, port)
  j = fugue.deny_resource(firewall)
}
