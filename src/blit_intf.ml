open! Import0

module Definitions = struct
  module type Sequence = sig
    type t

    val length : t -> int
  end

  type ('src, 'dst) blit =
    src:'src -> src_pos:int -> dst:'dst -> dst_pos:int -> len:int -> unit

  type ('src, 'dst) blito =
    src:'src -> ?src_pos:int -> ?src_len:int -> dst:'dst -> ?dst_pos:int -> unit -> unit

  type ('src, 'dst) blit_global =
    src:'src -> src_pos:int -> dst:'dst -> dst_pos:int -> len:int -> unit

  type ('src, 'dst) blito_global =
    src:'src -> ?src_pos:int -> ?src_len:int -> dst:'dst -> ?dst_pos:int -> unit -> unit

  type ('src, 'dst) sub = 'src -> pos:int -> len:int -> 'dst
  type ('src, 'dst) subo = ?pos:int -> ?len:int -> 'src -> 'dst
  type ('src, 'dst) sub_global = 'src -> pos:int -> len:int -> 'dst
  type ('src, 'dst) subo_global = ?pos:int -> ?len:int -> 'src -> 'dst

  module type S1_phantom2_distinct = sig
    type ('elt, 'p1, 'p2) src
    type ('elt, 'p1, 'p2) dst

    val blit : 'a 'p1 'p2 'p3 'p4. (('a, 'p1, 'p2) src, ('a, 'p3, 'p4) dst) blit
    val blito : 'a 'p1 'p2 'p3 'p4. (('a, 'p1, 'p2) src, ('a, 'p3, 'p4) dst) blito
    val unsafe_blit : 'a 'p1 'p2 'p3 'p4. (('a, 'p1, 'p2) src, ('a, 'p3, 'p4) dst) blit
    val sub : 'a 'p1 'p2 'p3 'p4. (('a, 'p1, 'p2) src, ('a, 'p3, 'p4) dst) sub
    val subo : 'a 'p1 'p2 'p3 'p4. (('a, 'p1, 'p2) src, ('a, 'p3, 'p4) dst) subo
  end

  module type S = sig
    type t

    include S1_phantom2_distinct with type (_, _, _) src := t and type (_, _, _) dst := t
  end

  module type S1 = sig
    type 'a t

    include
      S1_phantom2_distinct
      with type ('a, _, _) src := 'a t
       and type ('a, _, _) dst := 'a t
  end

  module type S1_zero_alloc = sig
    type 'a t

    val blit : 'a. ('a t, 'a t) blit
    val blito : 'a. ('a t, 'a t) blito
    val unsafe_blit : 'a. ('a t, 'a t) blit
    val sub : 'a. ('a t, 'a t) sub
    val subo : 'a. ('a t, 'a t) subo
  end

  module type S_distinct = sig
    type src
    type dst

    include
      S1_phantom2_distinct with type (_, _, _) src := src and type (_, _, _) dst := dst
  end

  module type S_distinct_global = sig
    type src
    type dst

    val blit : (src, dst) blit_global
    val blito : (src, dst) blito_global
    val unsafe_blit : (src, dst) blit_global
    val sub : (src, dst) sub_global
    val subo : (src, dst) subo_global
  end

  module type S_phantom_distinct = sig
    type 'a src
    type 'a dst

    include
      S1_phantom2_distinct
      with type (_, 'a, _) src := 'a src
       and type (_, 'a, _) dst := 'a dst
  end

  module type S_to_string = sig
    type t

    val sub : (t, string) sub
    val subo : (t, string) subo
  end

  module type S_to_string_global = sig
    type t

    val sub : (t, string) sub_global
    val subo : (t, string) subo_global
  end

  module type Sequence1 = sig
    type 'a t

    val create_like : 'a. len:int -> 'a t -> 'a t
    val length : 'a. 'a t -> int
    val unsafe_blit : 'a. ('a t, 'a t) blit
  end

  module type Sequence1_zero_alloc = sig
    type 'a t

    val create_like : 'a. len:int -> 'a t -> 'a t
    val length : 'a. 'a t -> int
    val unsafe_blit : 'a. ('a t, 'a t) blit
  end
end

module type Blit = sig
  include module type of struct
    include Definitions
  end

  module Make : functor
      (Sequence : sig
         include Sequence

         val create : len:int -> t
         val unsafe_blit : (t, t) blit
       end)
      -> S with type t := Sequence.t

  module Make_distinct : functor
      (Src : Sequence)
      (Dst : sig
         include Sequence

         val create : len:int -> t
         val unsafe_blit : (Src.t, t) blit
       end)
      -> S_distinct with type src := Src.t with type dst := Dst.t

  module Make_to_string : functor
      (T : sig
         type t
       end)
      (To_bytes : S_distinct with type src := T.t with type dst := bytes)
      -> S_to_string with type t := T.t

  module Make1 : functor (Sequence : Sequence1) -> S1 with type 'a t := 'a Sequence.t

  module Make1_zero_alloc : functor (Sequence : Sequence1_zero_alloc) ->
    S1_zero_alloc with type 'a t := 'a Sequence.t

  module Make1_phantom2_distinct : functor
      (Src : sig
         type ('elt, 'p1, 'p2) t

         val length : (_, _, _) t -> int
       end)
      (Dst : sig
         type ('elt, 'p1, 'p2) t

         val length : (_, _, _) t -> int
         val create_like : len:int -> ('elt, _, _) Src.t -> ('elt, _, _) t
         val unsafe_blit : (('elt, _, _) Src.t, ('elt, _, _) t) blit
       end)
      ->
    S1_phantom2_distinct
    with type ('elt, 'p1, 'p2) src := ('elt, 'p1, 'p2) Src.t
    with type ('elt, 'p1, 'p2) dst := ('elt, 'p1, 'p2) Dst.t
end
