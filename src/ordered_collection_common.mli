open! Import0
include module type of Ordered_collection_common0

val get_pos_len
  :  ?pos:int
  -> ?len:int
  -> unit
  -> total_length:int
  -> (int * int) Or_error.t
