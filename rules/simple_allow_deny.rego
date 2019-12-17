package rules.simple_allow_deny

resource_type = "aws_ebs_volume"

default allow = false
default deny = false

allow {
  input.encrypted == true
}

deny {
  input.size > 10
}
