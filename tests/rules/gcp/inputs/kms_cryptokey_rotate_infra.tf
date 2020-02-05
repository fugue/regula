resource "google_kms_key_ring" "keyring" {
  name     = "keyring-example"
  location = "global"
}

resource "google_kms_crypto_key" "valid_key_1" {
  name            = "crypto-key-example"
  key_ring        = "${google_kms_key_ring.keyring.self_link}"
  rotation_period = "31536000s"

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_kms_crypto_key" "invalid_key_1" {
  name            = "crypto-key-example"
  key_ring        = "${google_kms_key_ring.keyring.self_link}"

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_kms_crypto_key" "invalid_key_2" {
  name            = "crypto-key-example"
  key_ring        = "${google_kms_key_ring.keyring.self_link}"
  rotation_period = "31536002s"

  lifecycle {
    prevent_destroy = true
  }
}