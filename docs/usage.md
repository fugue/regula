# Usage


## Running Regula locally on macOS and Linux

Regula requires two types of inputs to run:

- `REGO_PATH`: A directory that contains rules written in Rego. **At a minimum, this should include `lib`**
- `IAC_PATH`: Either a CloudFormation YAML/JSON template, Terraform plan file, or Terraform directory with HCL files

This command evaluates a single Rego rule directory on a single `IAC_PATH`:

    ./bin/regula -d [REGO_PATH] [IAC_PATH]

This command evaluates multiple Rego rule directories on multiple `IAC_PATH`s. Please note that a single Regula run can evaluate multiple CloudFormation templates, Terraform plan files, and Terraform HCL directories:

    ./bin/regula -d [REGO_PATH_1] -d [REGO_PATH_2] [IAC_PATH_1] [IAC_PATH_2]

### Usage examples

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

## Running Regula locally on Windows

Because Regula uses a bash script to automatically generate a plan, convert it to JSON, and run the Rego validations, Windows users can instead manually run the steps that Regula performs. See those steps [here](development/rule-development.md#locally-producing-a-report-on-windows).  Alternatively, you can run the script using [WSL](https://docs.microsoft.com/en-us/windows/wsl/about).

## Running Regula with Docker

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

When integrating this in a CI pipeline, we recommend pinning the regula version, e.g. `docker run fugue/regula:{{ version }}`.

