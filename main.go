package main

import (
	"github.com/fugue/regula/cmd"
)

//go:generate go run pkg/tf_resource_schemas/generate/main.go

func main() {
	cmd.Execute()
}
