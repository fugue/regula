provider "google" {}

resource "google_compute_instance" "test" {
  name         = "no-metadata-keys-set"
  machine_type = "e2-micro"
  zone         = "us-east1-b"


  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network = "default"

    access_config {

    }
  }
}
