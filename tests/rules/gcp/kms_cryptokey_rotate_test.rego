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
package tests.rules.gcp_kms_cryptokey_rotate

import data.fugue.regula
import data.tests.rules.gcp.inputs.kms_cryptokey_rotate_infra.mock_plan_input

test_gcp_kms_cryptokey_rotate {
  report := regula.report with input as mock_plan_input
  resources := report.rules.gcp_kms_cryptokey_rotate.resources

  resources["google_kms_crypto_key.valid_key_1"].valid == true
  resources["google_kms_crypto_key.invalid_key_1"].valid == false
  resources["google_kms_crypto_key.invalid_key_2"].valid == false
}
