package asyncexecute

import (
	"sync"
	"time"
)

type AsyncExecute[V any] struct {
	m      sync.Mutex
	data   []V
	waited []chan struct{}
	exec   func(data []V)
}

func New[V any](exec func([]V), wait time.Duration, cap int) *AsyncExecute[V] {
	aq := &AsyncExecute[V]{
		data:   make([]V, 0, cap),
		waited: make([]chan struct{}, 0, 10),
		exec:   exec,
	}
	go aq.execute(wait)
	return aq
}

func (aq *AsyncExecute[V]) Set(data ...V) {
	aq.m.Lock()
	aq.data = append(aq.data, data...)
	aq.m.Unlock()
}

func (aq *AsyncExecute[V]) get() ([]V, []chan struct{}) {
	aq.m.Lock()
	data := aq.data
	aq.data = make([]V, 0, cap(data))

	waited := aq.waited
	aq.waited = make([]chan struct{}, 0, cap(waited))
	aq.m.Unlock()
	return data, waited
}

func (aq *AsyncExecute[V]) execute(wait time.Duration) {
	c := time.NewTicker(wait)
	defer c.Stop()
	for {
		data, waited := aq.get()
		if len(data) > 0 {
			aq.exec(data)
		}
		for _, ch := range waited {
			ch <- struct{}{}
		}
		<-c.C
	}
}

func (aq *AsyncExecute[V]) Wait() {
	ch := make(chan struct{}, 1)
	aq.m.Lock()
	aq.waited = append(aq.waited, ch)
	aq.m.Unlock()
	<-ch
}
