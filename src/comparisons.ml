open! Import0

module type Infix = sig
  type t

  val ( >= ) : t -> t -> bool
  val ( <= ) : t -> t -> bool
  val ( = ) : t -> t -> bool
  val ( > ) : t -> t -> bool
  val ( < ) : t -> t -> bool
  val ( <> ) : t -> t -> bool
end

module type S = sig
  include Infix

  val equal : t -> t -> bool
  val compare : t -> t -> int
  val min : t -> t -> t
  val max : t -> t -> t
end

module type Infix_with_local_opt = sig
  type t

  external ( < ) : t -> t -> bool = "%lessthan"
  external ( <= ) : t -> t -> bool = "%lessequal"
  external ( <> ) : t -> t -> bool = "%notequal"
  external ( = ) : t -> t -> bool = "%equal"
  external ( > ) : t -> t -> bool = "%greaterthan"
  external ( >= ) : t -> t -> bool = "%greaterequal"
end

module type S_with_local_opt = sig
  include Infix_with_local_opt

  external equal : t -> t -> bool = "%equal"
  external compare : t -> t -> int = "%compare"
  val min : t -> t -> t
  val max : t -> t -> t
end

module type Infix_with_zero_alloc = sig
  type t

  val ( >= ) : t -> t -> bool
  val ( <= ) : t -> t -> bool
  val ( = ) : t -> t -> bool
  val ( > ) : t -> t -> bool
  val ( < ) : t -> t -> bool
  val ( <> ) : t -> t -> bool
end

module type S_with_zero_alloc = sig
  include Infix_with_zero_alloc

  val equal : t -> t -> bool
  val compare : t -> t -> int
  val min : t -> t -> t
  val max : t -> t -> t
end

module type Infix_with_zero_alloc_strict = sig
  type t

  val ( >= ) : t -> t -> bool
  val ( <= ) : t -> t -> bool
  val ( = ) : t -> t -> bool
  val ( > ) : t -> t -> bool
  val ( < ) : t -> t -> bool
  val ( <> ) : t -> t -> bool
end

module type S_with_zero_alloc_strict = sig
  include Infix_with_zero_alloc_strict

  val equal : t -> t -> bool
  val compare : t -> t -> int
  val min : t -> t -> t
  val max : t -> t -> t
end
