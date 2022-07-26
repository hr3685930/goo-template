package boot

import (
	"context"
	"encoding/json"
	proto "{{ .ProjectName }}/api/proto/pb"
	"{{ .ProjectName }}/internal/errs"
	"{{ .ProjectName }}/internal/errs/export"
	"{{ .ProjectName }}/internal/events"
	"{{ .ProjectName }}/internal/utils/format"
	ce "github.com/cloudevents/sdk-go/v2/event"
	grpc_middleware "github.com/grpc-ecosystem/go-grpc-middleware"
	grpc_opentracing "github.com/grpc-ecosystem/go-grpc-middleware/tracing/opentracing"
	"github.com/hr3685930/pkg/event"
	rpcEvent "github.com/hr3685930/pkg/event/rpc"
	"github.com/hr3685930/pkg/goo"
	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials/insecure"
	"time"
)

// EventReceive EventReceive
func EventReceive() error {
	go func() {
		for {
			select {
			case err := <-event.EventErr:
				if e, ok := err.(goo.Error); ok {
					export.EventErr(e.GetStack())
				} else {
					export.EventErr(err.Error())
				}
			}
		}
	}()
	rpcEvent.SendFn = RPCSend
	return event.NewChanReceive(events.Bus)
}

// RPCSend RPCSend
func RPCSend(ctx context.Context, obj interface{}, endpoint string, cloudevent ce.Event) error {
	conn, err := grpc.DialContext(ctx,
		endpoint,
		grpc.WithBlock(),
		grpc.WithTransportCredentials(insecure.NewCredentials()),
		grpc.WithConnectParams(grpc.ConnectParams{
			MinConnectTimeout: time.Second * 5,
		}),
		grpc.WithUnaryInterceptor(grpc_middleware.ChainUnaryClient(
			grpc_opentracing.UnaryClientInterceptor(),
		)),
	)

	if err != nil {
		return errs.InternalError("connect error")
	}
	defer conn.Close()
	msg, err := json.Marshal(obj)
	if err != nil {
		return errs.InternalError("Marshal error")
	}
	data := &proto.EventData{Value: string(msg)}
	err = cloudevent.SetData(format.ContentTypeProtobuf, data)
	if err != nil {
		return errs.InternalError("set event data error")
	}
	cli := proto.NewEventClient(conn)
	req, err := format.ToProto(&cloudevent)
	if err != nil {
		return errs.InternalError("event to proto error")
	}
	_, err = cli.Send(ctx, req)
	return nil
}
