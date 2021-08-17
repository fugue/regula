module github.com/fugue/regula

go 1.16

require (
	github.com/alexeyco/simpletable v1.0.0
	github.com/fatih/color v1.9.0
	github.com/go-git/go-billy/v5 v5.3.1 // indirect
	github.com/go-git/go-git/v5 v5.3.0
	github.com/golang/mock v1.5.0
	github.com/hashicorp/hcl/v2 v2.10.0
	github.com/hashicorp/terraform v0.15.1
	github.com/hashicorp/terraform-plugin-sdk/v2 v2.5.0
	github.com/hashicorp/terraform-provider-google v1.20.0 // indirect
	github.com/manifoldco/promptui v0.8.0
	github.com/open-policy-agent/opa v0.28.0
	github.com/sirupsen/logrus v1.8.1
	github.com/spf13/afero v1.2.2
	github.com/spf13/cobra v1.1.3
	github.com/spf13/pflag v1.0.5
	github.com/spf13/viper v1.7.0
	github.com/stretchr/testify v1.6.1
	github.com/terraform-providers/terraform-provider-aws v1.60.0
	github.com/terraform-providers/terraform-provider-google v1.20.0
	github.com/thediveo/enumflag v0.10.1
	github.com/zclconf/go-cty v1.8.2
	gopkg.in/yaml.v3 v3.0.0-20200313102051-9f266ea9e77c
	tf_resource_schemas v0.0.0-00010101000000-000000000000
)

replace (
	github.com/terraform-providers/terraform-provider-aws => ./providers/terraform-provider-aws
	github.com/terraform-providers/terraform-provider-google => ./providers/terraform-provider-google
	tf_resource_schemas => ./pkg/tf_resource_schemas/
)
