package boot

import (
	"{{ .ProjectName }}/internal/errs/export"
	"{{ .ProjectName }}/internal/repo"
	"github.com/hr3685930/pkg/goo"
)

// App App
func App() error {
	goo.New()
	goo.AsyncErrFunc = export.GoroutineErr
	repo.Register()
	return nil
}
