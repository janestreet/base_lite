open! Import0

type 'a t = 'a -> 'a -> bool
type 'a equal = 'a t

module type S = sig
  type t

  val equal : t equal
end

module type S1 = sig
  type 'a t

  val equal : 'a equal -> 'a t equal
end

module type S2 = sig
  type ('a, 'b) t

  val equal : 'a equal -> 'b equal -> ('a, 'b) t equal
end

module type S3 = sig
  type ('a, 'b, 'c) t

  val equal : 'a equal -> 'b equal -> 'c equal -> ('a, 'b, 'c) t equal
end
