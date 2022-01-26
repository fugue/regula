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
package rules.tf_google_compute_firewall_port_3389

import data.tests.rules.tf.google.compute.inputs.firewall_no_ingress_3389_infra_json

test_gcp_compute_firewall_port_3389 {
  resources = firewall_no_ingress_3389_infra_json.mock_resources
  not deny with input as resources["google_compute_firewall.valid-rule-1"]
  not deny with input as resources["google_compute_firewall.valid-rule-2"]
  deny with input as resources["google_compute_firewall.invalid-rule-1"]
  deny with input as resources["google_compute_firewall.invalid-rule-2"]
}
