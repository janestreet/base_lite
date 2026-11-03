open! Import0

type -'a return = private { return : 'b. 'a -> 'b } [@@unboxed]

val with_return : 'a. ('a return -> 'a) -> 'a
val with_return_option : 'a. ('a return -> unit) -> 'a option
val prepend : 'a 'b. 'a return -> f:('b -> 'a) -> 'b return
