open! Import0

module T : sig
  type 'a t = 'a or_null =
    | Null
    | This of 'a
end

include module type of T

include sig
    type nonrec 'a t = 'a t

    include sig
      [@@@ocaml.warning "-32"]

      val compare
        : 'a.
        ('a -> ('a[@merlin.hide]) -> int) -> 'a t -> ('a t[@merlin.hide]) -> int

      val equal
        : 'a.
        ('a -> ('a[@merlin.hide]) -> bool) -> 'a t -> ('a t[@merlin.hide]) -> bool

      val globalize : 'a. ('a -> 'a) -> 'a t -> 'a t

      val hash_fold_t
        : 'a.
        (Ppx_hash_lib.Std.Hash.state -> 'a -> Ppx_hash_lib.Std.Hash.state)
        -> Ppx_hash_lib.Std.Hash.state
        -> 'a t
        -> Ppx_hash_lib.Std.Hash.state

      val sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t
      val t_of_sexp : 'a. (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a t
    end
    [@@merlin.hide]
  end
  with type 'a t := 'a t

val value : 'a t -> default:'a -> 'a
val value_exn : ?here:Stdlib.Lexing.position -> 'a t -> 'a
val unsafe_value : 'a t -> 'a
val value_or_thunk : 'a t -> default:(unit -> 'a) -> 'a
val iter : 'a t -> f:('a -> unit) -> unit
val value_map : 'a t -> default:'b -> f:('a -> 'b) -> 'b
val map : 'a t -> f:('a -> 'b) -> 'b t
val both : 'a t -> 'b t -> ('a * 'b) t
val bind : 'a t -> f:('a -> 'b t) -> 'b t
val to_list : 'a t -> 'a list
val fold : 'a t -> init:'acc -> f:('acc -> 'a -> 'acc) -> 'acc
val mem : 'a t -> 'a -> equal:('a -> 'a -> bool) -> bool
val exists : 'a t -> f:('a -> bool) -> bool
val for_all : 'a t -> f:('a -> bool) -> bool
val find : 'a t -> f:('a -> bool) -> 'a t
val to_array : 'a t -> 'a array
val call : 'a -> f:('a -> unit) t -> unit
val merge : 'a t -> 'a t -> f:('a -> 'a -> 'a) -> 'a t
val length : 'a t -> int
val try_with : (unit -> 'a) -> 'a t
val try_with_join : (unit -> 'a t) -> 'a t
val this : 'a -> 'a t
val first_this : 'a t -> 'a t -> 'a t
val first_this_thunk : 'a t -> (unit -> 'a t) -> 'a t
val this_if : bool -> 'a -> 'a t
val this_if_thunk : bool -> (unit -> 'a) -> 'a t
val to_option : 'a t -> 'a option
val of_option : 'a option -> 'a t
val map_to_option : 'a t -> f:('a -> 'b) -> 'b option
val is_null : 'a t -> bool
val is_this : 'a t -> bool

module Let_syntax : sig
  val return : 'a -> 'a t
  val ( >>= ) : 'a t -> ('a -> 'b t) -> 'b t
  val ( >>| ) : 'a t -> ('a -> 'b) -> 'b t

  module Let_syntax : sig
    val return : 'a -> 'a t
    val bind : 'a t -> f:('a -> 'b t) -> 'b t
    val map : 'a t -> f:('a -> 'b) -> 'b t
    val both : 'a t -> 'b t -> ('a * 'b) t

    module Open_on_rhs : sig end
  end
end

module Local : sig
  module Let_syntax : sig
    val return : 'a -> 'a t

    module Let_syntax : sig
      val return : 'a -> 'a t
      val map : 'a t -> f:('a -> 'b) -> 'b t
      val bind : 'a t -> f:('a -> 'b t) -> 'b t
      val both : 'a t -> 'b t -> ('a * 'b) t

      module Open_on_rhs : sig end
    end
  end
end

include Invariant.S1 with type 'a t := 'a t

module Optional_syntax : sig
  module Optional_syntax : sig
    val is_none : _ t -> bool
    val unsafe_value : 'a t -> 'a
  end
end

module Export = Basement.Or_null_shim.Export
