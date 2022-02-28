package configs

import "github.com/hr3685930/pkg/config"

// Queue default
type Queue struct {
	Default string `default:"local" mapstructure:"default"`
{{- if (eq .QueueDrive "kafka") }}
	Kafka Kafka
{{- else if (eq .QueueDrive "rabbitmq") }}
	Rabbitmq Rabbitmq
{{- end}}
	Local Local
}

// Kafka kafka config
type Kafka struct {
	config.KafkaDrive
	Addr string `default:"127.0.0.1:9092" mapstructure:"addr"`
}

// Rabbitmq Rabbitmq config
type Rabbitmq struct {
	config.RabbitMQDrive
	Host     string `default:"127.0.0.1" mapstructure:"host"`
	Port     string `default:"5672" mapstructure:"port"`
	VHost    string `default:"/" mapstructure:"vhost"`
	Username string `default:"" mapstructure:"username"`
	Password string `default:"" mapstructure:"password"`
}

// Local Local
type Local struct {
	config.LocalDrive
}
