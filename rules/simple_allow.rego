package rules.simple_allow

resource_type = "aws_ebs_volume"

default allow = false

allow {
  input.encrypted == true
}
