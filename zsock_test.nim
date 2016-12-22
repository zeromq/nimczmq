import unittest, nimczmq

suite "zsock":
    test "zsock create and destroy":

        # Create a socket and destroy it.
        var sock = zsock_new(ZMQ_PUB)
        check(sock != nil)
        zsock_destroy(addr(sock))
        check(sock == nil)

    test "zsock_new_pub and zsock_new_sub":

        # Create a ZMQ_PUB socket and connect to an in memory endpoint.
        # CZMQ will return a NULL if it cannot create the socket.
        var pub = zsock_new_pub("inproc://new_pub_sub_test")
        check(pub != nil)

        # Create a ZMQ_SUB socket and connect to an in memory endpoint.
        # CZMQ will return a NULL if it cannot create the socket.
        # We will subscribe to "", which receives all messages.
        var sub = zsock_new_sub("inproc://new_pub_sub_test", "")
        check(sub != nil)
 
        # Send a message from the publisher to the subscriber.
        var  rc = zstr_send(pub, "Hello")
        check(rc == 0)
 
        # Receive the message and check the message contents.
        var str = zstr_recv(sub)
        check($str == "Hello")

        # The caller is reponsible for freeing a string created via zstr_recv.
        zstr_free(addr(str))
        check(str == nil)
  
        # Destroy the sockets.
        zsock_destroy(addr(sub))
        check(sub == nil)
        zsock_destroy(addr(pub))
        check(pub == nil)
    
    test "zsock_new_rep and zsock_new_req":
        # Create a ZMQ_REP socket and connect to an in memory endpoint.
        var rep = zsock_new_rep("inproc://new_rep_req_test")
        check(rep != nil)

        # Create a ZMQ_REQ socket and connect to an in memory endpoint.
        var req = zsock_new_req("inproc://new_rep_req_test")
        check(req != nil)
       
        # Send a message from the ZMQ_REQ socket.
        var rc = zstr_send(req, "Hello")
        check(rc == 0)
   
        # Receive the message on the ZMQ_REP socket and check the contents.
        var str = zstr_recv(rep)
        check($str == "Hello")
  
        # The caller is responsible for freeing a string created via zstr_recv.
        zstr_free(addr(str))
        check(str == nil)
  
        # Send a reply from the ZMQ_REP socket back to the ZMQ_REQ socket.
        rc = zstr_send(rep, "World")
        check(rc == 0)

        # Receive the response.
        str = zstr_recv(req)
        check($str == "World")

        # The caller is responsible for freeing a string created via zstr_recv.
        zstr_free(addr(str))
        check(str == nil)

        # Destroy the sockets.
        zsock_destroy(addr(rep))
        check(rep == nil)
        zsock_destroy(addr(req))
        check(req == nil)

    test "zsock_new_dealer and zsock_new_router":
        # Create a ZMQ_ROUTER socket and connect to an in memory endpoint.
        var router = zsock_new_router("inproc://new_dealer_router_test")
        check(router != nil)

        # Create a ZMQ_DEALER socket and connect to an in memory endpoint.
        var dealer = zsock_new_dealer("inproc://new_dealer_router_test")
        check(dealer != nil)
   
        # Send a message from the ZMQ_DEALER socket.
        var rc = zstr_send(dealer, "Hello")
        check(rc == 0)

        # A message received on a ZMQ_ROUTER socket have a prepended frame
        # containing the id of the sender.
        var id_frame = zframe_recv(router)
        check(id_frame != nil)

        # Receive the second frame, which will have the message contents.
        var request_frame = zframe_recv(router)
        check(request_frame != nil)

        # Copy the message contents as a string 
        var str = zframe_strdup(request_frame)
        check($str == "Hello")

        # The caller is responsible for freeing a string created via zframe_strdup.
        zstr_free(addr(str))
        check(str == nil)

        # To reply to the ZMQ_DEALER, we first send the id frame. We use the
        # ZMQ_MORE flag to indicate there are more  frames to follow.
        rc = zframe_send(addr(id_frame), router, ZMQ_MORE)
        check(rc == 0)

        # Verify zframe_send free'd the frame after sending it.
        check(id_frame == nil)

        # Send a response. We use the ZMQ_NOMORE flag to indicate this is the last frame.
        var reply_frame = zframe_from("World")
        rc = zframe_send(addr(reply_frame), router, ZMQ_NOMORE)
        check(rc == 0)
        
        # Verify zframe_send free'd the frame after sending it.
        check(reply_frame == nil)

        # Receive the response from the ZMQ_ROUTER socket.
        var recv_frame = zframe_recv(dealer)
        check(recv_frame != nil)

        # Copy the frame payload into a string and verify it.
        str = zframe_strdup(recv_frame)
        check(str == "World")

        # Caller is responsible for destroying the frame.
        zframe_destroy(addr(recv_frame))
        check(recv_frame == nil)

        # Caller is responsible for destroying a string created with zframe_strdup.
        zstr_free(addr(str))
        check(str == nil)

        # Destroy the sockets.
        zsock_destroy(addr(dealer))
        check(dealer == nil)
        zsock_destroy(addr(router))
        check(router == nil)
    
    test "zsock_new_push and zsock_new_pull":
        # Create a ZMQ_PULL socket and connect to an in memory endpoint.
        var pull = zsock_new_pull("inproc://new_push_pull_test")
        check(pull != nil)

        # Create a ZMQ_PUSH socket and connect to an in memory endpoint.
        var push = zsock_new_push("inproc://new_push_pull_test")
        check(push != nil)
   
        # Send a message from the ZMQ_PUSH socket.
        var rc = zstr_send(push, "Hello")
        check(rc == 0)

        # Receive the message on the ZMQ_PULL socket and check the contents.
        var str = zstr_recv(pull)
        check($str == "Hello")
  
        # The caller is responsible for freeing a string created via zstr_recv.
        zstr_free(addr(str))
        check(str == nil)
 
        # Destroy the sockets.
        zsock_destroy(addr(push))
        check(push == nil)
        zsock_destroy(addr(pull))
        check(pull == nil)

    test "zsock_new_xpub and zsock_new_sub":
        # Create a ZMQ_XPUB socket and bind to an in memory endpoint.
        var xpub = zsock_new_xpub("inproc://new_xpub_sub_test")
        check(xpub != nil)

        # Create a ZMQ_SUB socket and connect to an in memory endpoint.
        var sub = zsock_new_sub("inproc://new_xpub_sub_test", "")
        check(sub != nil)
 
        # Send a message from the ZMQ_XPUB socket back to the ZMQ_SUB socket.
        var rc = zstr_send(xpub, "Hello")
        check(rc == 0)

        # Receive the response.
        var str = zstr_recv(sub)
        check($str == "Hello")

        # The caller is responsible for freeing a string created via zstr_recv.
        zstr_free(addr(str))
        check(str == nil)

        # Destroy the sockets.
        zsock_destroy(addr(sub))
        check(sub == nil)
        zsock_destroy(addr(xpub))
        check(xpub == nil)

    test "zsock_new_pair":
        # Create a ZMQ_PAIR socket and bind to an in memory endpoint.
        var pair1 = zsock_new_pair("@inproc://new_pair_test")
        check(pair1 != nil)

        # Create a ZMQ_PAIR socket and connect to an in memory endpoint.
        var pair2 = zsock_new_pair(">inproc://new_pair_test")
        check(pair2 != nil)
 
        # Send a message between the ZMQ_PAIR sockets
        var rc = zstr_send(pair1, "Hello")
        check(rc == 0)

        # Receive the response.
        var str = zstr_recv(pair2)
        check($str == "Hello")

        # The caller is responsible for freeing a string created via zstr_recv.
        zstr_free(addr(str))
        check(str == nil)

        # Destroy the sockets.
        zsock_destroy(addr(pair1))
        check(pair1 == nil)
        zsock_destroy(addr(pair2))
        check(pair2 == nil)
