open! Import0
module Either = Either0
module List = List0
module Result = Result0
open Modes.Export

module Definitions = struct
  module type Operators = sig
    type 'a t := 'a iarray

    external ( .:() ) : 'a. 'a t -> int -> 'a = "%array_safe_get"
  end

  module type Public = sig
    type +'a t

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

          val t_sexp_grammar
            : 'a.
            'a Sexplib0.Sexp_grammar.t -> 'a t Sexplib0.Sexp_grammar.t
        end
        [@@merlin.hide]
      end
      with type 'a t := 'a t

    include sig
        type nonrec 'a t = 'a t

        include sig
          [@@@ocaml.warning "-32"]

          include Ppx_hash_lib.Hashable.S1 with type 'a t := 'a t
        end
        [@@merlin.hide]
      end
      with type 'a t := 'a t

    val init : 'a. int -> f:(int -> 'a) -> 'a t

    include Binary_searchable.S1 with type 'a t := 'a t
    include Indexed_container.S1_with_creators with type 'a t := 'a t

    val init : 'a. int -> f:(int -> 'a) -> 'a t
    val map : 'a 'b. 'a t -> f:('a -> 'b) -> 'b t
    val mapi : 'a 'b. 'a t -> f:(int -> 'a -> 'b) -> 'b t
    val iteri : 'a. 'a t -> f:(int -> 'a -> unit) -> unit
    val iter : 'a. 'a t -> f:('a -> unit) -> unit
    val for_all : 'a. 'a t -> f:('a -> bool) -> bool
    val find_or_null : 'a. 'a t -> f:('a -> bool) -> 'a or_null
    val findi_or_null : 'a. 'a t -> f:(int -> 'a -> bool) -> (int * 'a) or_null
    val find_map_or_null : 'a 'b. 'a t -> f:('a -> 'b or_null) -> 'b or_null
    val find_mapi_or_null : 'a 'b. 'a t -> f:(int -> 'a -> 'b or_null) -> 'b or_null
    val of_array : 'a. 'a array -> 'a t
    val to_array : 'a. 'a t -> 'a array

    include Invariant.S1 with type 'a t := 'a t
    module O : Operators
    include Operators

    external length : 'a. 'a t -> int = "%array_length"
    external get : 'a. 'a t -> int -> 'a = "%array_safe_get"
    val get_opt : 'a t -> int -> 'a option
    external unsafe_get : 'a. 'a t -> int -> 'a = "%array_unsafe_get"

    include sig
      val last_exn : 'a t -> 'a
      val set : 'a t -> int -> 'a -> 'a t
      val update : 'a t -> int -> f:('a -> 'a) -> 'a t
      val empty : _ t
      val singleton : 'a -> 'a t
      val create : len:int -> 'a -> mutate:('a array -> unit) -> 'a iarray
      val of_sequence : 'a Sequence.t -> 'a t
      val to_sequence : 'a t -> 'a Sequence.t
      val of_list_rev : 'a. 'a list -> 'a t
      val of_list_map : 'a list -> f:('a -> 'b) -> 'b t
      val of_list_mapi : 'a list -> f:(int -> 'a -> 'b) -> 'b t
      val of_list_rev_map : 'a list -> f:('a -> 'b) -> 'b t
      val prefix : 'a t -> len:int -> 'a t
      val suffix : 'a t -> len:int -> 'a t
      val drop_prefix : 'a t -> len:int -> 'a t
      val drop_suffix : 'a t -> len:int -> 'a t
      val group : 'a t -> break:('a -> 'a -> bool) -> 'a t t
      val split_n : 'a t -> int -> 'a t * 'a t
      val chunks_of : 'a t -> length:int -> 'a t t
      val rev : 'a t -> 'a t
      val sort : 'a t -> compare:('a -> 'a -> int) -> 'a t
      val stable_sort : 'b t -> compare:('b -> 'b -> int) -> 'b t
      val dedup_and_sort : 'a t -> compare:('a -> 'a -> int) -> 'a t
      val sort_and_group : 'a t -> compare:('a -> 'a -> int) -> 'a t t
      val is_sorted : 'a t -> compare:('a -> 'a -> int) -> bool
      val is_sorted_strictly : 'a t -> compare:('a -> 'a -> int) -> bool
      val find_a_dup : 'a t -> compare:('a -> 'a -> int) -> 'a option
      val reduce : 'a t -> f:('a -> 'a -> 'a) -> 'a option
      val reduce_exn : 'a t -> f:('a -> 'a -> 'a) -> 'a
      val combine_errors : 'a Or_error.t t -> 'a t Or_error.t
      val combine_errors_unit : unit Or_error.t t -> unit Or_error.t
      val fold : 'a 'acc. 'a t -> init:'acc -> f:('acc -> 'a -> 'acc) -> 'acc
      val foldi : 'a 'acc. 'a t -> init:'acc -> f:(int -> 'acc -> 'a -> 'acc) -> 'acc
      val fold_right : 'a 'acc. 'a t -> init:'acc -> f:('a -> 'acc -> 'acc) -> 'acc
      val fold_map : 'a t -> init:'acc -> f:('acc -> 'a -> 'acc * 'b) -> 'acc * 'b t

      val fold_mapi
        :  'a t
        -> init:'acc
        -> f:(int -> 'acc -> 'a -> 'acc * 'b)
        -> 'acc * 'b t

      val zip : 'a t -> 'b t -> ('a * 'b) t option
      val zip_exn : 'a t -> 'b t -> ('a * 'b) t
      val unzip : ('a * 'b) t -> 'a t * 'b t
      val map2_exn : 'a t -> 'b t -> f:('a -> 'b -> 'c) -> 'c t
      val iter2_exn : 'a t -> 'b t -> f:('a -> 'b -> unit) -> unit
      val cartesian_product : 'a t -> 'b t -> ('a * 'b) t
      val random_element : ?random_state:Random.State.t -> 'a t -> 'a option
      val random_element_exn : ?random_state:Random.State.t -> 'a t -> 'a
      val sub : 'a t -> pos:int -> len:int -> 'a t
      val subo : ?pos:int -> ?len:int -> 'a t -> 'a t

      module Of_array : sig
        val sub : 'a array -> pos:int -> len:int -> 'a t
        val subo : ?pos:int -> ?len:int -> 'a array -> 'a t
      end

      module To_array : sig
        val sub : 'a t -> pos:int -> len:int -> 'a array
        val subo : ?pos:int -> ?len:int -> 'a t -> 'a array

        val blito
          :  src:'a t
          -> ?src_pos:int
          -> ?src_len:int
          -> dst:'a array
          -> ?dst_pos:int
          -> unit
          -> unit

        val blit
          :  src:'a t
          -> src_pos:int
          -> dst:'a array
          -> dst_pos:int
          -> len:int
          -> unit

        val unsafe_blit
          :  src:'a t
          -> src_pos:int
          -> dst:'a array
          -> dst_pos:int
          -> len:int
          -> unit
      end
    end

    module Local : sig
      val length : 'a t -> int
      val is_empty : 'a t -> bool
      val mem : 'a t -> 'a -> equal:('a -> 'a -> bool) -> bool
      val iter : 'a t -> f:('a -> unit) -> unit

      val fold_result
        :  'a t
        -> init:'acc
        -> f:('acc -> 'a -> ('acc, 'e) Result.t)
        -> ('acc, 'e) Result.t

      val fold_until
        :  'a t
        -> init:'acc
        -> f:('acc -> 'a -> ('acc, 'final) Container.Continue_or_stop.t)
        -> finish:('acc -> 'final)
        -> 'final

      val exists : 'a t -> f:('a -> bool) -> bool
      val for_all : 'a t -> f:('a -> bool) -> bool
      val count : 'a t -> f:('a -> bool) -> int

      val sum
        :  (module Container.Summable with type t = 'sum)
        -> 'a t
        -> f:('a -> 'sum)
        -> 'sum

      val find : 'a t -> f:('a -> bool) -> 'a option
      val find_map : 'a t -> f:('a -> 'b option) -> 'b option
      val to_list : 'a t -> 'a list
      val min_elt : 'a t -> compare:('a -> 'a -> int) -> 'a option
      val max_elt : 'a t -> compare:('a -> 'a -> int) -> 'a option
      val of_list : 'a list -> 'a t
      val append : 'a t -> 'a t -> 'a t
      val concat : 'a t t -> 'a t
      val map : 'a t -> f:('a -> 'b) -> 'b t
      val map_to_global : 'a t -> f:('a -> 'b) -> 'b t
      val map_of_global : 'a t -> f:('a -> 'b) -> 'b t
      val filter : 'a t -> f:('a -> bool) -> 'a t
      val filter_map : 'a t -> f:('a -> 'b option) -> 'b t
      val concat_map : 'a t -> f:('a -> 'b t) -> 'b t
      val partition_tf : 'a t -> f:('a -> bool) -> 'a t * 'a t
      val partition_map : 'a t -> f:('a -> ('b, 'c) Either.t) -> 'b t * 'c t
      val iteri : 'a t -> f:(int -> 'a -> unit) -> unit
      val existsi : 'a t -> f:(int -> 'a -> bool) -> bool
      val for_alli : 'a t -> f:(int -> 'a -> bool) -> bool
      val counti : 'a t -> f:(int -> 'a -> bool) -> int
      val findi : 'a t -> f:(int -> 'a -> bool) -> (int * 'a) option
      val find_mapi : 'a t -> f:(int -> 'a -> 'b option) -> 'b option
      val partitioni_tf : 'a t -> f:(int -> 'a -> bool) -> 'a t * 'a t
      val partition_mapi : 'a t -> f:(int -> 'a -> ('b, 'c) Either.t) -> 'b t * 'c t
      val mapi : 'a t -> f:(int -> 'a -> 'b) -> 'b t
      val mapi_to_global : 'a t -> f:(int -> 'a -> 'b) -> 'b t
      val mapi_of_global : 'a t -> f:(int -> 'a -> 'b) -> 'b t
      val filteri : 'a t -> f:(int -> 'a -> bool) -> 'a t
      val filter_mapi : 'a t -> f:(int -> 'a -> 'b option) -> 'b t
      val concat_mapi : 'a t -> f:(int -> 'a -> 'b t) -> 'b t
      val last_exn : 'a t -> 'a
      val to_array_of_immediates : 'a t -> 'a array
      val sort_immediates : 'a t -> compare:('a -> 'a -> int) -> 'a t

      module Let_syntax : sig
        val return : 'a -> 'a t

        module Let_syntax : sig
          val return : 'a -> 'a t
          val bind : 'a t -> f:('a -> 'b t) -> 'b t
          val map : 'a t -> f:('a -> 'b) -> 'b t
          val both : 'a t -> 'b t -> ('a * 'b) t

          module Open_on_rhs : sig end
        end
      end

      val init : int -> f:(int -> 'a) -> 'a t
      val init_with_globals : int -> f:(int -> 'a) -> 'a t
      val singleton : 'a -> 'a t
      val create : len:int -> 'a -> mutate:('a array -> unit) -> 'a iarray
      val prefix : 'a t -> len:int -> 'a t
      val suffix : 'a t -> len:int -> 'a t
      val drop_prefix : 'a t -> len:int -> 'a t
      val drop_suffix : 'a t -> len:int -> 'a t
      val rev : 'a t -> 'a t
      val sub : 'a t -> pos:int -> len:int -> 'a t
      val subo : ?pos:int -> ?len:int -> 'a t -> 'a t
      val of_list_rev : 'a list -> 'a t
      val of_list_map : 'a list -> f:('a -> 'b) -> 'b t
      val of_list_mapi : 'a list -> f:(int -> 'a -> 'b) -> 'b t
      val of_list_rev_map : 'a list -> f:('a -> 'b) -> 'b t
      val iter2_exn : 'a t -> 'b t -> f:('a -> 'b -> unit) -> unit
      val map2_exn : 'a t -> 'b t -> f:('a -> 'b -> 'c) -> 'c t
      val cartesian_product : 'a t -> 'b t -> ('a * 'b) t
      val fold : 'a 'acc. 'a t -> init:'acc -> f:('acc -> 'a -> 'acc) -> 'acc
      val foldi : 'a 'acc. 'a t -> init:'acc -> f:(int -> 'acc -> 'a -> 'acc) -> 'acc
      val fold_right : 'a 'acc. 'a t -> init:'acc -> f:('a -> 'acc -> 'acc) -> 'acc
      val fold_map : 'a t -> init:'acc -> f:('acc -> 'a -> 'acc * 'b) -> 'acc * 'b t

      val fold_mapi
        :  'a t
        -> init:'acc
        -> f:(int -> 'acc -> 'a -> 'acc * 'b)
        -> 'acc * 'b t
    end

    module Unique : sig
      val init : int -> f:(int -> 'a) -> 'a t
      val map : 'a t -> f:('a -> 'b) -> 'b t
      val mapi : 'a t -> f:(int -> 'a -> 'b) -> 'b t
      val iter : 'a t -> f:('a -> unit) -> unit
      val iteri : 'a t -> f:(int -> 'a -> unit) -> unit
      val unzip : ('a * 'b) t -> 'a t * 'b t
      val zip_exn : 'a t -> 'b t -> ('a * 'b) t
      external of_array : 'a array -> 'a global t = "%identity"
    end

    val unsafe_to_array__promise_no_mutation : 'a. 'a t -> 'a array
    external unsafe_of_array__promise_no_mutation : 'a. 'a array -> 'a t = "%identity"
  end
end

module type Iarray = sig
  include module type of struct
    include Definitions
  end

  include Public with type 'a t = 'a iarray

  module Private : sig
    module Test_unsafe_local_implementations : module type of struct
      let concat = concat
      let concat_map = concat_map
      let concat_mapi = concat_mapi
      let filter = filter
      let filteri = filteri
      let filter_map = filter_map
      let filter_mapi = filter_mapi
      let partition_tf = partition_tf
      let partition_map = partition_map
      let fold_map = Local.fold_map
      let fold_mapi = Local.fold_mapi
    end
  end
  [@@alert
    private_iarray "These bindings are intended only for use in tests of Iarray itself."]
end
