package configs

// App App
type App struct {
	Name      string `default:"demo" mapstructure:"name"`  //应用名
	Env       string `default:"local" mapstructure:"env"`  //环境
	Debug     bool   `default:"true" mapstructure:"debug"` //开启debug
	ErrReport string `default:"" mapstructure:"err_report"`
}
