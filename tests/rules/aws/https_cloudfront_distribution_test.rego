package tests.rules.https_cloudfront_distribution

import data.fugue.regula

test_https_cloudfront_distribution {
  report := regula.report with input as mock_input
  resources := report.rules.https_cloudfront_distribution.resources

  resources["aws_cloudfront_distribution.allow_all"].valid == false
  resources["aws_cloudfront_distribution.redirect_to_https"].valid == true
  resources["aws_cloudfront_distribution.https_only"].valid == true
}
