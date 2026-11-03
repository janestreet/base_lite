open! Import0

module Definitions = struct
  module type S3_kernel = sig
    type ('a, 'p, 'q) t

    val return : 'a 'p 'q. 'a -> ('a, 'p, 'q) t
    val apply : 'a 'b 'p 'q. ('a -> 'b, 'p, 'q) t -> ('a, 'p, 'q) t -> ('b, 'p, 'q) t
    val both : 'a 'b 'p 'q. ('a, 'p, 'q) t -> ('b, 'p, 'q) t -> ('a * 'b, 'p, 'q) t
    val map : 'a 'b 'p 'q. ('a, 'p, 'q) t -> f:('a -> 'b) -> ('b, 'p, 'q) t

    val map2
      : 'a 'b 'c 'p 'q.
      ('a, 'p, 'q) t -> ('b, 'p, 'q) t -> f:('a -> 'b -> 'c) -> ('c, 'p, 'q) t

    val map3
      : 'a 'b 'c 'd 'p 'q.
      ('a, 'p, 'q) t
      -> ('b, 'p, 'q) t
      -> ('c, 'p, 'q) t
      -> f:('a -> 'b -> 'c -> 'd)
      -> ('d, 'p, 'q) t

    val all : 'a 'p 'q. ('a, 'p, 'q) t list -> ('a list, 'p, 'q) t
    val all_unit : 'p 'q. (unit, 'p, 'q) t list -> (unit, 'p, 'q) t
  end

  module type S2_kernel = sig
    type ('a, 'p) t

    include S3_kernel with type ('a, 'p, _) t := ('a, 'p) t
  end

  module type S_kernel = sig
    type 'a t

    include S3_kernel with type ('a, _, _) t := 'a t
  end

  module type Applicative_infix3 = sig
    type ('a, 'p, 'q) t

    val ( <*> ) : 'a 'b 'p 'q. ('a -> 'b, 'p, 'q) t -> ('a, 'p, 'q) t -> ('b, 'p, 'q) t
    val ( <* ) : 'a 'p 'q. ('a, 'p, 'q) t -> (unit, 'p, 'q) t -> ('a, 'p, 'q) t
    val ( *> ) : 'a 'p 'q. (unit, 'p, 'q) t -> ('a, 'p, 'q) t -> ('a, 'p, 'q) t
    val ( >>| ) : 'a 'b 'p 'q. ('a, 'p, 'q) t -> ('a -> 'b) -> ('b, 'p, 'q) t
  end

  module type Applicative_infix2 = sig
    type ('a, 'p) t

    include Applicative_infix3 with type ('a, 'p, _) t := ('a, 'p) t
  end

  module type Applicative_infix = sig
    type 'a t

    include Applicative_infix3 with type ('a, _, _) t := 'a t
  end

  module type S3 = sig
    type ('a, 'p, 'q) t

    include S3_kernel with type ('a, 'p, 'q) t := ('a, 'p, 'q) t
    include Applicative_infix3 with type ('a, 'p, 'q) t := ('a, 'p, 'q) t

    module Applicative_infix :
      Applicative_infix3 with type ('a, 'p, 'q) t := ('a, 'p, 'q) t
  end

  module type S2 = sig
    type ('a, 'p) t

    include S3 with type ('a, 'p, _) t := ('a, 'p) t
  end

  module type S = sig
    type 'a t

    include S3 with type ('a, _, _) t := 'a t
  end

  module type Let_syntax3 = sig
    type ('a, 'p, 'q) t

    module Open_on_rhs_intf : sig
      module type S
    end

    module Let_syntax : sig
      val return : 'a 'p 'q. 'a -> ('a, 'p, 'q) t

      include Applicative_infix3 with type ('a, 'p, 'q) t := ('a, 'p, 'q) t

      module Let_syntax : sig
        val return : 'a 'p 'q. 'a -> ('a, 'p, 'q) t
        val map : 'a 'b 'p 'q. ('a, 'p, 'q) t -> f:('a -> 'b) -> ('b, 'p, 'q) t
        val both : 'a 'b 'p 'q. ('a, 'p, 'q) t -> ('b, 'p, 'q) t -> ('a * 'b, 'p, 'q) t

        module Open_on_rhs : Open_on_rhs_intf.S
      end
    end
  end

  module type Let_syntax2 = sig
    type ('a, 'p) t

    include Let_syntax3 with type ('a, 'p, _) t := ('a, 'p) t
  end

  module type Let_syntax = sig
    type 'a t

    include Let_syntax3 with type ('a, _, _) t := 'a t
  end

  module type Lazy_applicative = sig
    include S

    val of_thunk : 'a. (unit -> 'a t) -> 'a t
  end

  module type For_let_syntax3 = sig
    type ('a, 'p, 'q) t

    val return : 'a 'p 'q. 'a -> ('a, 'p, 'q) t
    val map : 'a 'b 'p 'q. ('a, 'p, 'q) t -> f:('a -> 'b) -> ('b, 'p, 'q) t
    val both : 'a 'b 'p 'q. ('a, 'p, 'q) t -> ('b, 'p, 'q) t -> ('a * 'b, 'p, 'q) t

    include Applicative_infix3 with type ('a, 'p, 'q) t := ('a, 'p, 'q) t
  end

  module type For_let_syntax2 = sig
    type ('a, 'p) t

    include For_let_syntax3 with type ('a, 'p, _) t := ('a, 'p) t
  end

  module type For_let_syntax = sig
    type 'a t

    include For_let_syntax3 with type ('a, _, _) t := 'a t
  end

  module type Basic3_using_map2 = sig
    type ('a, 'p, 'q) t

    val return : 'a 'p 'q. 'a -> ('a, 'p, 'q) t

    val map2
      : 'a 'b 'c 'p 'q.
      ('a, 'p, 'q) t -> ('b, 'p, 'q) t -> f:('a -> 'b -> 'c) -> ('c, 'p, 'q) t

    val map
      : 'a 'b 'p 'q.
      [ `Define_using_map2 | `Custom of ('a, 'p, 'q) t -> f:('a -> 'b) -> ('b, 'p, 'q) t ]
  end

  module type Basic_using_map2 = sig
    type 'a t

    include Basic3_using_map2 with type ('a, _, _) t := 'a t
  end

  module type Basic2_using_map2 = sig
    type ('a, 'p) t

    include Basic3_using_map2 with type ('a, 'p, _) t := ('a, 'p) t
  end

  module type Basic3 = sig
    type ('a, 'p, 'q) t

    val return : 'a 'p 'q. 'a -> ('a, 'p, 'q) t
    val apply : 'a 'b 'p 'q. ('a -> 'b, 'p, 'q) t -> ('a, 'p, 'q) t -> ('b, 'p, 'q) t

    val map
      : 'a 'b 'p 'q.
      [ `Define_using_apply
      | `Custom of ('a, 'p, 'q) t -> f:('a -> 'b) -> ('b, 'p, 'q) t
      ]
  end

  module type Basic = sig
    type 'a t

    include Basic3 with type ('a, _, _) t := 'a t
  end

  module type Basic2 = sig
    type ('a, 'p) t

    include Basic3 with type ('a, 'p, _) t := ('a, 'p) t
  end
end

module type Applicative = sig
  include module type of struct
    include Definitions
  end

  module Ident : S with type 'a t = 'a
  module Make : functor (X : Basic) -> S with type 'a t := 'a X.t
  module Make2 : functor (X : Basic2) -> S2 with type ('a, 'p) t := ('a, 'p) X.t
  module Make3 : functor (X : Basic3) -> S3 with type ('a, 'p, 'q) t := ('a, 'p, 'q) X.t
  module Make_using_map2 : functor (X : Basic_using_map2) -> S with type 'a t := 'a X.t

  module Make2_using_map2 : functor (X : Basic2_using_map2) ->
    S2 with type ('a, 'p) t := ('a, 'p) X.t

  module Make3_using_map2 : functor (X : Basic3_using_map2) ->
    S3 with type ('a, 'p, 'q) t := ('a, 'p, 'q) X.t

  module Of_monad : functor (M : Monad.S) -> S with type 'a t := 'a M.t
  module Of_monad2 : functor (M : Monad.S2) -> S2 with type ('a, 'p) t := ('a, 'p) M.t

  module Of_monad3 : functor (M : Monad.S3) ->
    S3 with type ('a, 'p, 'q) t := ('a, 'p, 'q) M.t

  module Compose : functor (Inner : S) (Outer : S) ->
    S with type 'a t = 'a Inner.t Outer.t

  module Pair : functor (Fst : S) (Snd : S) -> S with type 'a t = 'a Fst.t * 'a Snd.t

  module Make_let_syntax : functor
      (X : sig
         include For_let_syntax
       end)
      (Intf : sig
         module type S
       end)
      (Impl : Intf.S)
      -> sig
      include Let_syntax
    end
    with type 'a t := 'a X.t
    with module Open_on_rhs_intf := Intf

  module Make_let_syntax2 : functor
      (X : sig
         include For_let_syntax2
       end)
      (Intf : sig
         module type S
       end)
      (Impl : Intf.S)
      -> sig
      include Let_syntax2
    end
    with type ('a, 'p) t := ('a, 'p) X.t
    with module Open_on_rhs_intf := Intf

  module Make_let_syntax3 : functor
      (X : sig
         include For_let_syntax3
       end)
      (Intf : sig
         module type S
       end)
      (Impl : Intf.S)
      -> sig
      include Let_syntax3
    end
    with type ('a, 'p, 'q) t := ('a, 'p, 'q) X.t
    with module Open_on_rhs_intf := Intf
end
