open! Import
module Bool = Bool0

type t =
  | Neg
  | Zero
  | Pos

include struct
  let _ = fun (_ : t) -> ()

  let t_of_sexp =
    (let error_source__003_ = "../../../../lib/base/src/sign0.ml.t" in
     function
     | Sexplib0.Sexp.Atom ("neg" | "Neg") -> Neg
     | Sexplib0.Sexp.Atom ("zero" | "Zero") -> Zero
     | Sexplib0.Sexp.Atom ("pos" | "Pos") -> Pos
     | Sexplib0.Sexp.List
         (Sexplib0.Sexp.Atom ("neg" | "Neg" | "zero" | "Zero" | "pos" | "Pos") :: _) as
       sexp__004_ -> Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
     | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__002_ ->
       Sexplib0.Sexp_conv_error.nested_list_invalid_sum error_source__003_ sexp__002_
     | Sexplib0.Sexp.List [] as sexp__002_ ->
       Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__003_ sexp__002_
     | sexp__002_ ->
       Sexplib0.Sexp_conv_error.unexpected_stag
         error_source__003_
         [ "Neg"; "Zero"; "Pos" ]
         sexp__002_
     : Sexplib0.Sexp.t -> t)
  ;;

  let _ = t_of_sexp

  let sexp_of_t =
    (function
     | Neg -> Sexplib0.Sexp.Atom "Neg"
     | Zero -> Sexplib0.Sexp.Atom "Zero"
     | Pos -> Sexplib0.Sexp.Atom "Pos"
     : t -> Sexplib0.Sexp.t)
  ;;

  let _ = sexp_of_t

  let t_sexp_grammar : t Sexplib0.Sexp_grammar.t =
    { untyped =
        Variant
          { case_sensitivity = Case_sensitive_except_first_character
          ; clauses =
              [ No_tag { name = "Neg"; clause_kind = Atom_clause }
              ; No_tag { name = "Zero"; clause_kind = Atom_clause }
              ; No_tag { name = "Pos"; clause_kind = Atom_clause }
              ]
          }
    }
  ;;

  let _ = t_sexp_grammar
  let compare = (Stdlib.compare : t -> (t[@merlin.hide]) -> int)
  let _ = compare

  let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
    fun hsv arg ->
    Ppx_hash_lib.Std.Hash.fold_int
      hsv
      (match arg with
       | Neg -> 0
       | Zero -> 1
       | Pos -> 2)
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
  let all = ([ Neg; Zero; Pos ] : t list)
  let _ = all
end [@@merlin.hide]

module Replace_polymorphic_compare = struct
  let ( < ) (x : t) y = Poly.( < ) x y
  let ( <= ) (x : t) y = Poly.( <= ) x y
  let ( <> ) (x : t) y = Poly.( <> ) x y
  let ( = ) (x : t) y = Poly.( = ) x y
  let ( > ) (x : t) y = Poly.( > ) x y
  let ( >= ) (x : t) y = Poly.( >= ) x y
  let ascending (x : t) y = Poly.ascending x y
  let descending (x : t) y = Poly.descending x y
  let compare (x : t) y = Poly.compare x y
  let equal (x : t) y = Poly.equal x y
  let max (x : t) y = if x >= y then x else y
  let min (x : t) y = if x <= y then x else y
end

let of_string s = t_of_sexp (sexp_of_string s)
let to_string t = string_of_sexp (sexp_of_t t)

external magic_transparent : t -> int = "%identity"

let to_int t = magic_transparent t - 1
let _ = hash
let hash = to_int
let module_name = "Base.Sign"
let of_int n = Bool.select (n < 0) Neg (Bool.select (n = 0) Zero Pos)
