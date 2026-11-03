open! Import0

type t = |

include sig
  [@@@ocaml.warning "-32"]

  include Ppx_enumerate_lib.Enumerable.S with type t := t

  val globalize : t -> t

  include Sexplib0.Sexpable.S with type t := t

  val t_sexp_grammar : t Sexplib0.Sexp_grammar.t
end
[@@merlin.hide]

val unreachable_code : t -> _

include Identifiable.S with type t := t
include Stringable.S with type t := t

val must_be_none : t option -> unit
val must_be_empty : t list -> unit
val must_be_ok : ('ok, t) Result.t -> 'ok
val must_be_error : (t, 'err) Result.t -> 'err
val must_be_first : ('fst, t) Either.t -> 'fst
val must_be_second : (t, 'snd) Either.t -> 'snd
