open! Import0

type 'a t

include sig
    type nonrec 'a t = 'a t

    include sig
      [@@@ocaml.warning "-32"]

      include Sexplib0.Sexpable.S1 with type 'a t := 'a t

      val t_sexp_grammar : 'a. 'a Sexplib0.Sexp_grammar.t -> 'a t Sexplib0.Sexp_grammar.t
    end
    [@@merlin.hide]
  end
  with type 'a t := 'a t

val empty : _ t
val get_empty : unit -> _ t
val create : 'a. len:int -> 'a t

include
  Indexed_container.Generic with type ('a, _, _) t := 'a t and type 'a elt := 'a option

val length : _ t -> int
val init_some : int -> f:(int -> 'a) -> 'a t
val init : int -> f:(int -> 'a option) -> 'a t
val of_array : 'a option array -> 'a t
val of_array_some : 'a array -> 'a t
val to_array : 'a t -> 'a option array
val get : 'a t -> int -> 'a option
val get_or_null : 'a t -> int -> 'a or_null
val get_local : 'a t -> int -> 'a option
val get_some_exn : 'a. 'a t -> int -> 'a
val is_none : _ t -> int -> bool
val is_some : _ t -> int -> bool
val unsafe_get : 'a t -> int -> 'a option
val unsafe_get_some_exn : 'a t -> int -> 'a
val unsafe_get_some_assuming_some : 'a t -> int -> 'a
val unsafe_is_some : _ t -> int -> bool
val set : 'a t -> int -> 'a option -> unit
val set_some : 'a. 'a t -> int -> 'a -> unit
val set_none : _ t -> int -> unit
val swap : _ t -> int -> int -> unit
val clear : _ t -> unit
val map : 'a t -> f:('a option -> 'b option) -> 'b t
val map_some : 'a t -> f:('a -> 'b) -> 'b t
val unsafe_set : 'a t -> int -> 'a option -> unit
val unsafe_set_some : 'a t -> int -> 'a -> unit
val unsafe_set_none : _ t -> int -> unit

include Blit.S1 with type 'a t := 'a t

val copy : 'a t -> 'a t

module For_testing : sig
  module Unsafe_cheap_option : sig
    type 'a t

    include sig
      [@@@ocaml.warning "-32"]

      include Sexplib0.Sexpable.S1 with type 'a t := 'a t
    end
    [@@merlin.hide]

    val none : _ t
    val some : 'a -> 'a t
    val is_none : _ t -> bool
    val is_some : _ t -> bool
    val value_exn : 'a t -> 'a
    val value_unsafe : 'a t -> 'a
    val to_option : 'a t -> 'a option
    val of_option : 'a option -> 'a t
  end
end
