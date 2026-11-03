open! Import0

module Definitions = struct
  module type S = sig
    type 'a t

    include sig
      [@@@ocaml.warning "-32"]

      include Sexplib0.Sexpable.S1 with type 'a t := 'a t

      val t_sexp_grammar : 'a. 'a Sexplib0.Sexp_grammar.t -> 'a t Sexplib0.Sexp_grammar.t
    end
    [@@merlin.hide]

    include Indexed_container.S1 with type 'a t := 'a t

    val of_iarray : 'a iarray -> 'a t
    val to_iarray : 'a t -> 'a iarray
    val singleton : 'a -> 'a t
    val of_list : 'a list -> 'a t
    val of_array : 'a array -> 'a t
    val init : int -> f:(int -> 'a) -> 'a t
    val enqueue : 'a t -> 'a -> unit
    val enqueue_all : 'a t -> 'a list -> unit
    val dequeue : 'a t -> 'a option
    val dequeue_or_null : 'a t -> 'a or_null
    val dequeue_exn : 'a t -> 'a
    val dequeue_and_ignore_exn : 'a t -> unit
    val drain : 'a t -> f:('a -> unit) -> while_:('a -> bool) -> unit
    val peek : 'a t -> 'a option
    val peek_or_null : 'a t -> 'a or_null
    val peek_exn : 'a t -> 'a
    val clear : _ t -> unit
    val copy : 'a t -> 'a t
    val map : 'a t -> f:('a -> 'b) -> 'b t
    val mapi : 'a t -> f:(int -> 'a -> 'b) -> 'b t
    val concat_map : 'a t -> f:('a -> 'b list) -> 'b t
    val concat_mapi : 'a t -> f:(int -> 'a -> 'b list) -> 'b t
    val filter_map : 'a t -> f:('a -> 'b option) -> 'b t
    val filter_mapi : 'a t -> f:(int -> 'a -> 'b option) -> 'b t
    val filter : 'a t -> f:('a -> bool) -> 'a t
    val filteri : 'a t -> f:(int -> 'a -> bool) -> 'a t
    val filter_inplace : 'a t -> f:('a -> bool) -> unit
    val filteri_inplace : 'a t -> f:(int -> 'a -> bool) -> unit
  end
end

module type Queue = sig
  include module type of struct
    include Definitions
  end

  type 'a t

  include sig
    [@@@ocaml.warning "-32"]

    include Ppx_compare_lib.Comparable.S1 with type 'a t := 'a t
    include Ppx_compare_lib.Equal.S1 with type 'a t := 'a t

    val globalize : 'a. ('a -> 'a) -> 'a t -> 'a t

    include Sexplib0.Sexpable.S1 with type 'a t := 'a t
  end
  [@@merlin.hide]

  include S with type 'a t := 'a t
  include Invariant.S1 with type 'a t := 'a t

  val create : ?capacity:int -> unit -> _ t
  val last : 'a t -> 'a option
  val last_exn : 'a t -> 'a
  val enqueue_front : 'a t -> 'a -> unit
  val dequeue_back : 'a t -> 'a option
  val dequeue_back_exn : 'a t -> 'a
  val peek_back : 'a t -> 'a option
  val peek_back_exn : 'a t -> 'a
  val blit_transfer : src:'a t -> dst:'a t -> ?len:int -> unit -> unit
  val get : 'a t -> int -> 'a
  val set : 'a t -> int -> 'a -> unit
  val capacity : _ t -> int
  val set_capacity : _ t -> int -> unit

  module Iteration : sig
    type 'a queue := 'a t
    type t

    val start : _ queue -> t
    val assert_no_mutation_since_start : t -> _ queue -> unit
  end
end
