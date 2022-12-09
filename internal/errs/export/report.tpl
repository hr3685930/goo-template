package export
{{- if .IsSentry }}
import "github.com/getsentry/sentry-go"
{{- else }}
import (
	"{{ .ProjectName }}/configs"
	"github.com/ddliu/go-httpclient"
)
{{- end }}

// Report Report
func Report(option map[string]interface{}, msg string) {
{{- if .IsSentry }}
	go func(localHub *sentry.Hub) {
		localHub.ConfigureScope(func(scope *sentry.Scope) {
			scope.SetExtras(option)
		})
		localHub.CaptureMessage(msg)
	}(sentry.CurrentHub().Clone())
{{- else }}
    go func() {
        if configs.ENV.App.ErrReport != "" {
            _, _ = httpclient.Begin().PostJson(configs.ENV.App.ErrReport, option)
        }
    }()
{{- end }}
}

