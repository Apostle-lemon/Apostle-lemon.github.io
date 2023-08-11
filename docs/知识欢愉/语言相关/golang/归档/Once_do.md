# Once_do

once.do 的源码如下

```go
// Because no call to Do returns until the one call to f returns, if f causes
// Do to be called, it will deadlock.

func (o *Once) Do(f func()) {
    if atomic.LoadUint32(&o.done) == 1 {
        return
    }
    // Slow-path.
    o.m.Lock()
    defer o.m.Unlock()
    if o.done == 0 {
        defer atomic.StoreUint32(&o.done, 1)
        f()
    }
}
```
