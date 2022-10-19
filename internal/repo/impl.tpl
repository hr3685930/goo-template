package {{ .FileName }}

{{- if (eq .Types "db") }}

import (
	"context"
	"{{ .ProjectName }}/internal/models"
)
{{- end }}


//Repo Repo
var Repo Repository

{{- if (eq .Types "db") }}

// GetListFilter GetListFilter
type GetListFilter struct {

}

// GetInfoFilter GetInfoFilter
type GetInfoFilter struct {
	ID   *int64
}
{{- end }}

//Repository Repository
type Repository interface {
{{- if (eq .Types "db") }}
	GetList(ctx context.Context, filter *GetListFilter) (res []*models.{{ .Model }}, err error)
	GetInfo(ctx context.Context, filter *GetInfoFilter) (res *models.{{ .Model }}, err error)
	Save(ctx context.Context, m *models.{{ .Model }}) error
	Delete(ctx context.Context, m *models.{{ .Model }}) error
{{- end }}
}
