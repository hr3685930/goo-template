package boot

import (
	"{{ .ProjectName }}/internal/commands"
	"github.com/hr3685930/pkg/command"
)

//Command cmd
func Command() error {
	command.NewCommand(commands.Commands).Init()
	return nil
}
