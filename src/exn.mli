open! Import0
module Sexp := Sexp0

type t = exn

include sig
  [@@@ocaml.warning "-32"]

  val sexp_of_t : t -> Sexplib0.Sexp.t
end
[@@merlin.hide]

include Pretty_printer.S with type t := t

exception Finally of t * t
exception Reraised of string * t

val create_s : Sexp.t -> t
val create_s_lazy : Sexp.t Portable_lazy.t -> t
val raise_without_backtrace : 'a. t -> 'a
val raise_with_original_backtrace : 'a. t -> Stdlib.Printexc.raw_backtrace -> 'a
val reraise : 'a. t -> string -> 'a
val reraisef : t -> ('a, unit, string, unit -> _) format4 -> 'a
val to_string : t -> string
val to_string_mach : t -> string
val protectx : 'a 'b. f:('a -> 'b) -> 'a -> finally:('a -> unit) -> 'b
val protect : 'a. f:(unit -> 'a) -> finally:(unit -> unit) -> 'a
val handle_uncaught : exit:bool -> (unit -> unit) -> unit
val handle_uncaught_and_ignore : (unit -> unit) -> unit
val handle_uncaught_and_exit : (unit -> 'a) -> 'a
val handle_uncaught_and_exit_immediately : (unit -> 'a) -> 'a
val reraise_uncaught : string -> (unit -> 'a) -> 'a
val does_raise : (unit -> _) -> bool
val is_phys_equal_most_recent : t -> bool
val initialize_module : unit -> unit

module Private : sig
  val clear_backtrace : unit -> unit
end
