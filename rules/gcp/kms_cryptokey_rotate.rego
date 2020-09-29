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

# KMS crypto keys should be rotated at least once every 365 days
package rules.gcp_kms_cryptokey_rotate

controls = {"CIS_GCP_1-8", "REGULA_R00010"}
resource_type = "google_kms_crypto_key"

default allow = false

allow {
  rotation_per = input.rotation_period
  is_string(rotation_per)
  trimmed_rotation_per = trim_right(rotation_per, "s")
  num_rotation_per = to_number(trimmed_rotation_per)
  num_rotation_per <= 31536000
}
