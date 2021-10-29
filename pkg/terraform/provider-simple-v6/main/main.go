package main

import (
	"github.com/fugue/regula/pkg/terraform/grpcwrap"
	plugin "github.com/fugue/regula/pkg/terraform/plugin6"
	simple "github.com/fugue/regula/pkg/terraform/provider-simple-v6"
	"github.com/fugue/regula/pkg/terraform/tfplugin6"
)

func main() {
	plugin.Serve(&plugin.ServeOpts{
		GRPCProviderFunc: func() tfplugin6.ProviderServer {
			return grpcwrap.Provider6(simple.Provider())
		},
	})
}
