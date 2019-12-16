package index

import data.fugue.regula

index = regula.index([
  # {"package": "kms_rotate_advanced"},
  # {"resource_type": "aws_kms_key", "package": "kms_rotate_allow"},
  {"resource_type": "aws_kms_key", "package": "kms_rotate_allow_deny"},
  # {"resource_type": "aws_kms_key", "package": "kms_rotate_deny"}
])
