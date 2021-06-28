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
package rules.tf_google_compute_disable_ip_forwarding


__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-Google_v1.1.0": [
        "CIS-Google_v1.1.0_4.6"
      ]
    },
    "severity": "Low"
  },
  "description": "Compute instances 'IP forwarding' should not be enabled. By default, a Compute Engine instance cannot forward a packet originated by another instance (\"IP forwarding\"). If this is enabled, Google Cloud no longer enforces packet source and destination checking, which can result in data loss or unintended information disclosure.",
  "id": "FG_R00416",
  "title": "Compute instances 'IP forwarding' should not be enabled"
}

resource_type = "google_compute_instance"

default allow = false

allow {
  not input.can_ip_forward
}

