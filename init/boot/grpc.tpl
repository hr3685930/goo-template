package boot

import (
	"{{ .ProjectName }}/configs"
	"{{ .ProjectName }}/internal/errs"
	"{{ .ProjectName }}/internal/errs/export"
	"fmt"
	grpc_middleware "github.com/grpc-ecosystem/go-grpc-middleware"
	grpc_recovery "github.com/grpc-ecosystem/go-grpc-middleware/recovery"
	grpc_opentracing "github.com/grpc-ecosystem/go-grpc-middleware/tracing/opentracing"
	"github.com/hr3685930/pkg/rpc"
	"github.com/opentracing/opentracing-go"
	"google.golang.org/grpc"
	"google.golang.org/grpc/health"
	healthpb "google.golang.org/grpc/health/grpc_health_v1"
	"google.golang.org/grpc/reflection"
)

//Grpc rpc
func Grpc() error {
	recoveryOpts := []grpc_recovery.Option{
		grpc_recovery.WithRecoveryHandler(recoverFunc),
	}

	opts := []grpc.ServerOption{
		grpc.UnaryInterceptor(grpc_middleware.ChainUnaryServer(
			grpc_opentracing.UnaryServerInterceptor(grpc_opentracing.WithTracer(opentracing.GlobalTracer())),
			rpc.CustomErrInterceptor(export.GRPCErrorReport),
			grpc_recovery.UnaryServerInterceptor(recoveryOpts...),
		)),
	}
	grpcServer := rpc.NewGrpc(configs.ENV.App.Debug)
	err := grpcServer.Register(opts, func(s *grpc.Server) {
		healthServer := health.NewServer()
		healthServer.SetServingStatus("", healthpb.HealthCheckResponse_SERVING)
		healthpb.RegisterHealthServer(s, healthServer)
		reflection.Register(s)
	})

	err = grpcServer.Run(":8081")
	return err
}

// recoverFunc recover 自定义
func recoverFunc(p interface{}) (err error) {
	return errs.InternalServer(fmt.Sprintf("%v", p))
}
