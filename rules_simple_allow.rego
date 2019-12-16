package rules.kms_rotate_allow

default allow = false

allow {
  input.enable_key_rotation == true
}
