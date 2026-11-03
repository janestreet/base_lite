open! Import0

type t = int32

include sig
  [@@@ocaml.warning "-32"]

  val globalize : t -> t

  include Sexplib0.Sexpable.S with type t := t
end
[@@merlin.hide]

val sexp_of_t_u : Int32_u.t -> Sexp0.t
val t_u_of_sexp : Sexp0.t -> Int32_u.t

include Int.S with type t := t
include Replace_polymorphic_compare.S with type t := t

val of_int : int -> t option
val to_int : t -> int option
external of_int32 : int32 -> t = "%identity"
external to_int32 : t -> int32 = "%identity"
val of_nativeint : nativeint -> t option
external to_nativeint : t -> nativeint = "%nativeint_of_int32"
val of_int64 : int64 -> t option
val of_local_int64_exn : int64 -> t
external of_int_trunc : int -> t = "%int32_of_int"
val to_int_trunc : t -> int
external of_nativeint_trunc : nativeint -> t = "%nativeint_to_int32"
external of_int64_trunc : int64 -> t = "%int64_to_int32"

external bits_of_float
  :  float
  -> t
  = "caml_int32_bits_of_float" "caml_int32_bits_of_float_unboxed"
[@@unboxed] [@@noalloc]

external float_of_bits
  :  t
  -> float
  = "caml_int32_float_of_bits" "caml_int32_float_of_bits_unboxed"
[@@unboxed] [@@noalloc]

val bswap16 : t -> t
external bswap32 : t -> t = "%bswap_int32"
