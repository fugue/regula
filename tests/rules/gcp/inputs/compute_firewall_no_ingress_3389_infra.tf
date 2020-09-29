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
resource "google_compute_network" "default" {
  name = "test-network"
}

resource "google_compute_firewall" "valid-rule-1" {
  name    = "valid-rule-1"
  network = google_compute_network.default.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "8080", "1000-2000"]
  }

  source_tags = ["web"]

  source_ranges = ["0.0.0.0/0"]
  
}

resource "google_compute_firewall" "valid-rule-2" {
  name    = "valid-rule-2"
  network = google_compute_network.default.name

  allow {
    protocol = "tcp"
    ports    = ["3389"]
  }
}

resource "google_compute_firewall" "invalid-rule-1" {
  name    = "invalid-rule-1"
  network = google_compute_network.default.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["3389", "8080", "1000-2000"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "invalid-rule-2" {
  name    = "invalid-rule-2"
  network = google_compute_network.default.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["3320-3395", "20"]
  }

  source_ranges = ["0.0.0.0/0"]
}

