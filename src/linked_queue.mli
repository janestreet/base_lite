open! Import0
include Queue.S with type 'a t = 'a Stdlib.Queue.t

val create : unit -> _ t
val transfer : src:'a t -> dst:'a t -> unit
