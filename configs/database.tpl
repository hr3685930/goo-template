package configs

import (
	"github.com/hr3685930/pkg/config"
)

// Database default
type Database struct {
	Sqlite SQLite
	//Mysql  Mysql
	Default string `default:"sqlite" mapstructure:"default"`
}

// Mysql Mysql
type Mysql struct {
	config.MYSQLDrive
	Dsn string `default:"" mapstructure:"dsn"`
}

// SQLite SQLite
type SQLite struct {
	config.SQLiteDrive
}
