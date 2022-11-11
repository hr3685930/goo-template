package service

import (
	"context"
	"github.com/hr3685930/pkg/db"
	"gorm.io/gorm"
	"{{ .ProjectName }}/configs"
)

// Context Context
type Context struct {
	*Repo
	Ctx  context.Context
	Conf configs.DotEnv
}

// NewContext NewContext
func NewContext(ctx context.Context) *Context {
	return &Context{
		Repo: NewRepo(db.Orm),
		Ctx:  ctx,
		Conf: configs.ENV,
	}
}

// Repo repo
type Repo struct {

}

// NewRepo NewRepo
func NewRepo(db *gorm.DB) *Repo {
	return &Repo{

	}
}
