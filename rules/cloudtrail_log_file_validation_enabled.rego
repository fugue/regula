package rules.cloudtrail_log_file_validation_enabled

resource_type = "aws_cloudtrail"

controls = {"CIS_2-2", "REGULA_R00006"}

default allow = false

allow {
  input.enable_log_file_validation == true
}
