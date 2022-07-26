package listener

import cloudevents "github.com/cloudevents/sdk-go/v2"

// Example Example
type Example struct {

}

// NewExample NewExample
func NewExample() *Example {
	return &Example{}
}

// Handler Handler
func (u Example) Handler(event cloudevents.Event) error {
	panic("implement me")
}



