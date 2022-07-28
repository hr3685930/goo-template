package boot

import (
	"context"
	"{{ .ProjectName }}/configs"
	"fmt"
	"github.com/aaronjan/hunch"
	"github.com/hr3685930/pkg/cache"
	"github.com/hr3685930/pkg/config"
	"os"
	"time"
)

//Cache cache
func Cache(ctx context.Context, ignoreErr bool) error {
	_, err := hunch.Retry(ctx, 0, func(c context.Context) (interface{}, error) {
		err := config.Drive(configs.ENV.Cache, configs.ENV.App, ignoreErr)
		if err != nil {
			fmt.Println("缓存重连中...", err)
			time.Sleep(time.Second * 2)
		}
		return nil, err
	})

	go func() {
		cache.CacheMap.Range(func(key, value interface{}) bool {
			k := key.(string)
			d := cache.GetCache(k)
			go func() {
				for {
					if d.Ping() != nil {
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
