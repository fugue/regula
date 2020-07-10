package rules.https_cloudfront_distribution
resource_type = "aws_cloudfront_distribution"
# NOT SURE ABOUT THE FBP AND NIST CONTROLS
# controls = {"NIST-800-53_SC-13"}

# Explicitly allow only https or redirection to https.
valid_traffic = {
  "redirect-to-https",
  "https-only"
}

used_traffic_protocols ( protocol ) {
   valid_traffic[protocol]
}

default allow = false
allow {
  count(input.default_cache_behavior[_].viewer_protocol_policy) > 0
  used_traffic_protocols(input.default_cache_behavior[_].viewer_protocol_policy)
}
