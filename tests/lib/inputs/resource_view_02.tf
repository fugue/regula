provider "aws" {
  region = "us-west-2"
}

resource "aws_s3_bucket" "example" {
  bucket_prefix = "example"
}

data "aws_iam_policy_document" "example" {
  statement {
    effect = "Allow"
    actions = ["s3:*"]

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    resources = [
      "arn:aws:s3:::some-example-bucket/*",
      "arn:aws:s3:::${aws_s3_bucket.example.id}/*",
    ]
  }
}

resource "aws_iam_policy" "example" {
  policy = "${data.aws_iam_policy_document.example.json}"
}
