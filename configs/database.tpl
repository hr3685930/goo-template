package configs

import (
	"github.com/hr3685930/pkg/config"
)

// Database default
type Database struct {
	Sqlite SQLite
{{- if (eq .DBDrive "mysql") }}
	Mysql Mysql
{{- else if (eq .DBDrive "postgre") }}
	Postgre Postgre
{{- else if (eq .DBDrive "clickhouse") }}
	Clickhouse Clickhouse
{{- end }}
	Default string `default:"sqlite" mapstructure:"default"`
}

// Mysql Mysql
type Mysql struct {
	config.MYSQLDrive
	Dsn string `default:"" mapstructure:"dsn"`
}

// Postgre Postgre
type Postgre struct {
	config.PostgreDrive
	Dsn string `default:"" mapstructure:"dsn"`
}

// Clickhouse Clickhouse
type Clickhouse struct {
	config.ClickhouseDrive
	Dsn string `default:"" mapstructure:"dsn"`
}

// SQLite SQLite
type SQLite struct {
	config.SQLiteDrive
}
