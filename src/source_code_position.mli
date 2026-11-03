open! Import0

type t = Stdlib.Lexing.position =
  { pos_fname : string
  ; pos_lnum : int
  ; pos_bol : int
  ; pos_cnum : int
  }

include sig
  [@@@ocaml.warning "-32"]

  include Ppx_hash_lib.Hashable.S with type t := t

  val sexp_of_t : t -> Sexplib0.Sexp.t
end
[@@merlin.hide]

include Comparable.S with type t := t

val to_string : t -> string
val of_pos : string * int * int * int -> t
val here_or_there : ?here:Stdlib.Lexing.position -> t option -> t
val is_dummy : t -> bool
