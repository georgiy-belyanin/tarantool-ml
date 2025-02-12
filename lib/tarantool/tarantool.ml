open Tnt

type 'a typ = Typ of ('a -> Msgpck.t) * (Msgpck.t -> 'a)

let typ of_msgpack to_msgpack = Typ (of_msgpack, to_msgpack)
let number = typ Msgpck.of_int Msgpck.to_int
let string = typ Msgpck.of_string Msgpck.to_string
let bool = typ Msgpck.of_bool Msgpck.to_bool

let array (Typ (a_of_msgpack, a_to_msgpack)) =
  typ
    (fun l -> List.map a_of_msgpack l |> Msgpck.of_list)
    (fun m -> Msgpck.to_list m |> List.map a_to_msgpack)
;;

let tuple2 (Typ (a_of_msgpack, a_to_msgpack)) (Typ (b_of_msgpack, b_to_msgpack)) =
  typ
    (fun (a, b) -> [ a_of_msgpack a; b_of_msgpack b ] |> Msgpck.of_list)
    (fun m ->
       let ms = Msgpck.to_list m in
       List.nth ms 0 |> a_to_msgpack, List.nth ms 1 |> b_to_msgpack)
;;

let ( let* ) = Result.bind

type _ fn =
  | Returns : (Msgpck.t -> 'a) -> 'a fn
  | Fn : ('a -> Msgpck.t) * 'b fn -> ('a -> 'b) fn

let ( @-> ) (Typ (to_msgpack, _)) f' = Fn (to_msgpack, f')

let returning1 (Typ (_, from_msgpck)) =
  Returns
    (fun m ->
      let ms = Msgpck.to_list m in
      List.nth ms 0 |> from_msgpck)
;;

let returning2 (Typ (_, from_msgpck1)) (Typ (_, from_msgpck2)) =
  Returns
    (fun m ->
      let ms = Msgpck.to_list m in
      List.nth ms 0 |> from_msgpck1, List.nth ms 1 |> from_msgpck2)
;;

let returning3 (Typ (_, from_msgpck1)) (Typ (_, from_msgpck2)) (Typ (_, from_msgpck3)) =
  Returns
    (fun m ->
      let ms = Msgpck.to_list m in
      ( List.nth ms 0 |> from_msgpck1
      , List.nth ms 1 |> from_msgpck2
      , List.nth ms 2 |> from_msgpck3 ))
;;

let returning = returning1

type 'a func = Func of string * 'a fn

let func name fn = Func (name, fn)

let exec (Func (name, fn)) stream =
  let request = Request.call () in
  let _ = Request.set_func request name in
  let rec from_fn : type a. Msgpck.t list -> a fn -> a =
    fun args fn ->
    match fn with
    | Returns from_msgpack ->
      let args =
        args
        |> List.rev
        |> Msgpck.of_list
        |> Msgpck.Bytes.to_string
        |> Bytes.to_string
        |> Object.of_raw
      in
      let () = Request.set_tuple request args |> Result.get_ok in
      let _ = Request.compile stream request in
      let reply = Stream.read_reply stream |> Result.get_ok in
      let mp = Msgpck.String.read (Reply.data reply) |> snd |> from_msgpack in
      mp
    | Fn (to_msgpack', f) -> fun v -> from_fn (to_msgpack' v :: args) f
  in
  from_fn [] fn
;;

type query =
  | Call of { func : string }
  | Insert of { tuples : Msgpck.t }
  | Select of unit
  | Any of query list
  | All of query list

let connect uri =
  let stream = Stream.net () in
  let* () = Stream.set_string stream Opt.Uri uri in
  let* () = Stream.set_int stream Opt.RecvBuf 0 in
  let* () = Stream.set_int stream Opt.SendBuf 0 in
  let* () = Stream.connect stream in
  Result.ok stream
;;
