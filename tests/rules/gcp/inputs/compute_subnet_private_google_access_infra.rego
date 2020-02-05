# This package was automatically generated from:
#
#     tests/rules/gcp/inputs/gcp_compute_subnet_private_google_access_infra.tf
#
# using `generate_test_inputs.sh` and should not be modified
# directly.
package tests.rules.gcp_compute_subnet_private_google_access
mock_input = {
  "format_version": "0.1",
  "terraform_version": "0.12.20",
  "planned_values": {
    "root_module": {
      "resources": [
        {
          "address": "google_compute_network.custom-test",
          "mode": "managed",
          "type": "google_compute_network",
          "name": "custom-test",
          "provider_name": "google",
          "schema_version": 0,
          "values": {
            "auto_create_subnetworks": false,
            "delete_default_routes_on_create": false,
            "description": null,
            "name": "test-network",
            "timeouts": null
          }
        },
        {
          "address": "google_compute_subnetwork.invalid-subnet-1",
          "mode": "managed",
          "type": "google_compute_subnetwork",
          "name": "invalid-subnet-1",
          "provider_name": "google",
          "schema_version": 0,
          "values": {
            "description": null,
            "ip_cidr_range": "10.2.0.0/16",
            "log_config": [],
            "name": "invalid-subnet-1",
            "private_ip_google_access": null,
            "region": "us-central1",
            "timeouts": null
          }
        },
        {
          "address": "google_compute_subnetwork.invalid-subnet-2",
          "mode": "managed",
          "type": "google_compute_subnetwork",
          "name": "invalid-subnet-2",
          "provider_name": "google",
          "schema_version": 0,
          "values": {
            "description": null,
            "ip_cidr_range": "10.0.0.0/16",
            "log_config": [],
            "name": "invalid-subnet-2",
            "private_ip_google_access": false,
            "region": "us-central1",
            "timeouts": null
          }
        },
        {
          "address": "google_compute_subnetwork.valid-subnet-1",
          "mode": "managed",
          "type": "google_compute_subnetwork",
          "name": "valid-subnet-1",
          "provider_name": "google",
          "schema_version": 0,
          "values": {
            "description": null,
            "ip_cidr_range": "10.2.0.0/16",
            "log_config": [],
            "name": "valid-subnet-1",
            "private_ip_google_access": true,
            "region": "us-central1",
            "timeouts": null
          }
        }
      ]
    }
  },
  "resource_changes": [
    {
      "address": "google_compute_network.custom-test",
      "mode": "managed",
      "type": "google_compute_network",
      "name": "custom-test",
      "provider_name": "google",
      "change": {
        "actions": [
          "create"
        ],
        "before": null,
        "after": {
          "auto_create_subnetworks": false,
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
    },
    {
      "address": "google_compute_subnetwork.invalid-subnet-1",
      "mode": "managed",
      "type": "google_compute_subnetwork",
      "name": "invalid-subnet-1",
      "provider_name": "google",
      "change": {
        "actions": [
          "create"
        ],
        "before": null,
        "after": {
          "description": null,
          "ip_cidr_range": "10.2.0.0/16",
          "log_config": [],
          "name": "invalid-subnet-1",
          "private_ip_google_access": null,
          "region": "us-central1",
          "timeouts": null
        },
        "after_unknown": {
          "creation_timestamp": true,
          "enable_flow_logs": true,
          "fingerprint": true,
          "gateway_address": true,
          "id": true,
          "log_config": [],
          "network": true,
          "project": true,
          "secondary_ip_range": true,
          "self_link": true
        }
      }
    },
    {
      "address": "google_compute_subnetwork.invalid-subnet-2",
      "mode": "managed",
      "type": "google_compute_subnetwork",
      "name": "invalid-subnet-2",
      "provider_name": "google",
      "change": {
        "actions": [
          "create"
        ],
        "before": null,
        "after": {
          "description": null,
          "ip_cidr_range": "10.0.0.0/16",
          "log_config": [],
          "name": "invalid-subnet-2",
          "private_ip_google_access": false,
          "region": "us-central1",
          "timeouts": null
        },
        "after_unknown": {
          "creation_timestamp": true,
          "enable_flow_logs": true,
          "fingerprint": true,
          "gateway_address": true,
          "id": true,
          "log_config": [],
          "network": true,
          "project": true,
          "secondary_ip_range": true,
          "self_link": true
        }
      }
    },
    {
      "address": "google_compute_subnetwork.valid-subnet-1",
      "mode": "managed",
      "type": "google_compute_subnetwork",
      "name": "valid-subnet-1",
      "provider_name": "google",
      "change": {
        "actions": [
          "create"
        ],
        "before": null,
        "after": {
          "description": null,
          "ip_cidr_range": "10.2.0.0/16",
          "log_config": [],
          "name": "valid-subnet-1",
          "private_ip_google_access": true,
          "region": "us-central1",
          "timeouts": null
        },
        "after_unknown": {
          "creation_timestamp": true,
          "enable_flow_logs": true,
          "fingerprint": true,
          "gateway_address": true,
          "id": true,
          "log_config": [],
          "network": true,
          "project": true,
          "secondary_ip_range": true,
          "self_link": true
        }
      }
    }
  ],
  "configuration": {
    "root_module": {
      "resources": [
        {
          "address": "google_compute_network.custom-test",
          "mode": "managed",
          "type": "google_compute_network",
          "name": "custom-test",
          "provider_config_key": "google",
          "expressions": {
            "auto_create_subnetworks": {
              "constant_value": false
            },
            "name": {
              "constant_value": "test-network"
            }
          },
          "schema_version": 0
        },
        {
          "address": "google_compute_subnetwork.invalid-subnet-1",
          "mode": "managed",
          "type": "google_compute_subnetwork",
          "name": "invalid-subnet-1",
          "provider_config_key": "google",
          "expressions": {
            "ip_cidr_range": {
              "constant_value": "10.2.0.0/16"
            },
            "name": {
              "constant_value": "invalid-subnet-1"
            },
            "network": {
              "references": [
                "google_compute_network.custom-test"
              ]
            },
            "region": {
              "constant_value": "us-central1"
            }
          },
          "schema_version": 0
        },
        {
          "address": "google_compute_subnetwork.invalid-subnet-2",
          "mode": "managed",
          "type": "google_compute_subnetwork",
          "name": "invalid-subnet-2",
          "provider_config_key": "google",
          "expressions": {
            "ip_cidr_range": {
              "constant_value": "10.0.0.0/16"
            },
            "name": {
              "constant_value": "invalid-subnet-2"
            },
            "network": {
              "references": [
                "google_compute_network.custom-test"
              ]
            },
            "private_ip_google_access": {
              "constant_value": false
            },
            "region": {
              "constant_value": "us-central1"
            }
          },
          "schema_version": 0
        },
        {
          "address": "google_compute_subnetwork.valid-subnet-1",
          "mode": "managed",
          "type": "google_compute_subnetwork",
          "name": "valid-subnet-1",
          "provider_config_key": "google",
          "expressions": {
            "ip_cidr_range": {
              "constant_value": "10.2.0.0/16"
            },
            "name": {
              "constant_value": "valid-subnet-1"
            },
            "network": {
              "references": [
                "google_compute_network.custom-test"
              ]
            },
            "private_ip_google_access": {
              "constant_value": true
            },
            "region": {
              "constant_value": "us-central1"
            }
          },
          "schema_version": 0
        }
      ]
    }
  }
}
