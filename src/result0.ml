open! Import

type nonrec ('a, 'b) t = ('a, 'b) Stdlib.result =
  | Ok of 'a
  | Error of 'b

include struct
  let _ = fun (_ : ('a, 'b) t) -> ()

  let t_of_sexp
    : 'a 'b.
    (Sexplib0.Sexp.t -> 'a) -> (Sexplib0.Sexp.t -> 'b) -> Sexplib0.Sexp.t -> ('a, 'b) t
    =
    fun (type a__017_ b__018_)
      :  ((Sexplib0.Sexp.t -> a__017_) -> (Sexplib0.Sexp.t -> b__018_) -> Sexplib0.Sexp.t
      -> (a__017_, b__018_) t) ->
    let error_source__005_ = "../../../../lib/base/src/result0.ml.t" in
    fun _of_a__001_ _of_b__002_ -> function
      | Sexplib0.Sexp.List
          (Sexplib0.Sexp.Atom (("ok" | "Ok") as _tag__008_) :: sexp_args__009_) as
        _sexp__007_ ->
        (match sexp_args__009_ with
         | arg0__010_ :: [] ->
           let res0__011_ = _of_a__001_ arg0__010_ in
           Ok res0__011_
         | _ ->
           Sexplib0.Sexp_conv_error.stag_incorrect_n_args
             error_source__005_
             _tag__008_
             _sexp__007_)
      | Sexplib0.Sexp.List
          (Sexplib0.Sexp.Atom (("error" | "Error") as _tag__013_) :: sexp_args__014_) as
        _sexp__012_ ->
        (match sexp_args__014_ with
         | arg0__015_ :: [] ->
           let res0__016_ = _of_b__002_ arg0__015_ in
           Error res0__016_
         | _ ->
           Sexplib0.Sexp_conv_error.stag_incorrect_n_args
             error_source__005_
             _tag__013_
             _sexp__012_)
      | Sexplib0.Sexp.Atom ("ok" | "Ok" | "error" | "Error") as sexp__006_ ->
        Sexplib0.Sexp_conv_error.stag_takes_args error_source__005_ sexp__006_
      | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__004_ ->
        Sexplib0.Sexp_conv_error.nested_list_invalid_sum error_source__005_ sexp__004_
      | Sexplib0.Sexp.List [] as sexp__004_ ->
        Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__005_ sexp__004_
      | sexp__004_ ->
        Sexplib0.Sexp_conv_error.unexpected_stag
          error_source__005_
          [ "Ok"; "Error" ]
          sexp__004_
  ;;

  let _ = t_of_sexp

  let sexp_of_t
    : 'a 'b.
    ('a -> Sexplib0.Sexp.t) -> ('b -> Sexplib0.Sexp.t) -> ('a, 'b) t -> Sexplib0.Sexp.t
    =
    fun (type a__025_ b__026_)
      :  ((a__025_ -> Sexplib0.Sexp.t) -> (b__026_ -> Sexplib0.Sexp.t)
      -> (a__025_, b__026_) t -> Sexplib0.Sexp.t) ->
    fun _of_a__019_ _of_b__020_ -> function
    | Ok arg0__021_ ->
      let res0__022_ = _of_a__019_ arg0__021_ in
      Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Ok"; res0__022_ ]
    | Error arg0__023_ ->
      let res0__024_ = _of_b__020_ arg0__023_ in
      Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Error"; res0__024_ ]
  ;;

  let _ = sexp_of_t

  let t_sexp_grammar
    : 'a 'b.
    'a Sexplib0.Sexp_grammar.t
    -> 'b Sexplib0.Sexp_grammar.t
    -> ('a, 'b) t Sexplib0.Sexp_grammar.t
    =
    fun _'a_sexp_grammar _'b_sexp_grammar ->
    { untyped =
        Variant
          { case_sensitivity = Case_sensitive_except_first_character
          ; clauses =
              [ No_tag
                  { name = "Ok"
                  ; clause_kind =
                      List_clause { args = Cons (_'a_sexp_grammar.untyped, Empty) }
                  }
              ; No_tag
                  { name = "Error"
                  ; clause_kind =
                      List_clause { args = Cons (_'b_sexp_grammar.untyped, Empty) }
                  }
              ]
          }
    }
  ;;

  let _ = t_sexp_grammar

  let compare
    : 'a 'b.
    ('a -> ('a[@merlin.hide]) -> int)
    -> ('b -> ('b[@merlin.hide]) -> int)
    -> ('a, 'b) t
    -> (('a, 'b) t[@merlin.hide])
    -> int
    =
    fun _cmp__a _cmp__b a__027_ b__028_ ->
    if Stdlib.( == ) a__027_ b__028_
    then 0
    else (
      match a__027_, b__028_ with
      | Ok _a__029_, Ok _b__030_ -> _cmp__a _a__029_ _b__030_
      | Ok _, _ -> -1
      | _, Ok _ -> 1
      | Error _a__031_, Error _b__032_ -> _cmp__b _a__031_ _b__032_)
  ;;

  let _ = compare

  let equal
    : 'a 'b.
    ('a -> ('a[@merlin.hide]) -> bool)
    -> ('b -> ('b[@merlin.hide]) -> bool)
    -> ('a, 'b) t
    -> (('a, 'b) t[@merlin.hide])
    -> bool
    =
    fun _cmp__a _cmp__b a__033_ b__034_ ->
    if Stdlib.( == ) a__033_ b__034_
    then true
    else (
      match a__033_, b__034_ with
      | Ok _a__035_, Ok _b__036_ -> _cmp__a _a__035_ _b__036_
      | Ok _, _ -> false
      | _, Ok _ -> false
      | Error _a__037_, Error _b__038_ -> _cmp__b _a__037_ _b__038_)
  ;;

  let _ = equal

  let hash_fold_t
    : 'a 'b.
    (Ppx_hash_lib.Std.Hash.state -> 'a -> Ppx_hash_lib.Std.Hash.state)
    -> (Ppx_hash_lib.Std.Hash.state -> 'b -> Ppx_hash_lib.Std.Hash.state)
    -> Ppx_hash_lib.Std.Hash.state
    -> ('a, 'b) t
    -> Ppx_hash_lib.Std.Hash.state
    =
    fun (type a b)
      :  ((Ppx_hash_lib.Std.Hash.state -> a -> Ppx_hash_lib.Std.Hash.state)
      -> (Ppx_hash_lib.Std.Hash.state -> b -> Ppx_hash_lib.Std.Hash.state)
      -> Ppx_hash_lib.Std.Hash.state -> (a, b) t -> Ppx_hash_lib.Std.Hash.state) ->
    fun _hash_fold_a _hash_fold_b hsv arg ->
    match arg with
    | Ok _a0 ->
      let hsv = Ppx_hash_lib.Std.Hash.fold_int hsv 0 in
      let hsv = hsv in
      _hash_fold_a hsv _a0
    | Error _a0 ->
      let hsv = Ppx_hash_lib.Std.Hash.fold_int hsv 1 in
      let hsv = hsv in
      _hash_fold_b hsv _a0
  ;;

  let _ = hash_fold_t
end [@@merlin.hide]

let globalize = globalize_result
