package rules.kms_rotate_allow_deny

default allow = false
default deny = false

allow {
  input.enable_key_rotation == true
}

deny {
  input.id = "aws_kms_key.valid"
}
