open! Import0

type +!'a t

include sig
  [@@@ocaml.warning "-32"]

  val globalize : 'a. ('a -> 'a) -> 'a t -> 'a t
end
[@@merlin.hide]

include sig
    type nonrec +!'a t = 'a t

    include sig
      [@@@ocaml.warning "-32"]

      include Ppx_compare_lib.Comparable.S1 with type +!'a t := 'a t
      include Ppx_compare_lib.Equal.S1 with type +!'a t := 'a t

      val sexp_of_t : ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t
    end
    [@@merlin.hide]
  end
  with type +!'a t := 'a t

type 'a sequence := 'a t

include Indexed_container.S1 with type 'a t := 'a t
include Monad.S with type 'a t := 'a t

val empty : 'a. 'a t
val get_empty : 'a. unit -> 'a t
val next : 'a. 'a t -> ('a * 'a t) option

module Step : sig
  type (+'a, 's) t =
    | Done
    | Skip : 'a 's. { state : 's } -> ('a, 's) t
    | Yield :
        'a 's.
        { value : 'a
        ; state : 's
        }
        -> ('a, 's) t

  include sig
    [@@@ocaml.warning "-32"]

    val sexp_of_t
      : 'a 's.
      ('a -> Sexplib0.Sexp.t) -> ('s -> Sexplib0.Sexp.t) -> ('a, 's) t -> Sexplib0.Sexp.t
  end
  [@@merlin.hide]
end

val unfold_step : 'a 's. init:'s -> f:('s -> ('a, 's) Step.t) -> 'a t
val unfold : 'a 's. init:'s -> f:('s -> ('a * 's) option) -> 'a t
val unfold_with : 'a 'b 's. 'a t -> init:'s -> f:('s -> 'a -> ('b, 's) Step.t) -> 'b t

val unfold_with_and_finish
  : 'a 'b 's_b 's_a.
  'a t
  -> init:'s_a
  -> running_step:('s_a -> 'a -> ('b, 's_a) Step.t)
  -> inner_finished:('s_a -> 's_b)
  -> finishing_step:('s_b -> ('b, 's_b) Step.t)
  -> 'b t

val nth : 'a. 'a t -> int -> 'a option
val nth_exn : 'a. 'a t -> int -> 'a
val folding_map : 'a 'b 'acc. 'a t -> init:'acc -> f:('acc -> 'a -> 'acc * 'b) -> 'b t

val folding_mapi
  : 'a 'b 'acc.
  'a t -> init:'acc -> f:(int -> 'acc -> 'a -> 'acc * 'b) -> 'b t

val mapi : 'a 'b. 'a t -> f:(int -> 'a -> 'b) -> 'b t
val filteri : 'a. 'a t -> f:(int -> 'a -> bool) -> 'a t
val filter : 'a. 'a t -> f:('a -> bool) -> 'a t

val fold_result
  : 'a 'acc 'e.
  'a t -> init:'acc -> f:('acc -> 'a -> ('acc, 'e) Result.t) -> ('acc, 'e) Result.t

val merge_deduped_and_sorted : 'a. 'a t -> 'a t -> compare:('a -> 'a -> int) -> 'a t
val merge_sorted : 'a. 'a t -> 'a t -> compare:('a -> 'a -> int) -> 'a t

module Merge_with_duplicates_element : sig
  type ('a, 'b) t =
    | Left of 'a
    | Right of 'b
    | Both of 'a * 'b

  include sig
    [@@@ocaml.warning "-32"]

    val compare
      : 'a 'b.
      ('a -> ('a[@merlin.hide]) -> int)
      -> ('b -> ('b[@merlin.hide]) -> int)
      -> ('a, 'b) t
      -> (('a, 'b) t[@merlin.hide])
      -> int

    val equal
      : 'a 'b.
      ('a -> ('a[@merlin.hide]) -> bool)
      -> ('b -> ('b[@merlin.hide]) -> bool)
      -> ('a, 'b) t
      -> (('a, 'b) t[@merlin.hide])
      -> bool

    val hash_fold_t
      : 'a 'b.
      (Ppx_hash_lib.Std.Hash.state -> 'a -> Ppx_hash_lib.Std.Hash.state)
      -> (Ppx_hash_lib.Std.Hash.state -> 'b -> Ppx_hash_lib.Std.Hash.state)
      -> Ppx_hash_lib.Std.Hash.state
      -> ('a, 'b) t
      -> Ppx_hash_lib.Std.Hash.state

    val sexp_of_t
      : 'a 'b.
      ('a -> Sexplib0.Sexp.t) -> ('b -> Sexplib0.Sexp.t) -> ('a, 'b) t -> Sexplib0.Sexp.t

    val t_of_sexp
      : 'a 'b.
      (Sexplib0.Sexp.t -> 'a) -> (Sexplib0.Sexp.t -> 'b) -> Sexplib0.Sexp.t -> ('a, 'b) t

    val t_sexp_grammar
      : 'a 'b.
      'a Sexplib0.Sexp_grammar.t
      -> 'b Sexplib0.Sexp_grammar.t
      -> ('a, 'b) t Sexplib0.Sexp_grammar.t
  end
  [@@merlin.hide]
end

val merge_with_duplicates
  : 'a 'b.
  'a t -> 'b t -> compare:('a -> 'b -> int) -> ('a, 'b) Merge_with_duplicates_element.t t

val hd : 'a. 'a t -> 'a option
val hd_exn : 'a. 'a t -> 'a
val tl : 'a. 'a t -> 'a t option
val tl_eagerly_exn : 'a. 'a t -> 'a t
val find_exn : 'a. 'a t -> f:('a -> bool) -> 'a
val for_alli : 'a. 'a t -> f:(int -> 'a -> bool) -> bool
val append : 'a. 'a t -> 'a t -> 'a t
val concat : 'a. 'a t t -> 'a t
val concat_map : 'a 'b. 'a t -> f:('a -> 'b t) -> 'b t
val concat_mapi : 'a 'b. 'a t -> f:(int -> 'a -> 'b t) -> 'b t
val concat_list : 'a. 'a t list -> 'a t
val interleave : 'a. 'a t t -> 'a t
val round_robin : 'a. 'a t list -> 'a t
val zip : 'a 'b. 'a t -> 'b t -> ('a * 'b) t
val zip_full : 'a 'b. 'a t -> 'b t -> [ `Left of 'a | `Both of 'a * 'b | `Right of 'b ] t
val reduce_exn : 'a. 'a t -> f:('a -> 'a -> 'a) -> 'a
val reduce : 'a. 'a t -> f:('a -> 'a -> 'a) -> 'a option
val group : 'a. 'a t -> break:('a -> 'a -> bool) -> 'a list t
val find_consecutive_duplicate : 'a. 'a t -> equal:('a -> 'a -> bool) -> ('a * 'a) option
val remove_consecutive_duplicates : 'a. 'a t -> equal:('a -> 'a -> bool) -> 'a t

val range
  :  ?stride:int
  -> ?start:[ `inclusive | `exclusive ]
  -> ?stop:[ `inclusive | `exclusive ]
  -> int
  -> int
  -> int t

val init : 'a. int -> f:(int -> 'a) -> 'a t
val filter_map : 'a 'b. 'a t -> f:('a -> 'b option) -> 'b t
val filter_mapi : 'a 'b. 'a t -> f:(int -> 'a -> 'b option) -> 'b t
val filter_opt : 'a. 'a option t -> 'a t
val sub : 'a. 'a t -> pos:int -> len:int -> 'a t
val take : 'a. 'a t -> int -> 'a t
val drop : 'a. 'a t -> int -> 'a t
val drop_eagerly : 'a. 'a t -> int -> 'a t
val take_while : 'a. 'a t -> f:('a -> bool) -> 'a t
val drop_while : 'a. 'a t -> f:('a -> bool) -> 'a t
val drop_while_option : 'a. 'a t -> f:('a -> bool) -> ('a * 'a t) option
val split_n : 'a. 'a t -> int -> 'a list * 'a t
val chunks_exn : 'a. 'a t -> int -> 'a list t
val shift_right : 'a. 'a t -> 'a -> 'a t
val shift_right_with_list : 'a. 'a t -> 'a list -> 'a t
val shift_left : 'a. 'a t -> int -> 'a t

module Infix : sig
  val ( @ ) : 'a. 'a t -> 'a t -> 'a t
end

val cartesian_product : 'a 'b. 'a t -> 'b t -> ('a * 'b) t
val interleaved_cartesian_product : 'a 'b. 'a t -> 'b t -> ('a * 'b) t
val intersperse : 'a. 'a t -> sep:'a -> 'a t
val cycle_list_exn : 'a. 'a list -> 'a t
val repeat : 'a. 'a -> 'a t
val singleton : 'a. 'a -> 'a t

val delayed_fold
  : 'a 's 'r.
  'a t -> init:'s -> f:('s -> 'a -> k:('s -> 'r) -> 'r) -> finish:('s -> 'r) -> 'r

val fold_m
  : 'elt 'acc 'acc_m.
  bind:('acc_m -> f:('acc -> 'acc_m) -> 'acc_m)
  -> return:('acc -> 'acc_m)
  -> 'elt t
  -> init:'acc
  -> f:('acc -> 'elt -> 'acc_m)
  -> 'acc_m

val iter_m
  : 'elt 'unit_m.
  bind:('unit_m -> f:(unit -> 'unit_m) -> 'unit_m)
  -> return:(unit -> 'unit_m)
  -> 'elt t
  -> f:('elt -> 'unit_m)
  -> 'unit_m

val iter : 'a. 'a t -> f:('a -> unit) -> unit
val to_list_rev : 'a. 'a t -> 'a list
val of_list : 'a. 'a list -> 'a t
val of_lazy : 'a. 'a t lazy_t -> 'a t
val memoize : 'a. 'a t -> 'a t
val force_eagerly : 'a. 'a t -> 'a t
val bounded_length : 'a. 'a t -> at_most:int -> [ `Is of int | `Greater ]
val length_is_bounded_by : 'a. ?min:int -> ?max:int -> 'a t -> bool
val of_seq : 'a. 'a Stdlib.Seq.t -> 'a t
val to_seq : 'a. 'a t -> 'a Stdlib.Seq.t

module Generator : sig
  include Monad.S2

  val yield : 'elt -> (unit, 'elt) t
  val of_sequence : 'elt sequence -> (unit, 'elt) t
  val run : (unit, 'elt) t -> 'elt sequence
end

module Expert : sig
  val next_step : 'a. 'a t -> ('a, 'a t) Step.t

  val delayed_fold_step
    : 'a 'r 's.
    'a t
    -> init:'s
    -> f:('s -> 'a option -> k:('s -> 'r) -> 'r)
    -> finish:('s -> 'r)
    -> 'r

  module View : sig
    type +_ t =
      | Sequence :
          'a 's.
          { state : 's
          ; next : 's -> ('a, 's) Step.t
          }
          -> 'a t
  end

  val view : 'a. 'a t -> 'a View.t
end
