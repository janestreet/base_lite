open! Import0

type t = Int63_type.t

include sig
  [@@@ocaml.warning "-32"]

  val globalize : t -> t
end
[@@merlin.hide]

include Int.S with type t := t
include Replace_polymorphic_compare.S with type t := t

module Overflow_exn : sig
  val ( + ) : t -> t -> t
  val ( - ) : t -> t -> t
  val ( * ) : t -> t -> t
  val ( / ) : t -> t -> t
  val abs : t -> t
  val abs_local : t -> t
  val neg : t -> t
end

val of_int : int -> t
val to_int : t -> int option
val of_int32 : int32 -> t
val to_int32 : t -> int32 option
val of_int64 : int64 -> t option
val of_int64_exn : int64 -> t
val of_nativeint : nativeint -> t option
val to_nativeint : t -> nativeint option
val to_int_trunc : t -> int
val to_int32_trunc : t -> int32
val of_int64_trunc : int64 -> t
val of_nativeint_trunc : nativeint -> t
val to_nativeint_trunc : t -> nativeint
val bswap16 : t -> t
val bswap32 : t -> t
val bswap48 : t -> t
val random : ?state:Random.State.t -> t -> t
val random_incl : ?state:Random.State.t -> t -> t -> t

module Private : sig
  module Repr : sig
    type _ t =
      | Int : int t
      | Int64 : int64 t
  end

  val repr : t Repr.t

  module Emul = Int63_emul
end
