type t

val init : unit -> t
val free : t -> unit
val data : t -> string

type c_t

val c_t : c_t Ctypes.structure Ctypes.typ
val c : t -> c_t Ctypes.structure Ctypes_static.ptr
