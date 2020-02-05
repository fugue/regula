package tests.rules.gcp_compute_firewall_no_ingress_3389

import data.fugue.regula

test_gcp_compute_firewall_no_ingress_3389 {
  report := regula.report with input as mock_input
  resources := report.rules.gcp_compute_firewall_no_ingress_3389.resources

  resources["google_compute_firewall.valid-rule-1"].valid == true
  resources["google_compute_firewall.valid-rule-2"].valid == true
  resources["google_compute_firewall.invalid-rule-1"].valid == false
  resources["google_compute_firewall.invalid-rule-2"].valid == false
}