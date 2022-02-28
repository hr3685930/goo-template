package test

import (
	"{{ .ProjectName }}/configs"
	"{{ .ProjectName }}/init/boot"
	"{{ .ProjectName }}/internal/commands"
	"context"
{{- if (ne .ServiceType "api") }}
	"google.golang.org/grpc"
{{- end }}
	"testing"
)

func TestMain(m *testing.M) {
	config()
	commands.Migrate(nil)
{{- if (ne .ServiceType "api") }}
	RegisterGrpc(func(server *grpc.Server) {
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
	configs.ENV.Database.Default = "sqlite"
	configs.ENV.Cache.Default = "sync"
	boot.Log()
	boot.Database(ctx, true, false)
	boot.Queue(ctx, true)
	boot.Cache(ctx, true)
	boot.App()
}
