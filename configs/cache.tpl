package configs

import "github.com/hr3685930/pkg/config"

// Cache default once
type Cache struct {
	Sync    Sync
	//Redis   Redis
	Default string `default:"sync" mapstructure:"default"`
}

// Redis Redis
type Redis struct {
	config.RedisDrive
	Host     string `default:"sync" mapstructure:"host"`
	Port     string `default:"sync" mapstructure:"port"`
	Database string `default:"sync" mapstructure:"database"`
	Auth     string `default:"sync" mapstructure:"auth"`
}

// Sync Sync
type Sync struct {
	config.SyncDrive
}
