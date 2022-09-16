package {{ .FileName }}

import 	"{{ .ProjectName }}/internal/utils/client"

//API API
type API struct {
	*client.APIClient
}

//NewAPIRepo NewAPIRepo
func NewAPIRepo() *API {
	return &API{client.NewAPIClient()}
}
