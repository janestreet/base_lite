open! Import0

val get_pos_len_exn : ?pos:int -> ?len:int -> unit -> total_length:int -> int * int
val check_pos_len_exn : pos:int -> len:int -> total_length:int -> unit

module Private : sig
  val slow_check_pos_len_exn : pos:int -> len:int -> total_length:int -> unit
end
