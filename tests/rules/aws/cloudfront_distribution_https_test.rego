package tests.rules.cloudfront_distribution_https

import data.fugue.regula

test_cloudfront_distribution_https {
  report := regula.report with input as mock_input
  resources := report.rules.cloudfront_distribution_https.resources

  resources["aws_cloudfront_distribution.allow_all"].valid == false
  resources["aws_cloudfront_distribution.redirect_to_https"].valid == true
  resources["aws_cloudfront_distribution.https_only"].valid == true
}
