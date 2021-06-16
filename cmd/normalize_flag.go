package cmd

import (
	"strings"

	"github.com/spf13/pflag"
)

func normalizeFlag(f *pflag.FlagSet, name string) pflag.NormalizedName {
	name = strings.Replace(name, "_", "-", -1)
	return pflag.NormalizedName(name)
}
