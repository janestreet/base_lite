open! Import0
module Sexp := Sexp0

type 'a t = 'a Basement.Portable_lazy.t

val from_val : 'a. 'a -> 'a t
val from_fun : 'a. (unit -> 'a) -> 'a t
val from_fun_fixed : 'a. ('a t -> 'a) -> 'a t
val force : 'a. 'a t -> 'a
val map : 'a 'b. 'a t -> f:('a -> 'b) -> 'b t
val bind : 'a 'b. 'a t -> f:('a -> 'b t) -> 'b t

module Let_syntax : sig
  val return : 'a. 'a -> 'a t
  val ( >>| ) : 'a 'b. 'a t -> ('a -> 'b) -> 'b t
  val ( >>= ) : 'a 'b. 'a t -> ('a -> 'b t) -> 'b t

  module Let_syntax : sig
    val return : 'a. 'a -> 'a t
    val map : 'a 'b. 'a t -> f:('a -> 'b) -> 'b t
    val bind : 'a 'b. 'a t -> f:('a -> 'b t) -> 'b t
    val both : 'a 'b. 'a t -> 'b t -> ('a * 'b) t

    module Open_on_rhs : sig end
  end
end

val compare : 'a. ('a -> 'a -> int) -> 'a t -> 'a t -> int
val equal : 'a. ('a -> 'a -> bool) -> 'a t -> 'a t -> bool
val sexp_of_t : 'a. ('a -> Sexp.t) -> 'a t -> Sexp.t
val t_of_sexp : 'a. (Sexp.t -> 'a) -> Sexp.t -> 'a t
val t_sexp_grammar : 'a. 'a Sexplib0.Sexp_grammar.t -> 'a t Sexplib0.Sexp_grammar.t
val hash_fold_t : 'a. (Hash.state -> 'a -> Hash.state) -> Hash.state -> 'a t -> Hash.state
val globalize : 'a 'b. 'b -> 'a t -> 'a t
val is_val : 'a. 'a t -> bool
val peek : 'a. 'a t -> 'a or_null
val peek_opt : 'a. 'a t -> 'a option
