open! Import0
module Sexp = Sexp0

type 'a inv = 'a -> unit

module Definitions = struct
  type 'a t = 'a inv

  module type S = sig
    type t

    val invariant : t inv
  end

  module type S1 = sig
    type 'a t

    val invariant : 'a inv -> 'a t inv
  end

  module type S2 = sig
    type ('a, 'b) t

    val invariant : 'a inv -> 'b inv -> ('a, 'b) t inv
  end

  module type S3 = sig
    type ('a, 'b, 'c) t

    val invariant : 'a inv -> 'b inv -> 'c inv -> ('a, 'b, 'c) t inv
  end
end

module type Invariant = sig
  include module type of struct
    include Definitions
  end

  val invariant
    : 'a.
    ?here:Stdlib.Lexing.position -> 'a -> ('a -> Sexp.t) -> (unit -> unit) -> unit

  val check_field : 'a 'b. 'a -> 'b t -> ('a, 'b) Field.t -> unit
end
