variable "department" {
  type = string
  default = "engineering"
}

variable "environment" {
  type = string
}

resource "aws_s3_bucket" "main" {
  tags = {
    department = var.department
    environment = var.environment
  }
}
