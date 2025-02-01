type t

val net : unit -> t

val set_string : t -> Opt.t -> string -> (unit, int) Result.t

val set_int : t -> Opt.t -> int -> (unit, int) Result.t

val connect : t -> (unit, int) Result.t

val ping : t -> (unit, int) Result.t

val read_reply : t -> (Reply.t, int) Result.t

type c_t

val c_t : c_t Ctypes_static.structure Ctypes.typ

val c : t -> c_t Ctypes_static.structure Ctypes_static.ptr
