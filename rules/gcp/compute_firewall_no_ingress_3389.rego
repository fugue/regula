# VPC firewall rules should not permit unrestricted access from the internet
# to port 3389 (RDP). Removing unfettered connectivity to remote console services,
# such as RDP, reduces a server's exposure to risk.

package rules.gcp_compute_firewall_no_ingress_3389

import data.fugue.gcp.compute_firewall

controls = {"CIS_GCP_3-7", "REGULA_R00012"}
resource_type = "google_compute_firewall"

default deny = false

deny {
  compute_firewall.includes_zero_cidr_to_port(input, 3389)
}
