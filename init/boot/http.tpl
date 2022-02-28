package boot

import (
	"github.com/hr3685930/pkg/http/gin"
	"{{ .ProjectName }}/configs"
	"{{ .ProjectName }}/internal/http/handler"
)

//HTTP HTTP
func HTTP() error {
	hs := gin.NewHTTPServer(configs.ENV.App.Debug)
	err := hs.LoadRoute(handler.Route)
	if err != nil {
		return err
	}
	return hs.Run(":8080")
}
