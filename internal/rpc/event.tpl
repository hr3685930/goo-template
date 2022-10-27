package rpc

import (
	proto "{{ .ProjectName }}/api/proto/pb"
	"{{ .ProjectName }}/internal/events"
	"{{ .ProjectName }}/internal/utils/format"
    "{{ .ProjectName }}/internal/errs"
    "context"
    "encoding/base64"
    "encoding/json"
)

// Event Event
type Event struct {
}

// NewEvent NewEvent
func NewEvent() *Event {
	return &Event{}
}

// Send Send
func (ev *Event) Send(c context.Context, in *proto.CloudEvent) (*proto.Empty, error) {
	e, err := format.FromProto(in)
	if err != nil {
		return nil, err
	}
	// proto 转码方式不一样
    var s string
    if err := json.Unmarshal(e.DataEncoded, &s); err != nil {
        return nil,errs.InternalError("json unmarshal error")
    }
    dataEncoded, err := base64.StdEncoding.DecodeString(s)
    if err != nil {
        return nil,errs.InternalError("data encoded error:" + err.Error())
    }
    err = e.SetData(format.ContentTypeProtobuf, dataEncoded)
    if err != nil {
        return nil,errs.InternalError("data encoded error:" + err.Error())
    }
	err = events.Bus(c, *e)
	if err != nil {
		return nil, err
	}
	return &proto.Empty{}, err
}
