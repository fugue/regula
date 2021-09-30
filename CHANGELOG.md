# CHANGELOG

## v1.5.0 (2021-09-30)

### Added
* Add resource source code location for regula scan
* Kubernetes support and first batch of rules
* Add CIS AWS v1.4.0 and CIS Google v1.2.0

### Changed
* Enhance ASG AZ rule by inspecting vpc_zone_identifier

### Fixed
* Fix trailing commas in rego metadocs for regula scan

## v1.4.0 (2021-09-16)

### Added
* A new 'compact' output format. See [our updated usage documentation](https://regula.dev/usage.html#example-output) for example output.
* Option to set the output format via the `REGULA_FORMAT` environment variable
* Remediation docs URLs to JSON output format. See [our updated report output documentation](https://regula.dev/report.html#rule-result-attributes) for more info.

## v1.3.2 (2021-09-09)

### Added
* Rule documentation links in the text output format

### Fixed
* Bug with template strings in arguments to `jsonencode` in Terraform

## v1.3.1 (2021-09-07)

### Fixed
* Bug that caused S3 buckets to be ignored by some rules if they had a bucket policy we could not parse (#186)
* Compatibility issue with `regula scan` and some custom Fugue SaaS rules (#185)

## v1.3.0 (2021-09-02)

### Added
* Integration with Fugue's SaaS product via `regula scan`. This is a _purely optional_ feature and `regula run` continues to operate entirely standalone. Let us know if you'd like access to the closed beta by emailing support@fugue.co!

### Removed
* Out-of-date NIST mappings (#175)

### Fixed
* Errors from some Terraform configurations that use variables with nested complex types (#176)
* Bug where .terraform directory can get loaded when --no-ignore option is used (#181)
* Use consistent evaluation order for local variables in Terraform (#184)

## v1.2.0 (2021-08-19)

### Added
* A configuration file for 'regula run'. See 'regula init' in our [usage](https://regula.dev/usage.html#init) and [configuration](https://regula.dev/configuration.html#setting-defaults-for-regula-run) pages for more details (#172)

### Fixed
* Inconsistent filepaths when inputs are specified with a leading `./`. Now all filepaths will be normalized to remove any leading `./` (#169)
* Confusing warning messages when `terraform init` is needed (#170)

## v1.1.0 (2021-08-05)

### Added
* Default WORKDIR to `/workspace` in Docker image (#158)
* Resource line and column numbers in rule results :sunglasses:

### Changed
* Rule metadata updates (#148) (#153) (#166)

### Fixed
* Issue with `missing_resource()` rule results excluded from report output (#157)
* Values for undefined Terraform variables without defaults (#156)

## v1.0.0 (2021-06-29)

### Added
* Support for _ in flag names, e.g. --input_type=tf_plan
* A new text format as the default output format
* Many new Terraform rules! [See the full list on our docs site](https://regula.dev/rules.html).

### Changed
* Unified input_type values in rules with --input-type flag

### Fixed
* Bug when reading .tf files from stdin
* Use specific filepath in report output for tf inputs (#128)
* Include `data.` prefix in data source type names (e.g. `data.aws_iam_policy_document`) for tf inputs

## v0.9.1 (2021-06-10)

### Fixed
* Remove coloring for WAIVED status and severity in table output so that it's readable against a black background (#126)
* Improve support for conditional resources (count = 0) in Terraform HCL

## v0.9.0 (2021-05-27)

### Added
* A `regula` CLI tool with lots of new features, including:
  * Support for HCL source code
  * Built-in OPA and input processing - removes the need for a separate OPA
    installation as well as the Python and Terraform dependencies.
  * Discovery of IaC configurations
  * Additional output formats (an ASCII table, JUnit XML, etc.)
  * A configurable exit status based on rule severity 
  * `test` and `repl` commands which enhance OPA with the Regula library

  For descriptions of the new features and how to use them, please see our updated
  documentation at https://regula.dev


### Changed
* Put all rego code in a `rego` subdirectory. Please see our Conftest documentation for the updated URLs.

## 0.8.0 (2021-04-15)

* Add support for waivers.
* Add support for disabling rules.
* Always use multiple input file mode to display the file path.
* Rename `filename` to `filepath` in report out.
* Use nonzero exit code when rules are failing.

## 0.7.0 (2021-04-01)

*  Update regula report output format.
*  Support multiple input files.

## 0.6.0 (2021-03-18)

*  Add support for CloudFormation templates.
*  Add 23 new CIS AWS rules for CloudFormation templates.
*  Reorganize rules and tests and standardize rule names.
*  Update control and compliance family names to new format.
*  Add a Dockerfile.

## 0.5.0 (2020-08-21)

* New rule: Ensure AWS S3 Buckets are encrypted.
* New rule: Ensure AWS CloudFront uses HTTPS.
* Allow `deny[msg]` style simple rules.
* Enable structured output for `conftest` integration.

## 0.4.0 (2020-07-07)

* Relicense under Apache 2.0 rather than AGPL.
* Add `NIST_800-53` mapping to existing rules.
* Add support for `fugue.deny_resource_with_message` and
  `fugue.missing_resource_with_message` to return custom messages from rules.
* Add a workaround for a bug in OPA >= 0.20 that prevented simple `allow`/`deny`
  rules from working.
* Fix an issue where multiple terraform refs would cause an
  `object keys must be unique` error.

## 0.3.0 (2020-03-11)

* Add conftest integration.
* Add a human-readable message to the report.

## 0.2.0 (2020-02-25)

* Work around terraform issue with subdirectories & remote backends.
* Add initial set of Azure rules.
* Add initial set of GCP rules.
* Minor README.md and SECURITY.md fixes and improvements.

## 0.1.0 (2020-01-23)

* Add support for terraform modules.
* Fix `mktemp` invocation on Mac.
* Various README improvements.

## 0.0.1 (2020-01-14)

* Initial release.
