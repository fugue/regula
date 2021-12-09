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

package rules.arm_key_vault_secret_expiry

import data.fugue

__rego__metadoc__ := {
	"id": "FG_R00451",
	"title": "Key Vault secrets should have an expiration date set",
	"description": "By default, Key Vault secrets do not expire, which can be a security issue if secrets are compromised. As a best practice, an explicit expiration date should be set for secrets and secrets should be rotated.",
	"custom": {
		"controls": {
			"CIS-Azure_v1.1.0": [
				"CIS-Azure_v1.1.0_8.2"
			],
			"CIS-Azure_v1.3.0": [
				"CIS-Azure_v1.3.0_8.2"
			]
		},
		"severity": "Medium"
	}
}

input_type = "arm"

resource_type = "Microsoft.KeyVault/vaults/secrets"

default allow = false

allow {
	is_number(input.properties.attributes.exp)
}
