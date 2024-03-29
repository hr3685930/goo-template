package main

import (
    {{- if .IsDB }}
	"{{ .ProjectName }}/configs"
    {{- end }}
	"{{ .ProjectName }}/init/boot"
	"context"
	"github.com/aaronjan/hunch"
)

func main() {
	ctx := context.Background()
	_, err := hunch.Waterfall(
		ctx,
		func(ctx context.Context, n interface{}) (interface{}, error) {
			return nil, boot.Config()
		},
		func(ctx context.Context, n interface{}) (interface{}, error) {
			return hunch.All(
				ctx,
				func(ctx context.Context) (interface{}, error) {
					return nil, boot.Log()
				},
	            {{- if .IsDB }}
				func(ctx context.Context) (interface{}, error) {
					return nil, boot.Database(ctx, false, configs.ENV.App.Debug)
				},
				{{- end }}
				func(ctx context.Context) (interface{}, error) {
					return nil, boot.Cache(ctx, false)
				},
				func(ctx context.Context) (interface{}, error) {
					return nil, boot.Queue(ctx, false)
				},
                {{- if .IsSentry }}
                func(ctx context.Context) (interface{}, error) {
                 	return nil, boot.Sentry()
                },
                {{- end }}
			)
		},
        {{- if .IsTrace }}
        func(ctx context.Context, n interface{}) (interface{}, error) {
        	return nil, boot.Trace()
        },
        {{- end }}
		func(ctx context.Context, n interface{}) (interface{}, error) {
			return nil, boot.App()
		},
        func(ctx context.Context, n interface{}) (interface{}, error) {
            return nil, boot.EventReceive()
        },
        func(ctx context.Context, n interface{}) (interface{}, error) {
            return nil, boot.Governance()
        },
		func(ctx context.Context, n interface{}) (interface{}, error) {
			return nil, boot.Signal()
		},
		func(ctx context.Context, n interface{}) (interface{}, error) {
			return nil, boot.Command()
		},
		{{- if (ne .ServiceType "api") }}
        func(ctx context.Context, n interface{}) (interface{}, error) {
        	return nil, boot.Grpc()
        },
        {{- else }}
        func(ctx context.Context, n interface{}) (interface{}, error) {
            return nil, boot.HTTP()
        },
        {{- end }}
        {{- if .IsMetric }}
        func(ctx context.Context, n interface{}) (interface{}, error) {
        	return nil, boot.Metric()
        },
        {{- end }}
	)
	if err != nil {
		panic(err)
	}
}
