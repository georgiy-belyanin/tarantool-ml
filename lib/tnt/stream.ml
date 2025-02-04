open Ctypes
open Foreign

type c_t

let c_t = structure "tnt_stream"
let ( -: ) ty label = field c_t label ty
let _alloc = int -: "alloc"
let _write = funptr (ptr c_t @-> string @-> size_t @-> returning int64_t) -: "write"
let _writev = funptr (ptr c_t @-> ptr void @-> int @-> returning int64_t) -: "writev"

let _write_request =
  funptr (ptr c_t @-> ptr void @-> ptr uint64_t @-> returning int64_t) -: "write_request"
;;

let _read = funptr (ptr c_t @-> ptr char @-> size_t @-> returning int64_t) -: "read"

let read_reply =
  static_funptr (ptr c_t @-> ptr Reply.c_t @-> returning int) -: "read_reply"
;;

let _free = funptr (ptr c_t @-> returning void) -: "free"
let _data = ptr void -: "free"
let _wrcnt = uint32_t -: "data"
let _reqid = uint64_t -: "reqid"
let () = seal (c_t : c_t structure typ)
let _net = foreign "tnt_net" (ptr c_t @-> returning (ptr c_t))
let _set_string = foreign "tnt_set" (ptr c_t @-> int @-> string @-> returning int)
let _set_int = foreign "tnt_set" (ptr c_t @-> int @-> int @-> returning int)
let _connect = foreign "tnt_connect" (ptr c_t @-> returning int)
let _ping = foreign "tnt_ping" (ptr c_t @-> returning int)

let _read_reply s =
  let read_reply_f =
    getf !@s read_reply
    |> Ctypes.coerce
         (static_funptr (ptr c_t @-> ptr Reply.c_t @-> returning int))
         (funptr (ptr c_t @-> ptr Reply.c_t @-> returning int))
  in
  read_reply_f s
;;

type t = Stream of c_t Ctypes_static.structure Ctypes_static.ptr

let to_result ok code =
  match code with
  | 0 -> Result.ok ok
  | _ -> Result.error code
;;

let to_nn_result ok code = if code >= 0 then Result.ok ok else Result.error code
let net () = Stream (coerce (ptr void) (ptr c_t) null |> _net)
let wrap_set _set (Stream s) opt v = _set s (Opt.to_enum opt) v |> to_result ()
let set_string = wrap_set _set_string
let set_int = wrap_set _set_int
let connect (Stream s) = _connect s |> to_result ()
let ping (Stream s) = _ping s |> to_nn_result ()

let read_reply (Stream s) =
  let r = Reply.init () in
  let c = _read_reply s (Reply.c r) |> to_result r in
  if Result.is_error c then Reply.free r;
  c
;;

let c (Stream s) = s
let of_c c = Stream c
