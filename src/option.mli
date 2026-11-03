open! Import0
module Error := Error0
module Constructors : module type of Option0

type 'a t = 'a option =
  | None
  | Some of 'a

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
      val t_sexp_grammar : 'a. 'a Sexplib0.Sexp_grammar.t -> 'a t Sexplib0.Sexp_grammar.t
    end
    [@@merlin.hide]
  end
  with type 'a t := 'a t

include Invariant.S1 with type 'a t := 'a t
include Applicative.S with type 'a t := 'a t
include Monad.S with type 'a t := 'a t

include sig
  val return : 'a. 'a -> 'a t
  val value : 'a. 'a t -> default:'a -> 'a
  val value_exn : 'a. here:[%call_pos] -> ?error:Error.t -> ?message:string -> 'a t -> 'a
  val value_or_thunk : 'a. 'a t -> default:(unit -> 'a) -> 'a
  val iter : 'a. 'a t -> f:('a -> unit) -> unit
  val value_map : 'a 'b. 'a t -> default:'b -> f:('a -> 'b) -> 'b
  val map : 'a 'b. 'a t -> f:('a -> 'b) -> 'b t
  val bind : 'a 'b. 'a t -> f:('a -> 'b t) -> 'b t
end

val fold : 'a 'acc. 'a t -> init:'acc -> f:('acc -> 'a -> 'acc) -> 'acc
val mem : 'a. 'a t -> 'a -> equal:('a -> 'a -> bool) -> bool
val length : 'a. 'a t -> int
val exists : 'a. 'a t -> f:('a -> bool) -> bool
val for_all : 'a. 'a t -> f:('a -> bool) -> bool
val find : 'a. 'a t -> f:('a -> bool) -> 'a option
val find_map : 'a 'b. 'a t -> f:('a -> 'b option) -> 'b option
val to_list : 'a. 'a t -> 'a list
val to_array : 'a. 'a t -> 'a array
val to_iarray : 'a. 'a t -> 'a iarray
val call : 'a. 'a -> f:('a -> unit) t -> unit
val merge : 'a. 'a t -> 'a t -> f:('a -> 'a -> 'a) -> 'a t
val transpose_result : 'ok 'err. ('ok, 'err) Result.t t -> ('ok t, 'err) Result.t
val filter : 'a. 'a t -> f:('a -> bool) -> 'a t
val try_with : 'a. (unit -> 'a) -> 'a t
val try_with_join : 'a. (unit -> 'a t) -> 'a t

include sig
  val some : 'a. 'a -> 'a t
  val first_some : 'a. 'a t -> 'a t -> 'a t
  val first_some_thunk : 'a. 'a t -> (unit -> 'a t) -> 'a t
  val some_if : 'a. bool -> 'a -> 'a t
  val some_if_thunk : 'a. bool -> (unit -> 'a) -> 'a t
end

include sig
  val is_none : 'a. 'a t -> bool
  val is_some : 'a. 'a t -> bool
end

module Local : sig
  module Let_syntax : sig
    val return : 'a. 'a -> 'a t
    val ( >>| ) : 'a 'b. 'a t -> ('a -> 'b) -> 'b t
    val ( >>= ) : 'a 'b. 'a t -> ('a -> 'b t) -> 'b t

    module Let_syntax : sig
      val return : 'a. 'a -> 'a t
      val map : 'a 'b. 'a t -> f:('a -> 'b) -> 'b t
      val bind : 'a 'b. 'a t -> f:('a -> 'b t) -> 'b t
      val both : 'a 'b. 'a t -> 'b t -> ('a * 'b) t

      module Open_on_rhs : sig end
    end
  end
end
