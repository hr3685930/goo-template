package boot

import (
	"context"
	"{{ .ProjectName }}/configs"
	"fmt"
	"github.com/aaronjan/hunch"
	"github.com/hr3685930/pkg/config"
	"github.com/hr3685930/pkg/db"
	"gorm.io/gorm/logger"
	"os"
	"time"
)

//Database db
func Database(ctx context.Context, ignoreErr bool, debug bool) error {
	db.DefaultLogLevel = logger.Silent
	if debug {
		db.DefaultLogLevel = logger.Info
	}
	_, err := hunch.Retry(ctx, 0, func(c context.Context) (interface{}, error) {
		err := config.Drive(configs.ENV.Database, configs.ENV.App, ignoreErr)
		if err != nil {
			fmt.Println("数据库重连中...", err)
			time.Sleep(time.Second * 2)
		}
		return nil, err
	})

	go func() {
		db.ConnStore.Range(func(key, value interface{}) bool {
			k := key.(string)
			d, _ := db.GetConnect(k).DB()
			go func() {
				for {
					err := d.PingContext(context.Background())
					if err != nil {
						fmt.Println(k +" connect error")
						os.Exit(0)
					}
					time.Sleep(time.Second * 5)
				}
			}()
			return true
		})
	}()

	return err
}