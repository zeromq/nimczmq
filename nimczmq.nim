{.deadCodeElim: on.}
when defined(windows):
  const 
    czmqdll* = "czmq.dll"
elif defined(macosx):
  const 
    czmqdll* = "libczmq.dylib"
else:
  const 
    czmqdll* = "libczmq.so"

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

type
    TSock {.final, pure.} = object
    PSock* = ptr TSock

proc zsock_new*(sockType: cint): PSock {.cdecl, importc: "zsock_new", dynlib: czmqdll.}
proc zsock_connect*(sock: PSock, endpoint: cstring): cint {.cdecl, importc: "zsock_connect", dynlib: czmqdll.}
proc zsock_bind*(sock: PSock, endpoint: cstring): cint {.cdecl, importc: "zsock_bind", dynlib: czmqdll.}
proc zsock_destroy*(sock_p: pointer) {.cdecl, importc: "zsock_destroy", dynlib: czmqdll.}

type
    TFrame {.final, pure.} = object
    PFrame* = ptr TFRame

proc zframe_new*(data: cstring, size: int): PFrame {.cdecl, importc: "zframe_new", dynlib: czmqdll.}
proc zframe_new_empty*(): PFrame {.cdecl, importc: "zframe_new_empty", dynlib: czmqdll.}
proc zframe_from*(str: cstring): PFrame {.cdecl, importc: "zframe_from", dynlib: czmqdll.}
proc zframe_size*(frame: PFrame): cint {.cdecl, importc: "zframe_size", dynlib: czmqdll.}
proc zframe_dup*(frame: PFrame): PFrame {.cdecl, importc: "zframe_dup", dynlib: czmqdll.}
proc zframe_strdup*(frame: PFrame): cstring {.cdecl, importc: "zframe_strdup", dynlib: czmqdll.}
proc zframe_send*(frame_p: pointer, sock: PSock, flags: int): cint {.cdecl, importc: "zframe_send", dynlib: czmqdll.}
proc zframe_recv*(sock: PSock): PFrame {.cdecl, importc: "zframe_recv", dynlib: czmqdll.}
proc zframe_destroy*(frame_p: pointer) {.cdecl, importc: "zframe_destroy", dynlib: czmqdll.}

proc zstr_send*(sock: PSock, str: cstring): cint {.cdecl, importc: "zstr_send", dynlib: czmqdll.}
proc zstr_recv*(sock: PSock): cstring {.cdecl, importc: "zstr_recv", dynlib: czmqdll.}
proc zstr_free*(zstr_p: pointer) {.cdecl, importc: "zstr_free", dynlib: czmqdll.}
