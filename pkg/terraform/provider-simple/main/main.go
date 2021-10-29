package main

import (
	"github.com/fugue/regula/pkg/terraform/grpcwrap"
	"github.com/fugue/regula/pkg/terraform/plugin"
	simple "github.com/fugue/regula/pkg/terraform/provider-simple"
	"github.com/fugue/regula/pkg/terraform/tfplugin5"
)

func main() {
	plugin.Serve(&plugin.ServeOpts{
		GRPCProviderFunc: func() tfplugin5.ProviderServer {
			return grpcwrap.Provider(simple.Provider())
		},
	})
}
