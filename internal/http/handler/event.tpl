package handler

import (
	"{{ .ProjectName }}/internal/errs"
	"{{ .ProjectName }}/internal/events"
	"github.com/gin-gonic/gin"
	"github.com/hr3685930/pkg/event"
)

func eventHandler(c *gin.Context) {
	ctx := c.Request.Context()
	e, err := event.NewHTTPReceive(ctx, events.Bus)
	if err != nil {
		_ = c.Error(errs.InternalError("event err:" + err.Error()))
	}
	e.ServeHTTP(c.Writer, c.Request)
}
