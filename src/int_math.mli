open! Import0
open Int_intf.Definitions

module type Make_arg = sig
  type t

  val globalize : t -> t

  include Floatable.S_local_input with type t := t
  include Stringable.S with type t := t

  val ( + ) : t -> t -> t
  val ( - ) : t -> t -> t
  val ( * ) : t -> t -> t
  val ( / ) : t -> t -> t
  val ( ~- ) : t -> t
  val ( <> ) : t -> t -> bool
  val ( <= ) : t -> t -> bool
  val ( >= ) : t -> t -> bool
  val ( = ) : t -> t -> bool
  val ( < ) : t -> t -> bool
  val ( > ) : t -> t -> bool
  val abs : t -> t
  val neg : t -> t
  val zero : t
  val of_int_exn : int -> t
  val rem : t -> t -> t
end

module Make : functor (X : Make_arg) -> sig
  val ( % ) : X.t -> X.t -> X.t
  val ( /% ) : X.t -> X.t -> X.t
  val ( // ) : X.t -> X.t -> float

  include Round with type t := X.t
end

module Private : sig
  val int_pow : int -> int -> int
  val int64_pow : int64 -> int64 -> int64
  val int63_pow_on_int64 : int64 -> int64 -> int64

  module Pow_overflow_bounds = Pow_overflow_bounds
end
