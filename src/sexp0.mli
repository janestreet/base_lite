type t = Sexplib0.Sexp.t =
  | Atom of string
  | List of t list

include sig
  [@@@ocaml.warning "-32"]

  val globalize : t -> t

  include Ppx_hash_lib.Hashable.S with type t := t
end
[@@merlin.hide]

include
  module type of Sexplib0.Sexp
  with type t := Sexplib0.Sexp.t
   and module Private := Sexplib0.Sexp.Private

include Ppx_compare_lib.Equal.S with type t := t
include Ppx_compare_lib.Equal.S with type t := t
include Ppx_compare_lib.Comparable.S with type t := t
include Ppx_compare_lib.Comparable.S with type t := t

val t_sexp_grammar : t Sexplib0.Sexp_grammar.t
val invariant : t -> unit

val of_string : unit
[@@deprecated "[since 2018-02] Use [Parsexp.Single.parse_string_exn]"]
