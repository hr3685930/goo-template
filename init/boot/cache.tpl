package boot

import (
	"context"
	"fmt"
	"github.com/aaronjan/hunch"
	"github.com/hr3685930/pkg/config"
	"{{ .ProjectName }}/configs"
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
	return err
}
