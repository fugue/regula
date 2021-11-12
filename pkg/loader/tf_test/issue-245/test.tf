# KO
variable "dashboard_url" {}

# OK <----- Uncomment this one and comment the one above
#variable "dashboard_url" {
#  default = "http://example.com"
#}

locals {
  s3_cors_origins = [terraform.workspace == "dev" ? "*" : var.dashboard_url]
}
