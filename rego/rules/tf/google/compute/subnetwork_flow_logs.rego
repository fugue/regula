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
package rules.tf_google_compute_subnetwork_flow_logs

__rego__metadoc__ := {
  "id": "FG_R00409",
  "title": "Network subnet flow logs should be enabled",
  "description": "It is recommended that flow logs be enabled for every business-critical VPC subnet, as they provide visibility into network traffic for each VM inside the subnet and can be used to detect anomalous traffic or insight during security workflows.",
  "custom": {
    "controls": {
      "CIS-Google_v1.0.0": [
        "CIS-Google_v1.0.0_3.9"
      ],
      "CIS-Google_v1.1.0": [
        "CIS-Google_v1.1.0_3.8"
      ]
    },
    "severity": "Medium"
  }
}

resource_type = "google_compute_subnetwork"

default allow = false

allow {
  _ = input.log_config[_]
}
