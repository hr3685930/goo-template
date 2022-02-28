package jobs

import (
	"fmt"
	"github.com/hr3685930/pkg/queue"
)

type Example struct {
	Test string `json:"test"`
}

func (receiver Example) Handler() (queueErr *queue.Error) {
	defer func() {
		if err := recover(); err != nil {
			queueErr = queue.Err(fmt.Errorf("error send msg: %+v", err))
		}
	}()

	// ...

	return nil
}
