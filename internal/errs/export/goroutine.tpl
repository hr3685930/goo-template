package export

import (
	"{{ .ProjectName }}/configs"
	"fmt"
)
// GoroutineErr Custom Goroutine Err
func GoroutineErr(stack string) {
    if configs.ENV.App.Env == "local" {
		fmt.Println(stack)
		return
	}
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

