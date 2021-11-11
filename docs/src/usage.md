# Usage

You can run Regula [locally](#running-regula-locally) or [with Docker](#running-regula-with-docker).

## Running Regula locally

Regula supports the following commands:

```
Regula

Usage:
  regula [command]

Available Commands:
  completion        generate the autocompletion script for the specified shell
  help              Help about any command
  init              Create a new Regula configuration file in the current working directory.
  repl              Start an interactive session for testing rules with Regula
  run               Evaluate rules against infrastructure as code with Regula.
  show              Show debug information.
  test              Run OPA test with Regula.
  version           Print version information.
  write-test-inputs Persist dynamically-generated test inputs for use with other Rego interpreters

Flags:
  -h, --help      help for regula
  -v, --verbose   verbose output

Use "regula [command] --help" for more information about a command.
```

## run

The `run` command allows you to evaluate rules against infrastructure as code contained in one or more paths. It outputs a [report](report.md).

```
Usage:
  regula run [input...] [flags]

Flags:
  -c, --config string           Path to .regula.yaml file. By default regula will look in the current working directory and its parents.
  -e, --environment-id string   Environment ID in Fugue
  -x, --exclude strings         Rule IDs or names to exclude. Can be specified multiple times.
  -f, --format string           Set the output format (default "text")
  -h, --help                    help for run
  -i, --include strings         Specify additional rego files or directories to include
  -t, --input-type strings      Search for or assume the input type for the given paths. Can be specified multiple times. (default [auto])
  -n, --no-built-ins            Disable built-in rules
      --no-config               Do not look for or load a regula config file.
      --no-ignore               Disable use of .gitignore
  -o, --only strings            Rule IDs or names to run. All other rules will be excluded. Can be specified multiple times.
  -s, --severity string         Set the minimum severity that will result in a non-zero exit code. (default "unknown")
      --sync                    Fetch rules and configuration from Fugue
      --upload                  Upload rule results to Fugue

Global Flags:
  -v, --verbose   verbose output
```

### Input

`regula run [input...]` supports passing in CloudFormation templates, Kubernetes manifests, Terraform HCL files, and Terraform plan JSON files.

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

!!! note
    See our note about how [Regula handles globbing](#globbing) in commands.

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

#### Kubernetes input

Regula operates on YAML Kubernetes manifests containing single resource definitions or multiple definitions separated by the `---` operator.

### Flag values

`-f, --format FORMAT` values:

- `text` -- A human friendly format (default)
- `json` -- A JSON report containing rule results and a summary
- `table` -- An ASCII table of rule results
- `junit` -- The JUnit XML format
- `tap` -- The Test Anything Protocol format
- `compact` -- An alternate, more compact human friendly format
- `none` -- Do not print any output on stdout

`-t, --input type INPUT-TYPE` values:

- `auto` -- Automatically determine input types (default)
- `tf-plan` -- Terraform plan JSON
- `cfn` -- CloudFormation template in YAML or JSON format
- `tf` -- Terraform directory or file
- `k8s` -- Kubernetes manifest YAML

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

        regula run --no-built-ins --include ../custom-rules test_infra/cfn/cfntest1.yaml

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

* Recurse through the working directory and exclude rule FG_R00275:

        regula run --exclude FG_R00275

* Recurse through the working directory and run _only_ the rule named `tf_aws_vpc_flow_log`:

        regula run --only tf_aws_vpc_flow_log

* Recurse through the working directory and locally run the ruleset synced from your [Fugue](https://www.fugue.co) tenant:

        regula run --sync

* Recurse through the working directory, locally run the ruleset synced from your [Fugue](https://www.fugue.co) tenant, and upload the results to the Fugue environment specified in [`.regula.yaml`](configuration.md#setting-defaults-for-regula-run):

        regula run --sync --upload

    !!! note
        In Regula v2.0.0+, `regula run --sync --upload` has replaced `regula scan`.

* Recurse through the working directory, locally run the ruleset synced from your [Fugue](https://www.fugue.co) tenant, and upload the results to a specific environment (overriding the environment set in [`.regula.yaml`](configuration.md#setting-defaults-for-regula-run)):

        regula run --sync --upload --environment-id a29aec17-ab48-42dc-a7ef-c0ba8b650c4c

#### Example output

Use the `--f | --format FORMAT` flag to specify the output format:

=== "text"

    ```

    CUSTOM_0001: IAM policies must have a description of at least 25 characters [Low]

      [1]: InvalidManagedPolicy01
           in infra_cfn/invalid_long_description.yaml:14:3

    Found one problem.

    ```

=== "json"
    
    ```json
    {
      "rule_results": [
        {
          "controls": [
            "CORPORATE-POLICY_1.1"
          ],
          "filepath": "infra_cfn/invalid_long_description.yaml",
          "input_type": "cfn",
          "provider": "aws",
          "resource_id": "InvalidManagedPolicy01",
          "resource_type": "AWS::IAM::ManagedPolicy",
          "rule_description": "Per company policy, it is required for all IAM policies to have a description of at least 25 characters.",
          "rule_id": "CUSTOM_0001",
          "rule_message": "",
          "rule_name": "long_description_cfn",
          "rule_raw_result": false,
          "rule_result": "FAIL",
          "rule_severity": "Low",
          "rule_summary": "IAM policies must have a description of at least 25 characters",
          "source_location": [
            {
              "path": "infra_cfn/invalid_long_description.yaml",
              "line": 14,
              "column": 3
            }
          ]
        },
        {
          "controls": [
            "CORPORATE-POLICY_1.1"
          ],
          "filepath": "infra_cfn/invalid_long_description.yaml",
          "input_type": "cfn",
          "provider": "aws",
          "resource_id": "ValidManagedPolicy01",
          "resource_type": "AWS::IAM::ManagedPolicy",
          "rule_description": "Per company policy, it is required for all IAM policies to have a description of at least 25 characters.",
          "rule_id": "CUSTOM_0001",
          "rule_message": "",
          "rule_name": "long_description_cfn",
          "rule_raw_result": true,
          "rule_result": "PASS",
          "rule_severity": "Low",
          "rule_summary": "IAM policies must have a description of at least 25 characters",
          "source_location": [
            {
              "path": "infra_cfn/invalid_long_description.yaml",
              "line": 3,
              "column": 3
            }
          ]
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
    +------------------------+-------------------------+----------------------------------------------+----------+-------------+----------------------+----------------------------------------------------------------+--------+
    |        Resource        |          Type           |                   Filepath                   | Severity |   Rule ID   |      Rule Name       |                            Message                             | Result |
    +------------------------+-------------------------+----------------------------------------------+----------+-------------+----------------------+----------------------------------------------------------------+--------+
    | InvalidManagedPolicy01 | AWS::IAM::ManagedPolicy | infra_cfn/invalid_long_description.yaml:14:3 | Low      | CUSTOM_0001 | long_description_cfn | IAM policies must have a description of at least 25 characters | FAIL   |
    | ValidManagedPolicy01   | AWS::IAM::ManagedPolicy | infra_cfn/invalid_long_description.yaml:3:3  | Low      | CUSTOM_0001 | long_description_cfn | IAM policies must have a description of at least 25 characters | PASS   |
    +------------------------+-------------------------+----------------------------------------------+----------+-------------+----------------------+----------------------------------------------------------------+--------+
    |                        |                         |                                              |          |             |                      |                                                        Overall | FAIL   |
    +------------------------+-------------------------+----------------------------------------------+----------+-------------+----------------------+----------------------------------------------------------------+--------+
    ```

=== "junit"

    ```xml
    <testsuites name="Regula">
      <testsuite name="infra_cfn/invalid_long_description.yaml" tests="2">
        <testcase name="infra_cfn/invalid_long_description.yaml#InvalidManagedPolicy01" classname="AWS::IAM::ManagedPolicy" assertions="1">
          <failure message="IAM policies must have a description of at least 25 characters" type="long_description_cfn">Rule ID: CUSTOM_0001&#xA;Rule Name: long_description_cfn&#xA;Severity: Low&#xA;Message: IAM policies must have a description of at least 25 characters</failure>
        </testcase>
        <testcase name="infra_cfn/invalid_long_description.yaml#ValidManagedPolicy01" classname="AWS::IAM::ManagedPolicy" assertions="1"></testcase>
      </testsuite>
    </testsuites>
    ```

=== "tap"

    ```tap
    not ok 0 InvalidManagedPolicy01: IAM policies must have a description of at least 25 characters
    ok 1 ValidManagedPolicy01: IAM policies must have a description of at least 25 characters
    ```

=== "compact"

    ```
    CUSTOM_0001: IAM policies must have a description of at least 25 characters [Low]
      [1]: InvalidManagedPolicy01 in infra_cfn/invalid_long_description.yaml:14:3
    Found one problem.
    ```

You can also set the output format using the `REGULA_FORMAT` environment variable:

```
REGULA_FORMAT=compact regula run
```

For more about Regula's output, see [Report Output](report.md).

## completion

```
Generate the autocompletion script for regula for the specified shell.
See each sub-command's help for details on how to use the generated script.

Usage:
  regula completion [command]

Available Commands:
  bash        generate the autocompletion script for bash
  fish        generate the autocompletion script for fish
  powershell  generate the autocompletion script for powershell
  zsh         generate the autocompletion script for zsh

Flags:
  -h, --help   help for completion

Global Flags:
  -v, --verbose   verbose output

Use "regula completion [command] --help" for more information about a command.
```

The `completion` command enables you to set up autocompletion for a given shell. Use the `--help` flag to view instructions for your shell. Example:

```
regula completion bash --help
```

Use the subcommand for your shell to install the autogeneration script. Example:

```
regula completion bash
```

Once you've followed the instructions to load autocompletions, you can press the `Tab` key to autocomplete Regula commands and show available flags.

## init

```
Create a new Regula configuration file in the current working directory.

Pass one or more inputs (like you would with the 'regula run' command) in order to change the default inputs for 'regula run'.

Usage:
  regula init [input...] [flags]

Flags:
  -e, --environment-id string   Environment ID in Fugue
  -x, --exclude strings         Rule IDs or names to exclude. Can be specified multiple times.
      --force                   Overwrite configuration file without prompting for confirmation.
  -f, --format string           Set the output format (default "text")
  -h, --help                    help for init
  -i, --include strings         Specify additional rego files or directories to include
  -t, --input-type strings      Search for or assume the input type for the given paths. Can be specified multiple times. (default [auto])
  -n, --no-built-ins            Disable built-in rules
      --no-ignore               Disable use of .gitignore
  -o, --only strings            Rule IDs or names to run. All other rules will be excluded. Can be specified multiple times.
  -s, --severity string         Set the minimum severity that will result in a non-zero exit code. (default "unknown")
      --sync                    Fetch rules and configuration from Fugue

Global Flags:
  -v, --verbose   verbose output
```

`regula init` creates a configuration file in your current working directory that you can use to set defaults for `regula run`.

Similar to `git`, `regula run` will look for this configuration file in your current working directory, followed by its parent directories.

Besides setting defaults for `regula run`, the configuration file also helps regula calculate relative paths for your inputs. As an
example of why this is useful, say you've got this `waivers.rego` file that waives the "S3 buckets should have all `block public access` options enabled"
rule on a bucket hosts your company's website:

```ruby
package fugue.regula.config

waivers[waiver] {
  waiver := {
    "filepath": "infra/cloudformation.yaml",
    "resource_id": "WebsiteBucket",
    "rule_id": "FG_R00031",
  }
}
```

In order for regula to match the filepath in the waiver to your cloudformation template, you would always need
to run regula in the parent directory of `infra`. Unless, of course, you're using a regula configuration file:

```shell
# Here I'm showing the layout of the project
$ tree
.
├── README.md
├── config
│   └── waivers.rego
├── infra
│   └── cloudformation.yaml
└── src
    └── some_files

# Now I'll create a configuration file in the project's root directory and indicate that
# by default, I'd like to run regula against my 'infra' directory.
$ regula init --include config/waivers.rego infra

# And now I can run regula from anywhere within the project and it will apply the
# defaults from the configuration file and correctly apply the waiver.
$ cd src
$ regula run
INFO Using config file '/Users/jason/workspace/my-project/.regula.yaml' 

No problems found. Keep up the good work.
```

### Examples

Disable all built-in rules and add custom rules from a `rules` directory:

```
regula init --no-built-ins --include rules
```

Configure some specific inputs and the severity flag:

```
regula init --severity high src/*/cloudformation.yaml
```

Configure which input types Regula should search for:

```
regula init --input-type tf --input-type cfn
```

When using Regula with [Fugue](https://www.fugue.co), set the environment ID for Fugue to scan:

```
regula init --environment-id a29aec17-ab48-42dc-ade5-c0ba8b650c4c
```

Sync the built-in and custom rules from your [Fugue](https://www.fugue.co) tenant when running Regula locally:

```
regula init --environment-id a29aec17-ab48-42dc-ade5-c0ba8b650c4c --sync
```

!!! note
    If you're using `--sync` in your configuration file, note that the `--sync` flag takes precedence over options that modify the rule set (`--exclude`, `--include`, `--only`, `--no-built-ins`). Those options will be ignored. To use those options with `regula run`, set `--sync=false`:

    ```
    regula run --sync=false --include rules
    ```

## repl

```
Start an interactive session for testing rules with Regula

Usage:
  regula repl [paths containing rego or test inputs] [flags]

Flags:
  -h, --help             help for repl
  -n, --no-built-ins     Disable built-in rules
      --no-test-inputs   Disable loading test inputs

Global Flags:
  -v, --verbose   verbose output
```

`regula repl` is the same as OPA's REPL ([`opa run`](https://www.openpolicyagent.org/docs/latest/#3-try-opa-run-interactive)), but with the Regula library and ruleset built in (unless you disable it with `--no-built-ins`). Additionally, Regula's REPL allows you to generate [`mock_input`, `mock_resources`, and `mock_config`](development/test-inputs.md) at runtime.

To view this dynamically generated data, start by loading one or more IaC files or a directory containing IaC files. Note that `regula repl` will only operate on individual files rather than interpreting the entire directory as a single configuration.

!!! note
    See our note about how [Regula handles globbing](#globbing) in commands.

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

Then you can [view the input](development/test-inputs.md#viewing-test-inputs) using the format shown below:

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

This feature makes it simpler to [write rules](development/writing-rules.md) and [test/debug rules](development/writing-tests.md), because you can easily see Regula's resource view for an input file without having to run a separate script.

You can [evaluate test input](development/testing-rules.md#test-a-rule-via-regula-repl) if you switch to a rule package and import the dynamically generated data like so:

```
> package rules.private_bucket_acl
> import data.infra.cfn_resources_yaml
```

Once you've done that, you can evaluate rules using the `mock_input` (advanced rules), `mock_resources` (simple rules), or `mock_config` (for use cases where you want to check configuration outside of resources, such as provider config). See [Test Inputs](development/test-inputs.md) for more information about the types of input.

In the example below, we check the resource named `Bucket1` in the IaC file `infra/cfn_resources.yaml` against the rule `allow` in the package `rules.private_bucket_acl`:

```
> data.rules.private_bucket_acl.allow with input as cfn_resources_yaml.mock_resources["Bucket1"]
```

Regula returns the result of the evaluation:

```
true
```

For more information about testing and debugging rules with `regula repl`, see [Writing Tests](development/writing-tests.md), [Testing Rules](development/testing-rules.md), and [Test Inputs](development/test-inputs.md).

## show

```
Show debug information.

Usage:
  regula show [command]

Available Commands:
  config-rego Show the generated config rego file
  custom-rule Show a custom rule from your Fugue account
  input       Show the JSON input being passed to regula
  scan-view   Show the JSON output being passed to Fugue.

Flags:
  -h, --help   help for show

Global Flags:
  -v, --verbose   verbose output

Use "regula show [command] --help" for more information about a command.
```

### config-rego

```
Show the generated config rego file

Usage:
  regula show config-rego <options> [flags]

Flags:
  -x, --exclude strings   Rule IDs, names, or local paths to exclude. Can be specified multiple times.
  -h, --help              help for config-rego
  -o, --only strings      Rule IDs or names to run. All other rules will be excluded. Can be specified multiple times.

Global Flags:
  -v, --verbose   verbose output
```

When you execute `regula run` with the `-x | --exclude` or `-o | --only` flags, Regula generates a Rego [configuration file](configuration.md) behind the scenes. `regula show config-rego` shows the configuration file that would be generated if you executed `regula run` with certain specified flags.

#### Examples

```
regula show config-rego --exclude FG_R00275 --exclude FG_R00277
```

Example output:

```ruby hl_lines="30"
# Copyright 2020-2021 Fugue, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
package fugue.regula.config

__rule_id(pkg) = ret {
  metadoc = object.get(data.rules[pkg], "__rego__metadoc__", {})
  ret = object.get(metadoc, "id", null)
}

__contains_name_or_id(s, pkg) {
    s[pkg]
}

__contains_name_or_id(s, pkg) {
    i = __rule_id(pkg)
    s[i]
}

__excludes := {"FG_R00275","FG_R00277"}

rules[rule] {
    data.rules[pkg]
    __contains_name_or_id(__excludes, pkg)
    rule := {
        "rule_name": pkg,
        "status": "DISABLED"
    }
}
```

### custom-rule

```
Show a custom rule from your Fugue account

Usage:
  regula show custom-rule <rule ID> [flags]

Flags:
  -h, --help   help for custom-rule

Global Flags:
  -v, --verbose   verbose output
```

If you create a custom rule in [Fugue](https://www.fugue.co) and run it locally with `regula run --sync`, Regula adds some required information behind the scenes, such as a package declaration and metadata. To view the Fugue custom rule with Regula's additions, run the `regula show custom-rule <rule ID>` command. This is useful when debugging rules, as the line numbers given in an error message will correspond to the version shown in `regula show custom-rule`.

#### Examples

```
regula show custom-rule 30348f33-72af-499e-add0-28c0b202cf66
```

Example output, and comparison to the original rule in Fugue:

=== "Output"

    ```ruby
    package rules.rule_30348f33_72af_499e_add0_28c0b202cf66

    import data.fugue

    __rego__metadoc__ := {
      "custom": {
        "controls": {
          "Custom": [
            "custom/Storage accounts require 'stage:prod' tags"
          ]
        },
        "severity": "Informational"
      },
      "description": "Azure storage accounts should be tagged 'stage:prod'",
      "id": "30348f33-72af-499e-add0-28c0b202cf66",
      "title": "Storage accounts require 'stage:prod' tags"
    }

    resource_type := "azurerm_storage_account"

    allow {
      input.tags.environment == "staging"
    }
    ```

=== "Original rule"

    ```ruby
    allow {
      input.tags.environment == "staging"
    }
    ```

### scan-view

```
Show the JSON output being passed to Fugue

Usage:
  regula show scan-view [file...] [flags]

Flags:
  -c, --config string           Path to .regula.yaml file. By default regula will look in the current working directory and its parents.
  -e, --environment-id string   Environment ID in Fugue
  -h, --help                    help for scan-view
  -t, --input-type strings      Search for or assume the input type for the given paths. Can be specified multiple times. (default [auto])
      --no-ignore               Disable use of .gitignore

Global Flags:
  -v, --verbose   verbose output
```

Under the hood, whenever you use Regula with [Fugue](https://www.fugue.co) to scan your IaC, Regula syncs built-in and custom rules from Fugue and then generates a JSON scan view that is passed to Fugue. The scan view contains a [report](report.md) along with additional configuration and input information. You can see the scan view for a file by running `regula show scan-view [file...]` (or recurse through the current directory by running `regula show scan-view`). Regula will sync rules from Fugue and output the scan view.

#### Examples

Show the scan view of the file `pod.yaml`:

```
regula show scan-view pod.yaml
```

Example output:

```json
Using config file '/Users/becki/projects/k8s-test/.regula.yaml'
INFO Retrieved 27 custom rules...
{
  "inputs": [
    {
      "filepath": "pod.yaml",
      "input_type": "k8s",
      "resources": {
        "Pod.default.default": {
          "_provider": "kubernetes",
          "_source_location": [
            {
              "path": "pod.yaml",
              "line": 1,
              "column": 1
            }
          ],
          "_type": "Pod",
          "apiVersion": "v1",
          "id": "Pod.default.default",
          "kind": "Pod",
          "metadata": {
            "name": "default",
            "namespace": "default"
          },
          "spec": {
            "containers": [
              {
                "command": [
                  "sh",
                  "-c",
                  "echo \"Hello, Kubernetes!\" && sleep 3600"
                ],
                "image": "busybox",
                "name": "hello"
              }
            ]
          }
        }
      }
    }
  ],
  "regula_version": "v2.0.0",
  "scan_view_version": "v1",
  "report": {
    "rule_results": [
      {
        "controls": [
          "CIS-Kubernetes_v1.6.1_5.2.8"
        ],
        "filepath": "pod.yaml",
        "input_type": "k8s",
        "provider": "kubernetes",
        "resource_id": "Pod.default.default",
        "resource_type": "Pod",
        "rule_description": "Pods should not run containers with added capabilities. Adding capabilities beyond the default set increases the risk of container breakout attacks. In most cases, applications are able to operate normally with all Linux capabilities dropped, or with the default set of capabilities.",
        "rule_id": "FG_R00492",
        "rule_message": "",
        "rule_name": "k8s_added_capabilities",
        "rule_raw_result": true,
        "rule_result": "PASS",
        "rule_severity": "Medium",
        "rule_summary": "Pods should not run containers with added capabilities",
        "source_location": [
          {
            "path": "pod.yaml",
            "line": 1,
            "column": 1
          }
        ]
      },
      ... cut for length ...
    ],
    "summary": {
      "filepaths": [
        "pod.yaml"
      ],
      "rule_results": {
        "FAIL": 9,
        "PASS": 7,
        "WAIVED": 0
      },
      "severities": {
        "Critical": 0,
        "High": 0,
        "Informational": 0,
        "Low": 1,
        "Medium": 8,
        "Unknown": 0
      }
    }
  }
}
```

### input

```
Show the JSON input being passed to regula

Usage:
  regula show input [file...] [flags]

Flags:
  -h, --help                 help for input
  -t, --input-type strings   Search for or assume the input type for the given paths. Can be specified multiple times. (default [auto])

Global Flags:
  -v, --verbose   verbose output
```

`regula show input [file...]` accepts Terraform HCL files or directories, Terraform plan JSON, Kubernetes manifests, and CloudFormation templates in YAML or JSON. In all cases, Regula transforms the input file and displays the resulting JSON.

This command is used to facilitate development of Regula itself. If you'd like to see the mock input, mock resources, or mock config for an IaC file so you can develop rules, see [`regula repl`](#repl) and [Test Inputs](development/test-inputs.md#viewing-test-inputs).

#### Examples

Show the input for `pod.yaml`:

```
regula show input pod.yaml
```

Example output, and comparison to original file:

=== "Output"

    ```json
    [
      {
        "content": {
          "k8s_resource_view_version": "0.0.1",
          "resources": {
            "Pod.default.default": {
              "apiVersion": "v1",
              "kind": "Pod",
              "metadata": {
                "name": "default",
                "namespace": "default"
              },
              "spec": {
                "containers": [
                  {
                    "command": [
                      "sh",
                      "-c",
                      "echo \"Hello, Kubernetes!\" \u0026\u0026 sleep 3600"
                    ],
                    "image": "busybox",
                    "name": "hello"
                  }
                ]
              }
            }
          }
        },
        "filepath": "pod.yaml"
      }
    ]
    ```

=== "pod.yaml"

    ```yaml
    apiVersion: v1
    kind: Pod
    metadata:
      name: default
      namespace: default
    spec:
      containers:
        - name: hello
          image: busybox
          command: ['sh', '-c', 'echo "Hello, Kubernetes!" && sleep 3600']
    ```

!!! note
    See our note about how [Regula handles globbing](#globbing) in commands.

### Flag values

`-t, --input type INPUT-TYPE` values:

- `auto` -- Automatically determine input types (default)
- `tf-plan` -- Terraform plan JSON
- `cfn` -- CloudFormation template in YAML or JSON format
- `tf` -- Terraform directory or file
- `k8s` -- Kubernetes manifest YAML

## test

```
Run OPA test with Regula.

Usage:
  regula test [paths containing rego or test inputs] [flags]

Flags:
  -h, --help             help for test
      --no-test-inputs   Disable loading test inputs
  -t, --trace            Enable trace output

Global Flags:
  -v, --verbose   verbose output
```

`regula test` is the same as [`opa test`](https://www.openpolicyagent.org/docs/latest/policy-testing/), but with the Regula library built in. Additionally, Regula allows you to generate [`mock_input`, `mock_resources`, and `mock_config`](development/test-inputs.md) at runtime. That means you can simply pass in an IaC file containing test infrastructure without having to run a script generating the inputs.

Files or directories passed in to `regula test` must include the following for each rule tested:

- The Rego rule file
- The Rego tests file, where each test is prepended with `test_`
- The test Terraform, CloudFormation, or Kubernetes manifest file

If passed one or more directories, `regula test` recurses through them and runs all `test_` rules it finds. Note that `regula test` will only operate on individual files rather than interpreting the entire directory as a single configuration.

For more information about using `regula test`, see [Testing Rules](development/testing-rules.md).

!!! note
    See our note about how [Regula handles globbing](#globbing) in commands.

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

## write-test-inputs

```
Persist dynamically-generated test inputs for use with other Rego interpreters

Usage:
  regula write-test-inputs [input...] [flags]

Flags:
  -h, --help                    help for write-test-inputs
  -t, --input-type input-type   Set the input type for the given paths (default auto)

Global Flags:
  -v, --verbose   verbose output
```

`regula write-test-inputs` allows you to generate test input ([`mock_input`, `mock_resources`, `mock_config`](development/test-inputs.md)) for an IaC file and save the input as a `.rego` file for use with another Rego interpreter, such as [OPA](https://www.openpolicyagent.org/).

The input is saved as `<iac filename without extension>_<extension>.rego` in the same directory as the IaC file. Dashes in the filename are replaced with `_`

!!! note
    See our note about how [Regula handles globbing](#globbing) in commands.

### Flag values

`-t, --input type INPUT-TYPE` values:

- `auto` -- Automatically determine input types (default)
- `tf-plan` -- Terraform plan JSON
- `cfn` -- CloudFormation template in YAML or JSON format
- `tf` -- Terraform directory or file
- `k8s` -- Kubernetes manifest YAML

### Examples

* Generate test inputs for `infra/cfn_resources.yaml`:

    ```
    regula write-test-inputs infra/cfn_resources_yaml.rego
    ```

* Recurse through the current working directory and generate test inputs for all IaC files:

    ```
    regula write-test-inputs .
    ```

You'll see output like this:

```
INFO Loaded 3 IaC configurations as test inputs
```

#### Example generated file

Here's an example CloudFormation file and its generated test inputs file:

=== "cfn_resources.yaml"

    ```yaml
    AWSTemplateFormatVersion: '2010-09-09'
    Resources:
      ValidManagedPolicy01:
        Type: AWS::IAM::ManagedPolicy
        Properties:
          Description: 'This is a super long description hooray'
          PolicyDocument:
            Version: '2012-10-17'
            Statement:
            - Effect: Deny
              Action: '*'
              Resource: '*'

      InvalidManagedPolicy01:
        Type: AWS::IAM::ManagedPolicy
        Properties:
          Description: 'too short'
          PolicyDocument:
            Version: '2012-10-17'
            Statement:
            - Effect: Deny
              Action: '*'
              Resource: '*'
    ```

=== "cfn_resources_yaml.rego"

    ```ruby
    package infra.cfn_resources_yaml

    import data.fugue.resource_view.resource_view_input

    mock_input := ret {
      ret = resource_view_input with input as mock_config
    }
    mock_resources := mock_input.resources
    mock_config := {
      "AWSTemplateFormatVersion": "2010-09-09",
      "Resources": {
        "InvalidManagedPolicy01": {
          "Properties": {
            "Description": "too short",
            "PolicyDocument": {
              "Statement": [
                {
                  "Action": "*",
                  "Effect": "Deny",
                  "Resource": "*"
                }
              ],
              "Version": "2012-10-17"
            }
          },
          "Type": "AWS::IAM::ManagedPolicy"
        },
        "ValidManagedPolicy01": {
          "Properties": {
            "Description": "This is a super long description hooray",
            "PolicyDocument": {
              "Statement": [
                {
                  "Action": "*",
                  "Effect": "Deny",
                  "Resource": "*"
                }
              ],
              "Version": "2012-10-17"
            }
          },
          "Type": "AWS::IAM::ManagedPolicy"
        }
      }
    }
    ```

## Running Regula with Docker

!!! note
    Windows users can run Linux containers using a method described in the [Microsoft documentation](https://docs.microsoft.com/en-us/virtualization/windowscontainers/deploy-containers/linux-containers).

Regula is available as a Docker image on DockerHub [here](https://hub.docker.com/r/fugue/regula).

The default `--workdir` for the Regula container is `/workspace`. To run Regula on your
current working directory, you can use the following command:

=== "macOS and Linux"

    ```shell
    docker run --rm -t -v $(pwd):/workspace fugue/regula:{{ version }} run
    ```

=== "Windows (PowerShell)"

    ```powershell
    docker run --rm -t -v ${pwd}:/workspace fugue/regula:{{ version }} run
    ```

To run Regula on specific directories or files, you can use the following command:

=== "macOS and Linux"

    ```shell
    docker run --rm -t -v $(pwd):/workspace \
      fugue/regula:{{ version }} run src/template2.yaml infra/tfdirectory1
    ```

=== "Windows (PowerShell)"

    ```powershell
    # Note that we're using Unix-style paths in the arguments because
    # fugue/regula is a Linux container.
    docker run --rm -t -v ${pwd}:/workspace `
      fugue/regula:{{ version }} run src/template2.yaml infra/tfdirectory1
    ```

When integrating this in a CI pipeline, we recommend pinning the regula version, e.g. `docker run fugue/regula:{{ version }}`.

## Globbing

To pass an entire directory of files into Regula for any command, such as `regula run`, use the syntax `regula run .` rather than a glob such as `regula run ./*`.

When your shell expands the glob to a list of individual filenames, it may pass in files that Regula doesn't recognize. Regula reports errors when individual files are passed in, but ignores unrecognized files when it recurses a directory.

If you see a `FATAL Unable to detect input type of file` error, check whether you're using globbing.