# Copyright 2020-2022 Fugue, Inc.
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
provider google {}

resource "google_compute_network" "test" {
  name = "test-network"
}

resource "google_compute_firewall" "allow_all_22" {
  name = "allow-all-22-3389"
  network = google_compute_network.test.name
  source_ranges = [ "0.0.0.0/0" ]
  direction = "INGRESS"
  priority = 100

  allow {
    protocol = "tcp"
    ports = [ "22", "3389" ]
  }
}

resource "google_compute_firewall" "allow_all_3389" {
  name = "deny-all-22-3389"
  network = google_compute_network.test.name
  source_ranges = [ "0.0.0.0/0" ]
  direction = "INGRESS"
  priority = 100

  deny {
    protocol = "tcp"
    ports = [ "22", "3389" ]
  }
}
