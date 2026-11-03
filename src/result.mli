open! Import0
module Invariant := Invariant_intf.Definitions
module Either := Either0

type ('ok, 'err) t = ('ok, 'err) Stdlib.result =
  | Ok of 'ok
  | Error of 'err

include sig
  [@@@ocaml.warning "-32"]

  val sexp_of_t
    : 'ok 'err.
    ('ok -> Sexplib0.Sexp.t)
    -> ('err -> Sexplib0.Sexp.t)
    -> ('ok, 'err) t
    -> Sexplib0.Sexp.t

  val t_of_sexp
    : 'ok 'err.
    (Sexplib0.Sexp.t -> 'ok)
    -> (Sexplib0.Sexp.t -> 'err)
    -> Sexplib0.Sexp.t
    -> ('ok, 'err) t

  val t_sexp_grammar
    : 'ok 'err.
    'ok Sexplib0.Sexp_grammar.t
    -> 'err Sexplib0.Sexp_grammar.t
    -> ('ok, 'err) t Sexplib0.Sexp_grammar.t

  val compare
    : 'ok 'err.
    ('ok -> ('ok[@merlin.hide]) -> int)
    -> ('err -> ('err[@merlin.hide]) -> int)
    -> ('ok, 'err) t
    -> (('ok, 'err) t[@merlin.hide])
    -> int

  val equal
    : 'ok 'err.
    ('ok -> ('ok[@merlin.hide]) -> bool)
    -> ('err -> ('err[@merlin.hide]) -> bool)
    -> ('ok, 'err) t
    -> (('ok, 'err) t[@merlin.hide])
    -> bool

  val hash_fold_t
    : 'ok 'err.
    (Ppx_hash_lib.Std.Hash.state -> 'ok -> Ppx_hash_lib.Std.Hash.state)
    -> (Ppx_hash_lib.Std.Hash.state -> 'err -> Ppx_hash_lib.Std.Hash.state)
    -> Ppx_hash_lib.Std.Hash.state
    -> ('ok, 'err) t
    -> Ppx_hash_lib.Std.Hash.state

  val globalize
    : 'ok 'err.
    ('ok -> 'ok) -> ('err -> 'err) -> ('ok, 'err) t -> ('ok, 'err) t
end
[@@merlin.hide]

include Monad.S2 with type ('a, 'err) t := ('a, 'err) t
module Error : Monad.S2 with type ('err, 'a) t := ('a, 'err) t
include Invariant.S2 with type ('ok, 'err) t := ('ok, 'err) t

val fail : 'err -> (_, 'err) t
val failf : ('a, unit, string, (_, string) t) format4 -> 'a
val is_ok : 'ok 'err. ('ok, 'err) t -> bool
val is_error : 'ok 'err. ('ok, 'err) t -> bool
val ok : 'ok 'err. ('ok, 'err) t -> 'ok option
val ok_or_null : 'ok 'err. ('ok, 'err) t -> 'ok or_null
val ok_exn : 'ok. ('ok, exn) t -> 'ok
val ok_or_failwith : 'ok. ('ok, string) t -> 'ok
val error : 'ok 'err. ('ok, 'err) t -> 'err option
val error_or_null : 'ok 'err. ('ok, 'err) t -> 'err or_null
val of_option : 'ok 'err. 'ok option -> error:'err -> ('ok, 'err) t
val of_or_null : 'ok 'err. 'ok or_null -> error:'err -> ('ok, 'err) t
val of_option_or_thunk : 'ok 'err. 'ok option -> error:(unit -> 'err) -> ('ok, 'err) t
val iter : 'ok 'err. ('ok, 'err) t -> f:('ok -> unit) -> unit
val iter_error : 'ok 'err. ('ok, 'err) t -> f:('err -> unit) -> unit
val return : 'ok 'err. 'ok -> ('ok, 'err) t
val bind : 'a 'b 'err. ('a, 'err) t -> f:('a -> ('b, 'err) t) -> ('b, 'err) t
val map : 'a 'b 'err. ('a, 'err) t -> f:('a -> 'b) -> ('b, 'err) t
val map_error : 'ok 'err 'c. ('ok, 'err) t -> f:('err -> 'c) -> ('ok, 'c) t

val combine
  : 'ok1 'ok2 'ok3 'err.
  ('ok1, 'err) t
  -> ('ok2, 'err) t
  -> ok:('ok1 -> 'ok2 -> 'ok3)
  -> err:('err -> 'err -> 'err)
  -> ('ok3, 'err) t

val combine_errors : 'ok 'err. ('ok, 'err) t list -> ('ok list, 'err list) t
val combine_errors_unit : 'err. (unit, 'err) t list -> (unit, 'err list) t
val to_either : 'ok 'err. ('ok, 'err) t -> ('ok, 'err) Either.t
val of_either : 'ok 'err. ('ok, 'err) Either.t -> ('ok, 'err) t
val ok_if_true : 'err. bool -> error:'err -> (unit, 'err) t
val transpose_opt : 'ok 'err. ('ok option, 'err) t -> ('ok, 'err) t option
val try_with : 'a. (unit -> 'a) -> ('a, exn) t

module Export : sig
  type ('ok, 'err) _result = ('ok, 'err) t =
    | Ok of 'ok
    | Error of 'err

  val is_ok : 'ok 'err. ('ok, 'err) t -> bool
  val is_error : 'ok 'err. ('ok, 'err) t -> bool
end
