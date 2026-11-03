open! Import0

module Definitions = struct
  module type S3_indexed_kernel = sig
    type ('a, 'i, 'j, 'p, 'q) t

    val return : 'a 'i 'p 'q. 'a -> ('a, 'i, 'i, 'p, 'q) t

    val map
      : 'a 'b 'i 'j 'p 'q.
      ('a, 'i, 'j, 'p, 'q) t -> f:('a -> 'b) -> ('b, 'i, 'j, 'p, 'q) t

    val bind
      : 'a 'b 'i 'j 'k 'p 'q.
      ('a, 'i, 'j, 'p, 'q) t -> f:('a -> ('b, 'j, 'k, 'p, 'q) t) -> ('b, 'i, 'k, 'p, 'q) t

    val join
      : 'a 'i 'j 'k 'p 'q.
      (('a, 'j, 'k, 'p, 'q) t, 'i, 'j, 'p, 'q) t -> ('a, 'i, 'k, 'p, 'q) t

    val ignore_m : 'a 'i 'j 'p 'q. ('a, 'i, 'j, 'p, 'q) t -> (unit, 'i, 'j, 'p, 'q) t
    val all : 'a 'i 'p 'q. ('a, 'i, 'i, 'p, 'q) t list -> ('a list, 'i, 'i, 'p, 'q) t
    val all_unit : 'i 'p 'q. (unit, 'i, 'i, 'p, 'q) t list -> (unit, 'i, 'i, 'p, 'q) t
  end

  module type S_kernel = sig
    type 'a t

    include S3_indexed_kernel with type ('a, _, _, _, _) t := 'a t
  end

  module type S2_kernel = sig
    type ('a, 'p) t

    include S3_indexed_kernel with type ('a, _, _, 'p, _) t := ('a, 'p) t
  end

  module type S3_kernel = sig
    type ('a, 'p, 'q) t

    include S3_indexed_kernel with type ('a, _, _, 'p, 'q) t := ('a, 'p, 'q) t
  end

  module type S_indexed_kernel = sig
    type ('a, 'i, 'j) t

    include S3_indexed_kernel with type ('a, 'i, 'j, _, _) t := ('a, 'i, 'j) t
  end

  module type Infix3_indexed = sig
    type ('a, 'i, 'j, 'p, 'q) t

    val ( >>= )
      : 'a 'b 'i 'j 'k 'p 'q.
      ('a, 'i, 'j, 'p, 'q) t -> ('a -> ('b, 'j, 'k, 'p, 'q) t) -> ('b, 'i, 'k, 'p, 'q) t

    val ( >>| )
      : 'a 'b 'i 'j 'p 'q.
      ('a, 'i, 'j, 'p, 'q) t -> ('a -> 'b) -> ('b, 'i, 'j, 'p, 'q) t
  end

  module type Infix = sig
    type 'a t

    include Infix3_indexed with type ('a, _, _, _, _) t := 'a t
  end

  module type Infix2 = sig
    type ('a, 'p) t

    include Infix3_indexed with type ('a, _, _, 'p, _) t := ('a, 'p) t
  end

  module type Infix3 = sig
    type ('a, 'p, 'q) t

    include Infix3_indexed with type ('a, _, _, 'p, 'q) t := ('a, 'p, 'q) t
  end

  module type Infix_indexed = sig
    type ('a, 'i, 'j) t

    include Infix3_indexed with type ('a, 'i, 'j, _, _) t := ('a, 'i, 'j) t
  end

  module type Syntax3_indexed = sig
    type ('a, 'i, 'j, 'p, 'q) t

    module Let_syntax : sig
      val return : 'a 'i 'p 'q. 'a -> ('a, 'i, 'i, 'p, 'q) t

      include Infix3_indexed with type ('a, 'i, 'j, 'p, 'q) t := ('a, 'i, 'j, 'p, 'q) t

      module Let_syntax : sig
        val return : 'a 'i 'p 'q. 'a -> ('a, 'i, 'i, 'p, 'q) t

        val bind
          : 'a 'b 'i 'j 'k 'p 'q.
          ('a, 'i, 'j, 'p, 'q) t
          -> f:('a -> ('b, 'j, 'k, 'p, 'q) t)
          -> ('b, 'i, 'k, 'p, 'q) t

        val map
          : 'a 'b 'i 'j 'p 'q.
          ('a, 'i, 'j, 'p, 'q) t -> f:('a -> 'b) -> ('b, 'i, 'j, 'p, 'q) t

        val both
          : 'a 'b 'i 'j 'k 'p 'q.
          ('a, 'i, 'j, 'p, 'q) t -> ('b, 'j, 'k, 'p, 'q) t -> ('a * 'b, 'i, 'k, 'p, 'q) t

        module Open_on_rhs : sig end
      end
    end
  end

  module type Syntax = sig
    type 'a t

    include Syntax3_indexed with type ('a, _, _, _, _) t := 'a t
  end

  module type Syntax2 = sig
    type ('a, 'p) t

    include Syntax3_indexed with type ('a, _, _, 'p, _) t := ('a, 'p) t
  end

  module type Syntax3 = sig
    type ('a, 'p, 'q) t

    include Syntax3_indexed with type ('a, _, _, 'p, 'q) t := ('a, 'p, 'q) t
  end

  module type Syntax_indexed = sig
    type ('a, 'i, 'j) t

    include Syntax3_indexed with type ('a, 'i, 'j, _, _) t := ('a, 'i, 'j) t
  end

  module type S3_indexed_without_syntax = sig
    include S3_indexed_kernel
    include Infix3_indexed with type ('a, 'i, 'j, 'p, 'q) t := ('a, 'i, 'j, 'p, 'q) t

    module Monad_infix :
      Infix3_indexed with type ('a, 'i, 'j, 'p, 'q) t := ('a, 'i, 'j, 'p, 'q) t
  end

  module type S_without_syntax = sig
    type 'a t

    include S3_indexed_without_syntax with type ('a, _, _, _, _) t := 'a t
  end

  module type S2_without_syntax = sig
    type ('a, 'p) t

    include S3_indexed_without_syntax with type ('a, _, _, 'p, _) t := ('a, 'p) t
  end

  module type S3_without_syntax = sig
    type ('a, 'p, 'q) t

    include S3_indexed_without_syntax with type ('a, _, _, 'p, 'q) t := ('a, 'p, 'q) t
  end

  module type S_indexed_without_syntax = sig
    type ('a, 'i, 'j) t

    include S3_indexed_without_syntax with type ('a, 'i, 'j, _, _) t := ('a, 'i, 'j) t
  end

  module type S3_indexed = sig
    include S3_indexed_without_syntax
    include Syntax3_indexed with type ('a, 'i, 'j, 'p, 'q) t := ('a, 'i, 'j, 'p, 'q) t
  end

  module type S = sig
    type 'a t

    include S3_indexed with type ('a, _, _, _, _) t := 'a t
  end

  module type S2 = sig
    type ('a, 'p) t

    include S3_indexed with type ('a, _, _, 'p, _) t := ('a, 'p) t
  end

  module type S3 = sig
    type ('a, 'p, 'q) t

    include S3_indexed with type ('a, _, _, 'p, 'q) t := ('a, 'p, 'q) t
  end

  module type S_indexed = sig
    type ('a, 'i, 'j) t

    include S3_indexed with type ('a, 'i, 'j, _, _) t := ('a, 'i, 'j) t
  end

  module type Basic3_indexed = sig
    type ('a, 'i, 'j, 'p, 'q) t

    val return : 'a 'i 'p 'q. 'a -> ('a, 'i, 'i, 'p, 'q) t

    val map
      : 'a 'b 'i 'j 'p 'q.
      [ `Define_using_bind
      | `Custom of ('a, 'i, 'j, 'p, 'q) t -> f:('a -> 'b) -> ('b, 'i, 'j, 'p, 'q) t
      ]

    val bind
      : 'a 'b 'i 'j 'k 'p 'q.
      ('a, 'i, 'j, 'p, 'q) t -> f:('a -> ('b, 'j, 'k, 'p, 'q) t) -> ('b, 'i, 'k, 'p, 'q) t
  end

  module type Basic = sig
    type 'a t

    include Basic3_indexed with type ('a, _, _, _, _) t := 'a t
  end

  module type Basic2 = sig
    type ('a, 'p) t

    include Basic3_indexed with type ('a, _, _, 'p, _) t := ('a, 'p) t
  end

  module type Basic3 = sig
    type ('a, 'p, 'q) t

    include Basic3_indexed with type ('a, _, _, 'p, 'q) t := ('a, 'p, 'q) t
  end

  module type Basic_indexed = sig
    type ('a, 'i, 'j) t

    include Basic3_indexed with type ('a, 'i, 'j, _, _) t := ('a, 'i, 'j) t
  end
end

module type Monad = sig
  include module type of struct
    include Definitions
  end

  module Ident : S with type 'a t = 'a
  module Make : functor (X : Basic) -> S with type 'a t := 'a X.t
  module Make2 : functor (X : Basic2) -> S2 with type ('a, 'p) t := ('a, 'p) X.t
  module Make3 : functor (X : Basic3) -> S3 with type ('a, 'p, 'q) t := ('a, 'p, 'q) X.t

  module Make_indexed : functor (X : Basic_indexed) ->
    S_indexed with type ('a, 'i, 'j) t := ('a, 'i, 'j) X.t

  module Of_monad : functor
      (Monad : S)
      (M : sig
         type 'a t

         val to_monad : 'a. 'a t -> 'a Monad.t
         val of_monad : 'a. 'a Monad.t -> 'a t
       end)
      -> S with type 'a t := 'a M.t

  module Of_monad2 : functor
      (Monad : S2)
      (M : sig
         type ('a, 'p) t

         val to_monad : 'a 'p. ('a, 'p) t -> ('a, 'p) Monad.t
         val of_monad : 'a 'p. ('a, 'p) Monad.t -> ('a, 'p) t
       end)
      -> S2 with type ('a, 'p) t := ('a, 'p) M.t

  module Of_monad3 : functor
      (Monad : S3)
      (M : sig
         type ('a, 'p, 'q) t

         val to_monad : 'a 'p 'q. ('a, 'p, 'q) t -> ('a, 'p, 'q) Monad.t
         val of_monad : 'a 'p 'q. ('a, 'p, 'q) Monad.t -> ('a, 'p, 'q) t
       end)
      -> S3 with type ('a, 'p, 'q) t := ('a, 'p, 'q) M.t

  module Of_monad_indexed : functor
      (Monad : S_indexed)
      (M : sig
         type ('a, 'i, 'j) t

         val to_monad : 'a 'i 'j. ('a, 'i, 'j) t -> ('a, 'i, 'j) Monad.t
         val of_monad : 'a 'i 'j. ('a, 'i, 'j) Monad.t -> ('a, 'i, 'j) t
       end)
      -> S_indexed with type ('a, 'i, 'j) t := ('a, 'i, 'j) M.t
end
