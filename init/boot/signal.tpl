package boot

import (
	"fmt"
{{- if .IsSentry }}
	"github.com/getsentry/sentry-go"
	"time"
{{- end }}
	"os"
	"os/signal"
	"syscall"
)

// Signal 信号量处理关闭
func Signal() error {
	c := make(chan os.Signal)
	signal.Notify(c, syscall.SIGHUP, syscall.SIGINT, syscall.SIGTERM, syscall.SIGQUIT, syscall.SIGUSR1, syscall.SIGUSR2)
	go func() {
		for s := range c {
			switch s {
			case syscall.SIGHUP, syscall.SIGINT, syscall.SIGTERM:
			{{- if .IsSentry }}
				sentry.Flush(time.Second * 5)
			{{- end }}
            {{- if .IsTrace }}
			    TraceClose()
			{{- end }}
				fmt.Println("退出:", s)
				os.Exit(0)
			}
		}
	}()
	return nil
}
