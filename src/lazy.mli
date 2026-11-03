open! Import0

type 'a t = 'a lazy_t

include sig
  [@@@ocaml.warning "-32"]

  include Ppx_compare_lib.Comparable.S1 with type 'a t := 'a t
  include Ppx_compare_lib.Equal.S1 with type 'a t := 'a t

  val globalize : 'a. ('a -> 'a) -> 'a t -> 'a t

  include Ppx_hash_lib.Hashable.S1 with type 'a t := 'a t
  include Sexplib0.Sexpable.S1 with type 'a t := 'a t

  val t_sexp_grammar : 'a. 'a Sexplib0.Sexp_grammar.t -> 'a t Sexplib0.Sexp_grammar.t
end
[@@merlin.hide]

include Monad.S with type 'a t := 'a t

exception Undefined

external force : 'a t -> 'a = "%lazy_force"
val force_val : 'a t -> 'a
val from_fun : (unit -> 'a) -> 'a t
val from_val : 'a -> 'a t
val is_val : 'a t -> bool
val peek : 'a t -> 'a option

module T_unforcing : sig
  type nonrec 'a t = 'a t

  include sig
    [@@@ocaml.warning "-32"]

    val sexp_of_t : ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t
  end
  [@@merlin.hide]
end
