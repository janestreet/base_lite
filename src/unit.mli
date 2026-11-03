open! Import0

type t = unit

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
include Invariant.S with type t := t
