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
	default:
		return nil, fmt.Errorf("Unsupported or unrecognized reporter: %v", FormatIds[format])
	}
}

func noneReporter(o *RegulaOutput) (string, error) {
	return "", nil
}
