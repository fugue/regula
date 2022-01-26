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

import data.tests.rules.tf.google.compute.inputs


###################
### VALID TESTS ###
###################
test_valid_firewall_allow_then_deny {
  pol = policy with input as inputs.valid_firewall_allow_then_deny_tf.mock_input
  count([p | p = pol[_]; p.valid]) == 2
}

test_valid_firewall_deny_all {
  pol = policy with input as inputs.valid_firewall_deny_all_tf.mock_input
  count([p | p = pol[_]; p.valid]) == 1
}

test_valid_firewall_restricted_allow {
  pol = policy with input as inputs.valid_firewall_restricted_allow_tf.mock_input
  count([p | p = pol[_]; p.valid]) == 1
}

test_valid_firewall_allow_port_range {
  pol = policy with input as inputs.valid_firewall_allow_port_range_tf.mock_input
  count([p | p = pol[_]; p.valid]) == 1
}

test_valid_firewall_equal_priorities {
  pol = policy with input as inputs.valid_firewall_equal_priorities_tf.mock_input
  count([p | p = pol[_]; p.valid]) == 2
}

test_valid_firewall_icmp {
  pol = policy with input as inputs.valid_firewall_icmp_tf.mock_input
  count([p | p = pol[_]; p.valid]) == 1
}

#####################
### INVALID TESTS ###
#####################
test_invalid_firewall_allow_all {
  pol = policy with input as inputs.invalid_firewall_allow_all_tf.mock_input
  count([p | p = pol[_]; not p.valid]) == 1
}

test_invalid_firewall_allow_ports {
  pol = policy with input as inputs.invalid_firewall_allow_ports_tf.mock_input
  count([p | p = pol[_]; not p.valid]) == 1
}

test_invalid_firewall_deny_then_allow {
  pol = policy with input as inputs.invalid_firewall_deny_then_allow_tf.mock_input
  count([p | p = pol[_]; not p.valid]) == 1
}

test_invalid_firewall_allow_port_range {
  pol = policy with input as inputs.invalid_firewall_allow_port_range_tf.mock_input
  count([p | p = pol[_]; not p.valid]) == 1
}

test_invalid_firewall_multiple_networks {
  pol = policy with input as inputs.invalid_firewall_multiple_networks_tf.mock_input
  count([p | p = pol[_]; not p.valid]) == 1
  count([p | p = pol[_]; p.valid]) == 1
}

test_invalid_firewall_equal_priorities {
  pol = policy with input as inputs.invalid_firewall_equal_priorities_tf.mock_input
  count([p | p = pol[_]; not p.valid]) == 1
}
