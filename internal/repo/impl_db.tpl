package {{ .FileName }}

import (
	"context"
	"{{ .ProjectName }}/internal/models"
	"github.com/hr3685930/pkg/db"
	"gorm.io/gorm"
)

//DB DB
type DB struct {
	orm *gorm.DB
}

//NewDBRepo NewDBRepo
func NewDBRepo() *DB {
	return &DB{orm: db.Orm}
}

func (d *DB) GetList(ctx context.Context, filter *GetListFilter) (res []*models.{{ .Model }}, err error) {
	return res, d.orm.WithContext(ctx).Find(&res).Error
}

func (d *DB) GetInfo(ctx context.Context, filter *GetInfoFilter) (res *models.{{ .Model }}, err error) {
	query := d.orm.WithContext(ctx)
	if filter.ID != nil {
		query = query.Where("id = ?", filter.ID)
	}

	return res, query.First(&res).Error
}

func (d *DB) Save(ctx context.Context, m *models.{{ .Model }}) error {
	return d.orm.WithContext(ctx).Save(&m).Error
}

func (d *DB) Delete(ctx context.Context, m *models.{{ .Model }}) error {
	return d.orm.WithContext(ctx).Delete(&m).Error
}
