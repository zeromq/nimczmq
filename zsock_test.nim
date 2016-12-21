import unittest, nimczmq

suite "zsock":
    test "zsock create and destroy":
        var sock = zsock_new(ZMQ_PUB)
        check(sock != nil)
        zsock_destroy(addr(sock))
