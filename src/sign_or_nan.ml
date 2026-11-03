open! Import

module T = struct
  type t =
    | Neg
    | Zero
    | Pos
    | Nan

  include struct
    let _ = fun (_ : t) -> ()

    let t_of_sexp =
      (let error_source__003_ = "../../../../lib/base/src/sign_or_nan.ml.T.t" in
       function
       | Sexplib0.Sexp.Atom ("neg" | "Neg") -> Neg
       | Sexplib0.Sexp.Atom ("zero" | "Zero") -> Zero
       | Sexplib0.Sexp.Atom ("pos" | "Pos") -> Pos
       | Sexplib0.Sexp.Atom ("nan" | "Nan") -> Nan
       | Sexplib0.Sexp.List
           (Sexplib0.Sexp.Atom
              ("neg" | "Neg" | "zero" | "Zero" | "pos" | "Pos" | "nan" | "Nan")
           :: _) as sexp__004_ ->
         Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__002_ ->
         Sexplib0.Sexp_conv_error.nested_list_invalid_sum error_source__003_ sexp__002_
       | Sexplib0.Sexp.List [] as sexp__002_ ->
         Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__003_ sexp__002_
       | sexp__002_ ->
         Sexplib0.Sexp_conv_error.unexpected_stag
           error_source__003_
           [ "Neg"; "Zero"; "Pos"; "Nan" ]
           sexp__002_
       : Sexplib0.Sexp.t -> t)
    ;;

    let _ = t_of_sexp

    let sexp_of_t =
      (function
       | Neg -> Sexplib0.Sexp.Atom "Neg"
       | Zero -> Sexplib0.Sexp.Atom "Zero"
       | Pos -> Sexplib0.Sexp.Atom "Pos"
       | Nan -> Sexplib0.Sexp.Atom "Nan"
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
                ; No_tag { name = "Nan"; clause_kind = Atom_clause }
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
         | Pos -> 2
         | Nan -> 3)
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
    let all = ([ Neg; Zero; Pos; Nan ] : t list)
    let _ = all
  end [@@merlin.hide]

  let of_string s = t_of_sexp (sexp_of_string s)
  let to_string t = string_of_sexp (sexp_of_t t)
  let module_name = "Base.Sign_or_nan"
end

module Replace_polymorphic_compare = struct
  let ( < ) (x : T.t) y = Poly.( < ) x y
  let ( <= ) (x : T.t) y = Poly.( <= ) x y
  let ( <> ) (x : T.t) y = Poly.( <> ) x y
  let ( = ) (x : T.t) y = Poly.( = ) x y
  let ( > ) (x : T.t) y = Poly.( > ) x y
  let ( >= ) (x : T.t) y = Poly.( >= ) x y
  let ascending (x : T.t) y = Poly.ascending x y
  let descending (x : T.t) y = Poly.descending x y
  let compare (x : T.t) y = Poly.compare x y
  let equal (x : T.t) y = Poly.equal x y
  let max (x : T.t) y = if x >= y then x else y
  let min (x : T.t) y = if x <= y then x else y
end

include T
include Identifiable.Make (T)
open! Replace_polymorphic_compare

let of_sign = function
  | Sign.Neg -> Neg
  | Sign.Zero -> Zero
  | Sign.Pos -> Pos
;;

let to_sign_exn = function
  | Neg -> Sign.Neg
  | Zero -> Sign.Zero
  | Pos -> Sign.Pos
  | Nan -> invalid_arg "Base.Sign_or_nan.to_sign_exn: Nan"
;;

let of_int n = of_sign (Sign.of_int n)
let to_int_exn t = Sign.to_int (to_sign_exn t)

let flip = function
  | Neg -> Pos
  | Zero -> Zero
  | Pos -> Neg
  | Nan -> Nan
;;

let ( * ) t t' =
  match t, t' with
  | Nan, _ | _, Nan -> Nan
  | _ -> of_sign (Sign.( * ) (to_sign_exn t) (to_sign_exn t'))
;;

let to_string_hum = function
  | Neg -> "negative"
  | Zero -> "zero"
  | Pos -> "positive"
  | Nan -> "not-a-number"
;;

include Replace_polymorphic_compare
