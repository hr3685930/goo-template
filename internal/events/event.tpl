package events

import (
	"context"
	"{{ .ProjectName }}/internal/events/listener"
	cloudevents "github.com/cloudevents/sdk-go/v2"
	"github.com/cloudevents/sdk-go/v2/protocol"
	"github.com/hr3685930/pkg/event"
	"github.com/hr3685930/pkg/goo"
)

// Listener Listener interface
type Listener interface {
	Handler(event cloudevents.Event) error
}

// Listeners Listeners
var Listeners = map[string][]Listener{
	"com.example.create": {
		listener.NewExample(),
	},
}

// Bus event bus
func Bus(ctx context.Context, e cloudevents.Event) protocol.Result {
	for _, lis := range Listeners[e.Type()] {
		lis := lis
		g := goo.NewGroup(10)
		g.One(ctx, func(ctx context.Context) (interface{}, error) {
			if err := lis.Handler(e); err != nil {
				event.EventErrs <- &event.EventErr{
					Err:   err,
					Event: e,
				}
			}
			return nil, nil
		})
		g.Wait()
	}
	return nil
}
