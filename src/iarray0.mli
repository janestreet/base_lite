open! Import0

type +'a t = 'a iarray

include sig
    type nonrec 'a t = 'a t

    include sig
      [@@@ocaml.warning "-32"]

      val equal
        : 'a.
        ('a -> ('a[@merlin.hide]) -> bool) -> 'a t -> ('a t[@merlin.hide]) -> bool

      val compare
        : 'a.
        ('a -> ('a[@merlin.hide]) -> int) -> 'a t -> ('a t[@merlin.hide]) -> int

      val sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t
    end
    [@@merlin.hide]
  end
  with type 'a t := 'a t

external unsafe_to_array__promise_no_mutation : 'a. 'a t -> 'a array = "%identity"
external unsafe_of_array__promise_no_mutation : 'a. 'a array -> 'a t = "%identity"

module O : sig
  external ( .:() ) : 'a. 'a t -> int -> 'a = "%array_safe_get"
end

external get : 'a. 'a t -> int -> 'a = "%array_safe_get"
external unsafe_get : 'a. 'a t -> int -> 'a = "%array_unsafe_get"
external length : 'a. 'a t -> int = "%array_length"
val init : int -> f:(int -> 'a) -> 'a t
val map : 'a t -> f:('a -> 'b) -> 'b t
