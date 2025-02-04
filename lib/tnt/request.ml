open Ctypes
open Foreign

type c_t = unit

let c_t = Ctypes.void
let _init = foreign "tnt_request_init" (ptr c_t @-> returning (ptr c_t))
let _free = foreign "tnt_request_free" (ptr c_t @-> returning void)

let _compile =
  foreign "tnt_request_compile" (ptr Stream.c_t @-> ptr c_t @-> returning int64_t)
;;

let _set_uint32 call =
  foreign
    (String.concat "" [ "tnt_request_set_"; call ])
    (ptr c_t @-> uint32_t @-> returning int)
;;

let _set_stream call =
  foreign
    (String.concat "" [ "tnt_request_set_"; call ])
    (ptr c_t @-> ptr Stream.c_t @-> returning int)
;;

let _set_string call =
  foreign
    (String.concat "" [ "tnt_request_set_"; call ])
    (ptr c_t @-> string @-> returning int)
;;

let _ctor call =
  foreign (String.concat "" [ "tnt_request_"; call ]) (ptr c_t @-> returning (ptr c_t))
;;

type t = Request of c_t Ctypes_static.ptr

let to_result ok code =
  match code with
  | 0 -> Result.ok ok
  | _ -> Result.error code
;;

let init () = Request (_init null)
let free (Request r) = _free r
let set_uint32 call (Request r) v = _set_uint32 call r v |> to_result ()
let set_stream call (Request r) s = _set_stream call r (Stream.c s) |> to_result ()
let set_string call (Request r) v = _set_string call r v |> to_result ()

let ctor call () =
  let c = _ctor call null in
  Request c
;;

let set_space = set_uint32 "space"
let set_index = set_uint32 "index"
let set_offset = set_uint32 "offset"
let set_limit = set_uint32 "limit"
let set_index_base = set_uint32 "index_base"
let set_key = set_stream "key"
let set_tuple = set_stream "tuple"
let set_ops = set_stream "ops"
let set_func = set_string "func"
let set_expr = set_string "expr"
let compile s (Request r) = _compile (Stream.c s) r
let select = ctor "select"
let insert = ctor "insert"
let replace = ctor "replace"
let update = ctor "update"
let delete = ctor "delete"
let auth = ctor "auth"
let eval = ctor "eval"
let call = ctor "call"
let call_16 = ctor "call_16"
let upsert = ctor "upsert"
let ping = ctor "ping"
let c (Request r) = r
