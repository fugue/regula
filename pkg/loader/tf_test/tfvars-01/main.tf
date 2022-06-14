variable "using_default" {
    type = string
    default = "default_value"
}

variable "in_terraform_tfvars" {
    type = string
    default = "default_value"
}

variable "in_terraform_tfvars_json" {
    type = string
    default = "default_value"
}

variable "in_aaa_auto_tfvars" {
    type = string
    default = "default_value"
}

variable "in_bbb_auto_tfvars_json" {
    type = string
    default = "default_value"
}

variable "in_ccc_auto_tfvars" {
    type = string
    default = "default_value"
}

resource "aws_s3_bucket" "bucket" {
    tags = {
        var_1 = var.using_default
        var_2 = var.in_terraform_tfvars
        var_3 = var.in_terraform_tfvars_json
        var_4 = var.in_aaa_auto_tfvars
        var_5 = var.in_bbb_auto_tfvars_json
        var_6 = var.in_ccc_auto_tfvars
    }
}
