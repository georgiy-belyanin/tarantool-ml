open Tnt

let ( let* ) = Result.bind

let connect_and_ping () =
  let stream = Stream.net () in
  let* () = Stream.set_string stream Opt.Uri "localhost:3301" in
  let* () = Stream.set_int stream Opt.RecvBuf 0 in
  let* () = Stream.set_int stream Opt.SendBuf 0 in
  let* () = Stream.connect stream in
  let* () = Stream.ping stream in
  let* _ = Stream.read_reply stream in
  Result.ok ()

let () =
  match connect_and_ping () with
    | Ok () ->
        Format.printf "Pinged!\n"
    | Error code ->
        Format.printf "Failed with error %d\n" code
