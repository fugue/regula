package reporter

import "fmt"

func GetReporter(format Format) (Reporter, error) {
	switch format {
	case Json:
		return JsonReporter, nil
	case Table:
		return TableReporter, nil
	case Junit:
		return JUnitReporter, nil
	case Tap:
		return TapReporter, nil
	default:
		return nil, fmt.Errorf("Unsupported or unrecognized reporter: %v", FormatIds[format])
	}
}
