open! Import0

open struct
  module Either = Either0
  module List = List0
  module Option = Option0
  module Result = Result0
end

module Definitions = struct
  module Export = struct
    module Continue_or_stop = struct
      type ('a, 'b) t =
        | Continue of 'a
        | Stop of 'b
    end
  end

  include Export

  module type Summable = sig
    type t

    val zero : t
    val ( + ) : t -> t -> t
  end

  module type Generic_types = sig
    type ('a, _, _) t
    type 'a elt
  end

  include struct
    include struct
      module type Generic_without_mem = sig
        include Generic_types

        type ('a, 'b, 'c) t := ('a, 'b, 'c) t
        type 'a elt := 'a elt

        include sig
          type ('a, 'b, 'c) t := ('a, 'b, 'c) t
          type 'a elt := 'a elt

          val length : 'a 'p1 'p2. ('a, 'p1, 'p2) t -> int
          val is_empty : 'a 'p1 'p2. ('a, 'p1, 'p2) t -> bool
          val iter : 'a 'p1 'p2. ('a, 'p1, 'p2) t -> f:('a elt -> unit) -> unit
          val exists : 'a 'p1 'p2. ('a, 'p1, 'p2) t -> f:('a elt -> bool) -> bool
          val for_all : 'a 'p1 'p2. ('a, 'p1, 'p2) t -> f:('a elt -> bool) -> bool
          val count : 'a 'p1 'p2. ('a, 'p1, 'p2) t -> f:('a elt -> bool) -> int
          val find : 'a 'p1 'p2. ('a, 'p1, 'p2) t -> f:('a elt -> bool) -> 'a elt Option.t
          val to_list : 'a 'p1 'p2. ('a, 'p1, 'p2) t -> 'a elt List.Constructors.t

          val min_elt
            : 'a 'p1 'p2.
            ('a, 'p1, 'p2) t -> compare:('a elt -> 'a elt -> int) -> 'a elt Option.t

          val max_elt
            : 'a 'p1 'p2.
            ('a, 'p1, 'p2) t -> compare:('a elt -> 'a elt -> int) -> 'a elt Option.t

          val sum
            : 'a 'sum 'p1 'p2.
            (module Summable with type t = 'sum)
            -> ('a, 'p1, 'p2) t
            -> f:('a elt -> 'sum)
            -> 'sum

          val iter_until
            : 'a 'p1 'p2 'final.
            ('a, 'p1, 'p2) t
            -> f:('a elt -> (unit, 'final) Continue_or_stop.t)
            -> finish:(unit -> 'final)
            -> 'final

          val fold
            : 'a 'p1 'p2 'acc.
            ('a, 'p1, 'p2) t -> init:'acc -> f:('acc -> 'a elt -> 'acc) -> 'acc

          val fold_result
            : 'a 'p1 'p2 'acc 'e.
            ('a, 'p1, 'p2) t
            -> init:'acc
            -> f:('acc -> 'a elt -> ('acc, 'e) Result.t)
            -> ('acc, 'e) Result.t

          val find_map
            : 'a 'p1 'p2 'b.
            ('a, 'p1, 'p2) t -> f:('a elt -> 'b Option.t) -> 'b Option.t
        end

        include sig
          type ('a, 'b, 'c) t := ('a, 'b, 'c) t
          type 'a elt := 'a elt

          val fold_until
            : 'a 'p1 'p2 'acc 'final.
            ('a, 'p1, 'p2) t
            -> init:'acc
            -> f:('acc -> 'a elt -> ('acc, 'final) Continue_or_stop.t)
            -> finish:('acc -> 'final)
            -> 'final
        end
      end

      module type Generic = sig
        include Generic_without_mem

        val mem
          : 'a 'p1 'p2.
          ('a, 'p1, 'p2) t -> 'a elt -> equal:('a elt -> 'a elt -> bool) -> bool
      end

      module type Generic_for_s0 = sig
        include Generic_without_mem

        val mem : ('a, _, _) t -> 'a elt -> bool
      end
    end
  end

  include struct
    module type Generic = sig
      include Generic

      val to_array : ('a, _, _) t -> 'a elt array
    end

    module type S0 = sig
      include sig
        type t
        type elt
      end

      include Generic_for_s0 with type (_, _, _) t := t with type _ elt := elt

      val to_array : t -> elt array
    end

    module type S0_phantom = sig
      include sig
        type elt
        type 'phantom t
      end

      include
        Generic_for_s0 with type (_, 'phantom, _) t := 'phantom t with type _ elt := elt

      val to_array : _ t -> elt array
    end
  end

  include struct
    include struct
      module type S1 = sig
        type 'a t

        include Generic with type ('a, _, _) t := 'a t with type 'a elt := 'a

        val to_array : 'a. 'a t -> 'a array
      end

      module type S1_phantom = sig
        type ('a, 'phantom) t

        include
          Generic with type ('a, 'phantom, _) t := ('a, 'phantom) t with type 'a elt := 'a

        val to_array : 'a 'p. ('a, 'p) t -> 'a array
      end

      module type Creators = sig
        include Generic_types

        type ('a, 'b, 'c) t := ('a, 'b, 'c) t
        type 'a elt := 'a elt
        type (_, _, _) concat

        include sig
          type ('a, 'b, 'c) t := ('a, 'b, 'c) t
          type 'a elt := 'a elt

          val of_list : 'a 'p1 'p2. 'a elt List.Constructors.t -> ('a, 'p1, 'p2) t

          val append
            : 'a 'p1 'p2.
            ('a, 'p1, 'p2) t -> ('a, 'p1, 'p2) t -> ('a, 'p1, 'p2) t

          val concat : 'a 'p1 'p2. (('a, 'p1, 'p2) t, 'p1, 'p2) concat -> ('a, 'p1, 'p2) t

          val filter
            : 'a 'p1 'p2.
            ('a, 'p1, 'p2) t -> f:('a elt -> bool) -> ('a, 'p1, 'p2) t

          val partition_tf
            : 'a 'p1 'p2.
            ('a, 'p1, 'p2) t -> f:('a elt -> bool) -> ('a, 'p1, 'p2) t * ('a, 'p1, 'p2) t
        end

        include sig
          val map
            : 'a 'p1 'p2 'b.
            ('a, 'p1, 'p2) t -> f:('a elt -> 'b elt) -> ('b, 'p1, 'p2) t

          val filter_map
            : 'a 'p1 'p2 'b.
            ('a, 'p1, 'p2) t -> f:('a elt -> 'b elt Option.t) -> ('b, 'p1, 'p2) t

          val concat_map
            : 'a 'p1 'p2 'b.
            ('a, 'p1, 'p2) t -> f:('a elt -> ('b, 'p1, 'p2) t) -> ('b, 'p1, 'p2) t
        end

        include sig
          val partition_map
            : 'a 'p1 'p2 'b 'c.
            ('a, 'p1, 'p2) t
            -> f:('a elt -> ('b elt, 'c elt) Either.t)
            -> ('b, 'p1, 'p2) t * ('c, 'p1, 'p2) t
        end
      end

      module type Generic_with_creators = sig
        include Generic

        include
          Creators with type ('a, 'b, 'c) t := ('a, 'b, 'c) t with type 'a elt := 'a elt
      end

      module type Generic_with_creators_for_s0 = sig
        include Generic_for_s0

        include
          Creators with type ('a, 'b, 'c) t := ('a, 'b, 'c) t with type 'a elt := 'a elt
      end
    end
  end

  include struct
    module type Generic_with_creators = sig
      include Generic_with_creators

      val to_array : ('a, _, _) t -> 'a elt array
      val of_array : 'a elt array -> ('a, _, _) t
    end

    include struct
      module type S0_with_creators = sig
        include sig
          type t
          type elt
        end

        include
          Generic_with_creators_for_s0
          with type (_, _, _) concat := t list
          with type ('a, _, _) t := t
          with type _ elt := elt

        val to_array : t -> elt array
        val of_array : elt array -> t
      end
    end

    include struct
      module type S1_with_creators = sig
        type 'a t

        include
          Generic_with_creators
          with type ('a, _, _) concat := 'a t
          with type ('a, _, _) t := 'a t
          with type 'a elt := 'a

        val to_array : 'a. 'a t -> 'a array
        val of_array : 'a. 'a array -> 'a t
      end
    end
  end

  type ('t, 'a, 'acc) fold = 't -> init:'acc -> f:('acc -> 'a -> 'acc) -> 'acc

  type ('t, 'a, 'acc, 'final) fold_until =
    't
    -> init:'acc
    -> f:('acc -> 'a -> ('acc, 'final) Continue_or_stop.t)
    -> finish:('acc -> 'final)
    -> 'final

  type ('t, 'a) iter = 't -> f:('a -> unit) -> unit

  type ('t, 'a, 'final) iter_until =
    't -> f:('a -> (unit, 'final) Continue_or_stop.t) -> finish:(unit -> 'final) -> 'final

  type 't length = 't -> int

  module type Make_gen_arg = sig
    type ('a, 'phantom1, 'phantom2) t
    type 'a elt

    val fold_until : (('a, _, _) t, 'a elt, 'acc, 'final) fold_until
    val fold : [ `Define_using_fold_until | `Custom of (('a, _, _) t, 'a elt, 'acc) fold ]

    val iter_until
      : [ `Define_using_fold_until
        | `Custom of (('a, _, _) t, 'a elt, 'final) iter_until
        ]

    val iter
      : [ `Define_using_fold
        | `Define_using_iter_until
        | `Custom of (('a, _, _) t, 'a elt) iter
        ]

    val length : [ `Define_using_fold | `Custom of ('a, _, _) t length ]
  end

  module type Make_arg = sig
    type 'a t

    include Make_gen_arg with type ('a, _, _) t := 'a t and type 'a elt := 'a
  end

  module type Make0_arg = sig
    module Elt : sig
      type t

      val equal : t -> t -> bool
    end

    type t

    include Make_gen_arg with type ('a, _, _) t := t and type 'a elt := Elt.t
  end

  module type Make_common_with_creators_arg = sig
    include Make_gen_arg

    type (_, _, _) concat

    val of_list : 'a elt list -> ('a, _, _) t
    val of_array : 'a elt array -> ('a, _, _) t
    val concat : (('a, _, _) t, _, _) concat -> ('a, _, _) t
  end

  module type Make_gen_with_creators_arg = sig
    include Make_common_with_creators_arg

    val concat_of_array : 'a array -> ('a, _, _) concat
  end

  module type Make_with_creators_arg = sig
    type 'a t

    include
      Make_common_with_creators_arg
      with type ('a, _, _) t := 'a t
       and type 'a elt := 'a
       and type ('a, _, _) concat := 'a t
  end

  module type Make0_with_creators_arg = sig
    module Elt : sig
      type t

      val equal : t -> t -> bool
    end

    type t

    include
      Make_common_with_creators_arg
      with type ('a, _, _) t := t
       and type 'a elt := Elt.t
       and type ('a, _, _) concat := 'a list
  end

  module type Derived = sig
    include sig
      val fold_until
        : 't 'a 'acc 'final.
        fold:('t, 'a, 'acc) fold -> ('t, 'a, 'acc, 'final) fold_until

      val iter_via_fold : 't 'a. fold:('t, 'a, unit) fold -> ('t, 'a) iter
      val count : 't 'a. fold:('t, 'a, int) fold -> 't -> f:('a -> bool) -> int

      val min_elt
        : 't 'a.
        fold:('t, 'a, 'a option) fold -> 't -> compare:('a -> 'a -> int) -> 'a option

      val max_elt
        : 't 'a.
        fold:('t, 'a, 'a option) fold -> 't -> compare:('a -> 'a -> int) -> 'a option

      val length : 't 'a. fold:('t, 'a, int) fold -> 't length
    end

    val to_list : 't 'a. fold:('t, 'a, 'a list) fold -> 't -> 'a list

    val sum
      : 't 'a 'sum.
      fold:('t, 'a, 'sum) fold
      -> (module Summable with type t = 'sum)
      -> 't
      -> f:('a -> 'sum)
      -> 'sum

    val fold
      : 't 'a 'acc.
      fold_until:('t, 'a, 'acc, 'acc) fold_until -> ('t, 'a, 'acc) fold

    val fold_result
      : 't 'a 'acc 'e.
      fold_until:('t, 'a, 'acc, ('acc, 'e) Result.t) fold_until
      -> 't
      -> init:'acc
      -> f:('acc -> 'a -> ('acc, 'e) Result.t)
      -> ('acc, 'e) Result.t

    val iter_until
      : 't 'a 'final.
      fold_until:('t, 'a, unit, 'final) fold_until -> ('t, 'a, 'final) iter_until

    include sig
      val iter_via_iter_until
        : 't 'a.
        iter_until:('t, 'a, unit) iter_until -> ('t, 'a) iter

      val is_empty : 't 'a. iter_until:('t, 'a, bool) iter_until -> 't -> bool

      val mem
        : 't 'a.
        iter_until:('t, 'a, bool) iter_until
        -> 't
        -> 'a
        -> equal:('a -> 'a -> bool)
        -> bool

      val exists
        : 't 'a.
        iter_until:('t, 'a, bool) iter_until -> 't -> f:('a -> bool) -> bool

      val for_all
        : 't 'a.
        iter_until:('t, 'a, bool) iter_until -> 't -> f:('a -> bool) -> bool

      val find
        : 't 'a.
        iter_until:('t, 'a, 'a option) iter_until -> 't -> f:('a -> bool) -> 'a option
    end

    val find_map
      : 't 'a 'b.
      iter_until:('t, 'a, 'b option) iter_until -> 't -> f:('a -> 'b option) -> 'b option

    val to_array : 't 'a. length:'t length -> iter:('t, 'a) iter -> 't -> 'a array
  end
end

module type Container = sig
  include module type of struct
    include Definitions
  end

  module Derived : Derived
  include module type of Derived
  module Make : functor (T : Make_arg) -> S1 with type 'a t := 'a T.t
  module Make0 : functor (T : Make0_arg) -> S0 with type t := T.t and type elt := T.Elt.t

  module Make_gen : functor (T : Make_gen_arg) ->
    Generic
    with type ('a, 'phantom1, 'phantom2) t := ('a, 'phantom1, 'phantom2) T.t
     and type 'a elt := 'a T.elt

  module Make_with_creators : functor (T : Make_with_creators_arg) ->
    S1_with_creators with type 'a t := 'a T.t

  module Make0_with_creators : functor (T : Make0_with_creators_arg) ->
    S0_with_creators with type t := T.t and type elt := T.Elt.t

  module Make_gen_with_creators : functor (T : Make_gen_with_creators_arg) ->
    Generic_with_creators
    with type ('a, 'phantom1, 'phantom2) t := ('a, 'phantom1, 'phantom2) T.t
     and type 'a elt := 'a T.elt
     and type ('a, 'phantom1, 'phantom2) concat := ('a, 'phantom1, 'phantom2) T.concat
end
