# nimczmq
Nim ( http://nim-lang.org/ ) bindings for CZMQ

# Usage
```nim
import nimczmq

var pull = zsock_new(ZMQ_PULL)
var rc = zsock_connect(pull, "inproc://zsock_test")
assert(rc == 0)

var push = zsock_new(ZMQ_PUSH)
rc = push.zsock_bind("inproc://zsock_test")
assert (rc == 0)

for i in countdown(1000000, 1):
    rc = zstr_send(push, "Hello World")
    var msg = zstr_recv(pull)
    assert ($msg == "Hello World")

    zstr_free(addr(msg))

zsock_destroy(addr(pull))
zsock_destroy(addr(push))
```
