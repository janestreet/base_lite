type t =
  | Neg
  | Zero
  | Pos

include sig
  [@@@ocaml.warning "-32"]

  include Sexplib0.Sexpable.S with type t := t

  val t_sexp_grammar : t Sexplib0.Sexp_grammar.t

  include Ppx_compare_lib.Comparable.S with type t := t
  include Ppx_hash_lib.Hashable.S with type t := t
  include Ppx_enumerate_lib.Enumerable.S with type t := t
end
[@@merlin.hide]

module Replace_polymorphic_compare : sig
  include Comparisons.S with type t := t

  val ascending : t -> t -> int
  val descending : t -> t -> int
end

val to_string : t -> string
val of_string : string -> t
val to_int : t -> int
val of_int : int -> t
val module_name : string
