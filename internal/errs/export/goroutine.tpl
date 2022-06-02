package export

import (
	"{{ .ProjectName }}/configs"
)
// GoroutineErr Custom Goroutine Err
func GoroutineErr(stack string) {
	app := map[string]string{
		"name":        configs.ENV.App.Name,
		"environment": configs.ENV.App.Env,
	}
	option := map[string]interface{}{
		"error_type": "goroutine_error",
		"app":        app,
		"exception":  stack,
	}
	Report(option, "goroutine error")
}

