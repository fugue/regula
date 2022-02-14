# CHANGELOG

## v2.5.0 (2022-02-11)

### Changed
* Rule package names to match what's in the Fugue platform offering (#300)

### Fixed
* Empty `opa.runtime()` result (#301)
* Null `terraform.workspace` value (#305)
* Panic from null count in some Terraform configurations (#307)

### Improved
* Table output by making the result and severity columns more visible (#298 authored by @fafg)

## v2.4.0 (2022-01-25)

### Added
* Added support for retrieving rule bundles from Fugue
* Add families to JSON output

### Changed
* Change ARM provider from "arm" to "azurerm"
* On --sync, apply only rules from synced environment

### Fixed
* Fix issue around module detection
* Better error for missing environment ID on --upload

## v2.3.0 (2021-12-17)

### Added
* Rule `FG_R00500` that enforces AWS WAF configuration that mitigates the recently-publicized Log4J vulnerabilities

## v2.2.1 (2021-12-13)

### Fixed
* Panic in Terraform loader (#279)

## v2.2.0 (2021-12-09)

### Added
* Azure Resource Manager (ARM) template support with 38 rules. This feature is currently in preview.

## v2.1.0 (2021-11-18)

### Added
* Ability to specify remediation doc URL for custom rules (#247 authored by @darrendao)
* Support for aws_alb resource type in Terraform rules (#252)
* Remediation doc links for some newer rules

### Fixed
* Panic from HCL loader for variables without defaults (#245)
* Bucket policies not correctly associated with buckets in some Terraform rules (#251)
* Lambda permissions not associated with functions when values besides function name are used (#200)
* False positives from FG_R00073 for WAFv2 with Terraform HCL inputs (#249)

## v2.0.1 (2021-11-12)

### Fixed
* Issue where some data resources would appear empty in the resource view for Terraform HCL inputs (#244)

## v2.0.0 (2021-11-11)

This is a major release that contains a few breaking changes described below. Users who are upgrading from previous versions should:

* Swap any uses of the `--user-only` flag for `--no-built-ins`
* Use `regula run --sync --upload` instead of `regula scan`
* Update any tooling that consumes Regula's JSON output to account for the newly-added field

Please see our [docs site](https://regula.dev) for the latest usage information.

### Added
* `--sync` flag to `regula run`. When `--sync` is specified, Regula will fetch custom rules from Fugue.
* `--upload` flag to `regula run`. When `--upload` is specified, Regula will upload rule results to Fugue.
* `--exclude` flag to `regula run`. `--exclude` takes a rule ID or rule name and excludes that rule from the evaluation.
* `--only` flag to `regula run`. `--only` takes a rule ID or rule name and excludes all other rules from the evaluation.
* `rule_raw_result` field to Regula JSON report output. This boolean field indicates the unwaived rule status - `true` if the rule passed before waivers were applied and `false` otherwise.

### Changed
* Renamed `--user-only` flag to `--no-built-ins`

### Removed
* `regula scan` command. The functionality of `regula scan` has been combined into `regula run`.

### Fixed
* `:unneeded is deprecated` warning from brew install (#239 authored by @somaritane)

### Improved
* Regula's Terraform HCL loader. We've gained support for heredoc syntax, better error handling, better function support, and more.

## v1.6.0 (2021-10-15)

### Added
* Resource line numbers for Kubernetes manifests
* `k8s` input type in help text (#217)
* A tutorial on [how to debug a rule](https://regula.dev/examples/debug-tutorial.html)
* A new rule to enforce lambda permission conditions (#200)

### Changed
* Base docker image from scratch to alpine (#215)

### Fixed
* Incompatibility with plan files from Terraform v1.0.8 (#220) (#221) (#222)

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
