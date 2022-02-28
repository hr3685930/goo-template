package configs

// ENV ENV
var ENV DotEnv

//DotEnv DotEnv
type DotEnv struct {
	App      App
	Database Database
	Queue    Queue
	Cache    Cache
    {{- if .IsTrace }}
    Trace    Trace
    {{- end }}
}
