open! Import0
module Option = Option0
module List = List0

module Definitions = struct
  module type Public = sig
    type 'a t

    include Binary_searchable.S1 with type 'a t := 'a t
    include Indexed_container.S1_with_creators with type 'a t := 'a t

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

          val sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t
          val t_of_sexp : 'a. (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a t
          val globalize : 'a. ('a -> 'a) -> 'a t -> 'a t
        end
        [@@merlin.hide]
      end
      with type 'a t := 'a t

    include sig
        type nonrec 'a t = 'a t

        include sig
          [@@@ocaml.warning "-32"]

          val t_sexp_grammar
            : 'a.
            'a Sexplib0.Sexp_grammar.t -> 'a t Sexplib0.Sexp_grammar.t
        end
        [@@merlin.hide]
      end
      with type 'a t := 'a t

    include Indexed_container.S1_with_creators with type 'a t := 'a t
    include Invariant.S1 with type 'a t := 'a t

    val map : 'a 'b. 'a t -> f:('a -> 'b) -> 'b t
    val max_length : int
    external length : 'a. 'a array -> int = "%array_length"
    external get : 'a. 'a array -> int -> 'a = "%array_safe_get"
    val get_opt : 'a. 'a array -> int -> 'a Option.t
    val get_or_null : 'a array -> int -> 'a Or_null.t
    external set : 'a. 'a array -> int -> 'a -> unit = "%array_safe_set"
    external unsafe_get : 'a. 'a array -> int -> 'a = "%array_unsafe_get"
    external unsafe_set : 'a. 'a array -> int -> 'a -> unit = "%array_unsafe_set"
    val create : len:int -> 'a -> 'a array
    val create_local : len:int -> 'a -> 'a array
    val magic_create_uninitialized : len:int -> 'a array
    val create_float_uninitialized : len:int -> float t
    val init : 'a. int -> f:(int -> 'a) -> 'a array
    val make_matrix : dimx:int -> dimy:int -> 'a -> 'a t t
    val copy_matrix : 'a t t -> 'a t t
    val concat : 'a. 'a t list -> 'a t
    val copy : 'a. 'a t -> 'a t
    val fill : 'a. 'a t -> pos:int -> len:int -> 'a -> unit

    include Blit.S1 with type 'a t := 'a t

    val unsafe_blit : 'a. ('a array, 'a array) Blit.blit
    val sub : 'a. ('a array, 'a array) Blit.sub

    include sig
      val foldi_right : 'a t -> init:'acc -> f:(int -> 'a -> 'acc -> 'acc) -> 'acc
      val folding_map : 'a t -> init:'acc -> f:('acc -> 'a -> 'acc * 'b) -> 'b t
      val folding_mapi : 'a t -> init:'acc -> f:(int -> 'acc -> 'a -> 'acc * 'b) -> 'b t
      val fold_map : 'a t -> init:'acc -> f:('acc -> 'a -> 'acc * 'b) -> 'acc * 'b t

      val fold_mapi
        :  'a t
        -> init:'acc
        -> f:(int -> 'acc -> 'a -> 'acc * 'b)
        -> 'acc * 'b t

      val fold_right : 'a t -> f:('a -> 'acc -> 'acc) -> init:'acc -> 'acc
    end

    val sort : 'a. ?pos:int -> ?len:int -> 'a t -> compare:('a -> 'a -> int) -> unit
    val stable_sort : 'a t -> compare:('a -> 'a -> int) -> unit
    val is_sorted : 'a. 'a t -> compare:('a -> 'a -> int) -> bool
    val is_sorted_strictly : 'a. 'a t -> compare:('a -> 'a -> int) -> bool
    val merge : 'a. 'a t -> 'a t -> compare:('a -> 'a -> int) -> 'a t

    include sig
      val partitioni_tf : 'a t -> f:(int -> 'a -> bool) -> 'a t * 'a t
      val cartesian_product : 'a t -> 'b t -> ('a * 'b) t
      val transpose : 'a t t -> 'a t t option
      val transpose_exn : 'a t t -> 'a t t
      val filter_opt : 'a option t -> 'a t
      val iter2_exn : 'a t -> 'b t -> f:('a -> 'b -> unit) -> unit
      val map2_exn : 'a t -> 'b t -> f:('a -> 'b -> 'c) -> 'c t
      val fold2_exn : 'a t -> 'b t -> init:'acc -> f:('acc -> 'a -> 'b -> 'acc) -> 'acc
      val map_inplace : 'a t -> f:('a -> 'a) -> unit
    end

    val find_exn : 'a. 'a t -> f:('a -> bool) -> 'a
    val swap : 'a. 'a t -> int -> int -> unit
    val rev_inplace : 'a. 'a t -> unit
    val rev : 'a. 'a t -> 'a t
    val of_list_rev : 'a. 'a List.Constructors.t -> 'a t
    val find_map_exn : 'a 'b. 'a t -> f:('a -> 'b Option.t) -> 'b
    val find_mapi_exn : 'a 'b. 'a t -> f:(int -> 'a -> 'b Option.t) -> 'b
    val of_list_map : 'a 'b. 'a List.Constructors.t -> f:('a -> 'b) -> 'b t
    val of_list_mapi : 'a 'b. 'a List.Constructors.t -> f:(int -> 'a -> 'b) -> 'b t
    val of_list_rev_map : 'a 'b. 'a List.Constructors.t -> f:('a -> 'b) -> 'b t
    val of_list_rev_mapi : 'a 'b. 'a List.Constructors.t -> f:(int -> 'a -> 'b) -> 'b t
    val for_all2_exn : 'a 'b. 'a t -> 'b t -> f:('a -> 'b -> bool) -> bool
    val exists2_exn : 'a 'b. 'a t -> 'b t -> f:('a -> 'b -> bool) -> bool
    val find_or_null : 'a. 'a t -> f:('a -> bool) -> 'a or_null
    val findi_or_null : 'a. 'a t -> f:(int -> 'a -> bool) -> (int * 'a) or_null

    include sig
      val findi_exn : 'a t -> f:(int -> 'a -> bool) -> int * 'a

      val find_consecutive_duplicate
        :  'a t
        -> equal:('a -> 'a -> bool)
        -> ('a * 'a) option

      val reduce : 'a t -> f:('a -> 'a -> 'a) -> 'a option
      val reduce_exn : 'a t -> f:('a -> 'a -> 'a) -> 'a
      val permute : ?random_state:Random.State.t -> ?pos:int -> ?len:int -> 'a t -> unit
      val random_element : ?random_state:Random.State.t -> 'a t -> 'a option
      val random_element_exn : ?random_state:Random.State.t -> 'a t -> 'a
      val split_n : 'a t -> int -> 'a t * 'a t
      val chunks_of : 'a t -> length:int -> 'a t t
      val zip : 'a t -> 'b t -> ('a * 'b) t option
      val zip_exn : 'a t -> 'b t -> ('a * 'b) t
      val unzip : ('a * 'b) t -> 'a t * 'b t
      val sorted_copy : 'a t -> compare:('a -> 'a -> int) -> 'a t

      val last : 'a t -> 'a
      [@@deprecated "[since 2024-07] This was renamed to [last_exn]"]

      val last_exn : 'a t -> 'a
      val to_sequence : 'a t -> 'a Sequence.t
      val to_sequence_mutable : 'a t -> 'a Sequence.t
    end
  end
end

module type Array = sig
  include module type of struct
    include Definitions
  end

  include Public with type 'a t = 'a array

  module Private : sig
    module Sort : sig
      module type Sort = sig
        val sort : 'a. 'a t -> compare:('a -> 'a -> int) -> left:int -> right:int -> unit
      end

      module Insertion_sort : Sort
      module Heap_sort : Sort

      module Intro_sort : sig
        include Sort

        val five_element_sort
          : 'a.
          'a t -> compare:('a -> 'a -> int) -> int -> int -> int -> int -> int -> unit
      end
    end

    module Sorter : functor
        (S : sig
           type 'a t

           val get : 'a. 'a t -> int -> 'a
           val set : 'a. 'a t -> int -> 'a -> unit
           val length : 'a. 'a t -> int
         end)
        -> sig
      val sort : 'a. ?pos:int -> ?len:int -> 'a S.t -> compare:('a -> 'a -> int) -> unit
    end
  end
end
