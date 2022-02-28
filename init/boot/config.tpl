package boot

import (
	"github.com/hr3685930/pkg/config"
	"{{ .ProjectName }}/configs"
)

//Config config
func Config() error {
	return config.Load(&configs.ENV)
}
