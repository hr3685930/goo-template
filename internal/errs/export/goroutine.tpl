package export

import (
	"fmt"
	"{{ .ProjectName }}/configs"
)
// GoroutineErr Custom Goroutine Err
func GoroutineErr(err error) {
	app := map[string]string{
		"name":        configs.ENV.App.Name,
		"environment": configs.ENV.App.Env,
	}
	option := map[string]interface{}{
		"error_type": "goroutine_error",
		"app":        app,
		"exception":  fmt.Sprintf("%+v\n", err),
	}
	Report(option, "goroutine error")
}

