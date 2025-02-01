open Tarantool

let () =
  let tnt =
    Tnt.net
      (Ctypes.coerce (Ctypes.ptr Ctypes.void) (Ctypes.ptr Tnt.stream)
         Ctypes.null )
  in
  let _a = Tnt.set_string tnt Tnt.Uri "localhost:3301" in
  let _b = Tnt.set_int tnt Tnt.SendBuf 0 in
  let _c = Tnt.set_int tnt Tnt.RecvBuf 0 in
  let _d = Tnt.connect tnt in
  let _e = Tnt.ping tnt in
  let reply = Tnt.reply_init Ctypes.null in
  let f = Tnt.read_reply tnt reply in
  if f == 0 then Format.printf "Ping success\n%!"
  else Format.printf "Ping failed\n%!"
