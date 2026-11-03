open! Import0

type 'a t = 'a Stdlib.ref = { mutable contents : 'a }

include sig
  [@@@ocaml.warning "-32"]

  val compare
    : 'a.
    ('a -> ('a[@merlin.hide]) -> int) -> 'a t -> ('a t[@merlin.hide]) -> int

  val equal
    : 'a.
    ('a -> ('a[@merlin.hide]) -> bool) -> 'a t -> ('a t[@merlin.hide]) -> bool

  val globalize : 'a. ('a -> 'a) -> 'a t -> 'a t
  val sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t
  val t_of_sexp : 'a. (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a t
  val t_sexp_grammar : 'a. 'a Sexplib0.Sexp_grammar.t -> 'a t Sexplib0.Sexp_grammar.t
end
[@@merlin.hide]

external create : 'a. 'a -> 'a t = "%makemutable"
external ( ! ) : 'a. 'a t -> 'a = "%field0"
external ( := ) : 'a. 'a t -> 'a -> unit = "%setfield0"
val swap : 'a. 'a t -> 'a t -> unit
val replace : 'a. 'a t -> ('a -> 'a) -> unit
val set_temporarily : 'a 'b. 'a t -> 'a -> f:(unit -> 'b) -> 'b

module And_value : sig
  type t = T : 'a ref * 'a -> t

  include sig
    [@@@ocaml.warning "-32"]

    val sexp_of_t : t -> Sexplib0.Sexp.t
  end
  [@@merlin.hide]

  val set : t -> unit
  val sets : t list -> unit
  val snapshot : t -> t
end

val sets_temporarily : And_value.t list -> f:(unit -> 'a) -> 'a
