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

package rules.arm_key_vault_recoverable

import data.tests.rules.arm.key_vault.inputs.recoverable_infra_json as infra

test_key_vault_recoverable {
	allow with input as infra.mock_resources["Microsoft.KeyVault/vaults/valid"]
	not allow with input as infra.mock_resources["Microsoft.KeyVault/vaults/invalidUnset"]
	not allow with input as infra.mock_resources["Microsoft.KeyVault/vaults/invalidEnablePurgeProtection"]
	not allow with input as infra.mock_resources["Microsoft.KeyVault/vaults/invalidEnableSoftDelete"]
}
