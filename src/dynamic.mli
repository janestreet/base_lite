open! Import0

type 'a t = 'a Basement.Dynamic.t

val make : 'a -> 'a t
val get : 'a t -> 'a
val set_root : 'a t -> 'a -> unit
val with_temporarily : 'a 'b. 'a t -> 'a -> f:(unit -> 'b) -> 'b
