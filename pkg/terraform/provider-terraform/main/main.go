package main

import (
	"github.com/fugue/regula/pkg/terraform/builtin/providers/terraform"
	"github.com/fugue/regula/pkg/terraform/grpcwrap"
	"github.com/fugue/regula/pkg/terraform/plugin"
	"github.com/fugue/regula/pkg/terraform/tfplugin5"
)

func main() {
	// Provide a binary version of the internal terraform provider for testing
	plugin.Serve(&plugin.ServeOpts{
		GRPCProviderFunc: func() tfplugin5.ProviderServer {
			return grpcwrap.Provider(terraform.NewProvider())
		},
	})
}
