package rules.kms_rotate_deny

default deny = false

deny {
  input.enable_key_rotation != true
}
