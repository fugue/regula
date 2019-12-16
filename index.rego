package index

import data.fugue.regula

index = regula.index([
  {"resource_type": "aws_kms_key", "package": "kms_rotate"},
  {"package": "kms_rotate_advanced"}
])
