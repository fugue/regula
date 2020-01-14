provider "aws" {
  version = "~> 2.41"
  region  = "us-west-2"
}

resource "aws_kms_key" "valid" {
  description = "KMS key 1"
  enable_key_rotation = true
}

 resource "aws_kms_key" "invalid" {
   description = "KMS key 2"
   enable_key_rotation = false
 }
 
 resource "aws_kms_key" "blank-invalid" {
   description = "KMS key 3"
 }