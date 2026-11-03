open! Import0
module Error := Error0
module Sexp := Sexp0
module Source_code_position := Source_code_position0

type 'a t = ('a, Error.t) Result.t

include sig
  [@@@ocaml.warning "-32"]

  val compare
    : 'a.
    ('a -> ('a[@merlin.hide]) -> int) -> 'a t -> ('a t[@merlin.hide]) -> int

  val equal
    : 'a.
    ('a -> ('a[@merlin.hide]) -> bool) -> 'a t -> ('a t[@merlin.hide]) -> bool

  val globalize : 'a. ('a -> 'a) -> 'a t -> 'a t

  val hash_fold_t
    : 'a.
    (Ppx_hash_lib.Std.Hash.state -> 'a -> Ppx_hash_lib.Std.Hash.state)
    -> Ppx_hash_lib.Std.Hash.state
    -> 'a t
    -> Ppx_hash_lib.Std.Hash.state

  val sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t
  val t_of_sexp : 'a. (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a t
  val t_sexp_grammar : 'a. 'a Sexplib0.Sexp_grammar.t -> 'a t Sexplib0.Sexp_grammar.t
end
[@@merlin.hide]

include Applicative.S with type 'a t := 'a t
include Invariant.S1 with type 'a t := 'a t
include Monad.S with type 'a t := 'a t

val is_ok : 'a. 'a t -> bool
val is_error : 'a. 'a t -> bool
val try_with : 'a. ?backtrace:bool -> (unit -> 'a) -> 'a t
val try_with_join : 'a. ?backtrace:bool -> (unit -> 'a t) -> 'a t
val ok : 'ok. 'ok t -> 'ok option
val ok_or_null : 'ok t -> 'ok or_null
val ok_exn : 'a. 'a t -> 'a
val of_exn : 'a. ?backtrace:[ `Get | `This of string ] -> exn -> 'a t

val of_exn_result
  : 'a.
  ?backtrace:[ `Get | `This of string ] -> ('a, exn) Result.t -> 'a t

val of_option : 'a. 'a option -> error:Error.t -> 'a t
val of_option_lazy : 'a. 'a option -> error:Error.t lazy_t -> 'a t
val of_option_lazy_sexp : 'a. 'a option -> error:Sexp.t lazy_t -> 'a t
val of_option_lazy_string : 'a. 'a option -> error:string lazy_t -> 'a t
val of_or_null : 'a or_null -> error:Error.t -> 'a t
val of_or_null_lazy : 'a or_null -> error:Error.t lazy_t -> 'a t
val of_or_null_lazy_sexp : 'a or_null -> error:Sexp.t lazy_t -> 'a t
val of_or_null_lazy_string : 'a or_null -> error:string lazy_t -> 'a t

val error
  : 'a 'b.
  ?here:Source_code_position.t -> ?strict:unit -> string -> 'a -> ('a -> Sexp.t) -> 'b t

val error_s : 'a. Sexp.t -> 'a t
val error_string : 'a. string -> 'a t
val errorf : 'a 'b. ('a, unit, string, 'b t) format4 -> 'a
val errorf_portable : 'a 'b. ('a, unit, string, unit -> 'b t) format4 -> 'a
val tag : 'a. 'a t -> tag:string -> 'a t
val tag_s : 'a. 'a t -> tag:Sexp.t -> 'a t
val tag_lazy : 'a. 'a t -> tag:string lazy_t -> 'a t
val tag_s_lazy : 'a. 'a t -> tag:Sexp.t lazy_t -> 'a t
val tag_arg : 'a 'b. 'a t -> string -> 'b -> ('b -> Sexp.t) -> 'a t
val unimplemented : 'a. string -> 'a t
val return : 'a. 'a -> 'a t
val bind : 'a 'b. 'a t -> f:('a -> 'b t) -> 'b t
val map : 'a 'b. 'a t -> f:('a -> 'b) -> 'b t
val iter : 'a. 'a t -> f:('a -> unit) -> unit
val iter_error : 'a. 'a t -> f:(Error.t -> unit) -> unit
val combine_errors : 'a. 'a t list -> 'a list t
val combine_errors_unit : unit t list -> unit t
val filter_ok_at_least_one : 'a. 'a t list -> 'a list t
val find_ok : 'a. 'a t list -> 'a t
val find_map_ok : 'a 'b. 'a list -> f:('a -> 'b t) -> 'b t

module Portable : sig
  module Sexp := Sexp0

  type 'a t = ('a, Error.Portable.t) Result.t

  include sig
    [@@@ocaml.warning "-32"]

    include Ppx_compare_lib.Comparable.S1 with type 'a t := 'a t
    include Ppx_compare_lib.Equal.S1 with type 'a t := 'a t

    val globalize : 'a. ('a -> 'a) -> 'a t -> 'a t

    include Sexplib0.Sexpable.S1 with type 'a t := 'a t
  end
  [@@merlin.hide]

  include Applicative.S with type 'a t := 'a t
  include Monad.S with type 'a t := 'a t

  val ok : 'ok t -> 'ok option
  val ok_exn : 'a t -> 'a

  val error
    : 'a 'b.
    ?here:Source_code_position0.t
    -> ?strict:unit
    -> string
    -> 'b
    -> ('b -> Sexp.t)
    -> 'a t

  val error_s : Sexp.t -> _ t
  val error_string : string -> _ t
  val tag : 'a t -> tag:string -> 'a t
  val tag_s : 'a t -> tag:Sexp.t -> 'a t
  val tag_arg : 'a 'b. 'a t -> string -> 'b -> ('b -> Sexp.t) -> 'a t
  val combine_errors : 'a t list -> 'a list t
  val combine_errors_unit : unit t list -> unit t
  val try_with : ?backtrace:bool -> (unit -> 'a) -> 'a t
  val try_with_join : ?backtrace:bool -> (unit -> 'a t) -> 'a t
  val errorf : ('a, unit, string, 'b t) format4 -> 'a
  val of_exn : ?backtrace:[ `Get | `This of string ] -> exn -> 'a t
  val of_exn_result : ?backtrace:[ `Get | `This of string ] -> ('a, exn) Result.t -> 'a t
end

val of_portable : 'a Portable.t -> 'a t
val to_portable : 'a t -> 'a Portable.t
val portabilize : 'a t -> 'a Portable.t
