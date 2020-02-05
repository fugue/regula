# VPC subnet flow logging should be enabled.

package rules.gcp_compute_subnet_flow_log_enabled

controls = {"CIS_GCP_3-9", "REGULA_R00014"}
resource_type = "google_compute_subnetwork"

default deny = false

deny {
  count(input.log_config) == 0
}