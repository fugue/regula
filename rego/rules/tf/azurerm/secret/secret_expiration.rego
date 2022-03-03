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
package rules.tf_azurerm_secret_secret_expiration

import data.fugue

__rego__metadoc__ := {
  "custom": {
    "controls": {
      "CIS-Azure_v1.3.0": [
        "CIS-Azure_v1.3.0_8.2"
      ]
    },
    "severity": "Medium"
  },
  "description": "Key Vault secrets should have an expiration date. By default, Key Vault secrets do not expire, which can be a security issue if secrets are compromised. As a best practice, an explicit expiration date should be set for secrets and secrets should be rotated.",
  "id": "FG_R00451",
  "title": "Key Vault secrets should have an expiration date"
}

resource_type := "MULTIPLE"

vaults = fugue.resources("azurerm_key_vault")
key_vault_secrets = fugue.resources("azurerm_key_vault_secret")

secrets_by_vault := {vault_name: secrets |
  vault = vaults[_]
  vault_name = vault.name
  secrets = [secret_id |
    secret = key_vault_secrets[_]
    secret.key_vault_id == vault.id
    secret_id = secret.id
  ]
}

valid_secret(secret) {
  is_string(secret.expiration_date)
  count(secret.expiration_date) > 0
}

report_secret(secret) = ret {
  not valid_secret(secret)
  secrets_by_vault[vault][_] == secret.id
  ret = sprintf(
    "%s is contained in vault %s",
    [secret.name, vault],
  )
} else = ret {
  # We may not have the vault (or name) in the input.
  not valid_secret(secret)
  ret := "no have an expiration date set"
}

policy[j] {
  secret = key_vault_secrets[_]
  not report_secret(secret)
  j = fugue.allow_resource(secret)
}

policy[j] {
  secret = key_vault_secrets[_]
  reason = report_secret(secret)
  j = fugue.deny_resource_with_message(secret, reason)
}
