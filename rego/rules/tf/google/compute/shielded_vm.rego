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
package rules.tf_google_compute_shielded_vm


__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-Google_v1.1.0": [
        "CIS-Google_v1.1.0_4.8"
      ]
    },
    "severity": "Medium"
  },
  "description": "Compute instance Shielded VM should be enabled. Compute Engine Shielded VM instances enables several security features to ensure that instances haven't been compromised by boot or kernel-level malway or rootkits. This is achieved through use of Secure Boot, vTPM-enabled Measured Boot, and integrity monitoring.",
  "id": "FG_R00418",
  "title": "Compute instance Shielded VM should be enabled"
}

resource_type = "google_compute_instance"

default allow = false

allow {
    config = input.shielded_instance_config[_]
    config.enable_secure_boot == true
    # These properties default to true
    object.get(config, "enable_integrity_monitoring", true) == true
    object.get(config, "enable_vtpm", true) == true
}

