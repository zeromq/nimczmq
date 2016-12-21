import unittest, nimczmq

suite "zstr":
    test "send and receive string":
        var push = zsock_new(ZMQ_PUSH)
        var rc = zsock_bind(push, "inproc://zstr_test")
        check(rc == 0)
       
        var pull = zsock_new(ZMQ_PULL)
        rc = zsock_connect(pull, "inproc://zstr_test")
        check(rc == 0)

        rc = zstr_send(push, "Hello")
        check(rc == 0)
       
        var str = zstr_recv(pull)
        check($str == "Hello")

        zstr_free(addr(str))
        zsock_destroy(addr(push))
        zsock_destroy(addr(pull))
