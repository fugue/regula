package rules.s3_bucket_sse

resource_type = "aws_s3_bucket"
controls = {"NIST-800-53_SC-13"}

# Explicitly allow AES256 or aws:kms server side SSE algorithms.
valid_sse_algorithms = {
  "AES256",
  "aws:kms"
}

# Collect all sse algorithms configued under `server_side_encryption_configuration`.
used_sse_algorithms[algorithm] {
  algorithm = input.server_side_encryption_configuration[_].rule[_][_][_].sse_algorithm
}

default allow = false
allow {
  count(used_sse_algorithms) > 0
  count(used_sse_algorithms - valid_sse_algorithms) <= 0
}
