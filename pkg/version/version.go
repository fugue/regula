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

package version

import (
	"strings"

	"github.com/open-policy-agent/opa/version"
)

// Default build-time variables.
// These values are overridden via ldflags
var (
	Version   = "unknown-version"
	GitCommit = "unknown-commit"
	Homepage  = "https://regula.dev"
)

// OPAVersion is the canonical version of OPA that is embedded in Regula
var OPAVersion = version.Version

// Plain version, e.g. "1.2.0" rather than "v1.2.0-dev"
func PlainVersion() string {
	plain := strings.TrimPrefix(Version, "v")
	if idx := strings.Index(plain, "-"); idx >= 0 {
		plain = plain[:idx]
	}
	return plain
}
