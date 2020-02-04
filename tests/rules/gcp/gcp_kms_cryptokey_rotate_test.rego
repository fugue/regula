package tests.rules.gcp_kms_cryptokey_rotate_test

import data.fugue.regula

test_gcp_kms_cryptokey_rotate {
  report := regula.report with input as mock_input
  resources := report.rules.gcp_kms_cryptokey_rotate.resources

  resources["google_kms_crypto_key.valid_key_1"].valid == true
  resources["google_kms_crypto_key.invalid_key_1"].valid == false
  resources["google_kms_crypto_key.invalid_key_2"].valid == false
}