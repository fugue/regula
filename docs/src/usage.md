# Usage

You can run Regula [locally](#running-regula-locally) or [with Docker](#running-regula-with-docker).

## Running Regula locally

Regula supports the following commands:

```
Regula

Usage:
  regula [command]

Available Commands:
  help        Help about any command
  repl        Start an interactive session for testing rules with Regula
  run         Evaluate rules against infrastructure-as-code with Regula.
  show        Show debug information.
  test        Run OPA test with Regula.

Flags:
  -h, --help      help for regula
  -v, --version   version for regula

Use "regula [command] --help" for more information about a command.
```

## run

The `run` command allows you to evaluate rules against infrastructure as code contained in one or more paths. It outputs a [report](report.md).

```
Usage:
  regula run [input...] [flags]

Flags:
  -f, --format format           Set the output format (default text)
  -h, --help                    help for run
  -i, --include strings         Specify additional rego files or directories to include
  -t, --input-type input-type   Set the input type for the given paths (default auto)
  -n, --no-ignore               Disable use of .gitignore
  -s, --severity severity       Set the minimum severity that will result in a non-zero exit code. (default unknown)
  -u, --user-only               Disable built-in rules
```

### Input

`regula run [input...]` supports passing in CloudFormation YAML and JSON templates, Terraform HCL files, and Terraform plan JSON files.

- **When run without any paths,** Regula will recursively search for IaC configurations within the working directory. Example:

        regula run

- **When a directory is given,** Regula will recursively search for IaC configurations within that directory. Example:

        regula run my_infra

- **When a file is given,** Regula will assume that the file contains an IaC configuration. Example:

        regula run my_infra/cloudformation.yaml

You can specify multiple directories/files of multiple types. Example:

    regula run tfplan.json main.tf my_infra/cloudformation.yaml

If an [input type](#input-types) is set with `-t | --input-type`, Regula will only search for configurations of that type in the specified directories and it will assume that specified files are of that input type.

!!! note
    By default, Regula will exclude paths based on the patterns in the `.gitignore` file for a specified directory. This behavior can be disabled with the `--no-ignore` option.

#### Terraform input

Regula operates on Terraform HCL code and JSON plans.

You can pass in an HCL file or a directory containing an HCL file:

```
regula run my_tf_infra/main.tf
```

```
regula run my_tf_infra
```

Because Regula does not run a `terraform plan` on the user's behalf, Regula itself does not require any credentials.

If you'd like to evaluate a Terraform plan, simply generate a JSON plan and pass it into Regula:

```
terraform init
terraform plan -refresh=false -out=plan.tfplan
terraform show -json plan.tfplan >plan.json
regula run plan.json
```

Using stdin:

```
terraform init
terraform plan -refresh=false -out=plan.tfplan
terraform show -json plan.tfplan | regula run
```

!!! note
    Regula can only evaluate Terraform modules that are available locally. If your Terraform configuration depends on external modules (for example from the Terraform module registry or GitHub) and you want to evaluate resources from those modules, run `terraform init` before running Regula. `terraform init` will download all external modules to a `.terraform` directory and Regula will be able to resolve them.

#### CloudFormation input

Regula operates on CloudFormation templates formatted as JSON or YAML, including templates generated from the AWS CDK.

### Flag values

`-f, --format FORMAT` values:

- `text` -- A human friendly format (default)
- `json` -- A JSON report containing rule results and a summary
- `table` -- An ASCII table of rule results
- `junit` -- The JUnit XML format
- `tap` -- The Test Anything Protocol format
- `none` -- Do not print any output on stdout

`-t, --input type INPUT-TYPE` values:

- `auto` -- Automatically determine input types (default)
- `tf-plan` -- Terraform plan JSON
- `cfn` -- CloudFormation template in YAML or JSON format
- `tf` -- Terraform directory or file

`-s, --severity SEVERITY` values:

- `unknown` -- Lowest setting. Used for rules without a severity specified (default)
- `informational`
- `low`
- `medium`
- `high`
- `critical`
- `off` -- Never exit with a non-zero exit code.

### Examples

* Recurse through the working directory and check all IaC:

        regula run

* Recurse through the `my-infra` directory and check all IaC:

        regula run my-infra

* Recurse through the working directory and check only CloudFormation files:

        regula run --input-type cfn

* Check the `my-tf-infra.json` Terraform plan JSON file and only exit non-zero if there's a violation of `critical` severity:

        regula run my-tf-infra.json --severity critical

* Check the `test_infra/main.tf` HCL file against a single custom rule (and Regula's rule library, by default):

        regula run --include ../custom-rules/my-rule.rego test_infra/main.tf

* Check the `test_infra/cfn/cfntest1.yaml` CloudFormation template against a directory of custom rules only (the Regula rule library is not applied):

        regula run --user-only --include ../custom-rules test_infra/cfn/cfntest1.yaml

* Recurse through the current working directory for all IaC files, and don't exclude files in `.gitignore`:

        regula run --no-ignore

* Recurse through the current working directory for all IaC files and format the output as a table:

        regula run --format table

* Check a CloudFormation file with a non-standard extension:

        regula run --input-type cfn cloudformation.cfn

* Using stdin, check a Terraform plan JSON file:

        terraform show -json plan.tfplan | regula run

* Using stdin, check a CloudFormation stack defined in an AWS CDK app:

        cdk synth | regula run

#### Example output

Use the `--f | --format FORMAT` flag to specify the output format:

=== "text"

    ```

    Passed: 1, Failed: 1, Waived: 0

    CUSTOM_0001: IAM policies must have a description of at least 25 characters [Low]

        [1]: AWS::IAM::ManagedPolicy.InvalidManagedPolicy01
             in infra_cfn/invalid_long_description.yaml

    ```

=== "json"
    
    ```
    {
      "rule_results": [
        {
          "controls": [
            "CORPORATE-POLICY_1.1"
          ],
          "filepath": "infra_cfn/invalid_long_description.yaml",
          "platform": "cloudformation",
          "provider": "aws",
          "resource_id": "InvalidManagedPolicy01",
          "resource_type": "AWS::IAM::ManagedPolicy",
          "rule_description": "Per company policy, it is required for all IAM policies to have a description of at least 25 characters.",
          "rule_id": "CUSTOM_0001",
          "rule_message": "",
          "rule_name": "long_description_cfn",
          "rule_result": "FAIL",
          "rule_severity": "Low",
          "rule_summary": "IAM policies must have a description of at least 25 characters"
        },
        {
          "controls": [
            "CORPORATE-POLICY_1.1"
          ],
          "filepath": "infra_cfn/invalid_long_description.yaml",
          "platform": "cloudformation",
          "provider": "aws",
          "resource_id": "ValidManagedPolicy01",
          "resource_type": "AWS::IAM::ManagedPolicy",
          "rule_description": "Per company policy, it is required for all IAM policies to have a description of at least 25 characters.",
          "rule_id": "CUSTOM_0001",
          "rule_message": "",
          "rule_name": "long_description_cfn",
          "rule_result": "PASS",
          "rule_severity": "Low",
          "rule_summary": "IAM policies must have a description of at least 25 characters"
        }
      ],
      "summary": {
        "filepaths": [
          "infra_cfn/invalid_long_description.yaml"
        ],
        "rule_results": {
          "FAIL": 1,
          "PASS": 1,
          "WAIVED": 0
        },
        "severities": {
          "Critical": 0,
          "High": 0,
          "Informational": 0,
          "Low": 1,
          "Medium": 0,
          "Unknown": 0
        }
      }
    }
    ```

=== "table"

    ```
    +------------------------+-------------------------+-----------------------------------------+----------+-------------+----------------------+----------------------------------------------------------------+--------+
    |        Resource        |          Type           |                Filepath                 | Severity |   Rule ID   |      Rule Name       |                            Message                             | Result |
    +------------------------+-------------------------+-----------------------------------------+----------+-------------+----------------------+----------------------------------------------------------------+--------+
    | InvalidManagedPolicy01 | AWS::IAM::ManagedPolicy | infra_cfn/invalid_long_description.yaml | Low      | CUSTOM_0001 | long_description_cfn | IAM policies must have a description of at least 25 characters | FAIL   |
    | ValidManagedPolicy01   | AWS::IAM::ManagedPolicy | infra_cfn/invalid_long_description.yaml | Low      | CUSTOM_0001 | long_description_cfn | IAM policies must have a description of at least 25 characters | PASS   |
    +------------------------+-------------------------+-----------------------------------------+----------+-------------+----------------------+----------------------------------------------------------------+--------+
    |                        |                         |                                         |          |             |                      |                                                        Overall |   FAIL |
    +------------------------+-------------------------+-----------------------------------------+----------+-------------+----------------------+----------------------------------------------------------------+--------+
    ```

=== "junit"

    ```
    <testsuites name="Regula">
      <testsuite name="infra_cfn/invalid_long_description.yaml" tests="2">
        <testcase name="InvalidManagedPolicy01" classname="AWS::IAM::ManagedPolicy" assertions="1">
          <failure message="IAM policies must have a description of at least 25 characters" type="long_description_cfn">Rule ID: CUSTOM_0001&#xA;Rule Name: long_description_cfn&#xA;Severity: Low&#xA;Message: IAM policies must have a description of at least 25 characters</failure>
        </testcase>
        <testcase name="ValidManagedPolicy01" classname="AWS::IAM::ManagedPolicy" assertions="1"></testcase>
      </testsuite>
    </testsuites>
    ```

=== "tap"

    ```
    not ok 0 InvalidManagedPolicy01: IAM policies must have a description of at least 25 characters
    ok 1 ValidManagedPolicy01: IAM policies must have a description of at least 25 characters
    ```

For more about Regula's output, see [Report Output](report.md).

## repl

```
Start an interactive session for testing rules with Regula

Usage:
  regula repl [rego paths] [flags]

Flags:
  -h, --help        help for repl
  -u, --user-only   Disable built-in rules
```

`regula repl` is the same as OPA's REPL ([`opa run`](https://www.openpolicyagent.org/docs/latest/#3-try-opa-run-interactive)), but with the Regula library and ruleset built in (unless you disable it with `--user-only`). Additionally, Regula's REPL allows you to generate [`mock_input`, `mock_resources`, and `mock_config`](development/rule-development.md#test-inputs) at runtime.

To view this dynamically generated data, start by loading one or more IaC files or a directory containing IaC files. Note that `regula repl` will only operate on individual files rather than interpreting the entire directory as a single configuration.

### Examples
This command loads the `infra` directory into the REPL:

```
regula repl ./infra
```

You'll see output like this:

```
Loaded 9 IaC configurations as test inputs
Regula v0.8.0-dev - built with OPA v0.28.0
Run 'help' to see a list of commands.
>
```

Then you can [view the input](development/rule-development.md#viewing-test-inputs) using the format shown below:

```
data.<path.to.file>.<iac filename without extension>_<extension>.<input type>
```

Regula automatically generates a package name for the input based on the file path, replacing path separators with `.` and other characters (such as dashes) with `_`

For instance, to see the mock resources of `infra/cfn_resources.yaml`, you'd enter this command:

```
data.infra.cfn_resources_yaml.mock_resources
```

You'll see output like this:

```
{
  "Bucket1": {
    "AccessControl": "Private",
    "_provider": "aws",
    "_type": "AWS::S3::Bucket",
    "id": "Bucket1"
  },
  "Bucket2": {
    "AccessControl": "Private",
    "PublicAccessBlockConfiguration": {
      "BlockPublicAcls": true,
      "IgnorePublicAcls": true,
      "RestrictPublicBuckets": true
    },
    "_provider": "aws",
    "_type": "AWS::S3::Bucket",
    "id": "Bucket2"
  }
}
>
```

This feature makes it simpler to [write rules](development/writing-rules.md) and [test/debug rules](development/rule-development.md), because you can easily see Regula's resource view for an input file without having to run a separate script.

You can [evaluate test input](development/rule-development.md#test-a-rule-via-regula-repl) if you switch to a rule package and import the dynamically generated data like so:

```
> package rules.private_bucket_acl
> import data.infra.cfn_resources_yaml
```

Once you've done that, you can evaluate rules using the `mock_input` (advanced rules), `mock_resources` (simple rules), or `mock_config` (for use cases where you want to check configuration outside of resources, such as provider config).

In the example below, we check the resource named `Bucket1` in the IaC file `infra/cfn_resources.yaml` against the rule `allow` in the package `rules.private_bucket_acl`:

```
> data.rules.private_bucket_acl.allow with input as cfn_resources_yaml.mock_resources["Bucket1"]
```

Regula returns the result of the evaluation:

```
true
```

For more information about testing and debugging rules with `regula repl`, see [Rule Development](development/rule-development.md).

## show

```
Show debug information.  Currently the available items are:
  input [file..]   Show the JSON input being passed to regula

Usage:
  regula show [item] [flags]

Flags:
  -h, --help                    help for show
  -t, --input-type input-type   Set the input type for the given paths (default auto)
```

### Input

`regula show input [file...]` accepts Terraform HCL files or directories, Terraform plan JSON, and CloudFormation templates in YAML or JSON. In all cases, Regula transforms the input file and displays the resulting JSON.

This command is used to facilitate development of Regula itself. If you'd like to see the mock input, mock resources, or mock config for an IaC file so you can develop rules, see [`regula repl`](#repl) and [Rule Development](development/rule-development.md).

### Flag values

`-t, --input type INPUT-TYPE` values:

- `auto` -- Automatically determine input types (default)
- `tf-plan` -- Terraform plan JSON
- `cfn` -- CloudFormation template in YAML or JSON format
- `tf` -- Terraform directory or file

## test

```
Execute Rego test cases with Regula.

Usage:
  regula test [paths containing rego or test inputs] [flags]

Flags:
  -h, --help    help for test
  -t, --trace   Enable trace output
```

`regula test` is the same as [`opa test`](https://www.openpolicyagent.org/docs/latest/policy-testing/), but with the Regula library built in. Additionally, Regula allows you to generate [`mock_input`, `mock_resources`, and `mock_config`](development/rule-development.md#test-inputs) at runtime. That means you can simply pass in an IaC file containing test infrastructure without having to run a script generating the inputs.

Files or directories passed in to `regula test` must include the following for each rule tested:

- The Rego rule file
- The Rego tests file, where each test is prepended with `test_`
- The test Terraform or CloudFormation IaC file

If passed one or more directories, `regula test` recurses through them and runs all `test_` rules it finds. Note that `regula test` will only operate on individual files rather than interpreting the entire directory as a single configuration.

For more information about using `regula test`, see [Rule Development](development/rule-development.md).

### Examples

* Test the rule `my_rule.rego` using the tests in `my_rule_test.rego` and the input file `my_test_infra.tf`:

        regula test my_rule.rego my_rule_test.rego my_test_infra.tf

* Recurse through the current working directory to run all tests and accompanying rules and IaC files:

        regula test .

#### Example output

Passing tests:

```
PASS: 142/142
```

Failing tests:

```
data.rules.tf_aws_iam_admin_policy.test_admin_policy: FAIL (4.148344ms) (test skipped because success not possible)
--------------------------------------------------------------------------------
PASS: 141/142
FAIL: 1/142
```

## Running Regula with Docker

!!! note
    Windows users can run Linux containers using a method described in the [Microsoft documentation](https://docs.microsoft.com/en-us/virtualization/windowscontainers/deploy-containers/linux-containers).

Regula is available as a Docker image on DockerHub [here](https://hub.docker.com/r/fugue/regula).

To run Regula on a single CloudFormation template or Terraform plan file, you can use the following command, passing in the template through standard input:

    docker run --rm -it fugue/regula:{{ version }} run < [IAC_TEMPLATE]

To run Regula on IaC directories or individual CloudFormation templates, HCL files, or Terraform plan JSON files, you can use the following command:

    docker run --rm -t \
        -v $(pwd):/workspace \
        --workdir /workspace \
        fugue/regula:{{ version }} run template2.yaml tfdirectory1

When integrating this in a CI pipeline, we recommend pinning the regula version, e.g. `docker run fugue/regula:{{ version }}`.

