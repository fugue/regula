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
package rules.tf_google_kms_cryptokey_rotate

import data.tests.rules.tf.google.kms.inputs.cryptokey_rotate_infra_json

test_gcp_kms_cryptokey_rotate {
  resources = cryptokey_rotate_infra_json.mock_resources
  allow with input as resources["google_kms_crypto_key.valid_key_1"]
  not allow with input as resources["google_kms_crypto_key.invalid_key_1"]
  not allow with input as resources["google_kms_crypto_key.invalid_key_2"]
}
