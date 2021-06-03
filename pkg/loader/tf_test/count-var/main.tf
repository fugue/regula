variable "create" {
  type    = bool
  default = false
}

resource "aws_s3_bucket" "optional_bucket" {
  count = var.create ? 1 : 0
  force_destroy = true
}
