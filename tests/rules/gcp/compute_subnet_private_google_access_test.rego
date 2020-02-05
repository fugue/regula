package tests.rules.gcp_compute_subnet_private_google_access

import data.fugue.regula

test_gcp_compute_subnet_private_google_access {
  report := regula.report with input as mock_input
  resources := report.rules.gcp_compute_subnet_private_google_access.resources

  resources["google_compute_subnetwork.valid-subnet-1"].valid == true
  resources["google_compute_subnetwork.invalid-subnet-1"].valid == false
  resources["google_compute_subnetwork.invalid-subnet-2"].valid == false
}