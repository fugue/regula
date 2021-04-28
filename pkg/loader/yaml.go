package loader

import "fmt"

var YamlTypeDetector = NewTypeDetector(&TypeDetector{
	DetectFile: func(i *InputFile, opts DetectOptions) (Loader, error) {
		if !opts.IgnoreExt && i.Ext != ".yaml" && i.Ext != ".yml" {
			return nil, fmt.Errorf("File does not have .yaml or .yml extension: %v", i.Path)
		}

		return i.DetectType(*CfnYamlDetector, DetectOptions{
			IgnoreExt: true,
		})
	},
})
