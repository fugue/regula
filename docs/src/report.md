# Report Output

Here's a snippet of test results from a Regula JSON report:

```json
{
  "rule_results": [
    {
      "controls": [
        "CIS-Azure_v1.1.0_6.4",
        "CIS-Azure_v1.3.0_6.4"
      ],
      "families": [
        "CIS-Azure_v1.1.0",
        "CIS-Azure_v1.3.0"
      ],
      "filepath": "dev_network/main.tf",
      "input_type": "tf",
      "provider": "azurerm",
      "resource_id": "azurerm_network_security_group.devnsg",
      "resource_type": "azurerm_network_security_group",
      "resource_tags": {
        "environment": "dev"
      },
      "rule_description": "Virtual Network security group flow log retention period should be set to 90 days or greater. Flow logs enable capturing information about IP traffic flowing in and out of network security groups. Logs can be used to check for anomalies and give insight into suspected breaches.",
      "rule_id": "FG_R00286",
      "rule_message": "",
      "rule_name": "tf_azurerm_network_flow_log_90days",
      "rule_raw_result": true,
      "rule_remediation_doc": "https://docs.fugue.co/FG_R00286.html",
      "rule_result": "PASS",
      "rule_severity": "Medium",
      "rule_summary": "Virtual Network security group flow log retention period should be set to 90 days or greater",
      "source_location": [
        {
          "path": "dev_network/main.tf",
          "line": 25,
          "column": 1
        }
      ]
    },
    {
      "controls": [
        "CIS-Azure_v1.1.0_6.2",
        "CIS-Azure_v1.3.0_6.2"
      ],
      "families": [
        "CIS-Azure_v1.1.0",
        "CIS-Azure_v1.3.0"
      ],
      "filepath": "dev_network/main.tf",
      "input_type": "tf",
      "provider": "azurerm",
      "resource_id": "azurerm_network_security_group.devnsg",
      "resource_type": "azurerm_network_security_group",
      "resource_tags": {
        "environment": "dev"
      },
      "rule_description": "Virtual Network security groups should not permit ingress from '0.0.0.0/0' to TCP/UDP port 22 (SSH). The potential security problem with using SSH over the internet is that attackers can use various brute force techniques to gain access to Azure Virtual Machines. Once the attackers gain access, they can use a virtual machine as a launch point for compromising other machines on the Azure Virtual Network or even attack networked devices outside of Azure.",
      "rule_id": "FG_R00191",
      "rule_message": "",
      "rule_name": "tf_azurerm_network_security_group_no_inbound_22",
      "rule_raw_result": false,
      "rule_remediation_doc": "https://docs.fugue.co/FG_R00191.html",
      "rule_result": "FAIL",
      "rule_severity": "High",
      "rule_summary": "Network security group rules should not permit ingress from '0.0.0.0/0' to port 22 (SSH)",
      "source_location": [
        {
          "path": "dev_network/main.tf",
          "line": 25,
          "column": 1
        }
      ]
    },
    {
      "controls": [
        "CIS-Azure_v1.1.0_3.1",
        "CIS-Azure_v1.3.0_3.1"
      ],
      "families": [
        "CIS-Azure_v1.1.0",
        "CIS-Azure_v1.3.0"
      ],
      "filepath": "dev_network/main.tf",
      "input_type": "tf",
      "provider": "azurerm",
      "resource_id": "azurerm_storage_account.main",
      "resource_type": "azurerm_storage_account",
      "resource_tags": {
        "environment": "dev"
      },
      "rule_description": "Storage Accounts 'Secure transfer required' should be enabled. The secure transfer option enhances the security of a storage account by only allowing requests to the storage account by a secure connection. This control does not apply for custom domain names since Azure storage does not support HTTPS for custom domain names.",
      "rule_id": "FG_R00152",
      "rule_message": "",
      "rule_name": "tf_azurerm_storage_account_secure_transfer",
      "rule_raw_result": true,
      "rule_remediation_doc": "https://docs.fugue.co/FG_R00152.html",
      "rule_result": "WAIVED",
      "rule_severity": "Medium",
      "rule_summary": "Storage Accounts 'Secure transfer required' should be enabled",
      "source_location": [
        {
          "path": "dev_network/main.tf",
          "line": 118,
          "column": 1
        }
      ]
    }
  ],
  "summary": {
    "filepaths": [
      "dev_network/main.tf"
    ],
    "rule_results": {
      "FAIL": 1,
      "PASS": 1,
      "WAIVED": 1
    },
    "severities": {
      "Critical": 0,
      "High": 1,
      "Informational": 0,
      "Low": 0,
      "Medium": 0,
      "Unknown": 0
    }
  }
}
```

**These are the important bits:**

- [Rule Results](#rule-results)
- [Summary](#summary)

## Rule Results

Each entry in the `rule_results` block is the result of a Rego rule evaluation on a resource. All `rule_results` across multiple CloudFormation and Terraform files and directories are aggregated into this block. In the example above:

- The resource `azurerm_network_security_group.devnsg` configured in the `dev_network/main.tf` Terraform HCL file (line 25, column 1) **passed** the rule `tf_azurerm_network_flow_log_90days`
- The same resource **failed** the rule `tf_azurerm_network_security_group_no_inbound_22`
- The rule `tf_azurerm_storage_account_secure_transfer` was [**waived**](configuration.md#waiving-rule-results) for the resource `azurerm_storage_account.main` (line 118, column 1)

## Summary

The `summary` block contains a breakdown of the `filepaths` (CloudFormation templates, Terraform plan files, Terraform HCL directories) that were evaluated, a count of `rule_results` (PASS, FAIL, [WAIVED](configuration.md#waiving-rule-results)), and a count of `severities` (Critical, High, Medium, Low, Informational, Unknown) for failed `rule_results`. In the example above, 3 rule results were evaluated, of which 1 had a `FAIL` result with a `High` severity.

## Rule Result Attributes

Each rule result in the JSON report lists the following attributes:

- `controls`: Compliance controls mapped to the rule
- `families`: Compliance families associated with the rule
- `filepath`: Filepath of the evaluated Terraform HCL file, Terraform JSON plan, CloudFormation template, Kubernetes manifest, or ARM template (_in preview_)
- `input_type`: `tf` (Terraform source code), `tf_plan` (Terraform JSON plan), `cfn` (CloudFormation), `k8s` (Kubernetes), `arm` (Azure Resource Manager JSON; _in preview_)
- `provider`: `aws`, `azurerm`, `google`, `kubernetes`, `arm`
- `resource_id`: ID of the evaluated resource
- `resource_type`: Type of the evaluated resource
- `resource_tags`: Normalized resource tags/labels
- `rule_description`: A detailed description of the rule
- `rule_id`: ID of the rule; built-in rules start with `FG_R`
- `rule_message`: Optional error message associated with the rule; see how to create custom error messages in [simple](development/writing-rules.md#custom-error-messages-and-attributes-simple-rules) and [advanced](development/writing-rules.md#custom-error-messages-advanced-rules) custom rules
- `rule_name`: Name of the rule (filepath minus extension)
- `rule_raw_result`: `true` if the rule result was `PASS` before any waivers were applied, `false` if it was `FAIL`
- `rule_remediation_doc`: A URL with instructions for remediating the rule
- `rule_result`: `PASS`, `FAIL`, or `WAIVED`
- `rule_severity`: `Critical`, `High`, `Medium`, `Low`, `Informational`, or `Unknown`
- `rule_summary`: A short summary of the rule
- `source_location`: The path, line, and column of the evaluated resource
- `active_waivers`: A list of [Fugue waiver](https://docs.fugue.co/waivers.html) IDs applied to the relevant [Fugue repository environment](https://docs.fugue.co/setup-repository.html) (not applicable when running Regula without `--sync`)

## Compliance controls vs. rules

What's the difference between controls and rules? A **control** represents an individual recommendation within a compliance standard, such as "IAM policies should not have full `"*:*"` administrative privileges" (CIS AWS Foundations Benchmark v1.3.0 1.16).

In Regula, a **rule** is a Rego policy that validates whether a cloud resource violates a control (or multiple controls). One example of a rule is [`cfn_iam_admin_policy`](https://github.com/fugue/regula/blob/master/rego/rules/cfn/iam/admin_policy.rego), which checks whether an IAM policy in a CloudFormation template has `"*:*"` privileges. If it does not, the resource fails validation.

Controls map to sets of rules, and rules can map to multiple controls. For example, control `CIS-AWS_v1.2.0_1.22` and `CIS-AWS_v1.3.0_1.16` [both map to](https://github.com/fugue/regula/blob/master/rego/rules/cfn/iam/admin_policy.rego) the rule `cfn_iam_admin_policy`.
