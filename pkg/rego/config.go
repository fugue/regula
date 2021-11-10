// Copyright 2021 Fugue, Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package rego

import (
	"bytes"
	"context"
	_ "embed"
	"encoding/json"
	"strings"
	"text/template"
)

//go:embed config.tmpl
var regulaConfigTemplate string

type regulaConfigOptions struct {
	Excludes []string
	Only     []string
}

func RegoStringSet(items []string) (string, error) {
	b, err := json.Marshal(items)
	if err != nil {
		return "", err
	}
	arr := string(b)
	return strings.Join(
		[]string{
			"{",
			strings.TrimSuffix(strings.TrimPrefix(arr, "["), "]"),
			"}",
		},
		"",
	), nil
}

func RegulaConfigProvider(excludes []string, only []string) RegoProvider {
	return func(_ context.Context, cb RegoProcessor) error {
		tmpl, err := template.New("config").Funcs(
			template.FuncMap{
				"StringSet": RegoStringSet,
			},
		).Parse(regulaConfigTemplate)
		if err != nil {
			return err
		}
		buf := &bytes.Buffer{}
		err = tmpl.Execute(buf, &regulaConfigOptions{
			Excludes: excludes,
			Only:     only,
		})
		if err != nil {
			return err
		}
		cb(RegoFileFromString("<generated config file>", buf.String()))

		return nil
	}
}
