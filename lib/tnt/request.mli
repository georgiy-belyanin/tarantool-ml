type t

val init : unit -> t
val free : t -> unit
val set_space : t -> Unsigned.UInt32.t -> (unit, int) Result.t
val set_index : t -> Unsigned.UInt32.t -> (unit, int) Result.t
val set_offset : t -> Unsigned.UInt32.t -> (unit, int) Result.t
val set_limit : t -> Unsigned.UInt32.t -> (unit, int) Result.t
val set_index_base : t -> Unsigned.UInt32.t -> (unit, int) Result.t
val set_key : t -> Stream.t -> (unit, int) Result.t
val set_func : t -> string -> (unit, int) Result.t
val set_expr : t -> string -> (unit, int) Result.t
val set_tuple : t -> Stream.t -> (unit, int) Result.t
val set_ops : t -> Stream.t -> (unit, int) Result.t
val compile : Stream.t -> t -> int64
val select : unit -> t
val insert : unit -> t
val replace : unit -> t
val update : unit -> t
val delete : unit -> t
val auth : unit -> t
val eval : unit -> t
val call : unit -> t
val call_16 : unit -> t
val upsert : unit -> t
val ping : unit -> t

type c_t

val c_t : c_t Ctypes.typ
val c : t -> c_t Ctypes_static.ptr
