package export

import (
	"{{ .ProjectName }}/configs"
	"fmt"
	cloudevents "github.com/cloudevents/sdk-go/v2"
)

// EventErr Custom Event Err
func EventErr(stack string, e cloudevents.Event) {
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