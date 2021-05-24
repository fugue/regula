# Regula

- [Introduction](#introduction)
- [Installation](#installation)
- [Usage](#usage)
  - [Running Regula locally on macOS and Linux](#running-regula-locally-on-macos-and-linux)
    - [Usage examples](#usage-examples)
  - [Running Regula locally on Windows](#running-regula-locally-on-windows)
  - [Running Regula with Docker](#running-regula-with-docker)
- [Regula rules](#regula-rules)
- [Regula report output](#regula-report-output)
  - [Rule results](#rule-results)
  - [Summary](#summary)
- [Configuring Regula](#configuring-regula)
- [Running Regula in CI](#running-regula-in-ci)
- [Running Regula with Conftest](#running-regula-with-conftest)
- [For more information](#for-more-information)

## Introduction

**Tip: See all of our documentation at [regula.dev](https://regula.dev)!**

Regula is a tool that evaluates CloudFormation and Terraform infrastructure-as-code (IaC) for potential AWS, Azure, and Google Cloud security and compliance violations prior to deployment.

Regula includes a library of rules written in Rego, the policy language used by the Open Policy Agent ([opa]) project. Regula works with your favorite CI/CD tools such as Jenkins, Circle CI, and AWS CodePipeline; we’ve included a [GitHub Actions example](https://github.com/fugue/regula-action) so you can get started quickly. Where relevant, we’ve mapped Regula policies to the CIS AWS, Azure, and Google Cloud Foundations Benchmarks so you can assess compliance posture. Regula is maintained by engineers at [Fugue](https://fugue.co).

Regula is also available as a Docker image on DockerHub [here](https://hub.docker.com/r/fugue/regula).

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

**For a tutorial on using Regula with example IaC, see [Getting Started](https://regula.dev/getting-started.html#tutorial-run-regula-locally-on-terraform-iac).**

## Usage

### Running Regula locally on macOS and Linux

Regula requires two types of inputs to run:

- `REGO_PATH`: A directory that contains rules written in Rego. **At a minimum, this should include `lib`**
- `IAC_PATH`: Either a CloudFormation YAML/JSON template, Terraform plan file, or Terraform directory with HCL files

This command evaluates a single Rego rule directory on a single `IAC_PATH`:

    ./bin/regula -d [REGO_PATH] [IAC_PATH]

This command evaluates multiple Rego rule directories on multiple `IAC_PATH`s. Please note that a single Regula run can evaluate multiple CloudFormation templates, Terraform plan files, and Terraform HCL directories:

    ./bin/regula -d [REGO_PATH_1] -d [REGO_PATH_2] [IAC_PATH_1] [IAC_PATH_2]

#### Usage examples

* Check the `../my-tf-infra` Terraform directory against
all rules in the main repository:

        ./bin/regula -d . ../my-tf-infra

* Check the `../my-tf-infra.json` Terraform plan file against all rules in the main repository:

        ./bin/regula -d . ../my-tf-infra.json

* Check the `../test_infra/cfn/cfntest1.yaml` CloudFormation template against all rules in the main repository:

        ./bin/regula -d . ../test_infra/cfn/cfntest1.yaml

* Check the `../my-tf-infra` Terraform directory against the `examples/aws/ec2_t2_only.rego` rule:

        ./bin/regula -d lib -d examples/aws/ec2_t2_only.rego ../my-tf-infra

* Check the `../test_infra/cfn/cfntest1.yaml` CloudFormation template against a directory of custom rules:

        ./bin/regula -d lib -d ../custom-rules ../test_infra/cfn/cfntest1.yaml

* Check the `../my-tf-infra` Terraform directory against
all rules in the main repository:

        ./bin/regula -d . ../my-tf-infra

* Check the `../my-tf-infra.json` Terraform plan file against
all rules in the main repository:

        ./bin/regula -d . ../my-tf-infra.json

* Check the `../test_infra/cfn/cfntest1.yaml` CloudFormation template against all rules in the main repository:

        ./bin/regula -d . ../test_infra/cfn/cfntest1.yaml

* Check the `../my-tf-infra` Terraform directory against the `examples/aws/ec2_t2_only.rego` rule:

        ./bin/regula -d lib -d examples/aws/ec2_t2_only.rego ../my-tf-infra

* Check the `../test_infra/cfn/cfntest1.yaml` CloudFormation template against a directory of custom rules:

        ./bin/regula -d lib -d ../custom-rules ../test_infra/cfn/cfntest1.yaml


It is also possible to set the name of the `terraform` executable, which is useful if you have several versions of Terraform installed:

    env TERRAFORM=terraform-v0.12.18 ./bin/regula -d lib/ -d rules/ ../regula-ci-example/infra_tf

Note that Regula requires [Terraform 0.12+](https://www.terraform.io/downloads.html) in order to generate the JSON-formatted plan.

### Running Regula locally on Windows

Because Regula uses a bash script to automatically generate a plan, convert it to JSON, and run the Rego validations, Windows users can instead manually run the steps that Regula performs. See those steps [here](https://regula.dev/development/rule-development.html#locally-producing-a-report-on-windows).  Alternatively, you can run the script using [WSL](https://docs.microsoft.com/en-us/windows/wsl/about).

### Running Regula with Docker

Regula is available as a Docker image on DockerHub [here](https://hub.docker.com/r/fugue/regula).

To run Regula on a single CloudFormation template or Terraform plan file, you can use the following command, passing in the template through standard input:

    docker run --rm -i fugue/regula - < [IAC_TEMPLATE]

To run Regula on one or more CloudFormation templates or Terraform plan files, you can use the following command:

    docker run --rm \
        -v $(pwd):/workspace \
        --workdir /workspace \
        fugue/regula \
        template1.yaml template2.yaml tfdirectory1/*.json

You can also run Regula on Terraform HCL directories using the following command:

    docker run --rm \
        --volume [HCL_DIRECTORY]:/workspace \
        -e AWS_ACCESS_KEY_ID=XXXXXX \
        -e AWS_SECRET_ACCESS_KEY=XXXXXX \
        -e AWS_DEFAULT_REGION=xx-xxxx-x \
        fugue/regula /workspace

`HCL_DIRECTORY` is the location of the Terraform HCL files you want Regula to check. This command creates a volume for the Docker container to access these files, so that a Terraform plan file can be generated.

When integrating this in a CI pipeline, we recommend pinning the regula version, e.g. `docker run fugue/regula:v0.8.0`.

## Regula rules

Regula rules are written in [Rego] and use the same format as [Fugue Custom Rules].

For a list of Regula rules, see the [rules](https://github.com/fugue/regula/tree/master/rules) directory.

For more information about writing rules, see [Writing Rules](https://regula.dev/development/writing-rules.html)

To learn how to add tests and debug rules, see [Rule Development](https://regula.dev/development/rule-development.html).

## Regula report output

Here's a snippet of test results from a Regula report: 

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

- [Rule Results](#rule-results)
- [Summary](#summary)

### Rule Results

Each entry in the `rule_results` block is the result of a Rego rule evaluation on a resource. All `rule_results` across multiple CloudFormation and Terraform files and directories are aggregated into this block. In the example above:

- The resource `S3Bucket1` configured in the `../test_infra/cfn/cfntest2.yaml` CloudFormation template passed the rule `cfn_s3_block_public_access`
- The rule `cfn_s3_encryption` was [waived](https://regula.dev/configuration.html#waiving-rule-results) for the resource `S3BucketLogs` in the `../test_infra/cfn/cfntest2.yaml` template
- The resource `google_compute_firewall.rule-2` configured in the `../test_infra/tf/` Terraform directory failed the rule `tf_google_compute_firewall_no_ingress_22`

### Summary

The `summary` block contains a breakdown of the `filepaths` (CloudFormation templates, Terraform plan files, Terraform HCL directories) that were evaluated, a count of `rule_results` (PASS, FAIL, [WAIVED](https://regula.dev/configuration.html#waiving-rule-results)), and a count of `severities` (Critical, High, Medium, Low, Informational, Unknown) for failed `rule_results`. In the example above, 3 rule results were evaluated, of which 1 had a `FAIL` result with a `High` severity.

## Configuring Regula

Regula can be configured to ["waive" rule results](https://regula.dev/configuration.html#waiving-rule-results) or [enable/disable rules](https://regula.dev/configuration.html#disabling-rules) altogether.

To learn how to waive a rule result or disable a rule, see [Configuring Regula](https://regula.dev/configuration.html)

## Running Regula in CI

Regula is designed to be easy to run in CI.  We provide a GitHub Action that can
be easily added to your repository:

<https://github.com/fugue/regula-action>

Setting up Regula with different CI/CD solutions such as Jenkins, CodePipeline,
CircleCI, TravisCI, and others would follow a similar pattern.  This repository
contains examples:

<https://github.com/fugue/regula-ci-example>

## Running Regula with Conftest

For information about running Regula with [Conftest], see [Regula + Conftest](https://regula.dev/integrations/regula-conftest.html).

## For more information

Visit [regula.dev](https://regula.dev) for more information about Regula.


[opa]: https://www.openpolicyagent.org/
[fregot]: https://github.com/fugue/fregot
[CloudFormation]: https://docs.aws.amazon.com/cloudformation/
[Terraform]: https://www.terraform.io/
[Rego]: https://www.openpolicyagent.org/docs/latest/policy-language/
[Fugue Custom Rules]: https://docs.fugue.co/rules.html
[Conftest]: https://github.com/open-policy-agent/conftest
