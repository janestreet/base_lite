open! Import0

module type S = sig
  type t

  val hash_fold_t : Hash.state -> t -> Hash.state
end

module type S1 = sig
  type 'a t

  val hash_fold_t : (Hash.state -> 'a -> Hash.state) -> Hash.state -> 'a t -> Hash.state
end
