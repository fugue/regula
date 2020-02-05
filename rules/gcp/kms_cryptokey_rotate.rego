# KMS crypto keys should be rotated at least once every 365 days

package rules.gcp_kms_cryptokey_rotate

controls = {"CIS_GCP_1-8", "REGULA_R00010"}
resource_type = "google_kms_crypto_key"

default allow = false

allow {
  rotation_per = input.rotation_period
  is_string(rotation_per)
  trimmed_rotation_per = trim_right(rotation_per, "s")
  num_rotation_per = to_number(trimmed_rotation_per)
  num_rotation_per <= 31536000
}