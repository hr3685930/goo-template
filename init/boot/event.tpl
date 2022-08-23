package boot

import (
	"context"
	"encoding/json"
	proto "{{ .ProjectName }}/api/proto/pb"
	"{{ .ProjectName }}/internal/errs"
	"{{ .ProjectName }}/internal/errs/export"
	"{{ .ProjectName }}/internal/events"
	"{{ .ProjectName }}/internal/utils"
	"{{ .ProjectName }}/internal/utils/format"
	ce "github.com/cloudevents/sdk-go/v2/event"
	grpc_middleware "github.com/grpc-ecosystem/go-grpc-middleware"
	grpc_opentracing "github.com/grpc-ecosystem/go-grpc-middleware/tracing/opentracing"
	"github.com/hr3685930/pkg/event"
	"github.com/hr3685930/pkg/event/kafka"
	rpcEvent "github.com/hr3685930/pkg/event/rpc"
	"github.com/hr3685930/pkg/goo"
	"github.com/hr3685930/pkg/rpc"
	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials/insecure"
	"time"
)


// EventReceive EventReceive
func EventReceive() error {
	go func() {
		for {
			select {
			case err := <-event.EventErrs:
				if e, ok := err.Err.(goo.Error); ok {
					export.EventErr(e.GetStack(), err.Event)
				} else {
					export.EventErr(err.Err.Error(), err.Event)
				}
			}
		}
	}()
	rpcEvent.SendFn = RPCSend
	kafka.EventClient = utils.GetKafkaCli()
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
			rpc.UnaryGovernanceClientInterceptor(errs.InternalError("too many request")),
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
	err = cloudevent.SetData(format.ContentTypeProtobuf, msg)
	if err != nil {
		return errs.InternalError("set event data error")
	}
	cli := proto.NewEventClient(conn)
	req, err := format.ToProto(&cloudevent)
	if err != nil {
		return errs.InternalError("event to proto error")
	}
	_, err = cli.Send(ctx, req)
	return err
}
