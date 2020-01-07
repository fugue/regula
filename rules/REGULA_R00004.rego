package rules.REGULA_R00004

resource_type = "aws_security_group"
controls = {"CIS_4-1", "REGULA_R00004"}

# VPC security groups should not permit unrestricted access from the internet to port 22 (SSH). Removing unfettered connectivity to remote console services, such as SSH, reduces a server's exposure to risk.

invalid_port = 22

invalid_ingress_block(block) {
  block.cidr_blocks[_] == "0.0.0.0/0"
  block.from_port <= invalid_port
  block.to_port >= invalid_port
}

default deny = false

deny {
  block = input.ingress[_]
  invalid_ingress_block(block)
}