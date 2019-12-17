package rules.advanced

import data.fugue

resource_type = "MULTIPLE"

volumes = fugue.resources("aws_ebs_volume")

valid_volume(volume) {
  volume.encrypted == true
}

policy[p] {
  volume = volumes[_]
  valid_volume(volume)
  p = fugue.allow_resource(volume)
} {
  volume = volumes[_]
  not valid_volume(volume)
  p = fugue.deny_resource(volume)
}
