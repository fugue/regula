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
resource "google_kms_key_ring" "keyring" {
  name     = "keyring-example"
  location = "global"
}

resource "google_kms_crypto_key" "valid_key_1" {
  name            = "crypto-key-example"
  key_ring        = "${google_kms_key_ring.keyring.self_link}"
  rotation_period = "31536000s"

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_kms_crypto_key" "invalid_key_1" {
  name            = "crypto-key-example"
  key_ring        = "${google_kms_key_ring.keyring.self_link}"

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_kms_crypto_key" "invalid_key_2" {
  name            = "crypto-key-example"
  key_ring        = "${google_kms_key_ring.keyring.self_link}"
  rotation_period = "31536002s"

  lifecycle {
    prevent_destroy = true
  }
}