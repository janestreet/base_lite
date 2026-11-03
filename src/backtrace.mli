open! Import0

type t = Stdlib.Printexc.raw_backtrace

include sig
  [@@@ocaml.warning "-32"]

  val sexp_of_t : t -> Sexplib0.Sexp.t
end
[@@merlin.hide]

val get : ?at_most_num_frames:int -> unit -> t
val to_string : t -> string
val to_string_list : t -> string list
val elide : bool Dynamic.t

module Exn : sig
  val am_recording : unit -> bool
  val set_recording : bool -> unit
  val with_recording : bool -> f:(unit -> 'a) -> 'a
  val most_recent : unit -> t
  val most_recent_for_exn : exn -> t option
end

val initialize_module : unit -> unit
