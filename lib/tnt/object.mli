type sbo_type =
  | Simple
  | Sparse
  | Packed
[@@deriving enum]

val ty : Stream.t -> sbo_type -> (unit, int) result
val init : unit -> Stream.t
val add_nil : Stream.t -> (int, int) result
val add_int : Stream.t -> int64 -> (int, int) result
val add_uint : Stream.t -> Unsigned.uint64 -> (int, int) result
val add_str : Stream.t -> string -> (int, int) result

(*val add_bin : Stream.t -> bytes -> (int, int) result*)
val add_bool : Stream.t -> bool -> (int, int) result
val add_float : Stream.t -> float -> (int, int) result
val add_double : Stream.t -> float -> (int, int) result
val add_array : Stream.t -> Unsigned.uint32 -> (int, int) result
val add_map : Stream.t -> Unsigned.uint32 -> (int, int) result
val container_close : Stream.t -> (int, int) result
val verify : Stream.t -> (unit, int) result
val reset : Stream.t -> (unit, int) result
val of_raw : string -> Stream.t
