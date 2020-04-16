package rules.cloudtrail_log_file_validation

resource_type = "aws_cloudtrail"
controls = {
  "CIS_2-2",
  "NIST-800-53_AC-2g",
  "NIST-800-53_AC-6 (9)",
  "REGULA_R00006",
}

default allow = false

allow {
  input.enable_log_file_validation == true
}
