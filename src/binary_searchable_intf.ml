open! Import0

module Definitions = struct
  module type Indexable = sig
    type elt
    type t

    val get : t -> int -> elt
    val length : t -> int
  end

  module type Indexable1 = sig
    type 'a t

    val get : 'a. 'a t -> int -> 'a
    val length : _ t -> int
  end

  module Which_target_by_key = struct
    type t =
      [ `Last_strictly_less_than
      | `Last_less_than_or_equal_to
      | `Last_equal_to
      | `First_equal_to
      | `First_greater_than_or_equal_to
      | `First_strictly_greater_than
      ]

    include struct
      let _ = fun (_ : t) -> ()

      let all =
        ([ `Last_strictly_less_than
         ; `Last_less_than_or_equal_to
         ; `Last_equal_to
         ; `First_equal_to
         ; `First_greater_than_or_equal_to
         ; `First_strictly_greater_than
         ]
         : t list)
      ;;

      let _ = all
    end [@@merlin.hide]
  end

  module Which_target_by_segment = struct
    type t =
      [ `Last_on_left
      | `First_on_right
      ]

    include struct
      let _ = fun (_ : t) -> ()
      let all = ([ `Last_on_left; `First_on_right ] : t list)
      let _ = all
    end [@@merlin.hide]
  end

  type ('t, 'elt, 'key) binary_search =
    ?pos:int
    -> ?len:int
    -> 't
    -> compare:('elt -> 'key -> int)
    -> Which_target_by_key.t
    -> 'key
    -> int option

  type ('t, 'elt) binary_search_segmented =
    ?pos:int
    -> ?len:int
    -> 't
    -> segment_of:('elt -> [ `Left | `Right ])
    -> Which_target_by_segment.t
    -> int option

  module type S = sig
    type elt
    type t

    val binary_search : (t, elt, 'key) binary_search
    val binary_search_segmented : (t, elt) binary_search_segmented
  end

  module type S1 = sig
    type 'a t

    val binary_search : ('a t, 'a, 'key) binary_search
    val binary_search_segmented : ('a t, 'a) binary_search_segmented
  end
end

module type Binary_searchable = sig
  include module type of struct
    include Definitions
  end

  module Make : functor (T : Indexable) -> S with type t := T.t with type elt := T.elt
  module Make1 : functor (T : Indexable1) -> S1 with type 'a t := 'a T.t
end
