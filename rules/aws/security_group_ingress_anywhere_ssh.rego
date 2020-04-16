# VPC security groups should not permit unrestricted access from the internet
# to port 22 (SSH). Removing unfettered connectivity to remote console services,
# such as SSH, reduces a server's exposure to risk.
package rules.security_group_ingress_anywhere_ssh

import data.fugue.regula.aws.security_group as sglib

resource_type = "aws_security_group"
controls = {
  "CIS_4-1",
  "NIST-800-53_AC-4",
  "NIST-800-53_AC-17 (3)",
  "REGULA_R00004",
}

default deny = false

deny {
  block = input.ingress[_]
  sglib.ingress_zero_cidr_to_port(block, 22)
}
