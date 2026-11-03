open! Import0

external ( |> ) : 'a 'b. 'a -> ('a -> 'b) -> 'b = "%revapply"
val const : 'a -> _ -> 'a
external ignore : 'a. 'a -> unit = "%ignore"
val non : ('a -> bool) -> 'a -> bool
val forever : (unit -> unit) -> exn
val apply_n_times : 'a. n:int -> ('a -> 'a) -> 'a -> 'a
external id : 'a. 'a -> 'a = "%identity"
val compose : ('b -> 'c) -> ('a -> 'b) -> 'a -> 'c
val flip : ('a -> 'b -> 'c) -> 'b -> 'a -> 'c
