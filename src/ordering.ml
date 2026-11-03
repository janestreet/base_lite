open! Import0
module Bool = Bool0

type t =
  | Less
  | Equal
  | Greater

include struct
  let _ = fun (_ : t) -> ()
  let compare = (Stdlib.compare : t -> (t[@merlin.hide]) -> int)
  let _ = compare

  let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
    fun hsv arg ->
    Ppx_hash_lib.Std.Hash.fold_int
      hsv
      (match arg with
       | Less -> 0
       | Equal -> 1
       | Greater -> 2)
  ;;

  let _ = hash_fold_t

  let hash : t -> Ppx_hash_lib.Std.Hash.hash_value =
    fun x ->
    (fun arg ->
      Ppx_hash_lib.Std.Hash.get_hash_value
        (let hsv = Ppx_hash_lib.Std.Hash.create () in
         hash_fold_t hsv arg))
      x
  ;;

  let _ = hash
  let all = ([ Less; Equal; Greater ] : t list)
  let _ = all

  let t_of_sexp =
    (let error_source__005_ = "../../../../lib/base/src/ordering.ml.t" in
     function
     | Sexplib0.Sexp.Atom ("less" | "Less") -> Less
     | Sexplib0.Sexp.Atom ("equal" | "Equal") -> Equal
     | Sexplib0.Sexp.Atom ("greater" | "Greater") -> Greater
     | Sexplib0.Sexp.List
         (Sexplib0.Sexp.Atom ("less" | "Less" | "equal" | "Equal" | "greater" | "Greater")
         :: _) as sexp__006_ ->
       Sexplib0.Sexp_conv_error.stag_no_args error_source__005_ sexp__006_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__004_ ->
       Sexplib0.Sexp_conv_error.nested_list_invalid_sum error_source__005_ sexp__004_
     | Sexplib0.Sexp.List [] as sexp__004_ ->
       Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__005_ sexp__004_
     | sexp__004_ ->
       Sexplib0.Sexp_conv_error.unexpected_stag
         error_source__005_
         [ "Less"; "Equal"; "Greater" ]
         sexp__004_
     : Sexplib0.Sexp.t -> t)
  ;;

  let _ = t_of_sexp

  let sexp_of_t =
    (function
     | Less -> Sexplib0.Sexp.Atom "Less"
     | Equal -> Sexplib0.Sexp.Atom "Equal"
     | Greater -> Sexplib0.Sexp.Atom "Greater"
     : t -> Sexplib0.Sexp.t)
  ;;

  let _ = sexp_of_t

  let t_sexp_grammar : t Sexplib0.Sexp_grammar.t =
    { untyped =
        Variant
          { case_sensitivity = Case_sensitive_except_first_character
          ; clauses =
              [ No_tag { name = "Less"; clause_kind = Atom_clause }
              ; No_tag { name = "Equal"; clause_kind = Atom_clause }
              ; No_tag { name = "Greater"; clause_kind = Atom_clause }
              ]
          }
    }
  ;;

  let _ = t_sexp_grammar
end [@@merlin.hide]

let equal a b = compare a b = 0

module Export = struct
  type _ordering = t =
    | Less
    | Equal
    | Greater
end

let of_int n = Bool.select (n < 0) Less (Bool.select (n = 0) Equal Greater)

external magic_transparent : t -> int = "%identity"

let to_int t = magic_transparent t - 1
