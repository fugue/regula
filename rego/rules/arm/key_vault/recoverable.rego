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

package rules.arm_key_vault_recoverable

import data.fugue

__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-Azure_v1.1.0": [
        "CIS-Azure_v1.1.0_8.4"
      ],
      "CIS-Azure_v1.3.0": [
        "CIS-Azure_v1.3.0_8.4"
      ]
    },
    "severity": "Medium"
  },
  "description": "Enabling soft deletion ensures that even if the key vault is deleted, the key vault and its objects remain recoverable for next 90 days. In this span of 90 days, the key vault and its objects can be recovered or purged (permanent deletion). Enabling purge protection ensures that the key vault and its objects cannot be purged during the 90 day retention period.",
  "id": "FG_R00227",
  "title": "Key Vault 'Enable Soft Delete' and 'Enable Purge Protection' should be enabled"
}

input_type := "arm"

resource_type := "Microsoft.KeyVault/vaults"

default allow = false

allow {
	input.properties.enablePurgeProtection == true
	input.properties.enableSoftDelete == true
}
