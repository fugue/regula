package rules.simple_deny

resource_type = "aws_ebs_volume"

default deny = false

valid_volume(volume) {
  volume.encrypted == true
}

deny {
  not valid_volume(input)
}
