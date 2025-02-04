open Ctypes
open Foreign

type sbo_type =
  | Simple
  | Sparse
  | Packed
[@@deriving enum]

let c_t = Stream.c_t
let _ty = foreign "tnt_object_type" (ptr c_t @-> int @-> returning int)
let _init = foreign "tnt_object" (ptr c_t @-> returning (ptr c_t))

let _add call ty =
  foreign
    (String.concat "" [ "tnt_object_add_"; call ])
    (ptr c_t @-> ty @-> returning int64_t)
;;

let _add_nil = foreign "tnt_object_add_nil" (ptr c_t @-> returning int64_t)
let _add_int = _add "int" int64_t
let _add_uint = _add "uint" uint64_t
let _add_str = _add "strz" string
let _add_bool = _add "bool" bool
let _add_float = _add "float" float
let _add_double = _add "double" float

let _add_array =
  foreign "tnt_object_add_array" (ptr c_t @-> uint32_t @-> returning int64_t)
;;

let _add_map = foreign "tnt_object_add_map" (ptr c_t @-> uint32_t @-> returning int64_t)
let _container_close = foreign "tnt_object_container_close" (ptr c_t @-> returning int64_t)
let _verify_type = foreign "tnt_object_verify" (ptr c_t @-> int8_t @-> returning int)
let _reset = foreign "tnt_object_reset" (ptr c_t @-> returning int)

let _of_raw =
  foreign "tnt_object_as" (ptr c_t @-> string @-> size_t @-> returning (ptr c_t))
;;

let to_result ok code =
  match code with
  | 0 -> Result.ok ok
  | _ -> Result.error code
;;

let to_nn_result code =
  let code = Int64.to_int code in
  if code >= 0 then Result.ok code else Result.error code
;;

let ty s ty = _ty (Stream.c s) (sbo_type_to_enum ty) |> to_result ()
let init () = Stream.of_c (_init (coerce (ptr void) (ptr Stream.c_t) null))
let wrap_add call s = call (Stream.c s) |> to_nn_result
let wrap_add_1 call s a = call (Stream.c s) a |> to_nn_result
let add_nil = wrap_add _add_nil
let add_int = wrap_add_1 _add_int
let add_uint = wrap_add_1 _add_uint
let add_str = wrap_add_1 _add_str
let add_bool = wrap_add_1 _add_bool
let add_float = wrap_add_1 _add_float
let add_double = wrap_add_1 _add_double
let add_array = wrap_add_1 _add_array
let add_map = wrap_add_1 _add_map
let container_close = wrap_add _container_close
let verify s = _verify_type (Stream.c s) (-1) |> to_result ()
let reset s = _reset (Stream.c s) |> to_result ()

let of_raw s =
  _of_raw
    (_init (coerce (ptr void) (ptr Stream.c_t) null))
    s
    (String.length s |> Unsigned.Size_t.of_int)
  |> Stream.of_c
;;
