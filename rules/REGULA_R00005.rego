package rules.REGULA_R00005

resource_type = "aws_security_group"
controls = {"CIS_4-2", "REGULA_R00005"}

# VPC security groups should not permit unrestricted access from the internet to port 3389 (RDP). Removing unfettered connectivity to remote console services, such as Remote Desktop Protocol, reduces a server's exposure to risk.

invalid_port = 3389

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
