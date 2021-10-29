package local

import (
	"flag"
	"os"
	"testing"

	_ "github.com/fugue/regula/pkg/terraform/logging"
)

func TestMain(m *testing.M) {
	flag.Parse()
	os.Exit(m.Run())
}
