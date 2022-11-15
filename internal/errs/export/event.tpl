package export

import (
	"{{ .ProjectName }}/configs"
	cloudevents "github.com/cloudevents/sdk-go/v2"
	"fmt"
)

// EventErr Custom Event Err
func EventErr(stack string, e cloudevents.Event) {
    if configs.ENV.App.Env == "local" {
		fmt.Println(stack)
		return
	}
	app := map[string]string{
		"name":        configs.ENV.App.Name,
		"environment": configs.ENV.App.Env,
	}
	option := map[string]interface{}{
		"error_type": "event_error",
		"app":        app,
		"exception":  stack,
		"event_data": fmt.Sprintf("%s", e),
	}
	Report(option, "event error")
}