type ('f, 's) t =
  | First of 'f
  | Second of 's

include sig
  [@@@ocaml.warning "-32"]

  val compare
    : 'f 's.
    ('f -> ('f[@merlin.hide]) -> int)
    -> ('s -> ('s[@merlin.hide]) -> int)
    -> ('f, 's) t
    -> (('f, 's) t[@merlin.hide])
    -> int

  val sexp_of_t
    : 'f 's.
    ('f -> Sexplib0.Sexp.t) -> ('s -> Sexplib0.Sexp.t) -> ('f, 's) t -> Sexplib0.Sexp.t

  val t_of_sexp
    : 'f 's.
    (Sexplib0.Sexp.t -> 'f) -> (Sexplib0.Sexp.t -> 's) -> Sexplib0.Sexp.t -> ('f, 's) t

  val t_sexp_grammar
    : 'f 's.
    'f Sexplib0.Sexp_grammar.t
    -> 's Sexplib0.Sexp_grammar.t
    -> ('f, 's) t Sexplib0.Sexp_grammar.t
end
[@@merlin.hide]

include sig
    type nonrec ('f, 's) t = ('f, 's) t =
      | First of 'f
      | Second of 's

    include sig
      [@@@ocaml.warning "-32"]

      val globalize : 'f 's. ('f -> 'f) -> ('s -> 's) -> ('f, 's) t -> ('f, 's) t

      val hash_fold_t
        : 'f 's.
        (Ppx_hash_lib.Std.Hash.state -> 'f -> Ppx_hash_lib.Std.Hash.state)
        -> (Ppx_hash_lib.Std.Hash.state -> 's -> Ppx_hash_lib.Std.Hash.state)
        -> Ppx_hash_lib.Std.Hash.state
        -> ('f, 's) t
        -> Ppx_hash_lib.Std.Hash.state
    end
    [@@merlin.hide]
  end
  with type ('f, 's) t := ('f, 's) t
