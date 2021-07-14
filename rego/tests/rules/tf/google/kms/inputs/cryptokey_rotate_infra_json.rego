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
package tests.rules.tf.google.kms.inputs.cryptokey_rotate_infra_json

import data.fugue.resource_view.resource_view_input

mock_input := ret {
  ret = resource_view_input with input as mock_config
}
mock_resources := mock_input.resources
mock_config := {
  "configuration": {
    "root_module": {
      "resources": [
        {
          "address": "google_kms_crypto_key.invalid_key_1",
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
          "mode": "managed",
          "name": "invalid_key_1",
          "provider_config_key": "google",
          "schema_version": 1,
          "type": "google_kms_crypto_key"
        },
        {
          "address": "google_kms_crypto_key.invalid_key_2",
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
              "constant_value": "7776002s"
            }
          },
          "mode": "managed",
          "name": "invalid_key_2",
          "provider_config_key": "google",
          "schema_version": 1,
          "type": "google_kms_crypto_key"
        },
        {
          "address": "google_kms_crypto_key.valid_key_1",
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
              "constant_value": "7776000s"
            }
          },
          "mode": "managed",
          "name": "valid_key_1",
          "provider_config_key": "google",
          "schema_version": 1,
          "type": "google_kms_crypto_key"
        },
        {
          "address": "google_kms_key_ring.keyring",
          "expressions": {
            "location": {
              "constant_value": "global"
            },
            "name": {
              "constant_value": "keyring-example"
            }
          },
          "mode": "managed",
          "name": "keyring",
          "provider_config_key": "google",
          "schema_version": 0,
          "type": "google_kms_key_ring"
        }
      ]
    }
  },
  "format_version": "0.1",
  "planned_values": {
    "root_module": {
      "resources": [
        {
          "address": "google_kms_crypto_key.invalid_key_1",
          "mode": "managed",
          "name": "invalid_key_1",
          "provider_name": "registry.terraform.io/hashicorp/google",
          "schema_version": 1,
          "type": "google_kms_crypto_key",
          "values": {
            "labels": null,
            "name": "crypto-key-example",
            "purpose": "ENCRYPT_DECRYPT",
            "rotation_period": null,
            "skip_initial_version_creation": null,
            "timeouts": null
          }
        },
        {
          "address": "google_kms_crypto_key.invalid_key_2",
          "mode": "managed",
          "name": "invalid_key_2",
          "provider_name": "registry.terraform.io/hashicorp/google",
          "schema_version": 1,
          "type": "google_kms_crypto_key",
          "values": {
            "labels": null,
            "name": "crypto-key-example",
            "purpose": "ENCRYPT_DECRYPT",
            "rotation_period": "7776002s",
            "skip_initial_version_creation": null,
            "timeouts": null
          }
        },
        {
          "address": "google_kms_crypto_key.valid_key_1",
          "mode": "managed",
          "name": "valid_key_1",
          "provider_name": "registry.terraform.io/hashicorp/google",
          "schema_version": 1,
          "type": "google_kms_crypto_key",
          "values": {
            "labels": null,
            "name": "crypto-key-example",
            "purpose": "ENCRYPT_DECRYPT",
            "rotation_period": "7776000s",
            "skip_initial_version_creation": null,
            "timeouts": null
          }
        },
        {
          "address": "google_kms_key_ring.keyring",
          "mode": "managed",
          "name": "keyring",
          "provider_name": "registry.terraform.io/hashicorp/google",
          "schema_version": 0,
          "type": "google_kms_key_ring",
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
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "labels": null,
          "name": "crypto-key-example",
          "purpose": "ENCRYPT_DECRYPT",
          "rotation_period": null,
          "skip_initial_version_creation": null,
          "timeouts": null
        },
        "after_unknown": {
          "id": true,
          "key_ring": true,
          "self_link": true,
          "version_template": true
        },
        "before": null
      },
      "mode": "managed",
      "name": "invalid_key_1",
      "provider_name": "registry.terraform.io/hashicorp/google",
      "type": "google_kms_crypto_key"
    },
    {
      "address": "google_kms_crypto_key.invalid_key_2",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "labels": null,
          "name": "crypto-key-example",
          "purpose": "ENCRYPT_DECRYPT",
          "rotation_period": "7776002s",
          "skip_initial_version_creation": null,
          "timeouts": null
        },
        "after_unknown": {
          "id": true,
          "key_ring": true,
          "self_link": true,
          "version_template": true
        },
        "before": null
      },
      "mode": "managed",
      "name": "invalid_key_2",
      "provider_name": "registry.terraform.io/hashicorp/google",
      "type": "google_kms_crypto_key"
    },
    {
      "address": "google_kms_crypto_key.valid_key_1",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "labels": null,
          "name": "crypto-key-example",
          "purpose": "ENCRYPT_DECRYPT",
          "rotation_period": "7776000s",
          "skip_initial_version_creation": null,
          "timeouts": null
        },
        "after_unknown": {
          "id": true,
          "key_ring": true,
          "self_link": true,
          "version_template": true
        },
        "before": null
      },
      "mode": "managed",
      "name": "valid_key_1",
      "provider_name": "registry.terraform.io/hashicorp/google",
      "type": "google_kms_crypto_key"
    },
    {
      "address": "google_kms_key_ring.keyring",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "location": "global",
          "name": "keyring-example",
          "timeouts": null
        },
        "after_unknown": {
          "id": true,
          "project": true,
          "self_link": true
        },
        "before": null
      },
      "mode": "managed",
      "name": "keyring",
      "provider_name": "registry.terraform.io/hashicorp/google",
      "type": "google_kms_key_ring"
    }
  ],
  "terraform_version": "0.13.5"
}

