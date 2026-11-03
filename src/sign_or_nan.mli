open! Import0

type t =
  | Neg
  | Zero
  | Pos
  | Nan

include sig
  [@@@ocaml.warning "-32"]

  include Ppx_enumerate_lib.Enumerable.S with type t := t
  include Sexplib0.Sexpable.S with type t := t

  val t_sexp_grammar : t Sexplib0.Sexp_grammar.t
end
[@@merlin.hide]

include Identifiable.S with type t := t

val to_string_hum : t -> string
val of_int : int -> t
val to_int_exn : t -> int
val of_sign : Sign.t -> t
val to_sign_exn : t -> Sign.t
val flip : t -> t
val ( * ) : t -> t -> t
