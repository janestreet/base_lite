module Uchar := Uchar0

external get : bytes -> int -> char = "%bytes_safe_get"
external length : bytes -> int = "%bytes_length"
external unsafe_get : bytes -> int -> char = "%bytes_unsafe_get"
external set : bytes -> int -> char -> unit = "%bytes_safe_set"
external unsafe_set : bytes -> int -> char -> unit = "%bytes_unsafe_set"

external unsafe_blit_string
  :  src:string
  -> src_pos:int
  -> dst:bytes
  -> dst_pos:int
  -> len:int
  -> unit
  = "caml_blit_string"
[@@noalloc]

external unsafe_get_int64 : bytes -> int -> int64 = "%caml_bytes_get64u"
external unsafe_set_int64 : bytes -> int -> int64 -> unit = "%caml_bytes_set64u"
external unsafe_get_int32 : bytes -> int -> int32 = "%caml_bytes_get32u"
external unsafe_set_int32 : bytes -> int -> int32 -> unit = "%caml_bytes_set32u"
external unsafe_get_int16 : bytes -> int -> int = "%caml_bytes_get16u"
external unsafe_set_int16 : bytes -> int -> int -> unit = "%caml_bytes_set16u"
val max_length : int
val blit : src:bytes -> src_pos:int -> dst:bytes -> dst_pos:int -> len:int -> unit
val blit_string : src:string -> src_pos:int -> dst:bytes -> dst_pos:int -> len:int -> unit
val compare : bytes -> bytes -> int
val set_uchar_utf_8 : bytes -> int -> Uchar.t -> int
val set_uchar_utf_16le : bytes -> int -> Uchar.t -> int
val set_uchar_utf_16be : bytes -> int -> Uchar.t -> int
val set_uchar_utf_32le : bytes -> int -> Uchar.t -> int
val set_uchar_utf_32be : bytes -> int -> Uchar.t -> int

external unsafe_fill : bytes -> pos:int -> len:int -> char -> unit = "caml_fill_bytes"
[@@noalloc]

val fill : bytes -> pos:int -> len:int -> char -> unit
val empty : bytes
val get_empty : unit -> bytes
external unsafe_create_local : int -> bytes = "Base_unsafe_create_local_bytes" [@@noalloc]
val create_local : int -> bytes
val create : int -> bytes
val make : int -> char -> bytes
val map : bytes -> f:(char -> char) -> bytes
val mapi : bytes -> f:(int -> char -> char) -> bytes
val copy : bytes -> bytes
val sub : bytes -> pos:int -> len:int -> bytes
val to_string : bytes -> string
val of_string : string -> bytes

external unsafe_blit
  :  src:bytes
  -> src_pos:int
  -> dst:bytes
  -> dst_pos:int
  -> len:int
  -> unit
  = "caml_blit_bytes"
[@@noalloc]

external unsafe_to_string
  :  no_mutation_while_string_reachable:bytes
  -> string
  = "%bytes_to_string"

external unique_to_string : bytes -> string = "%bytes_to_string"
external unsafe_of_string_promise_no_mutation : string -> bytes = "%bytes_of_string"
