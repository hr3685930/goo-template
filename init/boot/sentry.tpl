package boot

import (
	"{{ .ProjectName }}/configs"
	"github.com/getsentry/sentry-go"
)

//Sentry sentry
func Sentry() error {
	return sentry.Init(sentry.ClientOptions{
		Dsn:              configs.ENV.App.ErrReport,
		Debug:            configs.ENV.App.Debug,
		Environment:      configs.ENV.App.Env,
		AttachStacktrace: true,
		Transport:        sentry.NewHTTPSyncTransport(), //同步执行,并发调用
	})
}
