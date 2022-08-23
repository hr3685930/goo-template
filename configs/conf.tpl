package configs

// ENV ENV
var ENV DotEnv

//DotEnv DotEnv
type DotEnv struct {
	App      App
	{{- if .IsDB }}
	Database Database
	{{- end }}
	Queue    Queue
	Cache    Cache
    {{- if .IsTrace }}
    Trace    Trace
    {{- end }}
}
