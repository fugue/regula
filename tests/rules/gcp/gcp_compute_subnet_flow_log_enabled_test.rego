package tests.rules.gcp_compute_subnet_flow_log_enabled

import data.fugue.regula

test_gcp_compute_subnet_flow_log_enabled {
  report := regula.report with input as mock_input
  resources := report.rules.gcp_compute_subnet_flow_log_enabled.resources

  resources["google_compute_subnetwork.valid-subnet-1"].valid == true
  resources["google_compute_subnetwork.valid-subnet-2"].valid == true
  resources["google_compute_subnetwork.valid-subnet-1"].valid == false
}