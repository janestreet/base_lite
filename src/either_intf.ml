open! Import0
module Either = Either0

module Definitions = struct
  module type Focused = sig
    type (+'focus, +'other) t

    include Monad.S2 with type ('a, 'b) t := ('a, 'b) t
    include Applicative.S2 with type ('a, 'b) t := ('a, 'b) t

    val value : 'a 'b. ('a, 'b) t -> default:'a -> 'a
    val to_option : 'a 'b. ('a, 'b) t -> 'a option
    val with_return : 'a 'b. ('a With_return.return -> 'b) -> ('a, 'b) t

    val combine
      : 'a 'b 'c 'd.
      ('a, 'd) t
      -> ('b, 'd) t
      -> f:('a -> 'b -> 'c)
      -> other:('d -> 'd -> 'd)
      -> ('c, 'd) t

    val combine_all : 'a 'b. ('a, 'b) t list -> f:('b -> 'b -> 'b) -> ('a list, 'b) t
    val combine_all_unit : 'b. (unit, 'b) t list -> f:('b -> 'b -> 'b) -> (unit, 'b) t
  end
end

module type Either = sig
  include module type of struct
    include Definitions
  end

  type ('f, 's) t = ('f, 's) Either.t =
    | First of 'f
    | Second of 's

  include sig
      type ('f, 's) t = ('f, 's) Either.t

      include sig
        [@@@ocaml.warning "-32"]

        val compare
          : 'f 's.
          ('f -> ('f[@merlin.hide]) -> int)
          -> ('s -> ('s[@merlin.hide]) -> int)
          -> ('f, 's) t
          -> (('f, 's) t[@merlin.hide])
          -> int

        val equal
          : 'f 's.
          ('f -> ('f[@merlin.hide]) -> bool)
          -> ('s -> ('s[@merlin.hide]) -> bool)
          -> ('f, 's) t
          -> (('f, 's) t[@merlin.hide])
          -> bool

        val sexp_of_t
          : 'f 's.
          ('f -> Sexplib0.Sexp.t)
          -> ('s -> Sexplib0.Sexp.t)
          -> ('f, 's) t
          -> Sexplib0.Sexp.t

        val t_of_sexp
          : 'f 's.
          (Sexplib0.Sexp.t -> 'f)
          -> (Sexplib0.Sexp.t -> 's)
          -> Sexplib0.Sexp.t
          -> ('f, 's) t

        val t_sexp_grammar
          : 'f 's.
          'f Sexplib0.Sexp_grammar.t
          -> 's Sexplib0.Sexp_grammar.t
          -> ('f, 's) t Sexplib0.Sexp_grammar.t
      end
      [@@merlin.hide]
    end
    with type ('f, 's) t := ('f, 's) t

  include sig
      type nonrec ('f, 's) t = ('f, 's) t =
        | First of 'f
        | Second of 's

      include sig
        [@@@ocaml.warning "-32"]

        val globalize : 'f 's. ('f -> 'f) -> ('s -> 's) -> ('f, 's) t -> ('f, 's) t

        val hash_fold_t
          : 'f 's.
          (Ppx_hash_lib.Std.Hash.state -> 'f -> Ppx_hash_lib.Std.Hash.state)
          -> (Ppx_hash_lib.Std.Hash.state -> 's -> Ppx_hash_lib.Std.Hash.state)
          -> Ppx_hash_lib.Std.Hash.state
          -> ('f, 's) t
          -> Ppx_hash_lib.Std.Hash.state
      end
      [@@merlin.hide]
    end
    with type ('f, 's) t := ('f, 's) t

  include Invariant.S2 with type ('a, 'b) t := ('a, 'b) t

  val swap : 'f 's. ('f, 's) t -> ('s, 'f) t
  val value : 'a. ('a, 'a) t -> 'a
  val iter : 'a 'b. ('a, 'b) t -> first:('a -> unit) -> second:('b -> unit) -> unit
  val value_map : 'a 'b 'c. ('a, 'b) t -> first:('a -> 'c) -> second:('b -> 'c) -> 'c
  val map : 'a 'b 'c 'd. ('a, 'b) t -> first:('a -> 'c) -> second:('b -> 'd) -> ('c, 'd) t

  module First : Focused with type ('a, 'b) t = ('a, 'b) t
  module Second : Focused with type ('a, 'b) t = ('b, 'a) t

  val is_first : 'f 's. ('f, 's) t -> bool
  val is_second : 'f 's. ('f, 's) t -> bool
  val first : 'f 's. 'f -> ('f, 's) t
  val second : 'f 's. 's -> ('f, 's) t

  module Export : sig
    type ('f, 's) _either = ('f, 's) t =
      | First of 'f
      | Second of 's
  end
end
