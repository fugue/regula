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
#     tests/rules/gcp/inputs/gcp_compute_firewall_no_ingress_22_infra.tf
#
# using `generate_test_inputs.sh` and should not be modified
# directly.
package tests.rules.gcp_compute_firewall_no_ingress_22
mock_input = {
  "format_version": "0.1",
  "terraform_version": "0.12.20",
  "planned_values": {
    "root_module": {
      "resources": [
        {
          "address": "google_compute_firewall.invalid-rule-1",
          "mode": "managed",
          "type": "google_compute_firewall",
          "name": "invalid-rule-1",
          "provider_name": "google",
          "schema_version": 1,
          "values": {
            "allow": [
              {
                "ports": [
                  "22",
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
            "enable_logging": null,
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
          "type": "google_compute_firewall",
          "name": "invalid-rule-2",
          "provider_name": "google",
          "schema_version": 1,
          "values": {
            "allow": [
              {
                "ports": [
                  "20-24"
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
            "enable_logging": null,
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
          "type": "google_compute_firewall",
          "name": "valid-rule-1",
          "provider_name": "google",
          "schema_version": 1,
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
            "enable_logging": null,
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
          "type": "google_compute_firewall",
          "name": "valid-rule-2",
          "provider_name": "google",
          "schema_version": 1,
          "values": {
            "allow": [
              {
                "ports": [
                  "22"
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
            "enable_logging": null,
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
          "type": "google_compute_network",
          "name": "default",
          "provider_name": "google",
          "schema_version": 0,
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
      "mode": "managed",
      "type": "google_compute_firewall",
      "name": "invalid-rule-1",
      "provider_name": "google",
      "change": {
        "actions": [
          "create"
        ],
        "before": null,
        "after": {
          "allow": [
            {
              "ports": [
                "22",
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
          "enable_logging": null,
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
          "id": true,
          "project": true,
          "self_link": true,
          "source_ranges": [
            false
          ]
        }
      }
    },
    {
      "address": "google_compute_firewall.invalid-rule-2",
      "mode": "managed",
      "type": "google_compute_firewall",
      "name": "invalid-rule-2",
      "provider_name": "google",
      "change": {
        "actions": [
          "create"
        ],
        "before": null,
        "after": {
          "allow": [
            {
              "ports": [
                "20-24"
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
          "enable_logging": null,
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
          "id": true,
          "project": true,
          "self_link": true,
          "source_ranges": [
            false
          ]
        }
      }
    },
    {
      "address": "google_compute_firewall.valid-rule-1",
      "mode": "managed",
      "type": "google_compute_firewall",
      "name": "valid-rule-1",
      "provider_name": "google",
      "change": {
        "actions": [
          "create"
        ],
        "before": null,
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
          "enable_logging": null,
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
          "id": true,
          "project": true,
          "self_link": true,
          "source_ranges": [
            false
          ],
          "source_tags": [
            false
          ]
        }
      }
    },
    {
      "address": "google_compute_firewall.valid-rule-2",
      "mode": "managed",
      "type": "google_compute_firewall",
      "name": "valid-rule-2",
      "provider_name": "google",
      "change": {
        "actions": [
          "create"
        ],
        "before": null,
        "after": {
          "allow": [
            {
              "ports": [
                "22"
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
          "enable_logging": null,
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
            },
            {
              "ports": []
            }
          ],
          "creation_timestamp": true,
          "deny": [],
          "destination_ranges": true,
          "direction": true,
          "id": true,
          "project": true,
          "self_link": true,
          "source_ranges": true
        }
      }
    },
    {
      "address": "google_compute_network.default",
      "mode": "managed",
      "type": "google_compute_network",
      "name": "default",
      "provider_name": "google",
      "change": {
        "actions": [
          "create"
        ],
        "before": null,
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
          "ipv4_range": true,
          "project": true,
          "routing_mode": true,
          "self_link": true
        }
      }
    }
  ],
  "configuration": {
    "root_module": {
      "resources": [
        {
          "address": "google_compute_firewall.invalid-rule-1",
          "mode": "managed",
          "type": "google_compute_firewall",
          "name": "invalid-rule-1",
          "provider_config_key": "google",
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
                    "22",
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
          "schema_version": 1
        },
        {
          "address": "google_compute_firewall.invalid-rule-2",
          "mode": "managed",
          "type": "google_compute_firewall",
          "name": "invalid-rule-2",
          "provider_config_key": "google",
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
                    "20-24"
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
          "schema_version": 1
        },
        {
          "address": "google_compute_firewall.valid-rule-1",
          "mode": "managed",
          "type": "google_compute_firewall",
          "name": "valid-rule-1",
          "provider_config_key": "google",
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
          "schema_version": 1
        },
        {
          "address": "google_compute_firewall.valid-rule-2",
          "mode": "managed",
          "type": "google_compute_firewall",
          "name": "valid-rule-2",
          "provider_config_key": "google",
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
                    "22"
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
          "schema_version": 1
        },
        {
          "address": "google_compute_network.default",
          "mode": "managed",
          "type": "google_compute_network",
          "name": "default",
          "provider_config_key": "google",
          "expressions": {
            "name": {
              "constant_value": "test-network"
            }
          },
          "schema_version": 0
        }
      ]
    }
  }
}
