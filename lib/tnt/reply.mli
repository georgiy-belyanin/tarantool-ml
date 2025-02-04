type t

val init : unit -> t
val free : t -> unit

type c_t

val c_t : c_t Ctypes.typ
val c : t -> c_t Ctypes_static.ptr
