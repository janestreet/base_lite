open! Import0
module Sexp = Sexp0

module Definitions (T : sig
    type (_, _) comparator
  end) =
struct
  open T

  module type S = sig
    type t
    type comparator_witness

    val comparator : (t, comparator_witness) comparator
  end

  module type S1 = sig
    type 'a t
    type comparator_witness

    val comparator : ('a t, comparator_witness) comparator
  end

  module type S_fc = sig
    type comparable_t

    include S with type t := comparable_t
  end

  module type Derived = sig
    type 'a t
    type !'cmp comparator_witness

    val comparator : ('a, 'cmp) comparator -> ('a t, 'cmp comparator_witness) comparator
  end

  module type Derived2 = sig
    type ('a, 'b) t
    type (!'cmp_a, !'cmp_b) comparator_witness

    val comparator
      :  ('a, 'cmp_a) comparator
      -> ('b, 'cmp_b) comparator
      -> (('a, 'b) t, ('cmp_a, 'cmp_b) comparator_witness) comparator
  end

  module type Derived_phantom = sig
    type ('a, 'b) t
    type !'cmp comparator_witness

    val comparator
      :  ('a, 'cmp) comparator
      -> (('a, _) t, 'cmp comparator_witness) comparator
  end

  module type Derived2_phantom = sig
    type ('a, 'b, 'c) t
    type (!'cmp_a, !'cmp_b) comparator_witness

    val comparator
      :  ('a, 'cmp_a) comparator
      -> ('b, 'cmp_b) comparator
      -> (('a, 'b, _) t, ('cmp_a, 'cmp_b) comparator_witness) comparator
  end
end

module type Comparator = sig
  type ('a, 'witness) t

  val compare : ('a, 'witness) t -> 'a -> 'a -> int
  val sexp_of_t : ('a, 'witness) t -> 'a -> Sexp.t

  module T : sig
    type ('a, 'b) comparator = ('a, 'b) t
  end

  include module type of struct
    include T
    include Definitions (T)
  end

  val make
    :  compare:('a -> 'a -> int)
    -> sexp_of_t:('a -> Sexp.t)
    -> (module S_fc with type comparable_t = 'a)

  module Poly : S1 with type 'a t = 'a

  module Module : sig
    type ('a, 'b) t = (module S with type t = 'a and type comparator_witness = 'b)
  end

  val of_module : ('a, 'b) Module.t -> ('a, 'b) t
  val to_module : ('a, 'b) t -> ('a, 'b) Module.t

  module S_to_S1 : functor (S : S) ->
    S1 with type 'a t = S.t with type comparator_witness = S.comparator_witness

  module Make : functor
      (M : sig
         type t

         include sig
           [@@@ocaml.warning "-32"]

           include Ppx_compare_lib.Comparable.S with type t := t

           val sexp_of_t : t -> Sexplib0.Sexp.t
         end
         [@@merlin.hide]
       end)
      -> S with type t := M.t

  module Make1 : functor
      (M : sig
         type 'a t

         val compare : 'a t -> 'a t -> int
         val sexp_of_t : _ t -> Sexp.t
       end)
      -> S1 with type 'a t := 'a M.t

  module Derived : functor
      (M : sig
         type 'a t

         include sig
           [@@@ocaml.warning "-32"]

           include Ppx_compare_lib.Comparable.S1 with type 'a t := 'a t

           val sexp_of_t : ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t
         end
         [@@merlin.hide]
       end)
      -> Derived with type 'a t := 'a M.t

  module Derived2 : functor
      (M : sig
         type ('a, 'b) t

         include sig
           [@@@ocaml.warning "-32"]

           include Ppx_compare_lib.Comparable.S2 with type ('a, 'b) t := ('a, 'b) t

           val sexp_of_t
             :  ('a -> Sexplib0.Sexp.t)
             -> ('b -> Sexplib0.Sexp.t)
             -> ('a, 'b) t
             -> Sexplib0.Sexp.t
         end
         [@@merlin.hide]
       end)
      -> Derived2 with type ('a, 'b) t := ('a, 'b) M.t

  module Derived_phantom : functor
      (M : sig
         type ('a, 'b) t

         val compare : ('a -> 'a -> int) -> ('a, 'b) t -> ('a, 'b) t -> int
         val sexp_of_t : ('a -> Sexp.t) -> ('a, _) t -> Sexp.t
       end)
      -> Derived_phantom with type ('a, 'b) t := ('a, 'b) M.t

  module Derived2_phantom : functor
      (M : sig
         type ('a, 'b, 'c) t

         val compare
           :  ('a -> 'a -> int)
           -> ('b -> 'b -> int)
           -> ('a, 'b, 'c) t
           -> ('a, 'b, 'c) t
           -> int

         val sexp_of_t : ('a -> Sexp.t) -> ('b -> Sexp.t) -> ('a, 'b, _) t -> Sexp.t
       end)
      -> Derived2_phantom with type ('a, 'b, 'c) t := ('a, 'b, 'c) M.t
end
