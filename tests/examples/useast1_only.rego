package tests.rules.useast1_only

import data.fugue.regula

test_useast1_only {
  report := regula.report with input as mock_input
  report.rules.useast1_only.valid == true
}

test_useast2_only {
  report := regula.report with input as mock_useast2_input
  report.rules.useast1_only.valid == false
}

mock_useast2_input = {
  "configuration": {
    "provider_config": {
      "aws": {
        "name": "aws",
        "expressions": {
          "region": {
            "constant_value": "us-east-2"
          }
        }
      }
    }
  }
}
