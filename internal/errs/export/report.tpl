package export
{{- if .IsSentry }}
import "github.com/getsentry/sentry-go"
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
{{- end }}
}

