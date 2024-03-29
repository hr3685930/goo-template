package test

import (
	"{{ .ProjectName }}/configs"
	"{{ .ProjectName }}/init/boot"
	"{{ .ProjectName }}/internal/commands"
	"context"
{{- if (ne .ServiceType "api") }}
	"google.golang.org/grpc"
	"google.golang.org/grpc/health"
    healthpb "google.golang.org/grpc/health/grpc_health_v1"
{{- end }}
	"testing"
)

func TestMain(m *testing.M) {
	config()
	commands.Migrate(nil)
{{- if (ne .ServiceType "api") }}
	RegisterGrpc(func(server *grpc.Server) {
	    healthServer := health.NewServer()
        healthServer.SetServingStatus("", healthpb.HealthCheckResponse_SERVING)
        healthpb.RegisterHealthServer(server, healthServer)
	})
{{- end }}
	m.Run()
}

func config() {
	ctx := context.Background()
	boot.Config()
	configs.ENV.App.Name = "test"
	configs.ENV.App.Debug = true
	configs.ENV.App.ErrReport = ""
	configs.ENV.App.Env = "testing"
	configs.ENV.Queue.Default = "local"
	{{- if .IsDB }}
	configs.ENV.Database.Default = "sqlite"
	{{- end }}
	configs.ENV.Cache.Default = "sync"
	boot.Log()
	{{- if .IsDB }}
	boot.Database(ctx, true, false)
	{{- end }}
	boot.Queue(ctx, true)
	boot.Cache(ctx, true)
	boot.App()
}
