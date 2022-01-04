# Copyright 2021 Fugue, Inc.
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

package rules.arm_monitor_key_vault_logging

import data.fugue

__rego__metadoc__ := {
	"id": "FG_R00344",
	"title": "Key Vault logging should be enabled",
	"description": "Enable AuditEvent logging for key vault instances to ensure interactions with key vaults are logged and available.",
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
	}
}

input_type = "arm"

resource_type = "MULTIPLE"

key_vaults := fugue.resources("Microsoft.KeyVault/vaults")
diagnostic_settings := fugue.resources("Microsoft.Insights/diagnosticSettings")

tokenize(str) = ret {
	ret = [p | p := regex.split(`[\[\]()',[:space:]]+`, str)[_]; p != ""]
}

retention_is_valid(retention) {
	retention.enabled == true
	retention.days >= 180
}

retention_is_valid(retention) {
	retention.enabled == true
	retention.days == 0
}

valid_key_vault_diagnostics := {id: ds |
	ds := diagnostic_settings[id]
	contains(lower(ds.scope), "microsoft.keyvault/vaults")
	log = ds.properties.logs[_]
	lower(log.category) == "auditevent"
	log.enabled == true
	retention_is_valid(log.retentionPolicy)
}

valid_key_vaults := {id |
	kv := key_vaults[id]
	ds := valid_key_vault_diagnostics[_]
	tokenize(lower(ds.scope))[_] == lower(kv.name)
}

policy[p] {
	kv := key_vaults[id]
	valid_key_vaults[id]
	p := fugue.allow_resource(kv)
}

policy[p] {
	kv := key_vaults[id]
	not valid_key_vaults[id]
	p := fugue.deny_resource(kv)
}
