# Report Output

Here's a snippet of test results from a Regula JSON report:

```json
{
  "rule_results": [
    {
      "controls": [
        "CIS-AWS_v1.3.0_1.20"
      ],
      "filepath": "../test_infra/cfn/cfntest2.yaml",
      "platform": "cloudformation",
      "provider": "aws",
      "resource_id": "S3Bucket1",
      "resource_type": "AWS::S3::Bucket",
      "rule_description": "S3 buckets should have all `block public access` options enabled. AWS's S3 Block Public Access feature has four settings: BlockPublicAcls, IgnorePublicAcls, BlockPublicPolicy, and RestrictPublicBuckets. All four settings should be enabled to help prevent the risk of a data breach.",
      "rule_id": "FG_R00229",
      "rule_message": "",
      "rule_name": "cfn_s3_block_public_access",
      "rule_result": "PASS",
      "rule_severity": "High",
      "rule_summary": "S3 buckets should have all `block public access` options enabled"
    },
    {
      "controls": [
        "CIS-AWS_v1.3.0_2.1.1"
      ],
      "filepath": "../test_infra/cfn/cfntest2.yaml",
      "platform": "cloudformation",
      "provider": "aws",
      "resource_id": "S3BucketLogs",
      "resource_type": "AWS::S3::Bucket",
      "rule_description": "S3 bucket server side encryption should be enabled. Enabling server-side encryption (SSE) on S3 buckets at the object level protects data at rest and helps prevent the breach of sensitive information assets. Objects can be encrypted with S3-Managed Keys (SSE-S3), KMS-Managed Keys (SSE-KMS), or Customer-Provided Keys (SSE-C).",
      "rule_id": "FG_R00099",
      "rule_message": "",
      "rule_name": "cfn_s3_encryption",
      "rule_result": "WAIVED",
      "rule_severity": "High",
      "rule_summary": "S3 bucket server side encryption should be enabled"
    },
    {
      "controls": [
        "CIS-Google_v1.0.0_3.6"
      ],
      "filepath": "../test_infra/tf/",
      "platform": "terraform",
      "provider": "google",
      "resource_id": "google_compute_firewall.rule-2",
      "resource_type": "google_compute_firewall",
      "rule_description": "VPC firewall rules should not permit unrestricted access from the internet to port 22 (SSH). Removing unfettered connectivity to remote console services, such as SSH, reduces a server's exposure to risk.",
      "rule_id": "FG_R00379",
      "rule_message": "",
      "rule_name": "tf_google_compute_firewall_no_ingress_22",
      "rule_result": "FAIL",
      "rule_severity": "High",
      "rule_summary": "VPC firewall rules should not permit ingress from '0.0.0.0/0' to port 22 (SSH)"
    }
  ],
  "summary": {
    "filepaths": [
      "../test_infra/cfn/cfntest2.yaml",
      "../test_infra/tf/"
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

- [Report Output](#report-output)
  - [Rule Results](#rule-results)
  - [Summary](#summary)
  - [Compliance controls vs. rules](#compliance-controls-vs-rules)

## Rule Results

Each entry in the `rule_results` block is the result of a Rego rule evaluation on a resource. All `rule_results` across multiple CloudFormation and Terraform files and directories are aggregated into this block. In the example above:

- The resource `S3Bucket1` configured in the `../test_infra/cfn/cfntest2.yaml` CloudFormation template passed the rule `cfn_s3_block_public_access`
- The rule `cfn_s3_encryption` was [waived](configuration.md#waiving-rule-results) for the resource `S3BucketLogs` in the `../test_infra/cfn/cfntest2.yaml` template
- The resource `google_compute_firewall.rule-2` configured in the `../test_infra/tf/` Terraform directory failed the rule `tf_google_compute_firewall_no_ingress_22`

## Summary

The `summary` block contains a breakdown of the `filepaths` (CloudFormation templates, Terraform plan files, Terraform HCL directories) that were evaluated, a count of `rule_results` (PASS, FAIL, [WAIVED](configuration.md#waiving-rule-results)), and a count of `severities` (Critical, High, Medium, Low, Informational, Unknown) for failed `rule_results`. In the example above, 3 rule results were evaluated, of which 1 had a `FAIL` result with a `High` severity.

## Compliance controls vs. rules

What's the difference between controls and rules? A **control** represents an individual recommendation within a compliance standard, such as "IAM policies should not have full `"*:*"` administrative privileges" (CIS AWS Foundations Benchmark v1.3.0 1.16).

In Regula, a **rule** is a Rego policy that validates whether a cloud resource violates a control (or multiple controls). One example of a rule is [`cfn_iam_admin_policy`](https://github.com/fugue/regula/blob/master/rego/rules/cfn/iam/admin_policy.rego), which checks whether an IAM policy in a CloudFormation template has `"*:*"` privileges. If it does not, the resource fails validation.

Controls map to sets of rules, and rules can map to multiple controls. For example, control `CIS-AWS_v1.2.0_1.22` and `CIS-AWS_v1.3.0_1.16` [both map to](https://github.com/fugue/regula/blob/master/rego/rules/cfn/iam/admin_policy.rego) the rule `cfn_iam_admin_policy`.
