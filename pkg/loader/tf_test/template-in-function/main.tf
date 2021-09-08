resource "aws_s3_bucket" "test1" {
  bucket  = "test1"
}

resource "aws_s3_bucket_policy" "test1" {
  bucket = "${aws_s3_bucket.test1.id}"
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "MYBUCKETPOLICY"
    Statement = [
      {
        Sid       = "IPAllow"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:List*"
        # Resource =        "*"
        Resource =        "${aws_s3_bucket.test1.arn}/*"
      },
    ]
  })  
}
