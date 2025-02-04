open Ctypes
open Foreign

type c_t

let c_t = structure "tnt_reply"
let ( -: ) ty label = field c_t label ty
let _alloc = int -: "alloc"
let _bitmap = uint64_t -: "bitmap"
let _buf = string -: "buf"
let _buf_size = size_t -: "buf_size"
let _code = uint64_t -: "code"
let _sync = uint64_t -: "sync"
let _schema_id = uint64_t -: "schema_id"
let _error = string -: "error"
let _error_end = string -: "error_end"
let data = ptr char -: "data"
let data_end = ptr char -: "data_end"
let _metadata = string -: "metadata"
let _metadata_end = string -: "metadata_end"
let _sqlinfo = string -: "sqlinfo"
let _sqlinfo_end = string -: "sqlinfo_end"
let () = seal (c_t : c_t structure typ)
let _init = foreign "tnt_reply_init" (ptr c_t @-> returning (ptr c_t))
let _free = foreign "tnt_reply_free" (ptr c_t @-> returning void)

type t = Reply of c_t Ctypes_static.structure Ctypes_static.ptr

let init () = Reply (coerce (ptr void) (ptr c_t) null |> _init)
let free (Reply r) = _free r

let data (Reply r) =
  let length = Ctypes.ptr_diff (getf !@r data) (getf !@r data_end) in
  Ctypes.string_from_ptr (getf !@r data) ~length
;;

let c (Reply r) = r
