resource "google_compute_subnetwork" "valid-subnet-1" {
  name          = "valid-subnet-1"
  ip_cidr_range = "10.2.0.0/16"
  region        = "us-central1"
  network       = google_compute_network.custom-test.self_link
  private_ip_google_access = true
}

resource "google_compute_subnetwork" "invalid-subnet-1" {
  name          = "invalid-subnet-1"
  ip_cidr_range = "10.2.0.0/16"
  region        = "us-central1"
  network       = google_compute_network.custom-test.self_link
}

resource "google_compute_subnetwork" "invalid-subnet-2" {
  name          = "invalid-subnet-2"
  ip_cidr_range = "10.0.0.0/16"
  region        = "us-central1"
  network       = google_compute_network.custom-test.self_link
  private_ip_google_access = false
}

resource "google_compute_network" "custom-test" {
  name                    = "test-network"
  auto_create_subnetworks = false
}

