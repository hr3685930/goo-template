package commands

import (
	"github.com/hr3685930/pkg/queue"
	"github.com/urfave/cli"
	"{{ .ProjectName }}/internal/jobs"
)

// Example Example
func Example(c *cli.Context) {
	ch := make(chan int)
	queue.NewConsumer("example-topic", queue.Consumers{
		{
			Queue:   "example-queue",
			Job:     &jobs.Example{},
			Sleep:   0,
			Retry:   0,
			Timeout: 0,
		},
	})
	<-ch
}
