open Protocol_conv_msgpack
open Tnt

type a = { name : string } [@@deriving protocol ~driver:(module Msgpack)]
type obj = a list [@@deriving protocol ~driver:(module Msgpack)]

let ( let* ) = Result.bind

let connect_and_call () =
  let stream = Stream.net () in
  let* () = Stream.set_string stream Opt.Uri "localhost:3301" in
  let* () = Stream.set_int stream Opt.RecvBuf 0 in
  let* () = Stream.set_int stream Opt.SendBuf 0 in
  let* () = Stream.connect stream in
  let arguments =
    Object.of_raw
      (obj_to_msgpack [ { name = "stas" } ] |> Msgpck.Bytes.to_string |> Bytes.to_string)
  in
  let request = Request.call () in
  let* () = Request.set_func request "test" in
  let* () = Request.set_tuple request arguments in
  let* () = Object.verify arguments in
  let _ = Request.compile stream request in
  let* reply = Stream.read_reply stream in
  let mp = Msgpck.String.read (Reply.data reply) |> snd in
  Result.ok mp
;;

let () =
  match connect_and_call () with
  | Ok mp -> Format.printf "Successful call! Retrieved %a.\n" Msgpck.pp mp
  | Error code -> Format.printf "Failed with error %d\n" code
;;
