open! Import0
module Invariant := Invariant_intf.Definitions
module Either := Either0
module Option := Option0
module Constructors : module type of List0.Constructors

type 'a t = 'a list

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

include Indexed_container.S1_with_creators with type 'a t := 'a t
include Invariant.S1 with type 'a t := 'a t

module Cartesian_product : sig
  include Applicative.S with type 'a t := 'a t
  include Monad.S with type 'a t := 'a t
end

include Monad.S with type 'a t := 'a t

module Or_unequal_lengths : sig
  type 'a t =
    | Ok of 'a
    | Unequal_lengths

  include sig
    [@@@ocaml.warning "-32"]

    val compare
      : 'a.
      ('a -> ('a[@merlin.hide]) -> int) -> 'a t -> ('a t[@merlin.hide]) -> int

    val sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t
  end
  [@@merlin.hide]
end

val create : 'a. len:int -> 'a -> 'a list
val singleton : 'a. 'a -> 'a t

type 'a t := 'a t
type 'a t := 'a t

val iter : 'a. 'a t -> f:('a -> unit) -> unit
val iteri : 'a. 'a t -> f:(int -> 'a -> unit) -> unit
val length : 'a. 'a t -> int
val nth_exn : 'a. 'a t -> int -> 'a
val nth : 'a. 'a t -> int -> 'a Option.t
val mem : 'a t -> 'a -> equal:('a -> 'a -> bool) -> bool
val init : 'a. int -> f:(int -> 'a) -> 'a t
val init_i64 : 'a. Int64_u.t -> f:(Int64_u.t -> 'a) -> 'a t
val append : 'a. 'a t -> 'a t -> 'a t
val filteri : 'a. 'a t -> f:(int -> 'a -> bool) -> 'a t
val filter : 'a. 'a t -> f:('a -> bool) -> 'a t
val rev_append : 'a. 'a t -> 'a t -> 'a t
val rev : 'a. 'a t -> 'a t
val find_or_null : 'a t -> f:('a -> bool) -> 'a or_null
val nth_or_null : 'a t -> int -> 'a or_null
val map : 'a 'b. 'a t -> f:('a -> 'b) -> 'b t
val mapi : 'a 'b. 'a t -> f:(int -> 'a -> 'b) -> 'b t
val rev_map : 'a 'b. 'a t -> f:('a -> 'b) -> 'b t
val rev_mapi : 'a 'b. 'a t -> f:(int -> 'a -> 'b) -> 'b t
val filter_map : 'a 'b. 'a t -> f:('a -> 'b Option.t) -> 'b t
val filter_mapi : 'a 'b. 'a t -> f:(int -> 'a -> 'b Option.t) -> 'b t
val concat_map : 'a 'b. 'a t -> f:('a -> 'b t) -> 'b t
val concat_mapi : 'a 'b. 'a t -> f:(int -> 'a -> 'b t) -> 'b t
val filter_map_or_null : 'a 'b. 'a t -> f:('a -> 'b or_null) -> 'b t
val filter_mapi_or_null : 'a 'b. 'a t -> f:(int -> 'a -> 'b or_null) -> 'b t
val fold : 'a 'b. 'a t -> init:'b -> f:('b -> 'a -> 'b) -> 'b
val foldi : 'a 'b. 'a t -> init:'b -> f:(int -> 'b -> 'a -> 'b) -> 'b
val unordered_append : 'a. 'a t -> 'a t -> 'a t
val iter2_exn : 'a 'b. 'a t -> 'b t -> f:('a -> 'b -> unit) -> unit
val iter2 : 'a 'b. 'a t -> 'b t -> f:('a -> 'b -> unit) -> unit Or_unequal_lengths.t
val rev_map2_exn : 'a 'b 'c. 'a t -> 'b t -> f:('a -> 'b -> 'c) -> 'c t
val rev_map2 : 'a 'b 'c. 'a t -> 'b t -> f:('a -> 'b -> 'c) -> 'c t Or_unequal_lengths.t

val fold2_exn
  : 'a 'b 'acc.
  'a t -> 'b t -> init:'acc -> f:('acc -> 'a -> 'b -> 'acc) -> 'acc

val fold2
  : 'a 'b 'acc.
  'a t -> 'b t -> init:'acc -> f:('acc -> 'a -> 'b -> 'acc) -> 'acc Or_unequal_lengths.t

val fold_right2_exn
  : 'a 'b 'acc.
  'a t -> 'b t -> f:('a -> 'b -> 'acc -> 'acc) -> init:'acc -> 'acc

val fold_right2
  : 'a 'b 'acc.
  'a t -> 'b t -> f:('a -> 'b -> 'acc -> 'acc) -> init:'acc -> 'acc Or_unequal_lengths.t

val for_all2_exn : 'a 'b. 'a t -> 'b t -> f:('a -> 'b -> bool) -> bool
val for_all2 : 'a 'b. 'a t -> 'b t -> f:('a -> 'b -> bool) -> bool Or_unequal_lengths.t
val exists2_exn : 'a 'b. 'a t -> 'b t -> f:('a -> 'b -> bool) -> bool
val exists2 : 'a 'b. 'a t -> 'b t -> f:('a -> 'b -> bool) -> bool Or_unequal_lengths.t
val rev_filter : 'a. 'a t -> f:('a -> bool) -> 'a t
val partition_map : 'a 'b 'c. 'a t -> f:('a -> ('b, 'c) Either.t) -> 'b t * 'c t

val partition3_map
  : 'a 'b 'c 'd.
  'a t -> f:('a -> [ `Fst of 'b | `Snd of 'c | `Trd of 'd ]) -> 'b t * 'c t * 'd t

val partition_result : 'ok 'error. ('ok, 'error) Result.t t -> 'ok t * 'error t
val split_n : 'a. 'a t -> int -> 'a t * 'a t
val sort : 'a. 'a t -> compare:('a -> 'a -> int) -> 'a t
val stable_sort : 'a. 'a t -> compare:('a -> 'a -> int) -> 'a t
val merge : 'a. 'a t -> 'a t -> compare:('a -> 'a -> int) -> 'a t
val merge_all : 'a. 'a t t -> compare:('a -> 'a -> int) -> 'a t
val hd : 'a. 'a t -> 'a option
val hd_or_null : 'a t -> 'a or_null
val tl : 'a. 'a t -> 'a t option
val tl_or_null : 'a t -> 'a t or_null
val hd_exn : 'a. 'a t -> 'a
val tl_exn : 'a. 'a t -> 'a t
val findi_exn : 'a. 'a t -> f:(int -> 'a -> bool) -> int * 'a
val find_exn : 'a. 'a t -> f:('a -> bool) -> 'a
val find_map_or_null : 'a t -> f:('a -> 'b or_null) -> 'b or_null
val find_map_or_null_exn : 'a t -> f:('a -> 'b or_null) -> 'b
val find_map_exn : 'a 'b. 'a t -> f:('a -> 'b option) -> 'b
val find_mapi_exn : 'a 'b. 'a t -> f:(int -> 'a -> 'b option) -> 'b
val find_mapi_or_null : 'a t -> f:(int -> 'a -> 'b or_null) -> 'b or_null
val find_mapi_or_null_exn : 'a t -> f:(int -> 'a -> 'b or_null) -> 'b
val folding_map : 'a 'b 'acc. 'a t -> init:'acc -> f:('acc -> 'a -> 'acc * 'b) -> 'b t

val folding_mapi
  : 'a 'b 'acc.
  'a t -> init:'acc -> f:(int -> 'acc -> 'a -> 'acc * 'b) -> 'b t

val fold_map : 'a 'b 'acc. 'a t -> init:'acc -> f:('acc -> 'a -> 'acc * 'b) -> 'acc * 'b t

val fold_mapi
  : 'a 'b 'acc.
  'a t -> init:'acc -> f:(int -> 'acc -> 'a -> 'acc * 'b) -> 'acc * 'b t

val map2_exn : 'a 'b 'c. 'a t -> 'b t -> f:('a -> 'b -> 'c) -> 'c t
val map2 : 'a 'b 'c. 'a t -> 'b t -> f:('a -> 'b -> 'c) -> 'c t Or_unequal_lengths.t
val rev_map3_exn : 'a 'b 'c 'd. 'a t -> 'b t -> 'c t -> f:('a -> 'b -> 'c -> 'd) -> 'd t

val rev_map3
  : 'a 'b 'c 'd.
  'a t -> 'b t -> 'c t -> f:('a -> 'b -> 'c -> 'd) -> 'd t Or_unequal_lengths.t

val map3_exn : 'a 'b 'c 'd. 'a t -> 'b t -> 'c t -> f:('a -> 'b -> 'c -> 'd) -> 'd t

val map3
  : 'a 'b 'c 'd.
  'a t -> 'b t -> 'c t -> f:('a -> 'b -> 'c -> 'd) -> 'd t Or_unequal_lengths.t

val rev_map_append : 'a 'b. 'a t -> 'b t -> f:('a -> 'b) -> 'b t
val fold_right : 'a 'acc. 'a t -> f:('a -> 'acc -> 'acc) -> init:'acc -> 'acc
val fold_left : 'a 'acc. 'a t -> init:'acc -> f:('acc -> 'a -> 'acc) -> 'acc
val unzip : 'a 'b. ('a * 'b) t -> 'a t * 'b t
val unzip3 : 'a 'b 'c. ('a * 'b * 'c) t -> 'a t * 'b t * 'c t
val zip : 'a 'b. 'a t -> 'b t -> ('a * 'b) t Or_unequal_lengths.t
val zip_exn : 'a 'b. 'a t -> 'b t -> ('a * 'b) t
val zip3 : 'a t -> 'b t -> 'c t -> ('a * 'b * 'c) t Or_unequal_lengths.t
val zip3_exn : 'a t -> 'b t -> 'c t -> ('a * 'b * 'c) t
val reduce : 'a. 'a t -> f:('a -> 'a -> 'a) -> 'a option
val reduce_exn : 'a. 'a t -> f:('a -> 'a -> 'a) -> 'a
val reduce_balanced : 'a. 'a t -> f:('a -> 'a -> 'a) -> 'a option
val reduce_balanced_exn : 'a. 'a t -> f:('a -> 'a -> 'a) -> 'a
val group : 'a. 'a t -> break:('a -> 'a -> bool) -> 'a t t
val groupi : 'a. 'a t -> break:(int -> 'a -> 'a -> bool) -> 'a t t
val sort_and_group : 'a. 'a t -> compare:('a -> 'a -> int) -> 'a t t
val chunks_of : 'a. 'a t -> length:int -> 'a t t
val chunk_evenly : 'a t -> into:int -> 'a t t
val last : 'a. 'a t -> 'a option
val last_exn : 'a. 'a t -> 'a
val is_prefix : 'a. 'a t -> prefix:'a t -> equal:('a -> 'a -> bool) -> bool
val is_suffix : 'a. 'a t -> suffix:'a t -> equal:('a -> 'a -> bool) -> bool
val find_consecutive_duplicate : 'a. 'a t -> equal:('a -> 'a -> bool) -> ('a * 'a) option

val remove_consecutive_duplicates
  : 'a.
  ?which_to_keep:[ `First | `Last ] -> 'a t -> equal:('a -> 'a -> bool) -> 'a t

val dedup_and_sort : 'a. 'a t -> compare:('a -> 'a -> int) -> 'a t
val stable_dedup : 'a. 'a t -> compare:('a -> 'a -> int) -> 'a t
val find_a_dup : 'a. 'a t -> compare:('a -> 'a -> int) -> 'a option
val contains_dup : 'a. 'a t -> compare:('a -> 'a -> int) -> bool
val find_all_dups : 'a. 'a t -> compare:('a -> 'a -> int) -> 'a list
val all_equal : 'a. 'a t -> equal:('a -> 'a -> bool) -> 'a option

val range
  :  ?stride:int
  -> ?start:[ `inclusive | `exclusive ]
  -> ?stop:[ `inclusive | `exclusive ]
  -> int
  -> int
  -> int t

val range'
  : 'a.
  compare:('a -> 'a -> int)
  -> stride:('a -> 'a)
  -> ?start:[ `inclusive | `exclusive ]
  -> ?stop:[ `inclusive | `exclusive ]
  -> 'a
  -> 'a
  -> 'a t

val filter_opt : 'a. 'a option t -> 'a t
val filter_or_null : 'a or_null t -> 'a t
val rev_filter_map : 'a 'b. 'a t -> f:('a -> 'b option) -> 'b t
val rev_filter_mapi : 'a 'b. 'a t -> f:(int -> 'a -> 'b option) -> 'b t
val rev_filter_map_or_null : 'a t -> f:('a -> 'b or_null) -> 'b t
val rev_filter_mapi_or_null : 'a t -> f:(int -> 'a -> 'b or_null) -> 'b t
val of_iter : 'a. iter:(f:('a -> unit) -> unit) -> 'a t

module Assoc : sig
  type ('a, 'b) t = ('a * 'b) list

  include sig
    [@@@ocaml.warning "-32"]

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

  val add : 'a 'b. ('a, 'b) t -> equal:('a -> 'a -> bool) -> 'a -> 'b -> ('a, 'b) t
  val find : 'a 'b. ('a, 'b) t -> equal:('a -> 'a -> bool) -> 'a -> 'b option
  val find_or_null : 'a 'b. ('a, 'b) t -> equal:('a -> 'a -> bool) -> 'a -> 'b or_null
  val find_exn : 'a 'b. ('a, 'b) t -> equal:('a -> 'a -> bool) -> 'a -> 'b
  val mem : 'a 'b. ('a, 'b) t -> equal:('a -> 'a -> bool) -> 'a -> bool
  val remove : 'a 'b. ('a, 'b) t -> equal:('a -> 'a -> bool) -> 'a -> ('a, 'b) t
  val map : 'a 'b 'c. ('a, 'b) t -> f:('b -> 'c) -> ('a, 'c) t
  val inverse : 'a 'b. ('a, 'b) t -> ('b, 'a) t
  val group : 'a 'b. ('a * 'b) list -> equal:('a -> 'a -> bool) -> ('a, 'b list) t

  val sort_and_group
    : 'a 'b.
    ('a * 'b) list -> compare:('a -> 'a -> int) -> ('a, 'b list) t
end

val sub : 'a. 'a t -> pos:int -> len:int -> 'a t
val take : 'a. 'a t -> int -> 'a t
val drop : 'a. 'a t -> int -> 'a t
val take_while : 'a. 'a t -> f:('a -> bool) -> 'a t
val drop_while : 'a. 'a t -> f:('a -> bool) -> 'a t
val split_while : 'a. 'a t -> f:('a -> bool) -> 'a t * 'a t
val drop_last : 'a. 'a t -> 'a t option
val drop_last_exn : 'a. 'a t -> 'a t
val concat_no_order : 'a. 'a t t -> 'a t
val cons : 'a. 'a -> 'a t -> 'a t
val cartesian_product : 'a 'b. 'a t -> 'b t -> ('a * 'b) t
val permute : 'a. ?random_state:Random.State.t -> 'a t -> 'a t
val random_element : 'a. ?random_state:Random.State.t -> 'a t -> 'a option
val random_element_exn : 'a. ?random_state:Random.State.t -> 'a t -> 'a
val is_sorted : 'a. 'a t -> compare:('a -> 'a -> int) -> bool
val is_sorted_strictly : 'a. 'a t -> compare:('a -> 'a -> int) -> bool

module Infix : sig
  val ( @ ) : 'a. 'a t -> 'a t -> 'a t
end

val transpose : 'a. 'a t t -> 'a t t option
val transpose_exn : 'a. 'a t t -> 'a t t
val intersperse : 'a. 'a t -> sep:'a -> 'a t

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

module Private : sig
  val max_non_tailcall : int
end
