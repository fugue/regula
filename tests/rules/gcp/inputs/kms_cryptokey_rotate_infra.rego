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

# This package was automatically generated from:
#
#     tests/rules/gcp/inputs/kms_cryptokey_rotate_infra.tf
#
# using `generate_test_inputs.sh` and should not be modified
# directly.
package tests.rules.gcp.inputs.kms_cryptokey_rotate_infra
mock_input = {
  "format_version": "0.1",
  "terraform_version": "0.12.18",
  "planned_values": {
    "root_module": {
      "resources": [
        {
          "address": "google_kms_crypto_key.invalid_key_1",
          "mode": "managed",
          "type": "google_kms_crypto_key",
          "name": "invalid_key_1",
          "provider_name": "google",
          "schema_version": 1,
          "values": {
            "labels": null,
            "name": "crypto-key-example",
            "purpose": "ENCRYPT_DECRYPT",
            "rotation_period": null,
            "timeouts": null
          }
        },
        {
          "address": "google_kms_crypto_key.invalid_key_2",
          "mode": "managed",
          "type": "google_kms_crypto_key",
          "name": "invalid_key_2",
          "provider_name": "google",
          "schema_version": 1,
          "values": {
            "labels": null,
            "name": "crypto-key-example",
            "purpose": "ENCRYPT_DECRYPT",
            "rotation_period": "31536002s",
            "timeouts": null
          }
        },
        {
          "address": "google_kms_crypto_key.valid_key_1",
          "mode": "managed",
          "type": "google_kms_crypto_key",
          "name": "valid_key_1",
          "provider_name": "google",
          "schema_version": 1,
          "values": {
            "labels": null,
            "name": "crypto-key-example",
            "purpose": "ENCRYPT_DECRYPT",
            "rotation_period": "31536000s",
            "timeouts": null
          }
        },
        {
          "address": "google_kms_key_ring.keyring",
          "mode": "managed",
          "type": "google_kms_key_ring",
          "name": "keyring",
          "provider_name": "google",
          "schema_version": 0,
          "values": {
            "location": "global",
            "name": "keyring-example",
            "timeouts": null
          }
        }
      ]
    }
  },
  "resource_changes": [
    {
      "address": "google_kms_crypto_key.invalid_key_1",
      "mode": "managed",
      "type": "google_kms_crypto_key",
      "name": "invalid_key_1",
      "provider_name": "google",
      "change": {
        "actions": [
          "create"
        ],
        "before": null,
        "after": {
          "labels": null,
          "name": "crypto-key-example",
          "purpose": "ENCRYPT_DECRYPT",
          "rotation_period": null,
          "timeouts": null
        },
        "after_unknown": {
          "id": true,
          "key_ring": true,
          "self_link": true,
          "version_template": true
        }
      }
    },
    {
      "address": "google_kms_crypto_key.invalid_key_2",
      "mode": "managed",
      "type": "google_kms_crypto_key",
      "name": "invalid_key_2",
      "provider_name": "google",
      "change": {
        "actions": [
          "create"
        ],
        "before": null,
        "after": {
          "labels": null,
          "name": "crypto-key-example",
          "purpose": "ENCRYPT_DECRYPT",
          "rotation_period": "31536002s",
          "timeouts": null
        },
        "after_unknown": {
          "id": true,
          "key_ring": true,
          "self_link": true,
          "version_template": true
        }
      }
    },
    {
      "address": "google_kms_crypto_key.valid_key_1",
      "mode": "managed",
      "type": "google_kms_crypto_key",
      "name": "valid_key_1",
      "provider_name": "google",
      "change": {
        "actions": [
          "create"
        ],
        "before": null,
        "after": {
          "labels": null,
          "name": "crypto-key-example",
          "purpose": "ENCRYPT_DECRYPT",
          "rotation_period": "31536000s",
          "timeouts": null
        },
        "after_unknown": {
          "id": true,
          "key_ring": true,
          "self_link": true,
          "version_template": true
        }
      }
    },
    {
      "address": "google_kms_key_ring.keyring",
      "mode": "managed",
      "type": "google_kms_key_ring",
      "name": "keyring",
      "provider_name": "google",
      "change": {
        "actions": [
          "create"
        ],
        "before": null,
        "after": {
          "location": "global",
          "name": "keyring-example",
          "timeouts": null
        },
        "after_unknown": {
          "id": true,
          "project": true,
          "self_link": true
        }
      }
    }
  ],
  "configuration": {
    "root_module": {
      "resources": [
        {
          "address": "google_kms_crypto_key.invalid_key_1",
          "mode": "managed",
          "type": "google_kms_crypto_key",
          "name": "invalid_key_1",
          "provider_config_key": "google",
          "expressions": {
            "key_ring": {
              "references": [
                "google_kms_key_ring.keyring"
              ]
            },
            "name": {
              "constant_value": "crypto-key-example"
            }
          },
          "schema_version": 1
        },
        {
          "address": "google_kms_crypto_key.invalid_key_2",
          "mode": "managed",
          "type": "google_kms_crypto_key",
          "name": "invalid_key_2",
          "provider_config_key": "google",
          "expressions": {
            "key_ring": {
              "references": [
                "google_kms_key_ring.keyring"
              ]
            },
            "name": {
              "constant_value": "crypto-key-example"
            },
            "rotation_period": {
              "constant_value": "31536002s"
            }
          },
          "schema_version": 1
        },
        {
          "address": "google_kms_crypto_key.valid_key_1",
          "mode": "managed",
          "type": "google_kms_crypto_key",
          "name": "valid_key_1",
          "provider_config_key": "google",
          "expressions": {
            "key_ring": {
              "references": [
                "google_kms_key_ring.keyring"
              ]
            },
            "name": {
              "constant_value": "crypto-key-example"
            },
            "rotation_period": {
              "constant_value": "31536000s"
            }
          },
          "schema_version": 1
        },
        {
          "address": "google_kms_key_ring.keyring",
          "mode": "managed",
          "type": "google_kms_key_ring",
          "name": "keyring",
          "provider_config_key": "google",
          "expressions": {
            "location": {
              "constant_value": "global"
            },
            "name": {
              "constant_value": "keyring-example"
            }
          },
          "schema_version": 0
        }
      ]
    }
  }
}
