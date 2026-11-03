open! Import0
module Sexp = Sexp0

module Definitions = struct
  module type Key = sig
    type t

    include sig
      [@@@ocaml.warning "-32"]

      val sexp_of_t : t -> Sexplib0.Sexp.t
    end
    [@@merlin.hide]

    val compare : t -> (t[@merlin.hide]) -> int
    val hash : t -> int
  end
end

module type Hashable = sig
  include module type of struct
    include Definitions
  end

  type 'a t =
    { hash : 'a -> int
    ; compare : 'a -> 'a -> int
    ; sexp_of_t : 'a -> Sexp.t
    }

  val equal : 'a t -> 'a t -> bool
  val poly : 'a t
  val of_key : 'a. (module Key with type t = 'a) -> 'a t
  val to_key : 'a. 'a t -> (module Key with type t = 'a)
  val hash_param : int -> int -> 'a -> int
  val hash : 'a -> int
end
