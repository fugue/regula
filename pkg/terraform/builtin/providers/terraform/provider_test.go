package terraform

import (
	backendInit "github.com/fugue/regula/pkg/terraform/backend/init"
)

func init() {
	// Initialize the backends
	backendInit.Init(nil)
}
