# VPC security groups should not permit unrestricted access from the internet
# to port 3389 (RDP). Removing unfettered connectivity to remote console
# services, such as Remote Desktop Protocol, reduces a server's exposure to
# risk.
package rules.security_group_ingress_anywhere_rdp

import data.fugue.regula.aws.security_group as sglib

resource_type = "aws_security_group"
controls = {"CIS_4-2", "REGULA_R00005"}

default deny = false

deny {
  block = input.ingress[_]
  sglib.ingress_zero_cidr_to_port(block, 3389)
}
