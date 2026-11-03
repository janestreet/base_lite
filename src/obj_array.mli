open! Import0

type t

include sig
  [@@@ocaml.warning "-32"]

  val sexp_of_t : t -> Sexplib0.Sexp.t
end
[@@merlin.hide]

include Blit.S with type t := t
include Invariant.S with type t := t

val create : len:int -> Stdlib.Obj.t -> t
val create_zero : len:int -> t
val copy : t -> t
val singleton : Stdlib.Obj.t -> t
val empty : t
val get_empty : unit -> t
val length : t -> int
val get : t -> int -> Stdlib.Obj.t
val unsafe_get : t -> int -> Stdlib.Obj.t
val set : t -> int -> Stdlib.Obj.t -> unit
val unsafe_set : t -> int -> Stdlib.Obj.t -> unit
val swap : t -> int -> int -> unit
val set_with_caml_modify : t -> int -> Stdlib.Obj.t -> unit
val unsafe_set_assuming_currently_int : t -> int -> Stdlib.Obj.t -> unit
val unsafe_set_int_assuming_currently_int : t -> int -> int -> unit
val unsafe_set_int : t -> int -> int -> unit
val unsafe_set_omit_phys_equal_check : t -> int -> Stdlib.Obj.t -> unit
val unsafe_set_with_caml_modify : t -> int -> Stdlib.Obj.t -> unit
val unsafe_clear_if_pointer : t -> int -> unit
val sub : t -> pos:int -> len:int -> t
