open! Import0

val init : int -> unit
val full_init : int array -> unit
val self_init : ?allow_in_tests:bool -> unit -> unit
val bits : unit -> int
val bits64 : unit -> int64
val int : int -> int
val int32 : int32 -> int32
val nativeint : nativeint -> nativeint
val int64 : int64 -> int64
val float : float -> float
val int_incl : int -> int -> int
val int32_incl : int32 -> int32 -> int32
val nativeint_incl : nativeint -> nativeint -> nativeint
val int64_incl : int64 -> int64 -> int64
val float_range : float -> float -> float
val bool : unit -> bool
val char : unit -> char
val ascii : unit -> char

module State : sig
  type t

  val default : t
  val get_default : unit -> t
  val make : int array -> t
  val make_self_init : ?allow_in_tests:bool -> unit -> t
  val copy : t -> t
  val bits : t -> int
  val bits64 : t -> int64
  val int : t -> int -> int
  val int32 : t -> int32 -> int32
  val nativeint : t -> nativeint -> nativeint
  val int64 : t -> int64 -> int64
  val float : t -> float -> float
  val int_incl : t -> int -> int -> int
  val int32_incl : t -> int32 -> int32 -> int32
  val nativeint_incl : t -> nativeint -> nativeint -> nativeint
  val int64_incl : t -> int64 -> int64 -> int64
  val float_range : t -> float -> float -> float
  val bool : t -> bool
  val char : t -> char
  val ascii : t -> char
end

val set_state : State.t -> unit
