package rules.ebs_volume_encrypted

resource_type = "aws_ebs_volume"
controls = {"NIST-800-53_SC-13"}

default allow = false

allow {
  input.encrypted == true
}
