package test

import (
	"{{ .ProjectName }}/configs"
	"{{ .ProjectName }}/internal/http/handler"
	"github.com/hr3685930/pkg/http/gin"
	"github.com/stretchr/testify/assert"
	"net/http"
	"net/http/httptest"
	"testing"
)

func TestPing(t *testing.T) {
	hs := gin.NewHTTPServer(configs.ENV.App.Debug)
	_ = hs.LoadRoute(handler.Route)

	w := httptest.NewRecorder()
	req, _ := http.NewRequest("GET", "/ping",  nil)
	hs.G.ServeHTTP(w, req)
	assert.Equal(t, 200, w.Code)
	assert.Equal(t, "pong", w.Body.String())
}
