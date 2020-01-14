package rules.ebs_volume_encrypted

resource_type = "aws_ebs_volume"

default allow = false

allow {
  input.encrypted == true
}
