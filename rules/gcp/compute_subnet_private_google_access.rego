# VPC subnet 'Private Google Access' should be enabled.
# When enabled, VMs in this subnetwork without external IP addresses can
# access Google APIs and services by using Private Google Access.

package rules.gcp_compute_subnet_private_google_access

controls = {"CIS_GCP_3-8", "REGULA_R00013"}
resource_type = "google_compute_subnetwork"

default allow = false

allow {
  input.private_ip_google_access == true
}