import unittest, nimczmq

suite "zframe":
    test "zframe new and destroy":
        var data = "Hello"
        var frame = zframe_new(data, len(data))
        var size = zframe_size(frame)
        check(size == 5)
        
        var payload = zframe_strdup(frame)
        check($payload == "Hello")

        zframe_destroy(addr(frame))

        var empty = zframe_new_empty()
        size = zframe_size(empty)
        check(size == 0)
        
        zframe_destroy(addr(frame))

    test "zframe from string":
        var frame = zframe_from("a string")
        var size = zframe_size(frame)
        check(size == 8)
        
        var str = zframe_strdup(frame)
        check($str == "a string")
        
        zframe_destroy(addr(frame))

    test "zframe duplicate frame":
        var data = "Hello"
        var frame = zframe_new(data, len(data))
        var frameStr = zframe_strdup(frame)
        var dup = zframe_dup(frame)
        var dupStr = zframe_strdup(dup)
        check($dupStr == $frameStr)

    test "send and receive frame":
        var frame = zframe_new("Hello", 5)
        var push = zsock_new(ZMQ_PUSH)
        var rc = zsock_bind(push, "inproc://zsock_test")
        check(rc == 0)
       
        var pull = zsock_new(ZMQ_PULL)
        rc = zsock_connect(pull, "inproc://zsock_test")
        check(rc == 0)

        rc = zframe_send(addr(frame), push, 0)
        check(rc == 0)

        var recvd = zframe_recv(pull)
        var msg = zframe_strdup(recvd)
        check($msg == "Hello")

        zframe_destroy(addr(recvd))
        zsock_destroy(addr(push))
        zsock_destroy(addr(pull))
