open Ctypes
open Foreign

type c_t = unit

let c_t = Ctypes.void

let _init = foreign "tnt_reply_init" (ptr c_t @-> returning (ptr c_t))

let _free = foreign "tnt_reply_free" (ptr c_t @-> returning void)

type t = Reply of c_t Ctypes_static.ptr

let init () = Reply (_init Ctypes.null)

let free (Reply r) = _free r

let c (Reply r) = r
