# Testing Rules

You can run rule tests using [`regula test`](../usage.md#test) or evaluate them interactively using [`regula repl`](../usage.md#repl). For each rule to be tested, you'll need three files:

- The test Terraform or CloudFormation IaC file (aka test input)
- The Rego rule file
- The Rego tests file, where each test is prepended with `test_`

In both cases, note the path to the IaC file relative to where you invoke `regula test` or `regula run` should align with the package name imported into the Rego test file, as explained in [this note](test-inputs.md#a-note-about-test-input-package-names).

## Test a rule via `regula test`

To test one or more rules via [`regula test`](../usage.md#test):

```
regula test path/to/rule path/to/tests path/to/IaC
```

- Example:

        regula test rules/my_rule.rego tests/my_rule_test.rego infra/my_infra.tf

- Example:

        regula test .

You'll see output like this:

```
PASS: 142/142
```

## Test a rule via `regula repl`

To test interactively test one or more rules via [`regula repl`](../usage.md#repl):

1. Load the tests, rule, and IaC files into the REPL:

        regula repl path/to/rule path/to/tests path/to/IaC

    Example:
    
        regula repl rules/my_rule.rego tests/my_rule_test.rego infra/my_infra.tf
        
    Example:
    
        regula repl .

2. Open the rule package:

        package rules.my_rule

3. Import the IaC package:

        import data.infra.my_infra_tf

4. Evaluate a test from your rule tests file:

        data.rules.my_rule.allow with input as my_infra_tf.mock_resources["aws_s3_bucket.my_valid_bucket"]

You'll see the result of the evaluation:

```
true
```