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
proc zsock_connect*(self: PSock, endpoint: cstring): cint {.importc: "zsock_connect".}
proc zsock_bind*(self: PSock, endpoint: cstring): cint {.importc: "zsock_bind".}
proc zsock_destroy*(self_p: pointer) {.importc: "zsock_destroy".}

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
