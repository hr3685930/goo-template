package test

import (
	"context"
	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials/insecure"
	"google.golang.org/grpc/test/bufconn"
	"log"
	"net"
)

const bufSize = 1024 * 1024

var lis *bufconn.Listener

// RegisterGrpc RegisterGrpc
func RegisterGrpc(fn func(server *grpc.Server)) {
	lis = bufconn.Listen(bufSize)
	s := grpc.NewServer()
	fn(s)
	go func() {
		if err := s.Serve(lis); err != nil {
			log.Fatalf("Server exited with error: %v", err)
		}
	}()
}

// BufDialer BufDialer
func BufDialer(context.Context, string) (net.Conn, error) {
	return lis.Dial()
}

// GrpcClient GrpcClient
func GrpcClient() (conn *grpc.ClientConn, err error) {
	return grpc.DialContext(
		context.Background(),
		"bufnet",
		grpc.WithContextDialer(BufDialer),
		grpc.WithTransportCredentials(insecure.NewCredentials()),
	)
}