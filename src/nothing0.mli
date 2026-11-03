type t = Basement.nothing = |

include sig
  [@@@ocaml.warning "-32"]

  include Ppx_compare_lib.Comparable.S with type t := t
  include Ppx_enumerate_lib.Enumerable.S with type t := t
  include Ppx_compare_lib.Equal.S with type t := t

  val globalize : t -> t

  include Ppx_hash_lib.Hashable.S with type t := t
  include Sexplib0.Sexpable.S with type t := t

  val t_sexp_grammar : t Sexplib0.Sexp_grammar.t
end
[@@merlin.hide]

val unreachable_code : t -> _
val to_string : t -> string
val of_string : string -> t
