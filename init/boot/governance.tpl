package boot

import (
	"github.com/alibaba/sentinel-golang/api"
	"github.com/alibaba/sentinel-golang/core/system"
)

// Governance 服务治理 限流熔断降级
func Governance() error {
	err := api.InitDefault()
	if err != nil {
		return err
	}

	_, err = system.LoadRules([]*system.Rule{
		{
			MetricType:   system.Load,
			TriggerCount: 8.0,
			Strategy:     system.BBR,
		},
	})

	if err != nil {
		return err
	}

	return nil
}
