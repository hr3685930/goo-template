package commands

import (
	"github.com/urfave/cli"
	"github.com/hr3685930/pkg/queue"
	"{{ .ProjectName }}/internal/jobs"
	"{{ .ProjectName }}/internal/errs/export"
)

// Example Example
func Example(c *cli.Context) {
	ErrExportHandler()
	queue.NewConsumer("example-topic", queue.Consumers{
		{
			Queue:   "example-queue",
			Job:     &jobs.Example{},
			Sleep:   0,
			Retry:   0,
			Timeout: 0,
		},
	})
}

// ErrExportHandler ErrExportHandler
func ErrExportHandler() {
	go func() {
		for {
			select {
			case failedJob := <-queue.ErrJob:
				export.QueueErrorReport(failedJob)
			}
		}
	}()
}
