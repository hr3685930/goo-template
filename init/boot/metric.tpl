package boot

import (
	"github.com/hr3685930/pkg/cache"
	"github.com/hr3685930/pkg/db"
	"github.com/prometheus/client_golang/prometheus/promhttp"
	"github.com/spf13/cast"
	"gorm.io/plugin/prometheus"
	"log"
	"net/http"
)

// metricPort metricPort
const metricPort = 9104

// Metric Metric
func Metric() error {
	// orm
	db.ConnStore.Range(func(key, value interface{}) bool {
		k := key.(string)
		if k != "sqlite" {
			_ = db.GetConnect(k).Use(prometheus.New(prometheus.Config{
				DBName:          k,
				RefreshInterval: 15, // 指标刷新频率（默认为 15 秒）
				StartServer:     false,
				HTTPServerPort:  metricPort,
				MetricsCollector: []prometheus.MetricsCollector{
					&prometheus.MySQL{
						VariableNames: []string{"Threads_running"},
					},
				},
			}))
		}
		return true
	})

	// cache
	cache.AddMetricHook()

	go func() {
		http.Handle("/metrics", promhttp.Handler())
		log.Fatal(http.ListenAndServe(":"+cast.ToString(metricPort), nil))
	}()

	return nil
}
