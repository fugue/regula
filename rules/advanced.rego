package rules.kms_rotate_advanced

import data.fugue

keys = fugue.resources("aws_kms_key")

invalid_key(key) {
  key.enable_key_rotation != true
}

policy[p] {
  key = keys[_]
  invalid_key(key)
  p = fugue.deny_resource(key)
} {
  key = keys[_]
  not invalid_key(key)
  p = fugue.allow_resource(key)
}
