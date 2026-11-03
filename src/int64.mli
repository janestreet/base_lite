open! Import0

type t = int64

include sig
  [@@@ocaml.warning "-32"]

  val globalize : t -> t

  include Sexplib0.Sexpable.S with type t := t
end
[@@merlin.hide]

val sexp_of_t_u : Int64_u.t -> Sexp0.t
val t_u_of_sexp : Sexp0.t -> Int64_u.t

include Int.S with type t := t
include Replace_polymorphic_compare.S with type t := t

module O : sig
  external ( + ) : t -> t -> t = "%int64_add"
  external ( - ) : t -> t -> t = "%int64_sub"
  external ( * ) : t -> t -> t = "%int64_mul"
  external ( / ) : t -> t -> t = "%int64_div"
  external ( ~- ) : t -> t = "%int64_neg"
  val ( ** ) : t -> t -> t
  external ( = ) : t -> t -> bool = "%equal"
  external ( <> ) : t -> t -> bool = "%notequal"
  external ( < ) : t -> t -> bool = "%lessthan"
  external ( > ) : t -> t -> bool = "%greaterthan"
  external ( <= ) : t -> t -> bool = "%lessequal"
  external ( >= ) : t -> t -> bool = "%greaterequal"
  external ( land ) : t -> t -> t = "%int64_and"
  external ( lor ) : t -> t -> t = "%int64_or"
  external ( lxor ) : t -> t -> t = "%int64_xor"
  val lnot : t -> t
  val abs : t -> t
  val abs_local : t -> t
  external neg : t -> t = "%int64_neg"
  val zero : t
  val ( % ) : t -> t -> t
  val ( /% ) : t -> t -> t
  val ( // ) : t -> t -> float
  external ( lsl ) : t -> int -> t = "%int64_lsl"
  external ( asr ) : t -> int -> t = "%int64_asr"
  external ( lsr ) : t -> int -> t = "%int64_lsr"
end

include module type of O

external of_int : int -> t = "%int64_of_int"
external of_int32 : int32 -> t = "%int64_of_int32"
external of_int64 : t -> t = "%identity"
val to_int : t -> int option
val to_int32 : t -> int32 option
external of_nativeint : nativeint -> t = "%int64_of_nativeint"
val to_nativeint : t -> nativeint option
external to_int_trunc : t -> int = "%int64_to_int"
external to_int32_trunc : t -> int32 = "%int64_to_int32"
external to_nativeint_trunc : t -> nativeint = "%int64_to_nativeint"

external bits_of_float
  :  float
  -> t
  = "caml_int64_bits_of_float" "caml_int64_bits_of_float_unboxed"
[@@unboxed] [@@noalloc] [@@builtin]

external float_of_bits
  :  t
  -> float
  = "caml_int64_float_of_bits" "caml_int64_float_of_bits_unboxed"
[@@unboxed] [@@noalloc] [@@builtin]

val bswap16 : t -> t
val bswap32 : t -> t
val bswap48 : t -> t
external bswap64 : t -> t = "%bswap_int64"
