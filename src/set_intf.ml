open! Import0
module Either = Either0
module Result = Result0
module Sexp = Sexp0

module Definitions = struct
  module type Elt_plain = sig
    type t

    include sig
      [@@@ocaml.warning "-32"]

      include Ppx_compare_lib.Comparable.S with type t := t

      val sexp_of_t : t -> Sexplib0.Sexp.t
    end
    [@@merlin.hide]
  end

  module Without_comparator = Map.Without_comparator
  module With_comparator = Map.With_comparator
  module With_first_class_module = Map.With_first_class_module
  module Merge_to_sequence_element = Sequence.Merge_with_duplicates_element

  module Named = struct
    type 'a t =
      { set : 'a
      ; name : string
      }
  end

  module type Accessors_generic = sig
    type ('a, 'cmp) t

    include Container.Generic with type ('a, 'cmp, _) t := ('a, 'cmp) t

    val is_empty : _ t -> bool
    val length : _ t -> int

    type ('a, 'cmp) tree
    type ('a, 'cmp, 'z) access_options
    type 'cmp cmp

    val invariants : ('a, 'cmp, ('a, 'cmp) t -> bool) access_options
    val mem : ('a, 'cmp, ('a, 'cmp) t -> 'a elt -> bool) access_options

    val symmetric_diff
      : ( 'a
          , 'cmp
          , ('a, 'cmp) t -> ('a, 'cmp) t -> ('a elt, 'a elt) Either.t Sequence.t )
          access_options

    val compare_direct : ('a, 'cmp, ('a, 'cmp) t -> ('a, 'cmp) t -> int) access_options
    val equal : ('a, 'cmp, ('a, 'cmp) t -> ('a, 'cmp) t -> bool) access_options
    val is_subset : ('a, 'cmp, ('a, 'cmp) t -> of_:('a, 'cmp) t -> bool) access_options
    val are_disjoint : ('a, 'cmp, ('a, 'cmp) t -> ('a, 'cmp) t -> bool) access_options

    module Named : sig
      val is_subset
        : ( 'a
            , 'cmp
            , ('a, 'cmp) t Named.t -> of_:('a, 'cmp) t Named.t -> unit Or_error.t )
            access_options

      val equal
        : ( 'a
            , 'cmp
            , ('a, 'cmp) t Named.t -> ('a, 'cmp) t Named.t -> unit Or_error.t )
            access_options
    end

    val fold_until
      :  ('a, _) t
      -> init:'acc
      -> f:('acc -> 'a elt -> ('acc, 'final) Container.Continue_or_stop.t)
      -> finish:('acc -> 'final)
      -> 'final

    val fold_right : ('a, _) t -> init:'acc -> f:('a elt -> 'acc -> 'acc) -> 'acc

    val iter2
      : ( 'a
          , 'cmp
          , ('a, 'cmp) t
            -> ('a, 'cmp) t
            -> f:
                 ([ `Left of 'a elt | `Right of 'a elt | `Both of 'a elt * 'a elt ]
                  -> unit)
            -> unit )
          access_options

    val elements : ('a, _) t -> 'a elt list
    val min_elt : ('a, _) t -> 'a elt option
    val min_elt_exn : ('a, _) t -> 'a elt
    val max_elt : ('a, _) t -> 'a elt option
    val max_elt_exn : ('a, _) t -> 'a elt
    val choose : ('a, _) t -> 'a elt option
    val choose_exn : ('a, _) t -> 'a elt
    val find_exn : ('a, _) t -> f:('a elt -> bool) -> 'a elt
    val nth : ('a, _) t -> int -> 'a elt option
    val rank : ('a, 'cmp, ('a, 'cmp) t -> 'a elt -> int option) access_options
    val to_tree : ('a, 'cmp) t -> ('a, 'cmp) tree

    val closest_elt
      : ( 'a
          , 'cmp
          , ('a, 'cmp) t
            -> [ `Greater_or_equal_to | `Greater_than | `Less_or_equal_to | `Less_than ]
            -> 'a elt
            -> 'a elt option )
          access_options

    val to_sequence
      : ( 'a
          , 'cmp
          , ?order:[ `Increasing | `Decreasing ]
            -> ?greater_or_equal_to:'a elt
            -> ?less_or_equal_to:'a elt
            -> ('a, 'cmp) t
            -> 'a elt Sequence.t )
          access_options

    val binary_search
      : ( 'a
          , 'cmp
          , ('a, 'cmp) t
            -> compare:('a elt -> 'key -> int)
            -> Binary_searchable.Which_target_by_key.t
            -> 'key
            -> 'a elt option )
          access_options

    val binary_search_segmented
      : ( 'a
          , 'cmp
          , ('a, 'cmp) t
            -> segment_of:('a elt -> [ `Left | `Right ])
            -> Binary_searchable.Which_target_by_segment.t
            -> 'a elt option )
          access_options

    val merge_to_sequence
      : ( 'a
          , 'cmp
          , ?order:[ `Increasing | `Decreasing ]
            -> ?greater_or_equal_to:'a elt
            -> ?less_or_equal_to:'a elt
            -> ('a, 'cmp) t
            -> ('a, 'cmp) t
            -> ('a elt, 'a elt) Merge_to_sequence_element.t Sequence.t )
          access_options
  end

  module type Transformers_generic = sig
    type ('a, 'cmp) t
    type ('a, 'cmp) tree
    type ('a, 'cmp, 'z) access_options
    type 'elt elt
    type 'cmp cmp

    val add : ('a, 'cmp, ('a, 'cmp) t -> 'a elt -> ('a, 'cmp) t) access_options
    val remove : ('a, 'cmp, ('a, 'cmp) t -> 'a elt -> ('a, 'cmp) t) access_options
    val union : ('a, 'cmp, ('a, 'cmp) t -> ('a, 'cmp) t -> ('a, 'cmp) t) access_options
    val inter : ('a, 'cmp, ('a, 'cmp) t -> ('a, 'cmp) t -> ('a, 'cmp) t) access_options
    val diff : ('a, 'cmp, ('a, 'cmp) t -> ('a, 'cmp) t -> ('a, 'cmp) t) access_options
    val filter : ('a, 'cmp) t -> f:('a elt -> bool) -> ('a, 'cmp) t
    val partition_tf : ('a, 'cmp) t -> f:('a elt -> bool) -> ('a, 'cmp) t * ('a, 'cmp) t

    val split
      : ( 'a
          , 'cmp
          , ('a, 'cmp) t -> 'a elt -> ('a, 'cmp) t * 'a elt option * ('a, 'cmp) t )
          access_options

    val split_le_gt
      : ('a, 'cmp, ('a, 'cmp) t -> 'a elt -> ('a, 'cmp) t * ('a, 'cmp) t) access_options

    val split_lt_ge
      : ('a, 'cmp, ('a, 'cmp) t -> 'a elt -> ('a, 'cmp) t * ('a, 'cmp) t) access_options

    val group_by : ('a, 'cmp) t -> equiv:('a elt -> 'a elt -> bool) -> ('a, 'cmp) t list
    [@@deprecated
      "[since 2024-08] This function is slow (O(n^2)) and pretty much never the right \
       thing to use. Consider using [to_list] along with [List.sort_and_group] or \
       [List.group]."]

    val remove_index : ('a, 'cmp, ('a, 'cmp) t -> int -> ('a, 'cmp) t) access_options
  end

  module type Creators_generic = sig
    type ('a, 'cmp) t
    type ('a, 'cmp) set
    type ('a, 'cmp) tree
    type 'a elt
    type ('a, 'cmp, 'z) create_options
    type 'cmp cmp

    val empty : ('a, 'cmp, ('a, 'cmp) t) create_options
    val singleton : ('a, 'cmp, 'a elt -> ('a, 'cmp) t) create_options
    val union_list : ('a, 'cmp, ('a, 'cmp) t list -> ('a, 'cmp) t) create_options
    val of_list : ('a, 'cmp, 'a elt list -> ('a, 'cmp) t) create_options
    val of_sequence : ('a, 'cmp, 'a elt Sequence.t -> ('a, 'cmp) t) create_options
    val of_array : ('a, 'cmp, 'a elt array -> ('a, 'cmp) t) create_options

    val of_sorted_array
      : ('a, 'cmp, 'a elt array -> ('a, 'cmp) t Or_error.t) create_options

    val of_sorted_array_unchecked
      : ('a, 'cmp, 'a elt array -> ('a, 'cmp) t) create_options

    val of_increasing_iterator_unchecked
      : ('a, 'cmp, len:int -> f:(int -> 'a elt) -> ('a, 'cmp) t) create_options

    val map : ('b, 'cmp, ('a, _) set -> f:('a -> 'b elt) -> ('b, 'cmp) t) create_options

    val filter_map
      : ('b, 'cmp, ('a, _) set -> f:('a -> 'b elt option) -> ('b, 'cmp) t) create_options

    val of_tree : ('a, 'cmp, ('a, 'cmp) tree -> ('a, 'cmp) t) create_options
  end

  module type Creators_and_accessors_and_transformers_generic = sig
    type ('elt, 'cmp) set
    type ('elt, 'cmp) t
    type ('elt, 'cmp) tree
    type 'elt elt
    type 'cmp cmp
    type ('elt, 'cmp, 'fn) access_options

    include
      Accessors_generic
      with type ('a, 'b) t := ('a, 'b) t
      with type ('a, 'b) tree := ('a, 'b) tree
      with type 'a elt := 'a elt
      with type 'cmp cmp := 'cmp cmp
      with type ('a, 'b, 'c) access_options := ('a, 'b, 'c) access_options

    include
      Transformers_generic
      with type ('a, 'b) t := ('a, 'b) t
      with type ('a, 'b) tree := ('a, 'b) tree
      with type 'a elt := 'a elt
      with type 'cmp cmp := 'cmp cmp
      with type ('a, 'b, 'c) access_options := ('a, 'b, 'c) access_options

    include
      Creators_generic
      with type ('a, 'b) set := ('a, 'b) set
      with type ('a, 'b) t := ('a, 'b) t
      with type ('a, 'b) tree := ('a, 'b) tree
      with type 'a elt := 'a elt
      with type 'cmp cmp := 'cmp cmp
  end

  module type S_poly = sig
    type ('elt, 'cmp) set
    type 'elt t
    type 'elt tree
    type comparator_witness

    include
      Creators_and_accessors_and_transformers_generic
      with type ('elt, 'cmp) set := ('elt, 'cmp) set
      with type ('elt, 'cmp) t := 'elt t
      with type ('elt, 'cmp) tree := 'elt tree
      with type 'a elt := 'a
      with type 'c cmp := comparator_witness
      with type ('a, 'b, 'c) create_options := ('a, 'b, 'c) Without_comparator.t
      with type ('a, 'b, 'c) access_options := ('a, 'b, 'c) Without_comparator.t
  end

  module type For_deriving = sig
    type ('a, 'b) t

    module type Sexp_of_m = Sexpable.Sexp_of

    module type M_of_sexp = sig
      type t

      include sig
        [@@@ocaml.warning "-32"]

        val t_of_sexp : Sexplib0.Sexp.t -> t
      end
      [@@merlin.hide]

      include Comparator.S with type t := t
    end

    module type M_sexp_grammar = sig
      type t

      include sig
        [@@@ocaml.warning "-32"]

        val t_sexp_grammar : t Sexplib0.Sexp_grammar.t
      end
      [@@merlin.hide]
    end

    module type Compare_m = sig end
    module type Equal_m = sig end
    module type Globalize_m = sig end
    module type Hash_fold_m = Hasher.S

    val sexp_of_m__t : (module Sexp_of_m with type t = 'elt) -> ('elt, 'cmp) t -> Sexp.t

    val m__t_of_sexp
      :  (module M_of_sexp with type t = 'elt and type comparator_witness = 'cmp)
      -> Sexp.t
      -> ('elt, 'cmp) t

    val m__t_sexp_grammar
      :  (module M_sexp_grammar with type t = 'elt)
      -> ('elt, 'cmp) t Sexplib0.Sexp_grammar.t

    val compare_m__t : (module Compare_m) -> ('elt, 'cmp) t -> ('elt, 'cmp) t -> int
    val equal_m__t : (module Equal_m) -> ('elt, 'cmp) t -> ('elt, 'cmp) t -> bool
    val globalize_m__t : (module Globalize_m) -> ('elt, 'cmp) t -> ('elt, 'cmp) t

    val hash_fold_m__t
      :  (module Hash_fold_m with type t = 'elt)
      -> Hash.state
      -> ('elt, _) t
      -> Hash.state

    val hash_m__t : (module Hash_fold_m with type t = 'elt) -> ('elt, _) t -> int
  end

  module type Enum = sig
    type ('a, 'cmp) tree
    type increasing
    type decreasing

    type ('a, 'cmp, 'direction) nonempty
    and ('a, 'cmp, 'direction) t = ('a, 'cmp, 'direction) nonempty or_null

    include sig
      [@@@ocaml.warning "-32"]

      val sexp_of_nonempty
        :  ('a -> Sexplib0.Sexp.t)
        -> ('cmp -> Sexplib0.Sexp.t)
        -> ('direction -> Sexplib0.Sexp.t)
        -> ('a, 'cmp, 'direction) nonempty
        -> Sexplib0.Sexp.t

      val sexp_of_t
        :  ('a -> Sexplib0.Sexp.t)
        -> ('cmp -> Sexplib0.Sexp.t)
        -> ('direction -> Sexplib0.Sexp.t)
        -> ('a, 'cmp, 'direction) t
        -> Sexplib0.Sexp.t
    end
    [@@merlin.hide]

    val to_list_with_trees : ('a, 'cmp, 'dir) t -> ('a * ('a, 'cmp) tree) list
    val of_list_with_trees : ('a * ('a, 'cmp) tree) list -> ('a, 'cmp, 'dir) t
    val cons : ('a, 'cmp) tree -> ('a, 'cmp, increasing) t -> ('a, 'cmp, increasing) t

    val cons_right
      :  ('a, 'cmp) tree
      -> ('a, 'cmp, decreasing) t
      -> ('a, 'cmp, decreasing) t

    val of_set : ('a, 'cmp) tree -> ('a, 'cmp, increasing) t
    val of_set_right : ('a, 'cmp) tree -> ('a, 'cmp, decreasing) t

    val starting_at_increasing
      :  ('a, 'cmp) tree
      -> 'a
      -> ('a -> 'a -> int)
      -> ('a, 'cmp, increasing) t

    val starting_at_decreasing
      :  ('a, 'cmp) tree
      -> 'a
      -> ('a -> 'a -> int)
      -> ('a, 'cmp, decreasing) t

    val elt : ('a, 'cmp, 'dir) nonempty -> 'a
    val next : ('a, 'cmp, increasing) nonempty -> ('a, 'cmp, increasing) t
    val next_decreasing : ('a, 'cmp, decreasing) nonempty -> ('a, 'cmp, decreasing) t

    module Which : sig
      type t =
        | Left
        | Right
        | Both
    end

    val which
      :  ('a, 'cmp, increasing) nonempty
      -> ('a, 'cmp, increasing) nonempty
      -> compare_elt:('a -> 'a -> int)
      -> Which.t

    val which_elt
      :  ('a, 'cmp, increasing) nonempty
      -> ('a, 'cmp, increasing) nonempty
      -> which:Which.t
      -> 'a

    val which_merge_element
      :  ('a, 'cmp, increasing) nonempty
      -> ('a, 'cmp, increasing) nonempty
      -> which:Which.t
      -> ('a, 'a) Map.Merge_element.t

    val next2
      :  ('a, 'cmp, increasing) nonempty
      -> ('a, 'cmp, increasing) nonempty
      -> which:Which.t
      -> ('a, 'cmp, increasing) t * ('a, 'cmp, increasing) t

    val next2_drop_phys_equal
      :  ('a, 'cmp, increasing) nonempty
      -> ('a, 'cmp, increasing) nonempty
      -> which:Which.t
      -> ('a, 'cmp, increasing) t * ('a, 'cmp, increasing) t
  end
end

module type Set = sig
  include module type of struct
    include Definitions
  end

  type (!'elt, !'cmp) t [@@sexp.phantom: 'cmp]

  include sig
    [@@@ocaml.warning "-32"]

    include Ppx_compare_lib.Comparable.S2 with type (!'elt, !'cmp) t := ('elt, 'cmp) t

    val globalize
      : 'elt 'cmp.
      ('elt -> 'elt) -> ('cmp -> 'cmp) -> ('elt, 'cmp) t -> ('elt, 'cmp) t

    val sexp_of_t : ('elt -> Sexplib0.Sexp.t) -> ('elt, 'cmp) t -> Sexplib0.Sexp.t
  end
  [@@merlin.hide]

  val invariants : (_, _) t -> bool
  val comparator_s : ('a, 'cmp) t -> ('a, 'cmp) Comparator.Module.t
  val comparator : ('a, 'cmp) t -> ('a, 'cmp) Comparator.t
  val globalize0 : ('a, 'cmp) t -> ('a, 'cmp) t
  val empty : 'a 'cmp. ('a, 'cmp) Comparator.Module.t -> ('a, 'cmp) t
  val singleton : ('a, 'cmp) Comparator.Module.t -> 'a -> ('a, 'cmp) t
  val length : (_, _) t -> int
  val is_empty : (_, _) t -> bool
  val mem : ('a, _) t -> 'a -> bool
  val add : ('a, 'cmp) t -> 'a -> ('a, 'cmp) t
  val remove : ('a, 'cmp) t -> 'a -> ('a, 'cmp) t
  val union : ('a, 'cmp) t -> ('a, 'cmp) t -> ('a, 'cmp) t
  val union_list : ('a, 'cmp) Comparator.Module.t -> ('a, 'cmp) t list -> ('a, 'cmp) t
  val inter : ('a, 'cmp) t -> ('a, 'cmp) t -> ('a, 'cmp) t
  val diff : ('a, 'cmp) t -> ('a, 'cmp) t -> ('a, 'cmp) t
  val symmetric_diff : ('a, 'cmp) t -> ('a, 'cmp) t -> ('a, 'a) Either.t Sequence.t
  val compare_direct : ('a, 'cmp) t -> ('a, 'cmp) t -> int
  val hash_fold_direct : 'a Hash.folder -> ('a, 'cmp) t Hash.folder
  val equal : ('a, 'cmp) t -> ('a, 'cmp) t -> bool
  val exists : ('a, _) t -> f:('a -> bool) -> bool
  val for_all : ('a, _) t -> f:('a -> bool) -> bool
  val count : ('a, _) t -> f:('a -> bool) -> int

  val sum
    :  (module Container.Summable with type t = 'sum)
    -> ('a, _) t
    -> f:('a -> 'sum)
    -> 'sum

  val find : ('a, _) t -> f:('a -> bool) -> 'a option
  val find_map : ('a, _) t -> f:('a -> 'b option) -> 'b option
  val find_exn : ('a, _) t -> f:('a -> bool) -> 'a
  val nth : ('a, _) t -> int -> 'a option
  val rank : ('a, _) t -> 'a -> int option
  val remove_index : ('a, 'cmp) t -> int -> ('a, 'cmp) t
  val is_subset : ('a, 'cmp) t -> of_:('a, 'cmp) t -> bool
  val are_disjoint : ('a, 'cmp) t -> ('a, 'cmp) t -> bool

  module Named : sig
    type ('a, 'cmp) set := ('a, 'cmp) t

    type 'a t = 'a Named.t =
      { set : 'a
      ; name : string
      }

    val is_subset : ('a, 'cmp) set t -> of_:('a, 'cmp) set t -> unit Or_error.t
    val equal : ('a, 'cmp) set t -> ('a, 'cmp) set t -> unit Or_error.t
  end

  val of_list : ('a, 'cmp) Comparator.Module.t -> 'a list -> ('a, 'cmp) t
  val of_sequence : ('a, 'cmp) Comparator.Module.t -> 'a Sequence.t -> ('a, 'cmp) t
  val of_array : ('a, 'cmp) Comparator.Module.t -> 'a array -> ('a, 'cmp) t
  val to_list : ('a, _) t -> 'a list
  val to_array : ('a, _) t -> 'a array

  val of_sorted_array
    :  ('a, 'cmp) Comparator.Module.t
    -> 'a array
    -> ('a, 'cmp) t Or_error.t

  val of_sorted_array_unchecked
    :  ('a, 'cmp) Comparator.Module.t
    -> 'a array
    -> ('a, 'cmp) t

  val of_increasing_iterator_unchecked
    :  ('a, 'cmp) Comparator.Module.t
    -> len:int
    -> f:(int -> 'a)
    -> ('a, 'cmp) t

  val map : ('b, 'cmp) Comparator.Module.t -> ('a, _) t -> f:('a -> 'b) -> ('b, 'cmp) t

  val filter_map
    :  ('b, 'cmp) Comparator.Module.t
    -> ('a, _) t
    -> f:('a -> 'b option)
    -> ('b, 'cmp) t

  val filter : ('a, 'cmp) t -> f:('a -> bool) -> ('a, 'cmp) t
  val fold : ('a, _) t -> init:'acc -> f:('acc -> 'a -> 'acc) -> 'acc

  val fold_result
    :  ('a, _) t
    -> init:'acc
    -> f:('acc -> 'a -> ('acc, 'e) Result.t)
    -> ('acc, 'e) Result.t

  val fold_until
    :  ('a, _) t
    -> init:'acc
    -> f:('acc -> 'a -> ('acc, 'final) Container.Continue_or_stop.t)
    -> finish:('acc -> 'final)
    -> 'final

  val fold_right : ('a, _) t -> init:'acc -> f:('a -> 'acc -> 'acc) -> 'acc
  val iter : ('a, _) t -> f:('a -> unit) -> unit

  val iter_until
    :  ('a, _) t
    -> f:('a -> (unit, 'final) Container.Continue_or_stop.t)
    -> finish:(unit -> 'final)
    -> 'final

  val iter2
    :  ('a, 'cmp) t
    -> ('a, 'cmp) t
    -> f:([ `Left of 'a | `Right of 'a | `Both of 'a * 'a ] -> unit)
    -> unit

  val partition_tf : ('a, 'cmp) t -> f:('a -> bool) -> ('a, 'cmp) t * ('a, 'cmp) t
  val elements : ('a, _) t -> 'a list
  val min_elt : ('a, _) t -> 'a option
  val min_elt_exn : ('a, _) t -> 'a
  val max_elt : ('a, _) t -> 'a option
  val max_elt_exn : ('a, _) t -> 'a
  val choose : ('a, _) t -> 'a option
  val choose_exn : ('a, _) t -> 'a
  val split : ('a, 'cmp) t -> 'a -> ('a, 'cmp) t * 'a option * ('a, 'cmp) t
  val split_le_gt : ('a, 'cmp) t -> 'a -> ('a, 'cmp) t * ('a, 'cmp) t
  val split_lt_ge : ('a, 'cmp) t -> 'a -> ('a, 'cmp) t * ('a, 'cmp) t

  val group_by : ('a, 'cmp) t -> equiv:('a -> 'a -> bool) -> ('a, 'cmp) t list
  [@@deprecated
    "[since 2024-08] This function is slow (O(n^2)) and pretty much never the right \
     thing to use. Consider using [to_list] along with [List.sort_and_group] or \
     [List.group]."]

  val closest_elt
    :  ('a, _) t
    -> [ `Greater_or_equal_to | `Greater_than | `Less_or_equal_to | `Less_than ]
    -> 'a
    -> 'a option

  val to_sequence
    :  ?order:[ `Increasing | `Decreasing ]
    -> ?greater_or_equal_to:'a
    -> ?less_or_equal_to:'a
    -> ('a, 'cmp) t
    -> 'a Sequence.t

  val binary_search
    :  ('a, 'cmp) t
    -> compare:('a -> 'key -> int)
    -> [ `Last_strictly_less_than
       | `Last_less_than_or_equal_to
       | `Last_equal_to
       | `First_equal_to
       | `First_greater_than_or_equal_to
       | `First_strictly_greater_than
       ]
    -> 'key
    -> 'a option

  val binary_search_segmented
    :  ('a, 'cmp) t
    -> segment_of:('a -> [ `Left | `Right ])
    -> [ `Last_on_left | `First_on_right ]
    -> 'a option

  val merge_to_sequence
    :  ?order:[ `Increasing | `Decreasing ]
    -> ?greater_or_equal_to:'a
    -> ?less_or_equal_to:'a
    -> ('a, 'cmp) t
    -> ('a, 'cmp) t
    -> ('a, 'a) Merge_to_sequence_element.t Sequence.t

  module M : functor
      (Elt : sig
         type t
         type comparator_witness
       end)
      -> sig
    type nonrec t = (Elt.t, Elt.comparator_witness) t
  end

  include For_deriving with type ('a, 'b) t := ('a, 'b) t

  module Tree : sig
    type weight

    type ('a, 'cmp) t = private
      | Empty
      | Leaf of { elt : 'a }
      | Node of
          { left : ('a, 'cmp) t
          ; elt : 'a
          ; right : ('a, 'cmp) t
          ; weight : weight
          }
    [@@sexp.phantom: 'cmp]

    include sig
      [@@@ocaml.warning "-32"]

      val globalize
        : 'a 'cmp.
        ('a -> 'a) -> ('cmp -> 'cmp) -> ('a, 'cmp) t -> ('a, 'cmp) t

      val sexp_of_t : ('a -> Sexplib0.Sexp.t) -> ('a, 'cmp) t -> Sexplib0.Sexp.t
    end
    [@@merlin.hide]

    val t_of_sexp_direct
      :  comparator:('elt, 'cmp) Comparator.t
      -> (Sexp.t -> 'elt)
      -> Sexp.t
      -> ('elt, 'cmp) t

    val globalize0 : ('elt, 'cmp) t -> ('elt, 'cmp) t

    include
      Creators_and_accessors_and_transformers_generic
      with type ('a, 'b) set := ('a, 'b) t
      with type ('a, 'b) t := ('a, 'b) t
      with type ('a, 'b) tree := ('a, 'b) t
      with type 'a elt := 'a
      with type 'c cmp := 'c
      with type ('a, 'b, 'c) create_options := ('a, 'b, 'c) With_comparator.t
      with type ('a, 'b, 'c) access_options := ('a, 'b, 'c) With_comparator.t

    val empty_without_value_restriction : (_, _) t

    module Enum : Enum with type ('a, 'cmp) tree := ('a, 'cmp) t

    module Expert : sig
      type nonrec ('a, 'cmp) t = ('a, 'cmp) t

      include sig
        [@@@ocaml.warning "-32"]

        include Ppx_compare_lib.Equal.S2 with type ('a, 'cmp) t := ('a, 'cmp) t

        val sexp_of_t
          :  ('a -> Sexplib0.Sexp.t)
          -> ('cmp -> Sexplib0.Sexp.t)
          -> ('a, 'cmp) t
          -> Sexplib0.Sexp.t
      end
      [@@merlin.hide]

      val balance_invariants : (_, _) t -> bool
      val order_invariants : comparator:('a, 'cmp) Comparator.t -> ('a, 'cmp) t -> bool
      val are_balanced : ('a, 'cmp) t -> ('a, 'cmp) t -> bool
      val need_rebalance_at_most_once : ('a, 'cmp) t -> ('a, 'cmp) t -> bool

      val create_assuming_balanced_unchecked
        :  ('a, 'cmp) t
        -> 'a
        -> ('a, 'cmp) t
        -> ('a, 'cmp) t

      val create_and_rebalance_at_most_once_unchecked
        :  ('a, 'cmp) t
        -> 'a
        -> ('a, 'cmp) t
        -> ('a, 'cmp) t

      val create_and_rebalance_unchecked
        :  ('a, 'cmp) t
        -> 'a
        -> ('a, 'cmp) t
        -> ('a, 'cmp) t

      val concat_and_rebalance_at_most_once_unchecked
        :  ('a, 'cmp) t
        -> ('a, 'cmp) t
        -> ('a, 'cmp) t

      val concat_and_rebalance_unchecked : ('a, 'cmp) t -> ('a, 'cmp) t -> ('a, 'cmp) t
      val singleton : 'a -> ('a, 'cmp) t
      val empty : ('a, 'cmp) t
      val length_of_weight : weight -> int
    end
  end

  module Using_comparator : sig
    type nonrec ('elt, 'cmp) t = ('elt, 'cmp) t [@@sexp.phantom: 'cmp]

    include sig
      [@@@ocaml.warning "-32"]

      val sexp_of_t : ('elt -> Sexplib0.Sexp.t) -> ('elt, 'cmp) t -> Sexplib0.Sexp.t
    end
    [@@merlin.hide]

    val t_of_sexp_direct
      :  comparator:('elt, 'cmp) Comparator.t
      -> (Sexp.t -> 'elt)
      -> Sexp.t
      -> ('elt, 'cmp) t

    include
      Creators_and_accessors_and_transformers_generic
      with type ('a, 'b) t := ('a, 'b) t
      with type ('a, 'b) tree := ('a, 'b) Tree.t
      with type ('a, 'b) set := ('a, 'b) t
      with type 'a elt := 'a
      with type 'c cmp := 'c
      with type ('a, 'b, 'c) access_options := ('a, 'b, 'c) Without_comparator.t
      with type ('a, 'b, 'c) create_options := ('a, 'b, 'c) With_comparator.t

    val comparator_s : ('a, 'cmp) t -> ('a, 'cmp) Comparator.Module.t
    val comparator : ('a, 'cmp) t -> ('a, 'cmp) Comparator.t
    val hash_fold_direct : 'elt Hash.folder -> ('elt, 'cmp) t Hash.folder

    module Empty_without_value_restriction : functor (Elt : Comparator.S1) -> sig
      val empty : ('a Elt.t, Elt.comparator_witness) t
    end

    module Tree = Tree
  end

  val to_tree : ('a, 'cmp) t -> ('a, 'cmp) Using_comparator.Tree.t

  val of_tree
    :  ('a, 'cmp) Comparator.Module.t
    -> ('a, 'cmp) Using_comparator.Tree.t
    -> ('a, 'cmp) t

  module Poly :
    S_poly
    with type 'elt t = ('elt, Comparator.Poly.comparator_witness) t
    with type comparator_witness := Comparator.Poly.comparator_witness
    with type 'elt tree :=
      ('elt, Comparator.Poly.comparator_witness) Using_comparator.Tree.t
    with type ('elt, 'cmp) set := ('elt, 'cmp) t
end
