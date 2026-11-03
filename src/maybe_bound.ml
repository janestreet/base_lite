open! Import0
module List = List0

type interval_comparison =
  | Below_lower_bound
  | In_range
  | Above_upper_bound

include struct
  let _ = fun (_ : interval_comparison) -> ()

  let interval_comparison_of_sexp =
    (let error_source__003_ =
       "../../../../lib/base/src/maybe_bound.ml.interval_comparison"
     in
     function
     | Sexplib0.Sexp.Atom ("below_lower_bound" | "Below_lower_bound") -> Below_lower_bound
     | Sexplib0.Sexp.Atom ("in_range" | "In_range") -> In_range
     | Sexplib0.Sexp.Atom ("above_upper_bound" | "Above_upper_bound") -> Above_upper_bound
     | Sexplib0.Sexp.List
         (Sexplib0.Sexp.Atom
            ( "below_lower_bound"
            | "Below_lower_bound"
            | "in_range"
            | "In_range"
            | "above_upper_bound"
            | "Above_upper_bound" )
         :: _) as sexp__004_ ->
       Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__002_ ->
       Sexplib0.Sexp_conv_error.nested_list_invalid_sum error_source__003_ sexp__002_
     | Sexplib0.Sexp.List [] as sexp__002_ ->
       Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__003_ sexp__002_
     | sexp__002_ ->
       Sexplib0.Sexp_conv_error.unexpected_stag
         error_source__003_
         [ "Below_lower_bound"; "In_range"; "Above_upper_bound" ]
         sexp__002_
     : Sexplib0.Sexp.t -> interval_comparison)
  ;;

  let _ = interval_comparison_of_sexp

  let sexp_of_interval_comparison =
    (function
     | Below_lower_bound -> Sexplib0.Sexp.Atom "Below_lower_bound"
     | In_range -> Sexplib0.Sexp.Atom "In_range"
     | Above_upper_bound -> Sexplib0.Sexp.Atom "Above_upper_bound"
     : interval_comparison -> Sexplib0.Sexp.t)
  ;;

  let _ = sexp_of_interval_comparison

  let interval_comparison_sexp_grammar : interval_comparison Sexplib0.Sexp_grammar.t =
    { untyped =
        Variant
          { case_sensitivity = Case_sensitive_except_first_character
          ; clauses =
              [ No_tag { name = "Below_lower_bound"; clause_kind = Atom_clause }
              ; No_tag { name = "In_range"; clause_kind = Atom_clause }
              ; No_tag { name = "Above_upper_bound"; clause_kind = Atom_clause }
              ]
          }
    }
  ;;

  let _ = interval_comparison_sexp_grammar

  let compare_interval_comparison =
    (Stdlib.compare : interval_comparison -> (interval_comparison[@merlin.hide]) -> int)
  ;;

  let _ = compare_interval_comparison

  let hash_fold_interval_comparison
    : Ppx_hash_lib.Std.Hash.state -> interval_comparison -> Ppx_hash_lib.Std.Hash.state
    =
    fun hsv arg ->
    Ppx_hash_lib.Std.Hash.fold_int
      hsv
      (match arg with
       | Below_lower_bound -> 0
       | In_range -> 1
       | Above_upper_bound -> 2)
  ;;

  let _ = hash_fold_interval_comparison

  let hash_interval_comparison : interval_comparison -> Ppx_hash_lib.Std.Hash.hash_value =
    fun x ->
    (fun arg ->
      Ppx_hash_lib.Std.Hash.get_hash_value
        (let hsv = Ppx_hash_lib.Std.Hash.create () in
         hash_fold_interval_comparison hsv arg))
      x
  ;;

  let _ = hash_interval_comparison
end [@@merlin.hide]

type 'a t =
  | Incl of 'a
  | Excl of 'a
  | Unbounded

include struct
  let _ = fun (_ : 'a t) -> ()

  let t_of_sexp : 'a. (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a t =
    fun (type a__022_) : ((Sexplib0.Sexp.t -> a__022_) -> Sexplib0.Sexp.t -> a__022_ t) ->
    let error_source__010_ = "../../../../lib/base/src/maybe_bound.ml.t" in
    fun _of_a__007_ -> function
      | Sexplib0.Sexp.List
          (Sexplib0.Sexp.Atom (("incl" | "Incl") as _tag__013_) :: sexp_args__014_) as
        _sexp__012_ ->
        (match sexp_args__014_ with
         | arg0__015_ :: [] ->
           let res0__016_ = _of_a__007_ arg0__015_ in
           Incl res0__016_
         | _ ->
           Sexplib0.Sexp_conv_error.stag_incorrect_n_args
             error_source__010_
             _tag__013_
             _sexp__012_)
      | Sexplib0.Sexp.List
          (Sexplib0.Sexp.Atom (("excl" | "Excl") as _tag__018_) :: sexp_args__019_) as
        _sexp__017_ ->
        (match sexp_args__019_ with
         | arg0__020_ :: [] ->
           let res0__021_ = _of_a__007_ arg0__020_ in
           Excl res0__021_
         | _ ->
           Sexplib0.Sexp_conv_error.stag_incorrect_n_args
             error_source__010_
             _tag__018_
             _sexp__017_)
      | Sexplib0.Sexp.Atom ("unbounded" | "Unbounded") -> Unbounded
      | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("unbounded" | "Unbounded") :: _) as
        sexp__011_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__010_ sexp__011_
      | Sexplib0.Sexp.Atom ("incl" | "Incl" | "excl" | "Excl") as sexp__011_ ->
        Sexplib0.Sexp_conv_error.stag_takes_args error_source__010_ sexp__011_
      | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__009_ ->
        Sexplib0.Sexp_conv_error.nested_list_invalid_sum error_source__010_ sexp__009_
      | Sexplib0.Sexp.List [] as sexp__009_ ->
        Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__010_ sexp__009_
      | sexp__009_ ->
        Sexplib0.Sexp_conv_error.unexpected_stag
          error_source__010_
          [ "Incl"; "Excl"; "Unbounded" ]
          sexp__009_
  ;;

  let _ = t_of_sexp

  let sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t =
    fun (type a__028_) : ((a__028_ -> Sexplib0.Sexp.t) -> a__028_ t -> Sexplib0.Sexp.t) ->
    fun _of_a__023_ -> function
    | Incl arg0__024_ ->
      let res0__025_ = _of_a__023_ arg0__024_ in
      Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Incl"; res0__025_ ]
    | Excl arg0__026_ ->
      let res0__027_ = _of_a__023_ arg0__026_ in
      Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Excl"; res0__027_ ]
    | Unbounded -> Sexplib0.Sexp.Atom "Unbounded"
  ;;

  let _ = sexp_of_t

  let t_sexp_grammar : 'a. 'a Sexplib0.Sexp_grammar.t -> 'a t Sexplib0.Sexp_grammar.t =
    fun _'a_sexp_grammar ->
    { untyped =
        Variant
          { case_sensitivity = Case_sensitive_except_first_character
          ; clauses =
              [ No_tag
                  { name = "Incl"
                  ; clause_kind =
                      List_clause { args = Cons (_'a_sexp_grammar.untyped, Empty) }
                  }
              ; No_tag
                  { name = "Excl"
                  ; clause_kind =
                      List_clause { args = Cons (_'a_sexp_grammar.untyped, Empty) }
                  }
              ; No_tag { name = "Unbounded"; clause_kind = Atom_clause }
              ]
          }
    }
  ;;

  let _ = t_sexp_grammar

  let globalize : 'a. ('a -> 'a) -> 'a t -> 'a t =
    fun (type a__029_) : ((a__029_ -> a__029_) -> a__029_ t -> a__029_ t) ->
    fun _globalize_a__030_ x__031_ ->
    match x__031_ with
    | Unbounded as x__032_ -> x__032_
    | Incl arg__033_ -> Incl (_globalize_a__030_ arg__033_)
    | Excl arg__034_ -> Excl (_globalize_a__030_ arg__034_)
  ;;

  let _ = globalize
end [@@merlin.hide]

let all (all_of_a : 'a List.Constructors.t) : 'a t list =
  List.rev_append
    (List.rev_map all_of_a ~f:(fun a : 'a t -> Incl a))
    (List.rev_append
       (List.rev_map all_of_a ~f:(fun a : 'a t -> Excl a))
       [ (Unbounded : 'a t) ])
;;

let map (t : _ t) ~f : _ t =
  match t with
  | Incl incl -> Incl (f incl)
  | Excl excl -> Excl (f excl)
  | Unbounded -> Unbounded
;;

let is_lower_bound (t : _ t) ~of_:a ~compare =
  match t with
  | Incl incl -> compare incl a <= 0
  | Excl excl -> compare excl a < 0
  | Unbounded -> true
;;

let is_upper_bound (t : _ t) ~of_:a ~compare =
  match t with
  | Incl incl -> compare a incl <= 0
  | Excl excl -> compare a excl < 0
  | Unbounded -> true
;;

let bounds_crossed ~(lower : 'a t) ~(upper : 'a t) ~compare =
  match lower with
  | Unbounded -> false
  | Incl lower | Excl lower ->
    (match upper with
     | Unbounded -> false
     | Incl upper | Excl upper -> compare lower upper > 0)
;;

let check_interval_exn ~lower ~upper ~compare =
  if bounds_crossed ~lower ~upper ~compare
  then failwith "Maybe_bound.compare_to_interval_exn: lower bound > upper bound"
;;

let compare_to_interval_exn ~lower ~upper a ~compare =
  check_interval_exn ~lower ~upper ~compare;
  if not (is_lower_bound lower ~of_:a ~compare)
  then Below_lower_bound
  else if not (is_upper_bound upper ~of_:a ~compare)
  then Above_upper_bound
  else In_range
;;

let interval_contains_exn ~lower ~upper a ~compare =
  match compare_to_interval_exn ~lower ~upper a ~compare with
  | In_range -> true
  | Below_lower_bound | Above_upper_bound -> false
;;
