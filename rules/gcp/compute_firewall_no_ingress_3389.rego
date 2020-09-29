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

# VPC firewall rules should not permit unrestricted access from the internet
# to port 3389 (RDP). Removing unfettered connectivity to remote console services,
# such as RDP, reduces a server's exposure to risk.
package rules.gcp_compute_firewall_no_ingress_3389

import data.fugue.gcp.compute_firewall

controls = {"CIS_GCP_3-7", "REGULA_R00012"}
resource_type = "google_compute_firewall"

default deny = false

deny {
  compute_firewall.includes_zero_cidr_to_port(input, 3389)
}
