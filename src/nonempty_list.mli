open! Import0

type 'a t = 'a Nonempty_list_type.Nonempty_list.t = ( :: ) of 'a * 'a list

include sig
  [@@@ocaml.warning "-32"]

  val compare
    : 'a.
    ('a -> ('a[@merlin.hide]) -> int) -> 'a t -> ('a t[@merlin.hide]) -> int

  val equal
    : 'a.
    ('a -> ('a[@merlin.hide]) -> bool) -> 'a t -> ('a t[@merlin.hide]) -> bool

  val hash_fold_t
    : 'a.
    (Ppx_hash_lib.Std.Hash.state -> 'a -> Ppx_hash_lib.Std.Hash.state)
    -> Ppx_hash_lib.Std.Hash.state
    -> 'a t
    -> Ppx_hash_lib.Std.Hash.state

  val globalize : 'a. ('a -> 'a) -> 'a t -> 'a t
end
[@@merlin.hide]

include sig
    type nonrec 'a t = 'a t = ( :: ) of 'a * 'a list

    include sig
      [@@@ocaml.warning "-32"]

      include Sexplib0.Sexpable.S1 with type 'a t := 'a t

      val t_sexp_grammar : 'a. 'a Sexplib0.Sexp_grammar.t -> 'a t Sexplib0.Sexp_grammar.t
    end
    [@@merlin.hide]
  end
  with type 'a t := 'a t

type 'a nonempty_list := 'a t

include Comparator.Derived with type 'a t := 'a t
include Container.S1 with type 'a t := 'a t
include Invariant.S1 with type 'a t := 'a t
include Monad.S with type 'a t := 'a t
include Indexed_container.S1 with type 'a t := 'a t

type 'a t := 'a t
type 'a t := 'a t

val length : 'a. 'a t -> int
val of_list : 'a. 'a List.t -> 'a t option
val of_list_or_null : 'a. 'a List.t -> 'a t or_null
val of_list_error : 'a. 'a List.t -> 'a t Or_error.t
val of_list_exn : 'a. 'a List.t -> 'a t
val to_list : 'a. 'a t -> 'a List.t
val hd : 'a. 'a t -> 'a
val tl : 'a. 'a t -> 'a List.t
val iter : 'a. 'a t -> f:('a -> unit) -> unit
val iteri : 'a. 'a t -> f:(int -> 'a -> unit) -> unit
val min_elt' : 'a. 'a t -> compare:('a -> 'a -> int) -> 'a
val max_elt' : 'a. 'a t -> compare:('a -> 'a -> int) -> 'a
val nth : 'a. 'a t -> int -> 'a Option.t
val nth_exn : 'a. 'a t -> int -> 'a
val reduce : 'a. 'a t -> f:('a -> 'a -> 'a) -> 'a
val last : 'a. 'a t -> 'a

type 'a t := 'a t

val create : 'a. 'a -> 'a List.t -> 'a t
val init : 'a. int -> f:(int -> 'a) -> 'a t
val append : 'a. 'a t -> 'a List.t -> 'a t
val filter : 'a. 'a t -> f:('a -> bool) -> 'a List.t
val filteri : 'a. 'a t -> f:(int -> 'a -> bool) -> 'a List.t
val singleton : 'a. 'a -> 'a t
val cons : 'a. 'a -> 'a t -> 'a t
val reverse : 'a. 'a t -> 'a t
val fold_nonempty : 'a 'acc. 'a t -> init:('a -> 'acc) -> f:('acc -> 'a -> 'acc) -> 'acc
val map : 'a 'b. 'a t -> f:('a -> 'b) -> 'b t
val mapi : 'a 'b. 'a t -> f:(int -> 'a -> 'b) -> 'b t
val filter_map : 'a 'b. 'a t -> f:('a -> 'b Option.t) -> 'b List.t
val filter_map_or_null : 'a 'b. 'a t -> f:('a -> 'b or_null) -> 'b list
val filter_mapi : 'a 'b. 'a t -> f:(int -> 'a -> 'b Option.t) -> 'b List.t
val filter_mapi_or_null : 'a 'b. 'a t -> f:(int -> 'a -> 'b or_null) -> 'b list
val rev_map : 'a 'b. 'a t -> f:('a -> 'b) -> 'b t
val rev_mapi : 'a 'b. 'a t -> f:(int -> 'a -> 'b) -> 'b t
val concat_map : 'a 'b. 'a t -> f:('a -> 'b t) -> 'b t
val bind : 'a 'b. 'a t -> f:('a -> 'b t) -> 'b t
val ( @ ) : 'a. 'a t -> 'a t -> 'a t
val append' : 'a. 'a list -> 'a t -> 'a t
val unzip : 'a 'b. ('a * 'b) t -> 'a t * 'b t
val unzip3 : 'a 'b 'c. ('a * 'b * 'c) t -> 'a t * 'b t * 'c t
val zip : 'a 'b. 'a t -> 'b t -> ('a * 'b) t List.Or_unequal_lengths.t
val zip_exn : 'a 'b. 'a t -> 'b t -> ('a * 'b) t
val zip3 : 'a t -> 'b t -> 'c t -> ('a * 'b * 'c) t List.Or_unequal_lengths.t
val zip3_exn : 'a t -> 'b t -> 'c t -> ('a * 'b * 'c) t
val map2 : 'a 'b 'c. 'a t -> 'b t -> f:('a -> 'b -> 'c) -> 'c t List.Or_unequal_lengths.t
val map2_exn : 'a 'b 'c. 'a t -> 'b t -> f:('a -> 'b -> 'c) -> 'c t
val filter_opt : 'a. 'a option t -> 'a list
val concat : 'a. 'a t nonempty_list -> 'a t
val drop_last : 'a. 'a t -> 'a list
val of_iarray : 'a iarray -> 'a t option
val to_iarray : 'a t -> 'a iarray
val to_sequence : 'a. 'a t -> 'a Sequence.t
val sort : 'a. 'a t -> compare:('a -> 'a -> int) -> 'a t
val group : 'a. 'a t -> break:('a -> 'a -> bool) -> 'a t t
val sort_and_group : 'a. 'a t -> compare:('a -> 'a -> int) -> 'a t t
val stable_sort : 'a. 'a t -> compare:('a -> 'a -> int) -> 'a t
val stable_dedup : 'a. 'a t -> compare:('a -> 'a -> int) -> 'a t
val dedup_and_sort : 'a. 'a t -> compare:('a -> 'a -> int) -> 'a t
val permute : ?random_state:Random.State.t -> 'a t -> 'a t
val random_element : 'a. ?random_state:Random.State.t -> 'a t -> 'a
val cartesian_product : 'a 'b. 'a t -> 'b t -> ('a * 'b) t
val fold_right : 'a 'b. 'a t -> init:'b -> f:('a -> 'b -> 'b) -> 'b
val folding_map : 'a 'b 'c. 'a t -> init:'b -> f:('b -> 'a -> 'b * 'c) -> 'c t
val fold_map : 'a 'b 'acc. 'a t -> init:'acc -> f:('acc -> 'a -> 'acc * 'b) -> 'acc * 'b t
val findi_exn : 'a t -> f:(int -> 'a -> bool) -> int * 'a
val all_equal : 'a. 'a t -> equal:('a -> 'a -> bool) -> 'a option
val is_sorted : 'a t -> compare:('a -> 'a -> int) -> bool
val is_sorted_strictly : 'a t -> compare:('a -> 'a -> int) -> bool
val transpose : 'a. 'a t t -> 'a t t option
val transpose_exn : 'a. 'a t t -> 'a t t
val map_add_multi : ('k, 'v t, 'cmp) Map.t -> key:'k -> data:'v -> ('k, 'v t, 'cmp) Map.t
val hashtbl_add_multi : ('k, 'v t) Hashtbl.t -> key:'k -> data:'v -> unit

val map_of_alist_multi
  :  ('k * 'v) list
  -> comparator:('k, 'cmp) Comparator.Module.t
  -> ('k, 'v t, 'cmp) Map.t

val map_of_alist_multi_rev
  :  ('k * 'v) list
  -> comparator:('k, 'cmp) Comparator.Module.t
  -> ('k, 'v t, 'cmp) Map.t

val map_of_sequence_multi
  :  ('k * 'v) Sequence.t
  -> comparator:('k, 'cmp) Comparator.Module.t
  -> ('k, 'v t, 'cmp) Map.t

val map_of_sequence_multi_rev
  :  ('k * 'v) Sequence.t
  -> comparator:('k, 'cmp) Comparator.Module.t
  -> ('k, 'v t, 'cmp) Map.t

val map_of_list_with_key_multi
  :  'v list
  -> comparator:('k, 'cmp) Comparator.Module.t
  -> get_key:('v -> 'k)
  -> ('k, 'v t, 'cmp) Map.t

val map_of_list_with_key_multi_rev
  :  'v list
  -> comparator:('k, 'cmp) Comparator.Module.t
  -> get_key:('v -> 'k)
  -> ('k, 'v t, 'cmp) Map.t

val combine_errors : 'ok 'err. ('ok, 'err) Result.t t -> ('ok t, 'err t) Result.t
val combine_errors_unit : (unit, 'err) Result.t t -> (unit, 'err t) Result.t
val combine_or_errors : 'a. 'a Or_error.t t -> 'a t Or_error.t
val combine_or_errors_unit : unit Or_error.t t -> unit Or_error.t
val filter_ok_at_least_one : 'a Or_error.t t -> 'a t Or_error.t
val option_all : 'a option t -> 'a t option

val remove_consecutive_duplicates
  :  ?which_to_keep:[ `First | `Last ]
  -> 'a t
  -> equal:('a -> 'a -> bool)
  -> 'a t

module Partition : sig
  type ('fst, 'snd) t =
    | Fst of 'fst nonempty_list
    | Snd of 'snd nonempty_list
    | Both of ('fst nonempty_list * 'snd nonempty_list)

  include sig
    [@@@ocaml.warning "-32"]

    val sexp_of_t
      :  ('fst -> Sexplib0.Sexp.t)
      -> ('snd -> Sexplib0.Sexp.t)
      -> ('fst, 'snd) t
      -> Sexplib0.Sexp.t
  end
  [@@merlin.hide]

  val fst : ('fst, _) t -> 'fst nonempty_list option
  val snd : (_, 'snd) t -> 'snd nonempty_list option
end

val partition_tf : 'a t -> f:('a -> bool) -> ('a, 'a) Partition.t
val partition_tf' : 'a t -> f:('a -> bool) -> 'a list * 'a list
val partition_map : 'a t -> f:('a -> ('fst, 'snd) Either.t) -> ('fst, 'snd) Partition.t
val partition_map' : 'a t -> f:('a -> ('fst, 'snd) Either.t) -> 'fst list * 'snd list
val partition_result : ('ok, 'error) Result.t t -> ('ok, 'error) Partition.t
val partition_result' : ('ok, 'error) Result.t t -> 'ok list * 'error list

module Partition3 : sig
  type ('fst, 'snd, 'trd) t =
    | Fst of 'fst nonempty_list
    | Snd of 'snd nonempty_list
    | Trd of 'trd nonempty_list
    | Fst_snd of 'fst nonempty_list * 'snd nonempty_list
    | Fst_trd of 'fst nonempty_list * 'trd nonempty_list
    | Snd_trd of 'snd nonempty_list * 'trd nonempty_list
    | Fst_snd_trd of 'fst nonempty_list * 'snd nonempty_list * 'trd nonempty_list

  include sig
    [@@@ocaml.warning "-32"]

    val sexp_of_t
      :  ('fst -> Sexplib0.Sexp.t)
      -> ('snd -> Sexplib0.Sexp.t)
      -> ('trd -> Sexplib0.Sexp.t)
      -> ('fst, 'snd, 'trd) t
      -> Sexplib0.Sexp.t
  end
  [@@merlin.hide]
end

val partition3_map
  :  'a t
  -> f:('a -> [ `Fst of 'fst | `Snd of 'snd | `Trd of 'trd ])
  -> ('fst, 'snd, 'trd) Partition3.t
