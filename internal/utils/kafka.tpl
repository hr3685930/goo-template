package utils

import (
	"github.com/Shopify/sarama"
	"github.com/hr3685930/pkg/queue"
	"github.com/hr3685930/pkg/queue/kafka"
)

func GetKafkaCli() sarama.Client {
	if queue.GetQueueDrive("kafka") != nil {
		kafkaCli := queue.GetQueueDrive("kafka").(*kafka.Kafka)
		return kafkaCli.Cli
	}
	return nil
}
