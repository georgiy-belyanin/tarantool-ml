open Ctypes
open Foreign

type opt =
  | Uri
  | TmoutConnect
  | TmoutRecv
  | TmoutSend
  | SendCb
  | SendCbv
  | SendCbArg
  | SendBuf
  | RecvCb
  | RecvCbArg
  | RecvBuf
[@@deriving enum]

let ssize_t = int64_t

let request = void

let reply = void

type stream

let stream = structure "tnt_stream"

let ( -: ) ty label = field stream label ty

let alloc = int -: "alloc"

let write =
  funptr (ptr stream @-> string @-> size_t @-> returning ssize_t) -: "write"

let writev =
  funptr (ptr stream @-> ptr void @-> int @-> returning ssize_t) -: "writev"

let write_request =
  funptr (ptr stream @-> ptr request @-> ptr uint64_t @-> returning ssize_t)
  -: "write_request"

let read =
  funptr (ptr stream @-> ptr char @-> size_t @-> returning ssize_t) -: "read"

let read_reply =
  static_funptr (ptr stream @-> ptr reply @-> returning int) -: "read_reply"

let free = funptr (ptr stream @-> returning void) -: "free"

let data = ptr void -: "free"

let wrcnt = uint32_t -: "data"

let reqid = uint64_t -: "reqid"

let () = seal (stream : stream structure typ)

let net = foreign "tnt_net" (ptr stream @-> returning (ptr stream))

let _set_string =
  foreign "tnt_set" (ptr stream @-> int @-> string @-> returning int)

let _set_int = foreign "tnt_set" (ptr stream @-> int @-> int @-> returning int)

let _wrap_set set stream opt = set stream (opt_to_enum opt)

let set_string = _wrap_set _set_string

let set_int = _wrap_set _set_int

let connect = foreign "tnt_connect" (ptr stream @-> returning int)

let ping = foreign "tnt_ping" (ptr stream @-> returning int)

let reply_init = foreign "tnt_reply_init" (ptr reply @-> returning (ptr reply))

let reply_free = foreign "tnt_reply_free" (ptr reply @-> returning void)

let read_reply tnt r =
  let read_reply_f =
    getf !@tnt read_reply
    |> Ctypes.coerce
         (static_funptr (ptr stream @-> ptr reply @-> returning int))
         (funptr (ptr stream @-> ptr reply @-> returning int))
  in
  read_reply_f tnt r
