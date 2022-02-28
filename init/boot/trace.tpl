package boot

import (
	"{{ .ProjectName }}/configs"
	"github.com/hr3685930/pkg/cache"
	"github.com/hr3685930/pkg/tracing"
	"io"
)

// TraceCloser 关闭trace
var TraceCloser io.Closer

//Trace trace
func Trace() error {
	TraceCloser = tracing.NewJaegerTracer(configs.ENV.App.Name, configs.ENV.Trace.Endpoint)
	cache.AddTracingHook()
	return nil
}

// TraceClose TraceClose
func TraceClose() {
	if TraceCloser != nil {
		_ = TraceCloser.Close()
	}
}
