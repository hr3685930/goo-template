package handler

import (
	"github.com/gin-gonic/gin"
	g "github.com/hr3685930/pkg/http/gin"
{{- if .IsTrace }}
	ginTrace "github.com/hr3685930/pkg/tracing/gin"
{{- end }}
	"{{ .ProjectName }}/internal/errs"
	"{{ .ProjectName }}/internal/errs/export"
)

// Route Route
func Route(e *gin.Engine) {
{{- if .IsTrace }}
	e.Use(ginTrace.OpenTracing())
{{- end }}
	e.Use(g.ErrHandler(export.HTTPErrorReport))
	e.Use(gin.CustomRecovery(func(c *gin.Context, err interface{}) {
		_ = c.Error(errs.InternalError("系统错误"))
	}))

	e.GET("/ping", func(c *gin.Context) {
		c.String(200, "pong")
	})
}
