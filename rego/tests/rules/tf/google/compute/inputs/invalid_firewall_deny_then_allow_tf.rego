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
package tests.rules.tf.google.compute.inputs.invalid_firewall_deny_then_allow_tf

import data.fugue.resource_view.resource_view_input

mock_input := ret {
  ret = resource_view_input with input as mock_config
}
mock_resources := mock_input.resources
mock_config := {
  "hcl_resource_view_version": "0.0.1",
  "resources": {
    "google_compute_firewall.allow_ports": {
      "_filepath": "tests/rules/tf/google/compute/inputs/invalid_firewall_deny_then_allow.tf",
      "_provider": "google",
      "_type": "google_compute_firewall",
      "allow": [
        {
          "ports": [
            "22",
            "3389"
          ],
          "protocol": "tcp"
        }
      ],
      "id": "google_compute_firewall.allow_ports",
      "name": "allow-ports",
      "network": "test-network",
      "priority": 1,
      "source_ranges": [
        "0.0.0.0/0"
      ]
    },
    "google_compute_firewall.deny_all": {
      "_filepath": "tests/rules/tf/google/compute/inputs/invalid_firewall_deny_then_allow.tf",
      "_provider": "google",
      "_type": "google_compute_firewall",
      "deny": [
        {
          "protocol": "all"
        }
      ],
      "id": "google_compute_firewall.deny_all",
      "name": "deny-all",
      "network": "test-network",
      "source_ranges": [
        "0.0.0.0/0"
      ]
    },
    "google_compute_network.test": {
      "_filepath": "tests/rules/tf/google/compute/inputs/invalid_firewall_deny_then_allow.tf",
      "_provider": "google",
      "_type": "google_compute_network",
      "id": "google_compute_network.test",
      "name": "test-network"
    }
  }
}

