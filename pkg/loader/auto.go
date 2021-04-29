package loader

type AutoDetector struct {
	detectors []ConfigurationDetector
}

func (a *AutoDetector) DetectDirectory(i InputDirectory, opts DetectOptions) (IACConfiguration, error) {
	for _, d := range a.detectors {
		l, err := i.DetectType(d, opts)
		if err == nil && l != nil {
			return l, nil
		}
	}

	return nil, nil
}

func (a *AutoDetector) DetectFile(i InputFile, opts DetectOptions) (IACConfiguration, error) {
	for _, d := range a.detectors {
		l, err := i.DetectType(d, opts)
		if err == nil && l != nil {
			return l, nil
		}
	}

	return nil, nil
}

func NewAutoDetector(detectors ...ConfigurationDetector) *AutoDetector {
	return &AutoDetector{
		detectors: detectors,
	}
}
