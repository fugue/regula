package rules.kms_rotate

resource_type = "aws_kms_key"

default allow = false

allow {
  input.enable_key_rotation == true
}