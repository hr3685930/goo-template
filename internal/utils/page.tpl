package utils

import (
	proto "{{ .ProjectName }}/api/proto/pb"
	"github.com/pilagod/gorm-cursor-paginator/v2/paginator"
)

// PageRequest PageRequest
type PageRequest struct {
	NextPageToken *string `json:"next_page_token"`
	LastPageToken *string `json:"last_page_token"`
	Limit         *int    `json:"limit"`
	SortBy        []Sort  `json:"sort_by"`
}

// Sort Sort
type Sort struct {
	Key  string `json:"key"`
	Sort string `json:"sort"`
}

// NewPageRequest NewPageRequest
func NewPageRequest(req *proto.PageReq) *PageRequest {
	p := &PageRequest{}
	if req != nil {
		p.NextPageToken = req.NextPageToken
		p.LastPageToken = req.LastPageToken
		if req.SortBy != nil {
			p.SortBy = make([]Sort, 0)
			for _, sort := range req.SortBy {
				p.SortBy = append(p.SortBy, Sort{
					Key:  sort.Key,
					Sort: sort.Sort,
				})
			}
		}

		if req.Limit != nil {
			l := int(*req.Limit)
			p.Limit = &l
		}
	}
	return p
}

// PageResult PageResult
type PageResult struct {
	NextPageToken *string `json:"next_page_token"`
	LastPageToken *string `json:"last_page_token"`
}

// CursorToPageResult CursorToPageResult
func CursorToPageResult(c paginator.Cursor) *PageResult {
	return &PageResult{
		NextPageToken: c.After,
		LastPageToken: c.Before,
	}
}

// ToPagePB ToPagePB
func (p *PageResult) ToPagePB() *proto.PageRes {
	res := &proto.PageRes{}
	if p.NextPageToken == nil {
		res.NextPageToken = ""
	} else {
		res.NextPageToken = *p.NextPageToken
	}

	if p.LastPageToken == nil {
		res.LastPageToken = ""
	} else {
		res.LastPageToken = *p.LastPageToken
	}

	return res
}

// NewPaginator NewPaginator
func NewPaginator(query *PageRequest) *paginator.Paginator {
	opts := []paginator.Option{
		&paginator.Config{
			Keys:  []string{"ID"},
			Limit: 10,
			Order: paginator.ASC,
		},
	}

	if query.SortBy != nil {
		rules := make([]paginator.Rule, 0)
		for _, sort := range query.SortBy {
			order := paginator.DESC
			if sort.Sort == "ASC" || sort.Sort == "asc" {
				order = paginator.ASC
			}
			rules = append(rules, paginator.Rule{
				Key:   sort.Key,
				Order: order,
			})
		}

		opts = append(opts, paginator.WithRules(rules...))
	}
	if query.Limit != nil {
		opts = append(opts, paginator.WithLimit(*query.Limit))
	}
	if query.NextPageToken != nil {
		opts = append(opts, paginator.WithAfter(*query.NextPageToken))
	}
	if query.LastPageToken != nil {
		opts = append(opts, paginator.WithBefore(*query.LastPageToken))
	}
	return paginator.New(opts...)
}
