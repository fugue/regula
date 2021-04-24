package reporter

import "fmt"

var Reporters map[string]Reporter = map[string]Reporter{
	"json": JsonReporter,
}

func GetReporter(name string) (Reporter, error) {
	reporter, ok := Reporters[name]
	if ok {
		return reporter, nil
	}
	return nil, fmt.Errorf("Unrecognized reporter: %v", name)
}
