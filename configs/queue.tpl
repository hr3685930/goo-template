package configs

import "github.com/hr3685930/pkg/config"

// Queue default
type Queue struct {
	Default string `default:"local" mapstructure:"default"`
	//Kafka Kafka
	Local Local
}

// Kafka kafka config
type Kafka struct {
	config.KafkaDrive
	Addr string `default:"127.0.0.1:9092" mapstructure:"addr"`
}

// Local Local
type Local struct {
	config.LocalDrive
}
