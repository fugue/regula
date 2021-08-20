provider "aws" {
  region = "us-east-1"
}

variable "default_network_acl_egress" {
  description = "List of maps of egress rules to set on the Default Network ACL"
  type        = list(map(string))

  default = [
    {
      rule_no    = 100
      action     = "allow"
      from_port  = 0
      to_port    = 0
      protocol   = "-1"
      cidr_block = "0.0.0.0/0"
    },
    {
      rule_no         = 101
      action          = "allow"
      from_port       = 0
      to_port         = 0
      protocol        = "-1"
      ipv6_cidr_block = "::/0"
    },
  ]
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/24"
}

resource "aws_network_acl" "main" {
  vpc_id = aws_vpc.main.id
  egress = reverse(var.default_network_acl_egress)
}
