open! Import0

type t = char

include sig
  [@@@ocaml.warning "-32"]

  include Ppx_enumerate_lib.Enumerable.S with type t := t

  val globalize : t -> t
  val sexp_of_t : t -> Sexplib0.Sexp.t [@@ocaml.warning "-32"]
  val sexp_of_t_u : t -> Sexplib0.Sexp.t
  val t_of_sexp : Sexplib0.Sexp.t -> t [@@ocaml.warning "-32"]
  val t_u_of_sexp : Sexplib0.Sexp.t -> t
  val t_sexp_grammar : t Sexplib0.Sexp_grammar.t
end
[@@merlin.hide]

include Identifiable.S with type t := t
include Stringable.S with type t := t
include Invariant.S with type t := t
module O : Comparisons.Infix with type t := t

val to_int : t -> int
val of_int : int -> t option
val of_int_exn : int -> t
val unsafe_of_int : int -> t
val escaped : t -> string
val lowercase : t -> t
val uppercase : t -> t
val is_digit : t -> bool
val is_lowercase : t -> bool
val is_uppercase : t -> bool
val is_alpha : t -> bool
val is_alphanum : t -> bool
val is_print : t -> bool
val is_whitespace : t -> bool
val get_digit : t -> int option
val get_digit_exn : t -> int
val is_hex_digit : t -> bool
val is_hex_digit_lower : t -> bool
val is_hex_digit_upper : t -> bool
val get_hex_digit : t -> int option
val get_hex_digit_exn : t -> int
val min_value : t
val max_value : t

module Caseless : sig
  type nonrec t = t

  include sig
    [@@@ocaml.warning "-32"]

    include Ppx_hash_lib.Hashable.S with type t := t
    include Sexplib0.Sexpable.S with type t := t

    val t_sexp_grammar : t Sexplib0.Sexp_grammar.t
  end
  [@@merlin.hide]

  include Comparable.S with type t := t
  include Ppx_compare_lib.Equal.S with type t := t
  include Ppx_compare_lib.Comparable.S with type t := t
end
