type t =
  | Uri
  | TmoutConnect
  | TmoutRecv
  | TmoutSend
  | SendCb
  | SendCbv
  | SendCbArg
  | SendBuf
  | RecvCb
  | RecvCbArg
  | RecvBuf
[@@deriving enum]
