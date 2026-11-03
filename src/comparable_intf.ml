open! Import0
module Error = Error0
module Sign = Sign0

module Definitions = struct
  module type Infix = Comparisons.Infix
  module type Infix_with_zero_alloc = Comparisons.Infix_with_zero_alloc
  module type Comparisons = Comparisons.S
  module type Comparisons_with_zero_alloc = Comparisons.S_with_zero_alloc

  module type With_compare = sig
    type 'a reversed = 'a
    type ('a, 'b) compare_fn := 'a -> 'a -> 'b
    type ('a, 'b) fn := 'a -> 'b
    type 'a select_fn := 'a -> 'a -> 'a

    val lexicographic : 'a. ('a, int) compare_fn list -> ('a, int) compare_fn

    val lift
      : 'a 'b 'result.
      ('a, 'result) compare_fn -> f:('b, 'a) fn -> ('b, 'result) compare_fn

    val reverse : 'a 'result. ('a, 'result) compare_fn -> ('a, 'result) compare_fn
    val compare_reversed : 'a. ('a, int) compare_fn -> ('a reversed, int) compare_fn
    val equal : 'a. ('a, int) compare_fn -> ('a, bool) compare_fn
    val max : 'a. ('a, int) compare_fn -> 'a select_fn
    val min : 'a. ('a, int) compare_fn -> 'a select_fn
  end

  module type Using_comparator_arg = sig
    type t

    include Comparator.S with type t := t
  end

  module type With_zero = sig
    type t

    val is_positive : t -> bool
    val is_non_negative : t -> bool
    val is_negative : t -> bool
    val is_non_positive : t -> bool
    val sign : t -> Sign.t
  end

  module type S = sig
    type t

    include Comparisons with type t := t

    val ascending : t -> t -> int
    val descending : t -> t -> int
    val between : t -> low:t -> high:t -> bool
    val clamp_exn : t -> min:t -> max:t -> t
    val clamp : t -> min:t -> max:t -> (t, Error.t) Result.t

    include Comparator.S with type t := t
  end
end

module type Comparable = sig
  include module type of struct
    include Definitions
  end

  include With_compare

  module Infix : functor
      (T : sig
         type t

         include sig
           [@@@ocaml.warning "-32"]

           include Ppx_compare_lib.Comparable.S with type t := t
         end
         [@@merlin.hide]
       end)
      -> Infix with type t := T.t

  module Infix_with_zero_alloc : functor
      (T : sig
         type t

         include sig
           [@@@ocaml.warning "-32"]

           val compare : t -> (t[@merlin.hide]) -> int
         end
         [@@merlin.hide]
       end)
      -> Infix_with_zero_alloc with type t := T.t

  module Comparisons : functor
      (T : sig
         type t

         include sig
           [@@@ocaml.warning "-32"]

           include Ppx_compare_lib.Comparable.S with type t := t
         end
         [@@merlin.hide]
       end)
      -> Comparisons with type t := T.t

  module Comparisons_with_zero_alloc : functor
      (T : sig
         type t

         include sig
           [@@@ocaml.warning "-32"]

           val compare : t -> (t[@merlin.hide]) -> int
         end
         [@@merlin.hide]
       end)
      -> Comparisons_with_zero_alloc with type t := T.t

  module Inherit : functor
      (C : sig
         type t

         include sig
           [@@@ocaml.warning "-32"]

           include Ppx_compare_lib.Comparable.S with type t := t
         end
         [@@merlin.hide]
       end)
      (T : sig
         type t

         include sig
           [@@@ocaml.warning "-32"]

           val sexp_of_t : t -> Sexplib0.Sexp.t
         end
         [@@merlin.hide]

         val component : t -> C.t
       end)
      -> S with type t := T.t

  module Make : functor
      (T : sig
         type t

         include sig
           [@@@ocaml.warning "-32"]

           include Ppx_compare_lib.Comparable.S with type t := t

           val sexp_of_t : t -> Sexplib0.Sexp.t
         end
         [@@merlin.hide]
       end)
      -> S with type t := T.t

  module Make_using_comparator : functor
      (T : sig
         type t

         include sig
           [@@@ocaml.warning "-32"]

           val sexp_of_t : t -> Sexplib0.Sexp.t
         end
         [@@merlin.hide]

         include Using_comparator_arg with type t := t
       end)
      -> S with type t := T.t with type comparator_witness := T.comparator_witness

  module Poly : functor
      (T : sig
         type t

         include sig
           [@@@ocaml.warning "-32"]

           val sexp_of_t : t -> Sexplib0.Sexp.t
         end
         [@@merlin.hide]
       end)
      -> S with type t := T.t

  module With_zero : functor
      (T : sig
         type t

         include sig
           [@@@ocaml.warning "-32"]

           include Ppx_compare_lib.Comparable.S with type t := t

           val sexp_of_t : t -> Sexplib0.Sexp.t
         end
         [@@merlin.hide]

         val zero : t
       end)
      -> sig
    include With_zero with type t := T.t
  end
end
