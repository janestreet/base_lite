open! Import0

type t = nativeint

include sig
  [@@@ocaml.warning "-32"]

  val globalize : t -> t

  include Sexplib0.Sexpable.S with type t := t
end
[@@merlin.hide]

val sexp_of_t_u : Nativeint_u.t -> Sexp0.t
val t_u_of_sexp : Sexp0.t -> Nativeint_u.t

include Int.S with type t := t
include Replace_polymorphic_compare.S with type t := t

external of_int : int -> t = "%nativeint_of_int"
val to_int : t -> int option
external of_int32 : int32 -> t = "%nativeint_of_int32"
val to_int32 : t -> int32 option
external of_nativeint : nativeint -> t = "%identity"
external to_nativeint : t -> nativeint = "%identity"
val of_int64 : int64 -> t option
val to_int_trunc : t -> int
external to_int32_trunc : t -> int32 = "%nativeint_to_int32"
external of_int64_trunc : int64 -> t = "%int64_to_nativeint"
external bswap : t -> t = "%bswap_native"
