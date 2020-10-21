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

# VPC subnet flow logging should be enabled.
package rules.gcp_compute_subnet_flow_log_enabled

__rego__metadoc__ := {
  "id": "FG_R00356",
  "title": "VPC subnet flow logging should be enabled",
  "description": "Flow logs provide visibility into network traffic that traverses a VPC, and can be used to detect anomalous traffic and additional insights.",
  "custom": {
    "controls": {
      "CIS-GCP": [
        "CIS-GCP_1.0.0_3-9"
      ]
    }
  }
}

resource_type = "google_compute_subnetwork"

default deny = false

deny {
  count(input.log_config) == 0
}
