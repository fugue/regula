# Rule Development

## Directory structure

 -  `bin/`: the main Regula script that, depending on the IaC platform, will call `opa` and `terraform` or convert CloudFormation YAML to JSON.
 -  `lib/`: the OPA library code to evaluate rules and mangle input.
 -  `rules/`: a collection of rules.
 -  `examples/`: a collection of example rules that you can use as inspiration
     for your own rules.
 -  `scripts/`: scripts for development; currently only a script to generate
    test input.
 -  `tests/`:
      *  `tests/lib`: internal tests for the library.
      *  `tests/rules/`: tests for the various rules.
      *  `tests/rules/tf/<provider>/<service>/inputs`: tests for Terraform rules
      *  `tests/rules/cfn/<service>/inputs`: tests for CloudFormation rules
      *  `tests/rules/inputs`: CloudFormation and Terraform files that can be used to generate Rego
         files.
      *  `tests/examples/`: tests for the example rules.
      *  `tests/examples/inputs`: input files for the example rules.

## Adding a test

If you would like to add a rule, we recommend starting with a test.
Put your code in a file in the `inputs` folder within the appropriate `tests/rules` directory; for example
[`tests/rules/tf/aws/kms/inputs/key_rotation_infra.tf`](https://github.com/fugue/regula/blob/master/tests/rules/tf/aws/kms/inputs/key_rotation_infra.tf).
From this, you can generate a mock input by running:

    bash scripts/generate-test-inputs.sh

The mock input will then be placed in a `.rego` file with the same name,
in our case [`tests/rules/tf/aws/kms/inputs/key_rotation_infra.rego`](https://github.com/fugue/regula/blob/master/tests/rules/tf/aws/kms/inputs/key_rotation_infra.rego).

Next, add the actual tests to a Rego file with the same name (appended with `_test` instead of `_infra`),
but outside of the `inputs/` subdirectory.  Using this example, that would be [`tests/rules/tf/aws/kms/key_rotation_test.rego`](https://github.com/fugue/regula/blob/master/tests/rules/tf/aws/kms/key_rotation_test.rego).

## Debugging a rule with fregot

Once you have generated the mock input, it is easy to debug a rule with
[fregot](https://github.com/fugue/fregot).  Fire up `fregot` with the right directories and set a breakpoint on
the rule you are trying to debug:

    $ fregot repl lib rules tests
    F u g u e   R E G O   T o o l k i t
    fregot v0.7.2 repl - use :help for usage info
    repl% :break data.rules.ec2_t2_only.allow

Now, we can just evaluate the entire report with the mock input.  If your rule
is triggered, that will drop you into a debug prompt:

    repl% data.fugue.regula.report with input as data.tests.rules.ec2_t2_only.mock_input
    19|   valid_instance_types[input.instance_type]
          ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

From here, you can evaluate anything in context; such as `input` to look at the
resource, or any other auxiliary rules such as `valid_instance_types` in this
example.

## Locally producing a terraform report

In some cases (such as development and testing), you may want to manually reproduce the steps that Regula performs automatically.
If that is something you want to step through, this section is for you.

We first need to obtain a JSON-formatted terraform plan.  In order to do get
that, you can use:

    terraform init
    terraform plan -refresh=false -out=plan.tfplan
    terraform show -json plan.tfplan >input.json

This gives you `input.json`.  Now you can test this input against the rules by
evaluating `data.fugue.regula.report` with OPA.  In order to do that, point OPA
to the input file, and the regula project directory.

    opa eval -d /path/to/regula --input input.json 'data.fugue.regula.report'

Or using `fregot`:

    fregot eval --input input.json 'data.fugue.regula.report' . | jq

If all goes well, you should now see the results for each rule.

## Locally producing a report on Windows

To locally produce a Regula report on Windows, use the following steps:

1.  Generate a JSON-based terraform plan:

    ```
    .\terraform.exe init
    .\terraform.exe plan -refresh=false -out=infra
    .\terraform.exe show -json infra >infra.json
    ```

2. Run OPA against this input file:

    ```
    .\opa_windows_amd64.exe eval -i .\infra.json -d .\regula\lib\ -d .\regula\rules\ 'data.fugue.regula.report'
    ```
