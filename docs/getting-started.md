# Getting Started

## Installation

1. Clone the Regula repo and move to the new directory:

        git clone https://github.com/fugue/regula.git
        cd regula

2. Install the following:

    - [OPA](https://www.openpolicyagent.org/docs/latest/#1-download-opa)
    - [Terraform 0.12+](https://www.terraform.io/downloads.html)
    - [cfn-flip](https://github.com/awslabs/aws-cfn-template-flip)

    To install cfn-flip, create a virtualenv if you don't already have one (recommended), and install python requirements:

        python3 -m venv venv
        . ./venv/bin/activate
        pip install -r requirements.txt

Keep reading for a simple tutorial on using Regula, or jump ahead to [Usage](usage.md).

## Tutorial: Run Regula locally on Terraform IaC

For this example, we'll be running Regula on some example Terraform infrastructure as code (IaC) in our [regula-ci-example](https://github.com/fugue/regula-ci-example) repo.

We'll assume you're cloning Regula and the sample code at the same level within a parent directory.

1. If you're still in the `regula` directory, move to the parent directory:

        cd ..

2. Clone the example IaC repo:

        git clone https://github.com/fugue/regula-ci-example.git

3. Move into the `regula` directory:

        cd regula

4. Run Regula against the [example Terraform](https://github.com/fugue/regula-ci-example/blob/master/infra_tf/main.tf):

        ./bin/regula -d lib -d rules ../regula-ci-example/infra_tf/

You'll see output like this:

```json
{
  "rule_results": [
    {
      "controls": [
        "CIS-AWS_v1.2.0_1.22"
      ],
      "filename": "../regula-ci-example/infra_tf/",
      "platform": "terraform",
      "provider": "aws",
      "resource_id": "aws_iam_policy.basically_allow_all",
      "resource_type": "aws_iam_policy",
      "rule_description": "IAM policies should not have full \"*:*\" administrative privileges. IAM policies should start with a minimum set of permissions and include more as needed rather than starting with full administrative privileges. Providing full administrative privileges when unnecessary exposes resources to potentially unwanted actions.",
      "rule_id": "FG_R00092",
      "rule_message": "",
      "rule_name": "tf_aws_iam_admin_policy",
      "rule_result": "FAIL",
      "rule_severity": "High",
      "rule_summary": "IAM policies should not have full \"*:*\" administrative privileges"
    },
    {
      "controls": [
        "CIS-AWS_v1.2.0_1.22"
      ],
      "filename": "../regula-ci-example/infra_tf/",
      "platform": "terraform",
      "provider": "aws",
      "resource_id": "aws_iam_policy.basically_deny_all",
      "resource_type": "aws_iam_policy",
      "rule_description": "IAM policies should not have full \"*:*\" administrative privileges. IAM policies should start with a minimum set of permissions and include more as needed rather than starting with full administrative privileges. Providing full administrative privileges when unnecessary exposes resources to potentially unwanted actions.",
      "rule_id": "FG_R00092",
      "rule_message": "",
      "rule_name": "tf_aws_iam_admin_policy",
      "rule_result": "PASS",
      "rule_severity": "High",
      "rule_summary": "IAM policies should not have full \"*:*\" administrative privileges"
    }
  ],
  "summary": {
    "filenames": [
      "../regula-ci-example/infra_tf/"
    ],
    "rule_results": {
      "FAIL": 1,
      "PASS": 1,
      "WAIVED": 0
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

### What does it mean?

Regula just showed us that our [sample Terraform](https://github.com/fugue/regula-ci-example/blob/master/infra_tf/main.tf) is noncompliant and a security vulnerability. In this example, there are two rule results: one PASS and one FAIL.

The AWS IAM policy resource `aws_iam_policy.basically_allow_all` failed the Regula rule ["IAM policies should not have full `"*:*"` administrative privileges."](https://github.com/fugue/regula/blob/master/rules/tf/aws/iam/admin_policy.rego) The report includes lots of other info, such as the filename the resource was found in, the rule severity, a full description of the rule, and more:

```json
    {
      "controls": [
        "CIS-AWS_v1.2.0_1.22"
      ],
      "filename": "../regula-ci-example/infra_tf/",
      "platform": "terraform",
      "provider": "aws",
      "resource_id": "aws_iam_policy.basically_allow_all",
      "resource_type": "aws_iam_policy",
      "rule_description": "IAM policies should not have full \"*:*\" administrative privileges. IAM policies should start with a minimum set of permissions and include more as needed rather than starting with full administrative privileges. Providing full administrative privileges when unnecessary exposes resources to potentially unwanted actions.",
      "rule_id": "FG_R00092",
      "rule_message": "",
      "rule_name": "tf_aws_iam_admin_policy",
      "rule_result": "FAIL",
      "rule_severity": "High",
      "rule_summary": "IAM policies should not have full \"*:*\" administrative privileges"
    },
```

In contrast, the policy `aws_iam_policy.basically_deny_all` passed the rule:

```json
    {
      "controls": [
        "CIS-AWS_v1.2.0_1.22"
      ],
      "filename": "../regula-ci-example/infra_tf/",
      "platform": "terraform",
      "provider": "aws",
      "resource_id": "aws_iam_policy.basically_deny_all",
      "resource_type": "aws_iam_policy",
      "rule_description": "IAM policies should not have full \"*:*\" administrative privileges. IAM policies should start with a minimum set of permissions and include more as needed rather than starting with full administrative privileges. Providing full administrative privileges when unnecessary exposes resources to potentially unwanted actions.",
      "rule_id": "FG_R00092",
      "rule_message": "",
      "rule_name": "tf_aws_iam_admin_policy",
      "rule_result": "PASS",
      "rule_severity": "High",
      "rule_summary": "IAM policies should not have full \"*:*\" administrative privileges"
    },
```

The summary lists the filenames evaluated, the number of FAIL/PASS/[WAIVED](configuration.md#waiving-rule-results) rule results, and the severity of the failed rules:

```json
  "summary": {
    "filenames": [
      "../regula-ci-example/infra_tf/"
    ],
    "rule_results": {
      "FAIL": 1,
      "PASS": 1,
      "WAIVED": 0
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

Now that you've tried running Regula locally on sample infrastructure, [learn other ways in which you can use Regula](usage.md) -- such as with the CLI or Docker.