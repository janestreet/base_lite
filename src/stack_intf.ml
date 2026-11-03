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

    include Invariant.S1 with type 'a t := 'a t
    include Container.S1 with type 'a t := 'a t

    val of_list : 'a list -> 'a t
    val create : unit -> _ t
    val singleton : 'a -> 'a t
    val push : 'a t -> 'a -> unit
    val pop : 'a t -> 'a option
    val pop_exn : 'a t -> 'a
    val top : 'a t -> 'a option
    val top_exn : 'a t -> 'a
    val clear : _ t -> unit
    val copy : 'a t -> 'a t
    val until_empty : 'a t -> ('a -> unit) -> unit
    val filter_map : 'a t -> f:('a -> 'b option) -> 'b t
    val filter : 'a t -> f:('a -> bool) -> 'a t
    val filter_inplace : 'a t -> f:('a -> bool) -> unit
  end
end

module type Stack = sig
  include module type of struct
    include Definitions
  end

  type 'a t

  include S with type 'a t := 'a t

  val capacity : _ t -> int
  val set_capacity : _ t -> int -> unit
end
