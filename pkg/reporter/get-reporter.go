package reporter

import "fmt"

func GetReporter(format Format) (Reporter, error) {
	switch format {
	case Json:
		return JsonReporter, nil
	case Table:
		return TableReporter, nil
	default:
		return nil, fmt.Errorf("Unsupported or unrecognized reporter: %v", FormatIds[format])
	}
}
