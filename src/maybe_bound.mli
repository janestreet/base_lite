open! Import0
module List := List0

type interval_comparison =
  | Below_lower_bound
  | In_range
  | Above_upper_bound

include sig
  [@@@ocaml.warning "-32"]

  val sexp_of_interval_comparison : interval_comparison -> Sexplib0.Sexp.t
  val interval_comparison_of_sexp : Sexplib0.Sexp.t -> interval_comparison
  val interval_comparison_sexp_grammar : interval_comparison Sexplib0.Sexp_grammar.t

  val compare_interval_comparison
    :  interval_comparison
    -> (interval_comparison[@merlin.hide])
    -> int

  val hash_fold_interval_comparison
    :  Ppx_hash_lib.Std.Hash.state
    -> interval_comparison
    -> Ppx_hash_lib.Std.Hash.state

  val hash_interval_comparison : interval_comparison -> Ppx_hash_lib.Std.Hash.hash_value
end
[@@merlin.hide]

include sig
  type 'a t =
    | Incl of 'a
    | Excl of 'a
    | Unbounded

  include sig
    [@@@ocaml.warning "-32"]

    include Sexplib0.Sexpable.S1 with type 'a t := 'a t

    val t_sexp_grammar : 'a. 'a Sexplib0.Sexp_grammar.t -> 'a t Sexplib0.Sexp_grammar.t
    val globalize : 'a. ('a -> 'a) -> 'a t -> 'a t
  end
  [@@merlin.hide]

  val all : 'a List.Constructors.t -> 'a t list
  val map : 'a t -> f:('a -> 'b) -> 'b t
  val is_lower_bound : 'a t -> of_:'a -> compare:('a -> 'a -> int) -> bool
  val is_upper_bound : 'a t -> of_:'a -> compare:('a -> 'a -> int) -> bool

  val interval_contains_exn
    :  lower:'a t
    -> upper:'a t
    -> 'a
    -> compare:('a -> 'a -> int)
    -> bool

  val bounds_crossed : lower:'a t -> upper:'a t -> compare:('a -> 'a -> int) -> bool

  val compare_to_interval_exn
    :  lower:'a t
    -> upper:'a t
    -> 'a
    -> compare:('a -> 'a -> int)
    -> interval_comparison
end
