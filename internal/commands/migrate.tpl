package commands

import (
	"{{ .ProjectName }}/configs"
	"fmt"
	"github.com/hr3685930/pkg/db"
	"github.com/urfave/cli"
)

// Migrate migrate
func Migrate(c *cli.Context) {
	dbs := db.Orm
	if configs.ENV.App.Env != "testing" {
		dbs = dbs.Set("gorm:table_options", "CHARSET=utf8mb4")
	}
	err := dbs.AutoMigrate(
		)

	if err != nil {
		fmt.Print(err)
		return
	}
}
