package tests.rules.s3_bucket_sse

import data.fugue.regula

test_s3_bucket_sse {
  report := regula.report with input as mock_input
  resources := report.rules.s3_bucket_sse.resources

  resources["aws_s3_bucket.unencrypted"].valid == false
  resources["aws_s3_bucket.aes_encrypted"].valid == true
  resources["aws_s3_bucket.kms_encrypted"].valid == true
}
