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
package tests.rules.tf.google.compute.inputs.firewall_no_ingress_3389_infra_json

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
          "address": "google_compute_firewall.invalid-rule-1",
          "expressions": {
            "allow": [
              {
                "protocol": {
                  "constant_value": "icmp"
                }
              },
              {
                "ports": {
                  "constant_value": [
                    "3389",
                    "8080",
                    "1000-2000"
                  ]
                },
                "protocol": {
                  "constant_value": "tcp"
                }
              }
            ],
            "name": {
              "constant_value": "invalid-rule-1"
            },
            "network": {
              "references": [
                "google_compute_network.default"
              ]
            },
            "source_ranges": {
              "constant_value": [
                "0.0.0.0/0"
              ]
            }
          },
          "mode": "managed",
          "name": "invalid-rule-1",
          "provider_config_key": "google",
          "schema_version": 1,
          "type": "google_compute_firewall"
        },
        {
          "address": "google_compute_firewall.invalid-rule-2",
          "expressions": {
            "allow": [
              {
                "protocol": {
                  "constant_value": "icmp"
                }
              },
              {
                "ports": {
                  "constant_value": [
                    "3320-3395",
                    "20"
                  ]
                },
                "protocol": {
                  "constant_value": "tcp"
                }
              }
            ],
            "name": {
              "constant_value": "invalid-rule-2"
            },
            "network": {
              "references": [
                "google_compute_network.default"
              ]
            },
            "source_ranges": {
              "constant_value": [
                "0.0.0.0/0"
              ]
            }
          },
          "mode": "managed",
          "name": "invalid-rule-2",
          "provider_config_key": "google",
          "schema_version": 1,
          "type": "google_compute_firewall"
        },
        {
          "address": "google_compute_firewall.valid-rule-1",
          "expressions": {
            "allow": [
              {
                "protocol": {
                  "constant_value": "icmp"
                }
              },
              {
                "ports": {
                  "constant_value": [
                    "80",
                    "8080",
                    "1000-2000"
                  ]
                },
                "protocol": {
                  "constant_value": "tcp"
                }
              }
            ],
            "name": {
              "constant_value": "valid-rule-1"
            },
            "network": {
              "references": [
                "google_compute_network.default"
              ]
            },
            "source_ranges": {
              "constant_value": [
                "0.0.0.0/0"
              ]
            },
            "source_tags": {
              "constant_value": [
                "web"
              ]
            }
          },
          "mode": "managed",
          "name": "valid-rule-1",
          "provider_config_key": "google",
          "schema_version": 1,
          "type": "google_compute_firewall"
        },
        {
          "address": "google_compute_firewall.valid-rule-2",
          "expressions": {
            "allow": [
              {
                "ports": {
                  "constant_value": [
                    "3389"
                  ]
                },
                "protocol": {
                  "constant_value": "tcp"
                }
              }
            ],
            "name": {
              "constant_value": "valid-rule-2"
            },
            "network": {
              "references": [
                "google_compute_network.default"
              ]
            }
          },
          "mode": "managed",
          "name": "valid-rule-2",
          "provider_config_key": "google",
          "schema_version": 1,
          "type": "google_compute_firewall"
        },
        {
          "address": "google_compute_network.default",
          "expressions": {
            "name": {
              "constant_value": "test-network"
            }
          },
          "mode": "managed",
          "name": "default",
          "provider_config_key": "google",
          "schema_version": 0,
          "type": "google_compute_network"
        }
      ]
    }
  },
  "format_version": "0.1",
  "planned_values": {
    "root_module": {
      "resources": [
        {
          "address": "google_compute_firewall.invalid-rule-1",
          "mode": "managed",
          "name": "invalid-rule-1",
          "provider_name": "registry.terraform.io/hashicorp/google",
          "schema_version": 1,
          "type": "google_compute_firewall",
          "values": {
            "allow": [
              {
                "ports": [
                  "3389",
                  "8080",
                  "1000-2000"
                ],
                "protocol": "tcp"
              },
              {
                "ports": [],
                "protocol": "icmp"
              }
            ],
            "deny": [],
            "description": null,
            "disabled": null,
            "log_config": [],
            "name": "invalid-rule-1",
            "network": "test-network",
            "priority": 1000,
            "source_ranges": [
              "0.0.0.0/0"
            ],
            "source_service_accounts": null,
            "source_tags": null,
            "target_service_accounts": null,
            "target_tags": null,
            "timeouts": null
          }
        },
        {
          "address": "google_compute_firewall.invalid-rule-2",
          "mode": "managed",
          "name": "invalid-rule-2",
          "provider_name": "registry.terraform.io/hashicorp/google",
          "schema_version": 1,
          "type": "google_compute_firewall",
          "values": {
            "allow": [
              {
                "ports": [
                  "3320-3395",
                  "20"
                ],
                "protocol": "tcp"
              },
              {
                "ports": [],
                "protocol": "icmp"
              }
            ],
            "deny": [],
            "description": null,
            "disabled": null,
            "log_config": [],
            "name": "invalid-rule-2",
            "network": "test-network",
            "priority": 1000,
            "source_ranges": [
              "0.0.0.0/0"
            ],
            "source_service_accounts": null,
            "source_tags": null,
            "target_service_accounts": null,
            "target_tags": null,
            "timeouts": null
          }
        },
        {
          "address": "google_compute_firewall.valid-rule-1",
          "mode": "managed",
          "name": "valid-rule-1",
          "provider_name": "registry.terraform.io/hashicorp/google",
          "schema_version": 1,
          "type": "google_compute_firewall",
          "values": {
            "allow": [
              {
                "ports": [
                  "80",
                  "8080",
                  "1000-2000"
                ],
                "protocol": "tcp"
              },
              {
                "ports": [],
                "protocol": "icmp"
              }
            ],
            "deny": [],
            "description": null,
            "disabled": null,
            "log_config": [],
            "name": "valid-rule-1",
            "network": "test-network",
            "priority": 1000,
            "source_ranges": [
              "0.0.0.0/0"
            ],
            "source_service_accounts": null,
            "source_tags": [
              "web"
            ],
            "target_service_accounts": null,
            "target_tags": null,
            "timeouts": null
          }
        },
        {
          "address": "google_compute_firewall.valid-rule-2",
          "mode": "managed",
          "name": "valid-rule-2",
          "provider_name": "registry.terraform.io/hashicorp/google",
          "schema_version": 1,
          "type": "google_compute_firewall",
          "values": {
            "allow": [
              {
                "ports": [
                  "3389"
                ],
                "protocol": "tcp"
              }
            ],
            "deny": [],
            "description": null,
            "disabled": null,
            "log_config": [],
            "name": "valid-rule-2",
            "network": "test-network",
            "priority": 1000,
            "source_service_accounts": null,
            "source_tags": null,
            "target_service_accounts": null,
            "target_tags": null,
            "timeouts": null
          }
        },
        {
          "address": "google_compute_network.default",
          "mode": "managed",
          "name": "default",
          "provider_name": "registry.terraform.io/hashicorp/google",
          "schema_version": 0,
          "type": "google_compute_network",
          "values": {
            "auto_create_subnetworks": true,
            "delete_default_routes_on_create": false,
            "description": null,
            "name": "test-network",
            "timeouts": null
          }
        }
      ]
    }
  },
  "resource_changes": [
    {
      "address": "google_compute_firewall.invalid-rule-1",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "allow": [
            {
              "ports": [
                "3389",
                "8080",
                "1000-2000"
              ],
              "protocol": "tcp"
            },
            {
              "ports": [],
              "protocol": "icmp"
            }
          ],
          "deny": [],
          "description": null,
          "disabled": null,
          "log_config": [],
          "name": "invalid-rule-1",
          "network": "test-network",
          "priority": 1000,
          "source_ranges": [
            "0.0.0.0/0"
          ],
          "source_service_accounts": null,
          "source_tags": null,
          "target_service_accounts": null,
          "target_tags": null,
          "timeouts": null
        },
        "after_unknown": {
          "allow": [
            {
              "ports": [
                false,
                false,
                false
              ]
            },
            {
              "ports": []
            }
          ],
          "creation_timestamp": true,
          "deny": [],
          "destination_ranges": true,
          "direction": true,
          "enable_logging": true,
          "id": true,
          "log_config": [],
          "project": true,
          "self_link": true,
          "source_ranges": [
            false
          ]
        },
        "before": null
      },
      "mode": "managed",
      "name": "invalid-rule-1",
      "provider_name": "registry.terraform.io/hashicorp/google",
      "type": "google_compute_firewall"
    },
    {
      "address": "google_compute_firewall.invalid-rule-2",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "allow": [
            {
              "ports": [
                "3320-3395",
                "20"
              ],
              "protocol": "tcp"
            },
            {
              "ports": [],
              "protocol": "icmp"
            }
          ],
          "deny": [],
          "description": null,
          "disabled": null,
          "log_config": [],
          "name": "invalid-rule-2",
          "network": "test-network",
          "priority": 1000,
          "source_ranges": [
            "0.0.0.0/0"
          ],
          "source_service_accounts": null,
          "source_tags": null,
          "target_service_accounts": null,
          "target_tags": null,
          "timeouts": null
        },
        "after_unknown": {
          "allow": [
            {
              "ports": [
                false,
                false
              ]
            },
            {
              "ports": []
            }
          ],
          "creation_timestamp": true,
          "deny": [],
          "destination_ranges": true,
          "direction": true,
          "enable_logging": true,
          "id": true,
          "log_config": [],
          "project": true,
          "self_link": true,
          "source_ranges": [
            false
          ]
        },
        "before": null
      },
      "mode": "managed",
      "name": "invalid-rule-2",
      "provider_name": "registry.terraform.io/hashicorp/google",
      "type": "google_compute_firewall"
    },
    {
      "address": "google_compute_firewall.valid-rule-1",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "allow": [
            {
              "ports": [
                "80",
                "8080",
                "1000-2000"
              ],
              "protocol": "tcp"
            },
            {
              "ports": [],
              "protocol": "icmp"
            }
          ],
          "deny": [],
          "description": null,
          "disabled": null,
          "log_config": [],
          "name": "valid-rule-1",
          "network": "test-network",
          "priority": 1000,
          "source_ranges": [
            "0.0.0.0/0"
          ],
          "source_service_accounts": null,
          "source_tags": [
            "web"
          ],
          "target_service_accounts": null,
          "target_tags": null,
          "timeouts": null
        },
        "after_unknown": {
          "allow": [
            {
              "ports": [
                false,
                false,
                false
              ]
            },
            {
              "ports": []
            }
          ],
          "creation_timestamp": true,
          "deny": [],
          "destination_ranges": true,
          "direction": true,
          "enable_logging": true,
          "id": true,
          "log_config": [],
          "project": true,
          "self_link": true,
          "source_ranges": [
            false
          ],
          "source_tags": [
            false
          ]
        },
        "before": null
      },
      "mode": "managed",
      "name": "valid-rule-1",
      "provider_name": "registry.terraform.io/hashicorp/google",
      "type": "google_compute_firewall"
    },
    {
      "address": "google_compute_firewall.valid-rule-2",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "allow": [
            {
              "ports": [
                "3389"
              ],
              "protocol": "tcp"
            }
          ],
          "deny": [],
          "description": null,
          "disabled": null,
          "log_config": [],
          "name": "valid-rule-2",
          "network": "test-network",
          "priority": 1000,
          "source_service_accounts": null,
          "source_tags": null,
          "target_service_accounts": null,
          "target_tags": null,
          "timeouts": null
        },
        "after_unknown": {
          "allow": [
            {
              "ports": [
                false
              ]
            }
          ],
          "creation_timestamp": true,
          "deny": [],
          "destination_ranges": true,
          "direction": true,
          "enable_logging": true,
          "id": true,
          "log_config": [],
          "project": true,
          "self_link": true,
          "source_ranges": true
        },
        "before": null
      },
      "mode": "managed",
      "name": "valid-rule-2",
      "provider_name": "registry.terraform.io/hashicorp/google",
      "type": "google_compute_firewall"
    },
    {
      "address": "google_compute_network.default",
      "change": {
        "actions": [
          "create"
        ],
        "after": {
          "auto_create_subnetworks": true,
          "delete_default_routes_on_create": false,
          "description": null,
          "name": "test-network",
          "timeouts": null
        },
        "after_unknown": {
          "gateway_ipv4": true,
          "id": true,
          "mtu": true,
          "project": true,
          "routing_mode": true,
          "self_link": true
        },
        "before": null
      },
      "mode": "managed",
      "name": "default",
      "provider_name": "registry.terraform.io/hashicorp/google",
      "type": "google_compute_network"
    }
  ],
  "terraform_version": "0.13.5"
}

