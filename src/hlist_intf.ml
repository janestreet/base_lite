open! Import

module Definitions = struct
  module type S = sig
    type 'a elt

    type _ t =
      | [] : unit t
      | ( :: ) : 'head elt * 'tail t -> ('head -> 'tail) t
  end

  module Map_f (Input : S) (Output : S) = struct
    type t = { f : 'a. 'a Input.elt -> 'a Output.elt } [@@unboxed]
  end

  module Map2_f (Input1 : S) (Input2 : S) (Output : S) = struct
    type t = { f : 'a. 'a Input1.elt -> 'a Input2.elt -> 'a Output.elt } [@@unboxed]
  end

  module Lift_map_f (Liftable : T1) (Input : S) (Output : S) = struct
    type t = { f : 'a. 'a Input.elt -> 'a Output.elt Liftable.t } [@@unboxed]
  end

  module type Applicative_like = sig
    type 'a t

    val return : 'a -> 'a t
    val map2 : 'a t -> 'b t -> f:('a -> 'b -> 'c) -> 'c t
  end

  module type Monad_like = sig
    type 'a t

    val return : 'a -> 'a t
    val map : 'a t -> f:('a -> 'b) -> 'b t
    val both : 'a t -> 'b t -> ('a * 'b) t
  end
end

module type Hlist = sig
  include module type of struct
    include Definitions
  end

  include S with type 'a elt = 'a
  module Make : functor (Elt : T1) -> S with type 'a elt = 'a Elt.t

  module Map : functor (Input : S) (Output : S) -> sig
    val map : 'a Input.t -> f:Map_f(Input)(Output).t -> 'a Output.t
  end

  module Map2 : functor (Input1 : S) (Input2 : S) (Output : S) -> sig
    val map2
      :  'a Input1.t
      -> 'a Input2.t
      -> f:Map2_f(Input1)(Input2)(Output).t
      -> 'a Output.t
  end

  module Liftable_monad : functor (Make : Monad_like) ->
    Applicative_like with type 'a t = 'a Make.t

  module Lift : functor
      (Liftable : Applicative_like)
      (Inner : S)
      (Outer : S with type 'a elt = 'a Inner.elt Liftable.t)
      -> sig
    val lift : 'a Outer.t -> 'a Inner.t Liftable.t
  end

  module Lift_map : functor (Liftable : Applicative_like) (Input : S) (Output : S) -> sig
    val lift_map
      :  'a Input.t
      -> f:Lift_map_f(Liftable)(Input)(Output).t
      -> 'a Output.t Liftable.t
  end

  module T1 : sig
    type nonrec 'a t = ('a -> unit) t

    include sig
      [@@@ocaml.warning "-32"]

      include Ppx_compare_lib.Comparable.S1 with type 'a t := 'a t
      include Ppx_compare_lib.Equal.S1 with type 'a t := 'a t

      val globalize : 'a. ('a -> 'a) -> 'a t -> 'a t

      include Ppx_hash_lib.Hashable.S1 with type 'a t := 'a t
      include Sexplib0.Sexpable.S1 with type 'a t := 'a t

      val t_sexp_grammar : 'a. 'a Sexplib0.Sexp_grammar.t -> 'a t Sexplib0.Sexp_grammar.t
    end
    [@@merlin.hide]
  end

  module T2 : sig
    type nonrec ('a, 'b) t = ('a -> 'b -> unit) t

    include sig
      [@@@ocaml.warning "-32"]

      include Ppx_compare_lib.Comparable.S2 with type ('a, 'b) t := ('a, 'b) t
      include Ppx_compare_lib.Equal.S2 with type ('a, 'b) t := ('a, 'b) t

      val globalize : 'a 'b. ('a -> 'a) -> ('b -> 'b) -> ('a, 'b) t -> ('a, 'b) t

      include Ppx_hash_lib.Hashable.S2 with type ('a, 'b) t := ('a, 'b) t
      include Sexplib0.Sexpable.S2 with type ('a, 'b) t := ('a, 'b) t

      val t_sexp_grammar
        : 'a 'b.
        'a Sexplib0.Sexp_grammar.t
        -> 'b Sexplib0.Sexp_grammar.t
        -> ('a, 'b) t Sexplib0.Sexp_grammar.t
    end
    [@@merlin.hide]
  end

  module T3 : sig
    type nonrec ('a, 'b, 'c) t = ('a -> 'b -> 'c -> unit) t

    include sig
      [@@@ocaml.warning "-32"]

      include Ppx_compare_lib.Comparable.S3 with type ('a, 'b, 'c) t := ('a, 'b, 'c) t
      include Ppx_compare_lib.Equal.S3 with type ('a, 'b, 'c) t := ('a, 'b, 'c) t

      val globalize
        : 'a 'b 'c.
        ('a -> 'a) -> ('b -> 'b) -> ('c -> 'c) -> ('a, 'b, 'c) t -> ('a, 'b, 'c) t

      include Ppx_hash_lib.Hashable.S3 with type ('a, 'b, 'c) t := ('a, 'b, 'c) t
      include Sexplib0.Sexpable.S3 with type ('a, 'b, 'c) t := ('a, 'b, 'c) t

      val t_sexp_grammar
        : 'a 'b 'c.
        'a Sexplib0.Sexp_grammar.t
        -> 'b Sexplib0.Sexp_grammar.t
        -> 'c Sexplib0.Sexp_grammar.t
        -> ('a, 'b, 'c) t Sexplib0.Sexp_grammar.t
    end
    [@@merlin.hide]
  end

  module T4 : sig
    type nonrec ('a, 'b, 'c, 'd) t = ('a -> 'b -> 'c -> 'd -> unit) t

    include sig
      [@@@ocaml.warning "-32"]

      val compare
        : 'a 'b 'c 'd.
        ('a -> ('a[@merlin.hide]) -> int)
        -> ('b -> ('b[@merlin.hide]) -> int)
        -> ('c -> ('c[@merlin.hide]) -> int)
        -> ('d -> ('d[@merlin.hide]) -> int)
        -> ('a, 'b, 'c, 'd) t
        -> (('a, 'b, 'c, 'd) t[@merlin.hide])
        -> int

      val equal
        : 'a 'b 'c 'd.
        ('a -> ('a[@merlin.hide]) -> bool)
        -> ('b -> ('b[@merlin.hide]) -> bool)
        -> ('c -> ('c[@merlin.hide]) -> bool)
        -> ('d -> ('d[@merlin.hide]) -> bool)
        -> ('a, 'b, 'c, 'd) t
        -> (('a, 'b, 'c, 'd) t[@merlin.hide])
        -> bool

      val globalize
        : 'a 'b 'c 'd.
        ('a -> 'a)
        -> ('b -> 'b)
        -> ('c -> 'c)
        -> ('d -> 'd)
        -> ('a, 'b, 'c, 'd) t
        -> ('a, 'b, 'c, 'd) t

      val hash_fold_t
        : 'a 'b 'c 'd.
        (Ppx_hash_lib.Std.Hash.state -> 'a -> Ppx_hash_lib.Std.Hash.state)
        -> (Ppx_hash_lib.Std.Hash.state -> 'b -> Ppx_hash_lib.Std.Hash.state)
        -> (Ppx_hash_lib.Std.Hash.state -> 'c -> Ppx_hash_lib.Std.Hash.state)
        -> (Ppx_hash_lib.Std.Hash.state -> 'd -> Ppx_hash_lib.Std.Hash.state)
        -> Ppx_hash_lib.Std.Hash.state
        -> ('a, 'b, 'c, 'd) t
        -> Ppx_hash_lib.Std.Hash.state

      val sexp_of_t
        :  ('a -> Sexplib0.Sexp.t)
        -> ('b -> Sexplib0.Sexp.t)
        -> ('c -> Sexplib0.Sexp.t)
        -> ('d -> Sexplib0.Sexp.t)
        -> ('a, 'b, 'c, 'd) t
        -> Sexplib0.Sexp.t

      val t_of_sexp
        :  (Sexplib0.Sexp.t -> 'a)
        -> (Sexplib0.Sexp.t -> 'b)
        -> (Sexplib0.Sexp.t -> 'c)
        -> (Sexplib0.Sexp.t -> 'd)
        -> Sexplib0.Sexp.t
        -> ('a, 'b, 'c, 'd) t

      val t_sexp_grammar
        : 'a 'b 'c 'd.
        'a Sexplib0.Sexp_grammar.t
        -> 'b Sexplib0.Sexp_grammar.t
        -> 'c Sexplib0.Sexp_grammar.t
        -> 'd Sexplib0.Sexp_grammar.t
        -> ('a, 'b, 'c, 'd) t Sexplib0.Sexp_grammar.t
    end
    [@@merlin.hide]
  end
end
