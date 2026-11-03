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
