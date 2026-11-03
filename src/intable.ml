open! Import0

module type S = sig
  type t

  val of_int_exn : int -> t
  val to_int_exn : t -> int
end

module type S_with_zero_alloc = sig
  type t

  val of_int_exn : int -> t
  val to_int_exn : t -> int
end
