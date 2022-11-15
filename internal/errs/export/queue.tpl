package export

import (
	"github.com/hr3685930/pkg/queue"
	"{{ .ProjectName }}/configs"
	"fmt"
)

// QueueErrorReport QueueErrorReport
func QueueErrorReport(failedJob queue.FailedJobs) {
    if configs.ENV.App.Env == "local" {
		fmt.Println(failedJob.Stack)
		return
	}
	app := map[string]string{
		"name":        configs.ENV.App.Name,
		"environment": configs.ENV.App.Env,
	}
	option := map[string]interface{}{
		"error_type": "queue_error",
		"app":        app,
		"detail":     failedJob,
	}
	Report(option, "queue error")
}
