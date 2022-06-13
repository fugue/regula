provider "aws" {
    region = "us-east-1"
}

variable "booly" {
    type = bool
}

variable "listy" {
    type = list(string)
}

variable "mappy" {
    type = map(string)
}

resource "aws_s3_bucket" "bucket" {
    tags = {
        booly = var.booly ? "yes" : "no"
        listy = var.listy[0]
        mappy = var.mappy["key"]
    }
}
