package commands

import (
	"github.com/urfave/cli"
)

// Commands cmd
var Commands = []cli.Command{
	{
		Name:    "db",
		Usage:   "db操作",
		Subcommands: []cli.Command{
			{
				Name:   "migrate",
				Usage:  "迁移数据表",
				Action: Migrate,
			},
		},
	},
	{
        Name:    "queue",
        Usage:   "队列job",
        Subcommands: []cli.Command{
            {
                Name:   "example",
                Usage:  "example消费程序",
                Action: Example,
            },
        },
    },
}
