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
package rules.azurerm_monitor_key_vault_logging

import data.fugue


__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-Azure_v1.1.0": [
        "CIS-Azure_v1.1.0_5.1.7"
      ],
      "CIS-Azure_v1.3.0": [
        "CIS-Azure_v1.3.0_5.1.5"
      ]
    },
    "severity": "Medium"
  },
  "description": "Key Vault logging should be enabled. Enable AuditEvent logging for key vault instances to ensure interactions with key vaults are logged and available.",
  "id": "FG_R00344",
  "title": "Key Vault logging should be enabled"
}

key_vaults = fugue.resources("azurerm_key_vault")
diagnostic_settings = fugue.resources("azurerm_monitor_diagnostic_setting")

valid_audit_target_ids = {lower(id) |
  diagnostic_setting = diagnostic_settings[_]
  _ = diagnostic_setting.storage_account_id
  id = diagnostic_setting.target_resource_id
  log = diagnostic_setting.log[_]

  lower(log.category) == "auditevent"
  log.enabled == true
  log.retention_policy[_].days >= 180
  log.retention_policy[_].enabled == true
}

resource_type = "MULTIPLE"

policy[p] {
  key_vault = key_vaults[_]
  valid_audit_target_ids[lower(key_vault.id)]
  p = fugue.allow_resource(key_vault)
} {
  key_vault = key_vaults[_]
  not valid_audit_target_ids[lower(key_vault.id)]
  p = fugue.deny_resource(key_vault)
}

