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

package reporter

import "fmt"

func GetReporter(format Format) (Reporter, error) {
	switch format {
	case JSON:
		return JSONReporter, nil
	case Table:
		return TableReporter, nil
	case Junit:
		return JUnitReporter, nil
	case Tap:
		return TapReporter, nil
	case None:
		return noneReporter, nil
	case Text:
		return TextReporter, nil
	case Compact:
		return CompactReporter, nil
	case Sarif:
		return SarifReporter, nil
	default:
		return nil, fmt.Errorf("Unsupported or unrecognized reporter: %v", FormatIDs[format])
	}
}

func noneReporter(o *RegulaReport) (string, error) {
	return "", nil
}
