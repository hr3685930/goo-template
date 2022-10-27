package events

import (
	"context"
	"{{ .ProjectName }}/internal/events/listener"
	cloudevents "github.com/cloudevents/sdk-go/v2"
	"github.com/cloudevents/sdk-go/v2/protocol"
	"github.com/hr3685930/pkg/event"
	"{{ .ProjectName }}/internal/errs"
	"github.com/hr3685930/pkg/goo"
)

// Listener Listener func
type Listener func(ctx context.Context, event cloudevents.Event) error

// Listeners Listeners
var Listeners = map[string][]Listener{
	"com.example.create": {
		listener.Example,
	},
}

// Bus event bus
func Bus(ctx context.Context, e cloudevents.Event) protocol.Result {
	if _, ok := Listeners[e.Type()]; !ok {
        return errs.ResourceNotFound("event not found")
    }
	for _, lis := range Listeners[e.Type()] {
		list := lis
		g := goo.NewGroup(10)
		g.One(ctx, func(ctx context.Context) (interface{}, error) {
			if err := list(ctx, e); err != nil {
				event.EventErrs <- &event.EventErr{
					Err:   err,
					Event: e,
				}
			    return nil, err
			}
			return nil, nil
		})
		_, errArr := g.Wait()
        for _, err := range errArr {
            if err != nil {
                return err
            }
        }
	}
	return nil
}
