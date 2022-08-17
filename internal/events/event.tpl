package events

import (
	"context"
	"encoding/json"
	"{{ .ProjectName }}/internal/events/listener"
	cloudevents "github.com/cloudevents/sdk-go/v2"
	"github.com/cloudevents/sdk-go/v2/protocol"
	"github.com/hr3685930/pkg/event"
	"github.com/hr3685930/pkg/goo"
)

// Listener Listener interface
type Listener interface {
	Handler(ctx context.Context, event cloudevents.Event) error
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
		list := lis
        if err := json.Unmarshal(e.DataEncoded, &list); err != nil {
            return errs.InternalError("json 解析失败")
        }
		g := goo.NewGroup(10)
		g.One(ctx, func(ctx context.Context) (interface{}, error) {
			if err := list.Handler(ctx, e); err != nil {
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
