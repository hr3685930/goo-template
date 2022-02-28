package boot

import (
	zap "github.com/hr3685930/pkg/log"
)

//Log log
func Log() error {
	path := "./storage/log/"
	filename := "app.log"
	return zap.NewLog(path, filename).Init()
}
