package loader

type AutoDetector struct {
	detectors []ConfigurationDetector
}

func (a *AutoDetector) DetectDirectory(i InputDirectory, opts DetectOptions) (IACConfiguration, error) {
	if opts.IgnoreDirs {
		return nil, nil
	}
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

func (a *AutoDetector) InputType() InputType {
	return Auto
}

func NewAutoDetector(detectors ...ConfigurationDetector) *AutoDetector {
	return &AutoDetector{
		detectors: detectors,
	}
}
