package commands

import (
	"context"
	"{{ .ProjectName }}/internal/events"
	"{{ .ProjectName }}/internal/utils"
	"github.com/hr3685930/pkg/event"
	"github.com/urfave/cli"
)

// Event Event
func Event(c *cli.Context) {
	err := event.NewKafkaReceiver(
		context.Background(),
		utils.GetKafkaCli(),
		"demo-topic",
		"group",
		events.Bus,
	)
	if err != nil {
		panic(err)
	}
}
