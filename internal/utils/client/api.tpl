package client

import (
	"context"
	"{{ .ProjectName }}/internal/errs"
	grpc_middleware "github.com/grpc-ecosystem/go-grpc-middleware"
	grpc_opentracing "github.com/grpc-ecosystem/go-grpc-middleware/tracing/opentracing"
	"github.com/hr3685930/pkg/rpc"
	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials/insecure"
	"time"
)

type APIClient struct {
}

func NewAPIClient() *APIClient {
	return &APIClient{}
}

func (c APIClient) GetRpcConn(ctx context.Context, endpoint string) (conn *grpc.ClientConn, err error) {
	return grpc.DialContext(ctx,
		endpoint,
		grpc.WithBlock(),
		grpc.WithTransportCredentials(insecure.NewCredentials()),
		grpc.WithConnectParams(grpc.ConnectParams{
			MinConnectTimeout: time.Second * 5,
		}),
		grpc.WithUnaryInterceptor(grpc_middleware.ChainUnaryClient(
			rpc.UnaryGovernanceClientInterceptor(errs.InternalError("too many request")),
			grpc_opentracing.UnaryClientInterceptor(),
		)),
	)
}
