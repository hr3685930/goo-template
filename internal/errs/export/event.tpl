package export

import "{{ .ProjectName }}/configs"

// EventErr Custom Event Err
func EventErr(stack string) {
	app := map[string]string{
		"name":        configs.ENV.App.Name,
		"environment": configs.ENV.App.Env,
	}
	option := map[string]interface{}{
		"error_type": "event_error",
		"app":        app,
		"exception":  stack,
	}
	Report(option, "event error")
}
