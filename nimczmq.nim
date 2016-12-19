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

type
    TSock {.final, pure.} = object
    PSock* = ptr TSock

proc zsock_new*(sockType: cint): PSock {.importc: "zsock_new".}
proc zsock_connect*(sock: PSock, endpoint: cstring): cint {.importc: "zsock_connect".}
proc zsock_bind*(sock: PSock, endpoint: cstring): cint {.importc: "zsock_bind".}
proc zsock_destroy*(sock_p: pointer) {.importc: "zsock_destroy".}

type
    TFrame {.final, pure.} = object
    PFrame* = ptr TFRame

proc zframe_new*(data: cstring, size: int): PFrame {.importc: "zframe_new".}
proc zframe_new_empty*(): PFrame {.importc: "zframe_new_empty".}
proc zframe_from*(str: cstring): PFrame {.importc: "zframe_from".}
proc zframe_size*(frame: PFrame): cint {.importc: "zframe_size".}
proc zframe_dup*(frame: PFrame): PFrame {.importc: "zframe_dup".}
proc zframe_strdup*(frame: PFrame): cstring {.importc: "zframe_strdup".}
proc zframe_send*(frame_p: pointer, sock: PSock, flags: int): cint {.importc: "zframe_send".}
proc zframe_recv*(sock: PSock): PFrame {.importc: "zframe_recv".}
proc zframe_destroy*(frame_p: pointer) {.importc: "zframe_destroy".}

proc zstr_send*(sock: PSock, str: cstring): cint {.importc: "zstr_send".}
proc zstr_recv*(sock: PSock): cstring {.importc: "zstr_recv".}
proc zstr_free*(zstr_p: pointer) {.importc: "zstr_free".}

{.pop.}
