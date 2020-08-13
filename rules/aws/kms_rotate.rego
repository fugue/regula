package rules.kms_rotate

resource_type = "aws_kms_key"
controls = {"CIS_2-8", "REGULA_R00007"}

deny[msg] {
  not input.enable_key_rotation
  msg = "KMS key rotation should be enabled"
}
