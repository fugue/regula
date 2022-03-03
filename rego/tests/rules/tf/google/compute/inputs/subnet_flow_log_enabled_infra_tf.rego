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
package tests.rules.tf.google.compute.inputs.subnet_flow_log_enabled_infra_tf

import data.fugue.resource_view.resource_view_input

mock_input := ret {
  ret = resource_view_input with input as mock_config
}
mock_resources := mock_input.resources
mock_config := {
  "hcl_resource_view_version": "0.0.1",
  "resources": {
    "google_compute_network.custom-test": {
      "_filepath": "tests/rules/tf/google/compute/inputs/subnet_flow_log_enabled_infra.tf",
      "_provider": "google",
      "_type": "google_compute_network",
      "auto_create_subnetworks": false,
      "id": "google_compute_network.custom-test",
      "name": "test-network"
    },
    "google_compute_subnetwork.invalid-subnet-1": {
      "_filepath": "tests/rules/tf/google/compute/inputs/subnet_flow_log_enabled_infra.tf",
      "_provider": "google",
      "_type": "google_compute_subnetwork",
      "id": "google_compute_subnetwork.invalid-subnet-1",
      "ip_cidr_range": "10.0.0.0/16",
      "name": "invalid-subnet-1",
      "network": "google_compute_network.custom-test",
      "private_ip_google_access": false,
      "region": "us-central1"
    },
    "google_compute_subnetwork.valid-subnet-1": {
      "_filepath": "tests/rules/tf/google/compute/inputs/subnet_flow_log_enabled_infra.tf",
      "_provider": "google",
      "_type": "google_compute_subnetwork",
      "id": "google_compute_subnetwork.valid-subnet-1",
      "ip_cidr_range": "10.2.0.0/16",
      "log_config": [
        {
          "aggregation_interval": "INTERVAL_10_MIN",
          "flow_sampling": 0.5,
          "metadata": "INCLUDE_ALL_METADATA"
        }
      ],
      "name": "valid-subnet-1",
      "network": "google_compute_network.custom-test",
      "private_ip_google_access": true,
      "region": "us-central1"
    },
    "google_compute_subnetwork.valid-subnet-2": {
      "_filepath": "tests/rules/tf/google/compute/inputs/subnet_flow_log_enabled_infra.tf",
      "_provider": "google",
      "_type": "google_compute_subnetwork",
      "id": "google_compute_subnetwork.valid-subnet-2",
      "ip_cidr_range": "10.2.0.0/16",
      "log_config": [
        {
          "aggregation_interval": "INTERVAL_10_MIN"
        }
      ],
      "name": "valid-subnet-2",
      "network": "google_compute_network.custom-test",
      "region": "us-central1"
    }
  }
}

