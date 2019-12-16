package rules.kms_rotate

deny {
  input.enable_key_rotation != true
}
