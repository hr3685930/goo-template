package test

import (
	"context"
	"github.com/stretchr/testify/assert"
	healthpb "google.golang.org/grpc/health/grpc_health_v1"
	"testing"
)

func TestHealth(t *testing.T) {
	conn,err := GrpcClient()
	defer conn.Close()
	client := healthpb.NewHealthClient(conn)
	resp, err := client.Check(context.Background(), &healthpb.HealthCheckRequest{})
	if err != nil {
		t.Fatalf("health failed: %v", err)
	}
	assert.Equal(t, healthpb.HealthCheckResponse_SERVING, resp.Status)
}