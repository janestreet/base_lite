open! Import
module Sexp = Sexp0

module Definitions = struct
  module Type_equal_defns (Type_equal : T.T2) = struct
    module type Lift = sig
      type 'a t

      val lift : 'a 'b. ('a, 'b) Type_equal.t -> ('a t, 'b t) Type_equal.t
    end

    module type Lift2 = sig
      type ('a, 'b) t

      val lift
        : 'a1 'b1 'a2 'b2.
        ('a1, 'b1) Type_equal.t
        -> ('a2, 'b2) Type_equal.t
        -> (('a1, 'a2) t, ('b1, 'b2) t) Type_equal.t
    end

    module type Lift3 = sig
      type ('a, 'b, 'c) t

      val lift
        : 'a1 'b1 'a2 'b2 'a3 'b3.
        ('a1, 'b1) Type_equal.t
        -> ('a2, 'b2) Type_equal.t
        -> ('a3, 'b3) Type_equal.t
        -> (('a1, 'a2, 'a3) t, ('b1, 'b2, 'b3) t) Type_equal.t
    end

    module type Lift4 = sig
      type ('a, 'b, 'c, 'd) t

      val lift
        : 'a1 'b1 'a2 'b2 'a3 'b3 'a4 'b4.
        ('a1, 'b1) Type_equal.t
        -> ('a2, 'b2) Type_equal.t
        -> ('a3, 'b3) Type_equal.t
        -> ('a4, 'b4) Type_equal.t
        -> (('a1, 'a2, 'a3, 'a4) t, ('b1, 'b2, 'b3, 'b4) t) Type_equal.t
    end
  end

  module Type_equal_id_defns (Id : sig
      type 'a t
    end) =
  struct
    module type Arg0 = sig
      type t

      include sig
        [@@@ocaml.warning "-32"]

        val sexp_of_t : t -> Sexplib0.Sexp.t
      end
      [@@merlin.hide]

      val name : string
    end

    module type S0 = sig
      type t

      val type_equal_id : t Id.t
    end

    module type Arg1 = sig
      type !'a t

      include sig
        [@@@ocaml.warning "-32"]

        val sexp_of_t : ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t
      end
      [@@merlin.hide]

      val name : string
    end

    module type S1 = sig
      type 'a t

      val type_equal_id : 'a Id.t -> 'a t Id.t
    end

    module type Arg2 = sig
      type (!'a, !'b) t

      include sig
        [@@@ocaml.warning "-32"]

        val sexp_of_t
          : 'a 'b.
          ('a -> Sexplib0.Sexp.t)
          -> ('b -> Sexplib0.Sexp.t)
          -> ('a, 'b) t
          -> Sexplib0.Sexp.t
      end
      [@@merlin.hide]

      val name : string
    end

    module type S2 = sig
      type ('a, 'b) t

      val type_equal_id : 'a 'b. 'a Id.t -> 'b Id.t -> ('a, 'b) t Id.t
    end

    module type Arg3 = sig
      type (!'a, !'b, !'c) t

      include sig
        [@@@ocaml.warning "-32"]

        val sexp_of_t
          :  ('a -> Sexplib0.Sexp.t)
          -> ('b -> Sexplib0.Sexp.t)
          -> ('c -> Sexplib0.Sexp.t)
          -> ('a, 'b, 'c) t
          -> Sexplib0.Sexp.t
      end
      [@@merlin.hide]

      val name : string
    end

    module type S3 = sig
      type ('a, 'b, 'c) t

      val type_equal_id : 'a Id.t -> 'b Id.t -> 'c Id.t -> ('a, 'b, 'c) t Id.t
    end

    module type Arg4 = sig
      type (!'a, !'b, !'c, !'d) t

      include sig
        [@@@ocaml.warning "-32"]

        val sexp_of_t
          :  ('a -> Sexplib0.Sexp.t)
          -> ('b -> Sexplib0.Sexp.t)
          -> ('c -> Sexplib0.Sexp.t)
          -> ('d -> Sexplib0.Sexp.t)
          -> ('a, 'b, 'c, 'd) t
          -> Sexplib0.Sexp.t
      end
      [@@merlin.hide]

      val name : string
    end

    module type S4 = sig
      type ('a, 'b, 'c, 'd) t

      val type_equal_id
        :  'a Id.t
        -> 'b Id.t
        -> 'c Id.t
        -> 'd Id.t
        -> ('a, 'b, 'c, 'd) t Id.t
    end
  end
end

module type Type_equal = sig
  open Definitions

  type ('a, 'b) t = T : 'a. ('a, 'a) t

  include sig
    [@@@ocaml.warning "-32"]

    val sexp_of_t
      : 'a 'b.
      ('a -> Sexplib0.Sexp.t) -> ('b -> Sexplib0.Sexp.t) -> ('a, 'b) t -> Sexplib0.Sexp.t
  end
  [@@merlin.hide]

  type ('a, 'b) equal := ('a, 'b) t

  include module type of Type_equal_defns (struct
      type ('a, 'b) t = ('a, 'b) equal
    end)

  val refl : 'a. ('a, 'a) t
  val sym : 'a 'b. ('a, 'b) t -> ('b, 'a) t
  val trans : ('a, 'b) t -> ('b, 'c) t -> ('a, 'c) t
  val conv : 'a 'b. ('a, 'b) t -> 'a -> 'b

  module Lift : functor (T : T1) -> Lift with type 'a t := 'a T.t
  module Lift2 : functor (T : T2) -> Lift2 with type ('a, 'b) t := ('a, 'b) T.t

  include sig
    module Lift3 : functor (T : T3) -> Lift3 with type ('a, 'b, 'c) t := ('a, 'b, 'c) T.t

    module Lift4 : functor (T : T4) ->
      Lift4 with type ('a, 'b, 'c, 'd) t := ('a, 'b, 'c, 'd) T.t
  end

  val detuple2 : ('a1 * 'a2, 'b1 * 'b2) t -> ('a1, 'b1) t * ('a2, 'b2) t
  val tuple2 : ('a1, 'b1) t -> ('a2, 'b2) t -> ('a1 * 'a2, 'b1 * 'b2) t

  module Id : sig
    type 'a t

    include sig
      [@@@ocaml.warning "-32"]

      val sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t
    end
    [@@merlin.hide]

    include module type of Type_equal_id_defns (struct
        type nonrec 'a t = 'a t
      end)

    module Uid : sig
      type t

      include sig
        [@@@ocaml.warning "-32"]

        include Ppx_hash_lib.Hashable.S with type t := t

        val sexp_of_t : t -> Sexplib0.Sexp.t
      end
      [@@merlin.hide]

      include Comparable.S with type t := t
    end

    val uid : _ t -> Uid.t
    val create : 'a. name:string -> ('a -> Sexp.t) -> 'a t
    val hash : 'a. 'a t -> int
    val name : 'a. 'a t -> string
    val to_sexp : 'a. 'a t -> 'a -> Sexp.t
    val hash_fold_t : Hash.state -> _ t -> Hash.state
    val same : _ t -> _ t -> bool
    val same_witness : 'a 'b. 'a t -> 'b t -> ('a, 'b) equal option
    val same_witness_exn : 'a 'b. 'a t -> 'b t -> ('a, 'b) equal

    module Create0 : functor (T : Arg0) -> S0 with type t := T.t
    module Create1 : functor (T : Arg1) -> S1 with type 'a t := 'a T.t
    module Create2 : functor (T : Arg2) -> S2 with type ('a, 'b) t := ('a, 'b) T.t
    module Create3 : functor (T : Arg3) -> S3 with type ('a, 'b, 'c) t := ('a, 'b, 'c) T.t

    module Create4 : functor (T : Arg4) ->
      S4 with type ('a, 'b, 'c, 'd) t := ('a, 'b, 'c, 'd) T.t
  end
end
