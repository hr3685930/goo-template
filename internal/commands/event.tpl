package commands

import (
	"context"
	"{{ .ProjectName }}/internal/events"
	"github.com/hr3685930/pkg/event"
	"github.com/urfave/cli"
)

// Event Event
func Event(c *cli.Context) {
	err := event.NewKafkaReceiver(
		context.Background(),
		"demo-topic",
		"{{ .ProjectName }}",
		events.Bus,
	)
	if err != nil {
		panic(err)
	}
}
