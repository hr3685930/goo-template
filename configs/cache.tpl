package configs

import "github.com/hr3685930/pkg/config"

// Cache default once
type Cache struct {
	Sync    Sync
{{- if (eq .CacheDrive "redis") }}
	Redis   Redis
{{- end}}
	Default string `default:"sync" mapstructure:"default"`
}

// Redis Redis
type Redis struct {
	config.RedisDrive
	Host     string `default:"127.0.0.1" mapstructure:"host"`
	Port     string `default:"3306" mapstructure:"port"`
	Database string `default:"0" mapstructure:"database"`
	Auth     string `default:"" mapstructure:"auth"`
}

// Sync Sync
type Sync struct {
	config.SyncDrive
}
