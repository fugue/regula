package rules.cloudfront_distribution_https

resource_type = "aws_cloudfront_distribution"

controls = {
  "NIST-800-53_AC-17 (2)",
  "NIST-800-53_SC-8",
}

# Explicitly allow only https or redirection to https.
valid_protocols = {
  "redirect-to-https",
  "https-only"
}

used_traffic_protocols[protocol] {
  protocol = input.default_cache_behavior[_].viewer_protocol_policy
}

default allow = false

allow {
  # Difference of used_traffic_protocols and valid_protocols must be empty.
  count(used_traffic_protocols - valid_protocols) == 0
}
