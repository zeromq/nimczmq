{.deadCodeElim: on.}

when defined(Windows):
    const czmqLib = "czmq.dll"
elif defined(MacOsx):
    const czmqLib = "libczmq.dynlib"
else:
    const czmqLib = "libczmq.so"

{.push dynlib: czmqLib.}

const
    ZMQ_PAIR* = 0
    ZMQ_PUB* = 1
    ZMQ_SUB* = 2
    ZMQ_REQ* = 3
    ZMQ_REP* = 4
    ZMQ_DEALER* = 5
    ZMQ_ROUTER* = 6
    ZMQ_PULL* = 7
    ZMQ_PUSH* = 8
    ZMQ_XPUB* = 9
    ZMQ_XSUB* = 10
    ZMQ_STREAM* = 11
    ZMQ_SERVER* = 12
    ZMQ_CLIENT* = 13
    ZMQ_RADIO* = 14
    ZMQ_DISH* = 15
    ZMQ_GATHER* = 16
    ZMQ_SCATTER* = 17
    ZMQ_DGRAM* = 18
    ZMQ_MORE* = 1
    ZMQ_NOMORE* = 0

# zsock - high-level socket API that hides libzmq contexts and sockets
type
    TSock {.final, pure.} = object
    PSock* = ptr TSock

# Create a new socket. Returns the new socket, or NULL if the new socket
# could not be created.
proc zsock_new*(sockType: cint): PSock {.importc: "zsock_new".}

# Create a PUB socket. Default action is bind.
proc zsock_new_pub*(endpoint: cstring): PSock {.importc: "zsock_new_pub".}

# Create a SUB socket, and optionally subscribe to some prefix string. Default
# action is connect.
proc zsock_new_sub*(endpoint, subscribe: cstring): PSock {.importc: "zsock_new_sub".}

# Create a REQ socket. Default action is connect.
proc zsock_new_req*(endpoint: cstring): PSock {.importc: "zsock_new_req".}

# Create a REP socket. Default action is bind.
proc zsock_new_rep*(endpoint: cstring): PSock {.importc: "zsock_new_rep".}

# Create a DEALER socket. Default action is connect.
proc zsock_new_dealer*(endpoint: cstring): PSock {.importc: "zsock_new_dealer".}

# Create a ROUTER socket. Default action is bind.
proc zsock_new_router*(endpoint: cstring): PSock {.importc: "zsock_new_router".}

# Create a PUSH socket. Default action is connect.
proc zsock_new_push*(endpoint: cstring): PSock {.importc: "zsock_new_push".}

# Create a PULL socket. Default action is bind.
proc zsock_new_pull*(endpoint: cstring): PSock {.importc: "zsock_new_pull".}

# Create an XPUB socket. Default action is bind.
proc zsock_new_xpub*(endpoint: cstring): PSock {.importc: "zsock_new_xpub".}

# Create an XSUB socket. Default action is connect.
proc zsock_new_xsub*(endpoint: cstring): PSock {.importc: "zsock_new_xsub".}

# Create a PAIR socket. Default action is connect.
proc zsock_new_pair*(endpoint: cstring): PSock {.importc: "zsock_new_pair".}

# Create a STREAM socket. Default action is connect.
proc zsock_new_stream*(endpoint: cstring): PSock {.importc: "zsock_new_stream".}

# Destroy the socket. You must use this for any socket created via the
# zsock_new method
proc zsock_destroy*(self_p: pointer) {.importc: "zsock_destroy".}

# Bind a socket to a formatted endpoint. For tcp:// endpoints, supports   
# ephemeral ports, if you specify the port number as "*". By default      
# zsock uses the IANA designated range from C000 (49152) to FFFF (65535). 
# To override this range, follow the "*" with "[first-last]". Either or   
# both first and last may be empty. To bind to a random port within the   
# range, use "!" in place of "*".                                         
#
# Examples:                                                               
#  tcp://127.0.0.1:*           bind to first free port from C000 up    
#  tcp://127.0.0.1:!           bind to random port from C000 to FFFF   
#  tcp://127.0.0.1:*[60000-]   bind to first free port from 60000 up   
#  tcp://127.0.0.1:![-60000]   bind to random port from C000 to 60000  
#  tcp://127.0.0.1:![55000-55999]                                      
#
# On success, returns the actual port number used, for tcp:// endpoints,  
# and 0 for other transports. On failure, returns -1. Note that when using
# ephemeral ports, a port may be reused by different services without     
# clients being aware. Protocols that run on ephemeral ports should take  
# this into account.                                                      
proc zsock_bind*(self: PSock, endpoint: cstring): cint {.importc: "zsock_bind", discardable.}

# Connect a socket to a formatted endpoint        
# Returns 0 if OK, -1 if the endpoint was invalid.
proc zsock_connect*(self: PSock, endpoint: cstring): cint {.importc: "zsock_connect", discardable.}

# Disconnect a socket from a formatted endpoint                  
# Returns 0 if OK, -1 if the endpoint was invalid or the function
# isn't supported.                         
proc zsock_disconnect*(self: PSock, format: cstring): cint {.importc: "zsock_disconnect", varargs, discardable.}


type
    TFrame {.final, pure.} = object
    PFrame* = ptr TFRame

proc zframe_new*(data: cstring, size: int): PFrame {.importc: "zframe_new".}
proc zframe_new_empty*(): PFrame {.importc: "zframe_new_empty".}
proc zframe_from*(str: cstring): PFrame {.importc: "zframe_from".}
proc zframe_size*(self: PFrame): cint {.importc: "zframe_size".}
proc zframe_dup*(self: PFrame): PFrame {.importc: "zframe_dup".}
proc zframe_strdup*(self: PFrame): cstring {.importc: "zframe_strdup".}
proc zframe_send*(self_p: pointer, sock: PSock, flags: int): cint {.importc: "zframe_send".}
proc zframe_recv*(self: PSock): PFrame {.importc: "zframe_recv".}
proc zframe_destroy*(self_p: pointer) {.importc: "zframe_destroy".}

proc zstr_send*(self: PSock, str: cstring): cint {.importc: "zstr_send".}
proc zstr_recv*(self: PSock): cstring {.importc: "zstr_recv".}
proc zstr_free*(self_p: pointer) {.importc: "zstr_free".}

{.pop.}
