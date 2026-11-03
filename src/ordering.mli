open! Import0

type t =
  | Less
  | Equal
  | Greater

include sig
  [@@@ocaml.warning "-32"]

  include Ppx_compare_lib.Comparable.S with type t := t
  include Ppx_compare_lib.Equal.S with type t := t
  include Ppx_hash_lib.Hashable.S with type t := t
  include Sexplib0.Sexpable.S with type t := t

  val t_sexp_grammar : t Sexplib0.Sexp_grammar.t
end
[@@merlin.hide]

val all : t list
val of_int : int -> t
val to_int : t -> int

module Export : sig
  type _ordering = t =
    | Less
    | Equal
    | Greater
end
