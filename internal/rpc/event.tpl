package rpc

import (
	"context"
	proto "{{ .ProjectName }}/api/proto/pb"
	"{{ .ProjectName }}/internal/events"
	"{{ .ProjectName }}/internal/utils/format"
)

// Event Event
type Event struct {
}

// NewEvent NewEvent
func NewEvent() *Event {
	return &Event{}
}

// Send Send
func (s *Event) Send(c context.Context, in *proto.CloudEvent) (*proto.Empty, error) {
	e, err := format.FromProto(in)
	if err != nil {
		return nil, err
	}
	err = events.Bus(c, *e)
	if err != nil {
		return nil, err
	}
	return &proto.Empty{}, err
}
