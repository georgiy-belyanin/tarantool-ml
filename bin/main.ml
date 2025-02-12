open Tarantool

let connect () =
  let stream = connect "localhost:3301" |> Result.get_ok in
  let test = func "inc10" (number @-> returning number) in
  let a = exec test stream 10 in
  Format.printf "%d\n" a
;;

let () = connect ()
