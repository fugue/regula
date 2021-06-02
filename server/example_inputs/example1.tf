terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }
  required_version = ">= 0.14.7"
}

data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "inventory" {
  bucket = "regula-example-${data.aws_caller_identity.current.account_id}"
}
