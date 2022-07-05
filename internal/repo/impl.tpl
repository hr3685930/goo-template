package {{ .FileName }}

import (
	"context"
	"evaluation/internal/models"
)

//Repo Repo
var Repo Repository

type GetListFilter struct {

}

type GetInfoFilter struct {
	ID   *int64
}

//Repository Repository
type Repository interface {
	GetList(ctx context.Context, filter *GetListFilter) (res []*models.{{ .Model }}, err error)
	GetInfo(ctx context.Context, filter *GetInfoFilter) (res *models.{{ .Model }}, err error)
	Save(ctx context.Context, m *models.{{ .Model }}) error
	Delete(ctx context.Context, m *models.{{ .Model }}) error
}
