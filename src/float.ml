open! Import
open! Printf
module Bytes = Bytes0
module Error = Error0
module Sexp = Sexp0
module Sign = Sign0
module Sys = Sys0
include Float_intf.Definitions
include Float0

let raise_s = Error.raise_s

module T = struct
  type t = float

  include struct
    let _ = fun (_ : t) -> ()

    let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
      hash_fold_float

    and hash : t -> Ppx_hash_lib.Std.Hash.hash_value = fun x -> hash_float x

    let _ = hash_fold_t
    and _ = hash

    let globalize : t -> t = globalize_float
    let _ = globalize

    let t_of_sexp = (float_of_sexp : Sexplib0.Sexp.t -> t)
    and t_u_of_sexp = (float_u_of_sexp : Sexplib0.Sexp.t -> t)

    let _ = t_of_sexp
    and _ = t_u_of_sexp

    let sexp_of_t = (sexp_of_float : t -> Sexplib0.Sexp.t)
    and sexp_of_t_u = (sexp_of_float_u : t -> Sexplib0.Sexp.t)

    let _ = sexp_of_t
    and _ = sexp_of_t_u

    let t_sexp_grammar : t Sexplib0.Sexp_grammar.t = float_sexp_grammar
    let _ = t_sexp_grammar
  end [@@merlin.hide]

  let compare = Float_replace_polymorphic_compare.compare
  let hashable : t Hashable.t = { hash; compare; sexp_of_t }
end

include T
include Comparator.Make (T)
open Float_replace_polymorphic_compare

external mod_float : t -> t -> t = "caml_fmod_float" "fmod" [@@unboxed] [@@noalloc]
external float_of_string : string -> t = "caml_float_of_string"

let float_of_string_opt s =
  try Some (float_of_string s) with
  | Failure _ -> None
;;

let nan = Stdlib.nan
let infinity = Stdlib.infinity
let neg_infinity = Stdlib.neg_infinity
let max_finite_value = Stdlib.max_float
let epsilon_float = Stdlib.epsilon_float

external classify_float
  :  (t[@unboxed])
  -> Stdlib.fpclass
  = "caml_classify_float" "caml_classify_float_unboxed"
[@@noalloc]

external trunc : t -> t = "caml_trunc_float" "caml_trunc" [@@unboxed] [@@noalloc]

let is_finite t = t -. t = 0.
let is_integer x = x = trunc x && is_finite x

external frexp : t -> t * int = "caml_frexp_float"

external ldexp
  :  (t[@unboxed])
  -> (int[@untagged])
  -> (t[@unboxed])
  = "caml_ldexp_float" "caml_ldexp_float_unboxed"
[@@noalloc]

external log10 : t -> t = "caml_log10_float" "log10" [@@unboxed] [@@noalloc]
external log2 : t -> t = "caml_log2_float" "caml_log2" [@@unboxed] [@@noalloc]
external expm1 : t -> t = "caml_expm1_float" "caml_expm1" [@@unboxed] [@@noalloc]
external log1p : t -> t = "caml_log1p_float" "caml_log1p" [@@unboxed] [@@noalloc]

external copysign : t -> t -> t = "caml_copysign_float" "caml_copysign"
[@@unboxed] [@@noalloc]

external cos : t -> t = "caml_cos_float" "cos" [@@unboxed] [@@noalloc]
external sin : t -> t = "caml_sin_float" "sin" [@@unboxed] [@@noalloc]
external tan : t -> t = "caml_tan_float" "tan" [@@unboxed] [@@noalloc]
external acos : t -> t = "caml_acos_float" "acos" [@@unboxed] [@@noalloc]
external asin : t -> t = "caml_asin_float" "asin" [@@unboxed] [@@noalloc]
external atan : t -> t = "caml_atan_float" "atan" [@@unboxed] [@@noalloc]
external acosh : t -> t = "caml_acosh_float" "caml_acosh" [@@unboxed] [@@noalloc]
external asinh : t -> t = "caml_asinh_float" "caml_asinh" [@@unboxed] [@@noalloc]
external atanh : t -> t = "caml_atanh_float" "caml_atanh" [@@unboxed] [@@noalloc]
external atan2 : t -> t -> t = "caml_atan2_float" "atan2" [@@unboxed] [@@noalloc]
external hypot : t -> t -> t = "caml_hypot_float" "caml_hypot" [@@unboxed] [@@noalloc]
external cosh : t -> t = "caml_cosh_float" "cosh" [@@unboxed] [@@noalloc]
external sinh : t -> t = "caml_sinh_float" "sinh" [@@unboxed] [@@noalloc]
external tanh : t -> t = "caml_tanh_float" "tanh" [@@unboxed] [@@noalloc]
external sqrt : t -> t = "caml_sqrt_float" "sqrt" [@@unboxed] [@@noalloc]
external cbrt : t -> t = "caml_cbrt_float" "caml_cbrt" [@@unboxed] [@@noalloc]
external exp : t -> t = "caml_exp_float" "exp" [@@unboxed] [@@noalloc]
external log : t -> t = "caml_log_float" "log" [@@unboxed] [@@noalloc]

module Intrinsics_with_weird_nan_behavior = struct
  let min a b = Ocaml_intrinsics_kernel.Float.min a b
  let max a b = Ocaml_intrinsics_kernel.Float.max a b
end

let clamp_unchecked
  ~(to_clamp_maybe_nan : float)
  ~min_which_is_not_nan
  ~max_which_is_not_nan
  =
  let t_maybe_nan =
    Intrinsics_with_weird_nan_behavior.max min_which_is_not_nan to_clamp_maybe_nan
  in
  Intrinsics_with_weird_nan_behavior.min max_which_is_not_nan t_maybe_nan
;;

let invariant (_ : t) = ()
let to_float x = x
let of_float x = x

let of_string s =
  try float_of_string s with
  | _ -> invalid_argf "Float.of_string %s" (globalize_string s) ()
;;

let of_string_opt = float_of_string_opt

external format_float : string -> t -> string = "caml_format_float"

let valid_float_lexem s =
  let l = String.length s in
  let rec loop i =
    if Int_replace_polymorphic_compare.( >= ) i l
    then s ^ "."
    else (
      match s.[i] with
      | '0' .. '9' | '-' -> loop (i + 1)
      | _ -> s)
  in
  loop 0
;;

let to_string x =
  valid_float_lexem
    (let y = format_float "%.15g" x in
     if float_of_string y = x then y else format_float "%.17g" x)
;;

let max_value = infinity
let min_value = neg_infinity
let min_positive_subnormal_value = 2. ** -1074.
let min_positive_normal_value = 2. ** -1022.
let zero = 0.
let one = 1.
let minus_one = -1.
let pi = 0x3.243F6A8885A308D313198A2E037073
let sqrt_pi = 0x1.C5BF891B4EF6AA79C3B0520D5DB938
let sqrt_2pi = 0x2.81B263FEC4E0B2CAF9483F5CE459DC
let euler_gamma_constant = 0x0.93C467E37DB0C7A4D1BE3F810152CB
let of_int = Int.to_float
let to_int = Int.of_float
let of_int63 i = Int63.to_float i
let of_int64 i = Int64.to_float i
let to_int64 = Int64.of_float
let iround_lbound = lower_bound_for_int Int.num_bits
let iround_ubound = upper_bound_for_int Int.num_bits
let round_nearest_lb = -.(2. ** 52.)
let round_nearest_ub = 2. ** 52.
let one_ulp_less_than_half = one_ulp `Down 0.5

let add_half_for_round_nearest t =
  t +. if t = one_ulp_less_than_half then one_ulp_less_than_half else 0.5
;;

let round_down = Ocaml_intrinsics_kernel.Float.round_down
let round_up = Ocaml_intrinsics_kernel.Float.round_up
let round_towards_zero = Ocaml_intrinsics_kernel.Float.round_towards_zero

let round_nearest_inline t =
  if t > round_nearest_lb && t < round_nearest_ub
  then round_down (add_half_for_round_nearest t) [@nontail]
  else box t
;;

let round_nearest t = round_nearest_inline t

let iround_up_or_null t =
  if t > 0.0
  then (
    let t' = round_up t in
    if t' <= iround_ubound then This (Int.of_float_unchecked t') else Null)
  else if t >= iround_lbound
  then This (Int.of_float_unchecked t)
  else Null
;;

let iround_up t = Or_null.to_option (iround_up_or_null t)

let iround_up_exn t =
  if t > 0.0
  then (
    let t' = round_up t in
    if t' <= iround_ubound
    then Int.of_float_unchecked t'
    else invalid_argf "Float.iround_up_exn: argument (%f) is too large" (box t) ())
  else if t >= iround_lbound
  then Int.of_float_unchecked t
  else invalid_argf "Float.iround_up_exn: argument (%f) is too small or NaN" (box t) ()
;;

let iround_down_or_null t =
  if t >= 0.0
  then if t <= iround_ubound then This (Int.of_float_unchecked t) else Null
  else (
    let t' = round_down t in
    if t' >= iround_lbound then This (Int.of_float_unchecked t') else Null)
;;

let iround_down t = Or_null.to_option (iround_down_or_null t)

let iround_down_exn t =
  if t >= 0.0
  then
    if t <= iround_ubound
    then Int.of_float_unchecked t
    else invalid_argf "Float.iround_down_exn: argument (%f) is too large" (box t) ()
  else (
    let t' = round_down t in
    if t' >= iround_lbound
    then Int.of_float_unchecked t'
    else
      invalid_argf "Float.iround_down_exn: argument (%f) is too small or NaN" (box t) ())
;;

let iround_towards_zero_or_null t =
  if t >= iround_lbound && t <= iround_ubound
  then This (Int.of_float_unchecked t)
  else Null
;;

let iround_towards_zero t = Or_null.to_option (iround_towards_zero_or_null t)

let iround_towards_zero_exn t =
  if t >= iround_lbound && t <= iround_ubound
  then Int.of_float_unchecked t
  else
    invalid_argf
      "Float.iround_towards_zero_exn: argument (%f) is out of range or NaN"
      (box t)
      ()
;;

let iround_nearest_32 t =
  if t >= 0.
  then (
    let t' = add_half_for_round_nearest t in
    if t' <= iround_ubound then This (Int.of_float_unchecked t') else Null)
  else (
    let t' = round_down (t +. 0.5) in
    if t' >= iround_lbound then This (Int.of_float_unchecked t') else Null)
;;

let iround_nearest_64 t =
  if t >= 0.
  then
    if t < round_nearest_ub
    then This (Int.of_float_unchecked (add_half_for_round_nearest t))
    else if t <= iround_ubound
    then This (Int.of_float_unchecked t)
    else Null
  else if t > round_nearest_lb
  then This (Int.of_float_unchecked (round_down (t +. 0.5)))
  else if t >= iround_lbound
  then This (Int.of_float_unchecked t)
  else Null
;;

let iround_nearest_or_null =
  match Word_size.word_size with
  | W64 -> iround_nearest_64
  | W32 -> iround_nearest_32
;;

let iround_nearest_or_null t = iround_nearest_or_null t
let iround_nearest t = Or_null.to_option (iround_nearest_or_null t)

let iround_nearest_exn_32 t =
  if t >= 0.
  then (
    let t' = add_half_for_round_nearest t in
    if t' <= iround_ubound
    then Int.of_float_unchecked t' [@nontail]
    else invalid_argf "Float.iround_nearest_exn: argument (%f) is too large" (box t) ())
  else (
    let t' = round_down (t +. 0.5) in
    if t' >= iround_lbound
    then Int.of_float_unchecked t'
    else invalid_argf "Float.iround_nearest_exn: argument (%f) is too small" (box t) ())
;;

let iround_nearest_exn_64 t =
  if t >= 0.
  then
    if t < round_nearest_ub
    then Int.of_float_unchecked (add_half_for_round_nearest t) [@nontail]
    else if t <= iround_ubound
    then Int.of_float_unchecked t
    else invalid_argf "Float.iround_nearest_exn: argument (%f) is too large" (box t) ()
  else if t > round_nearest_lb
  then Int.of_float_unchecked (round_down (t +. 0.5))
  else if t >= iround_lbound
  then Int.of_float_unchecked t
  else
    invalid_argf "Float.iround_nearest_exn: argument (%f) is too small or NaN" (box t) ()
;;

let iround_nearest_exn =
  match Word_size.word_size with
  | W64 -> iround_nearest_exn_64
  | W32 -> iround_nearest_exn_32
;;

let iround_nearest_exn t = iround_nearest_exn t

let iround_exn ?(dir = `Nearest) t =
  match dir with
  | `Zero -> iround_towards_zero_exn t [@nontail]
  | `Nearest -> iround_nearest_exn t [@nontail]
  | `Up -> iround_up_exn t [@nontail]
  | `Down -> iround_down_exn t [@nontail]
;;

let iround ?(dir = `Nearest) t =
  try Some (iround_exn ~dir t) with
  | _ -> None
;;

let is_inf t = 1. /. t = 0.

external add : t -> t -> t = "%addfloat"
external sub : t -> t -> t = "%subfloat"
external neg : t -> t = "%negfloat"
external abs : t -> t = "%absfloat"
external scale : t -> t -> t = "%mulfloat"

module Parts : sig
  type t

  val fractional : t -> float
  val integral : t -> float
end = struct
  type t = float * float

  let fractional t = fst t
  let integral t = snd t
end

external modf : t -> Parts.t = "caml_modf_float"

let round_nearest_half_to_even' t =
  if t <= round_nearest_lb || t >= round_nearest_ub
  then box t
  else (
    let floor = round_down t in
    let ceil_or_succ = floor +. 1. in
    let diff_floor = t -. floor in
    let diff_ceil = ceil_or_succ -. t in
    if diff_floor < diff_ceil
    then floor
    else if diff_floor > diff_ceil
    then ceil_or_succ
    else if mod_float floor 2. = 0.
    then floor
    else ceil_or_succ)
;;

let round_nearest_half_to_even =
  match Sys.backend_type with
  | Native -> Ocaml_intrinsics_kernel.Float.round_current
  | _ -> round_nearest_half_to_even'
;;

let iround_nearest_half_to_even' t = to_int64 (round_nearest_half_to_even' t)

let iround_nearest_half_to_even =
  match Sys.backend_type with
  | Native -> Ocaml_intrinsics_kernel.Float.iround_current
  | _ -> iround_nearest_half_to_even'
;;

let int63_round_lbound =
  lower_bound_for_int
    (let open Int63 in
     to_int_trunc num_bits)
;;

let int63_round_ubound =
  upper_bound_for_int
    (let open Int63 in
     to_int_trunc num_bits)
;;

let int63_round_up_or_null t =
  if t > 0.0
  then (
    let t' = round_up t in
    if t' <= int63_round_ubound then This (Int63.of_float_unchecked t') else Null)
  else if t >= int63_round_lbound
  then This (Int63.of_float_unchecked t)
  else Null
;;

let int63_round_up_exn t =
  if t > 0.0
  then (
    let t' = round_up t in
    if t' <= int63_round_ubound
    then Int63.of_float_unchecked t'
    else invalid_argf "Float.int63_round_up_exn: argument (%f) is too large" (box t) ())
  else if t >= int63_round_lbound
  then Int63.of_float_unchecked t
  else
    invalid_argf "Float.int63_round_up_exn: argument (%f) is too small or NaN" (box t) ()
;;

let int63_round_down_or_null t =
  if t >= 0.0
  then if t <= int63_round_ubound then This (Int63.of_float_unchecked t) else Null
  else (
    let t' = round_down t in
    if t' >= int63_round_lbound then This (Int63.of_float_unchecked t') else Null)
;;

let int63_round_down_exn t =
  if t >= 0.0
  then
    if t <= int63_round_ubound
    then Int63.of_float_unchecked t
    else invalid_argf "Float.int63_round_down_exn: argument (%f) is too large" (box t) ()
  else (
    let t' = round_down t in
    if t' >= int63_round_lbound
    then Int63.of_float_unchecked t'
    else
      invalid_argf
        "Float.int63_round_down_exn: argument (%f) is too small or NaN"
        (box t)
        ())
;;

let int63_round_nearest_portable_alloc_exn t0 =
  let t = round_nearest_inline t0 in
  if t > 0.
  then
    if t <= int63_round_ubound
    then Int63.of_float_unchecked t
    else
      invalid_argf
        "Float.int63_round_nearest_portable_alloc_exn: argument (%f) is too large"
        (box t0)
        ()
  else if t >= int63_round_lbound
  then Int63.of_float_unchecked t
  else
    invalid_argf
      "Float.int63_round_nearest_portable_alloc_exn: argument (%f) is too small or NaN"
      (box t0)
      ()
;;

let int63_round_nearest_portable_alloc_or_null t =
  let t = round_nearest_inline t in
  if t > 0.
  then if t <= int63_round_ubound then This (Int63.of_float_unchecked t) else Null
  else if t >= int63_round_lbound
  then This (Int63.of_float_unchecked t)
  else Null
;;

let int63_round_nearest_arch64_noalloc_or_null f =
  match iround_nearest_or_null f with
  | Null -> Null
  | This i -> This (Int63.of_int i)
;;

let int63_round_nearest_or_null =
  match Word_size.word_size with
  | W64 -> int63_round_nearest_arch64_noalloc_or_null
  | W32 -> int63_round_nearest_portable_alloc_or_null
;;

let int63_round_nearest_arch64_noalloc_exn f = Int63.of_int (iround_nearest_exn f)

let int63_round_nearest_exn =
  match Word_size.word_size with
  | W64 -> int63_round_nearest_arch64_noalloc_exn
  | W32 -> int63_round_nearest_portable_alloc_exn
;;

let round ?(dir = `Nearest) t =
  match dir with
  | `Nearest -> round_nearest t [@nontail]
  | `Down -> round_down t [@nontail]
  | `Up -> round_up t [@nontail]
  | `Zero -> round_towards_zero t [@nontail]
;;

module Class = struct
  type t =
    | Infinite
    | Nan
    | Normal
    | Subnormal
    | Zero

  include struct
    let _ = fun (_ : t) -> ()
    let compare = (Stdlib.compare : t -> (t[@merlin.hide]) -> int)
    let _ = compare
    let all = ([ Infinite; Nan; Normal; Subnormal; Zero ] : t list)
    let _ = all
    let equal = (Stdlib.( = ) : t -> (t[@merlin.hide]) -> bool)
    let _ = equal

    let t_of_sexp =
      (let error_source__010_ = "../../../../lib/base/src/float.ml.Class.t" in
       function
       | Sexplib0.Sexp.Atom ("infinite" | "Infinite") -> Infinite
       | Sexplib0.Sexp.Atom ("nan" | "Nan") -> Nan
       | Sexplib0.Sexp.Atom ("normal" | "Normal") -> Normal
       | Sexplib0.Sexp.Atom ("subnormal" | "Subnormal") -> Subnormal
       | Sexplib0.Sexp.Atom ("zero" | "Zero") -> Zero
       | Sexplib0.Sexp.List
           (Sexplib0.Sexp.Atom
              ( "infinite"
              | "Infinite"
              | "nan"
              | "Nan"
              | "normal"
              | "Normal"
              | "subnormal"
              | "Subnormal"
              | "zero"
              | "Zero" )
           :: _) as sexp__011_ ->
         Sexplib0.Sexp_conv_error.stag_no_args error_source__010_ sexp__011_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__009_ ->
         Sexplib0.Sexp_conv_error.nested_list_invalid_sum error_source__010_ sexp__009_
       | Sexplib0.Sexp.List [] as sexp__009_ ->
         Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__010_ sexp__009_
       | sexp__009_ ->
         Sexplib0.Sexp_conv_error.unexpected_stag
           error_source__010_
           [ "Infinite"; "Nan"; "Normal"; "Subnormal"; "Zero" ]
           sexp__009_
       : Sexplib0.Sexp.t -> t)
    ;;

    let _ = t_of_sexp

    let sexp_of_t =
      (function
       | Infinite -> Sexplib0.Sexp.Atom "Infinite"
       | Nan -> Sexplib0.Sexp.Atom "Nan"
       | Normal -> Sexplib0.Sexp.Atom "Normal"
       | Subnormal -> Sexplib0.Sexp.Atom "Subnormal"
       | Zero -> Sexplib0.Sexp.Atom "Zero"
       : t -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_t

    let t_sexp_grammar : t Sexplib0.Sexp_grammar.t =
      { untyped =
          Variant
            { case_sensitivity = Case_sensitive_except_first_character
            ; clauses =
                [ No_tag { name = "Infinite"; clause_kind = Atom_clause }
                ; No_tag { name = "Nan"; clause_kind = Atom_clause }
                ; No_tag { name = "Normal"; clause_kind = Atom_clause }
                ; No_tag { name = "Subnormal"; clause_kind = Atom_clause }
                ; No_tag { name = "Zero"; clause_kind = Atom_clause }
                ]
            }
      }
    ;;

    let _ = t_sexp_grammar
  end [@@merlin.hide]

  let to_string t = string_of_sexp (sexp_of_t t)
  let of_string s = t_of_sexp (sexp_of_string s)
end

let classify t =
  let module C = Class in
  match classify_float t with
  | FP_normal -> C.Normal
  | FP_subnormal -> C.Subnormal
  | FP_zero -> C.Zero
  | FP_infinite -> C.Infinite
  | FP_nan -> C.Nan
;;

let insert_underscores ?(delimiter = '_') ?(strip_zero = false) string =
  match String.lsplit2 string ~on:'.' with
  | None -> Int_string_conversions.insert_delimiter string ~delimiter
  | Some (left, right) ->
    let left = Int_string_conversions.insert_delimiter left ~delimiter in
    let right =
      if strip_zero then String.rstrip right ~drop:(fun c -> Char.( = ) c '0') else right
    in
    (match right with
     | "" -> left
     | _ -> left ^ "." ^ right)
;;

let to_string_hum ?delimiter ?(decimals = 3) ?strip_zero ?(explicit_plus = false) f =
  if Int_replace_polymorphic_compare.( < ) decimals 0
  then invalid_argf "to_string_hum: invalid argument ~decimals=%d" decimals ();
  match classify f with
  | Class.Infinite -> if f > 0. then "inf" else "-inf"
  | Class.Nan -> "nan"
  | Class.Normal | Class.Subnormal | Class.Zero ->
    let s =
      if explicit_plus
      then sprintf "%+.*f" decimals (globalize f)
      else sprintf "%.*f" decimals (globalize f)
    in
    insert_underscores s ?delimiter ?strip_zero
;;

let sexp_of_t t =
  let sexp = sexp_of_t t in
  match Dynamic.get Sexp.of_float_style with
  | `No_underscores -> sexp
  | `Underscores ->
    (match sexp with
     | List _ ->
       raise_s (Sexp.message "[sexp_of_float] produced strange sexp" [ "sexp", sexp ])
     | Atom string ->
       if String.contains string 'E' then sexp else Atom (insert_underscores string))
;;

let to_padded_compact_string_custom t ?(prefix = "") ~kilo ~mega ~giga ~tera ?peta () =
  let iround_ratio_exn ~numerator ~denominator =
    let k = round_down (numerator /. denominator) in
    let lower = denominator *. k in
    let higher = denominator *. (k +. 1.) in
    let diff_right = higher -. numerator in
    let diff_left = numerator -. lower in
    let k = iround_nearest_exn k in
    if diff_right < diff_left
    then k + 1
    else if diff_right > diff_left
    then k
    else if Int_replace_polymorphic_compare.( = ) (k mod 2) 0
    then k
    else k + 1
  in
  match classify t with
  | Class.Infinite -> if t < 0.0 then "-inf  " else "inf  "
  | Class.Nan -> "nan  "
  | Class.Subnormal | Class.Normal | Class.Zero ->
    let go t =
      let conv_one t =
        assert (0. <= t && t < 999.95);
        let x = prefix ^ format_float "%.1f" t in
        if String.is_suffix x ~suffix:".0"
        then (
          let x = Bytes.of_string x in
          let n = Bytes.length x in
          Bytes.set x (n - 1) ' ';
          Bytes.set x (n - 2) ' ';
          Bytes.unsafe_to_string ~no_mutation_while_string_reachable:x)
        else x
      in
      let conv mag t denominator =
        assert (
          (denominator = 100. && t >= 999.95)
          || (denominator >= 100_000. && t >= round_nearest (denominator *. 9.999_5)));
        assert (t < round_nearest (denominator *. 9_999.5));
        let i, d =
          let k = iround_ratio_exn ~numerator:t ~denominator in
          k / 10, k mod 10
        in
        let open Int_replace_polymorphic_compare in
        assert (0 <= i && i < 1000);
        assert (0 <= d && d < 10);
        if d = 0
        then sprintf "%s%d%s " prefix i mag
        else sprintf "%s%d%s%d" prefix i mag d
      in
      if t < 999.95E0
      then conv_one t
      else if t < 999.95E3
      then conv kilo t 100.
      else if t < 999.95E6
      then conv mega t 100_000.
      else if t < 999.95E9
      then conv giga t 100_000_000.
      else if t < 999.95E12
      then conv tera t 100_000_000_000.
      else (
        match peta with
        | None -> sprintf "%s%.1e" prefix (globalize t)
        | Some peta ->
          if t < 999.95E15
          then conv peta t 100_000_000_000_000.
          else sprintf "%s%.1e" prefix (globalize t))
    in
    if t >= 0. then go t else "-" ^ go (-.t)
;;

let to_padded_compact_string t =
  to_padded_compact_string_custom t ~kilo:"k" ~mega:"m" ~giga:"g" ~tera:"t" ~peta:"p" ()
;;

let int_pow x n =
  let open Int_replace_polymorphic_compare in
  if n = 0
  then 1.
  else (
    let x = ref (box x) in
    let n = ref n in
    let accum = ref 1. in
    if !n < 0
    then (
      x := 1. /. !x;
      n := - !n;
      if !n < 0
      then (
        accum := !x;
        decr n));
    while !n > 1 do
      if !n land 1 <> 0 then accum := !x *. !accum;
      x := !x *. !x;
      n := !n lsr 1
    done;
    !x *. !accum)
;;

let square x = x *. x
let min x y = if x < y || is_nan x then x else y
let max x y = if x > y || is_nan x then x else y
let min_inan x y = if is_nan y then x else if is_nan x then y else if x < y then x else y
let max_inan x y = if is_nan y then x else if is_nan x then y else if x > y then x else y

let round_gen x ~how =
  if x = 0.
  then 0.
  else if not (is_finite x)
  then x
  else (
    let sd, dd =
      match how with
      | `significant_digits sd ->
        let dd = sd - to_int (round_up (log10 (abs x))) in
        sd, dd
      | `decimal_digits dd ->
        let sd = dd + to_int (round_up (log10 (abs x))) in
        sd, dd
    in
    let open Int_replace_polymorphic_compare in
    if sd < 0
    then 0.
    else if sd >= 17
    then x
    else (
      let abs_dd = Int.abs dd in
      if abs_dd > 22 || sd >= 16
      then of_string (sprintf "%.*g" sd (globalize x))
      else (
        let order = int_pow 10. abs_dd in
        if dd >= 0
        then round_nearest_half_to_even (x *. order) /. order
        else round_nearest_half_to_even (x /. order) *. order)))
;;

let round_significant x ~significant_digits =
  if Int_replace_polymorphic_compare.( <= ) significant_digits 0
  then
    invalid_argf
      "Float.round_significant: invalid argument significant_digits:%d"
      significant_digits
      ()
  else (
    let how = `significant_digits significant_digits in
    round_gen x ~how)
;;

let round_decimal x ~decimal_digits =
  let how = `decimal_digits decimal_digits in
  round_gen x ~how
;;

let between t ~low ~high = low <= t && t <= high

let clamp_exn t ~min ~max =
  assert (min <= max);
  clamp_unchecked
    ~to_clamp_maybe_nan:t
    ~min_which_is_not_nan:min
    ~max_which_is_not_nan:max
;;

let clamp t ~min ~max =
  if min <= max
  then
    Ok
      (clamp_unchecked
         ~to_clamp_maybe_nan:t
         ~min_which_is_not_nan:min
         ~max_which_is_not_nan:max)
  else
    Or_error.error_s
      (Sexp.message
         "clamp requires [min <= max]"
         [ "min", T.sexp_of_t min; "max", T.sexp_of_t max ])
;;

external ( + ) : t -> t -> t = "%addfloat"
external ( - ) : t -> t -> t = "%subfloat"
external ( * ) : t -> t -> t = "%mulfloat"
external ( / ) : t -> t -> t = "%divfloat"

external ( % )
  :  t
  -> t
  -> t
  = "Base_caml_modf_positive_float_exn" "Base_caml_modf_positive_float_unboxed_exn"
[@@unboxed]

external ( ** ) : t -> t -> t = "caml_power_float" "pow" [@@unboxed] [@@noalloc]
external ( ~- ) : t -> t = "%negfloat"

let sign_exn t : Sign.t =
  if t > 0.
  then Pos
  else if t < 0.
  then Neg
  else if t = 0.
  then Zero
  else
    Error.raise_s (Sexp.message "Float.sign_exn of NAN" [ "", sexp_of_t (globalize t) ])
;;

let sign_or_nan t : Sign_or_nan.t =
  if t > 0. then Pos else if t < 0. then Neg else if t = 0. then Zero else Nan
;;

let ieee_negative t =
  let bits = Int64.bits_of_float t in
  let open Int64.O in
  bits < zero
;;

let exponent_bits = 11
let mantissa_bits = 52

let exponent_mask64 =
  let open Int64 in
  shift_left one exponent_bits - one
;;

let exponent_mask = Int64.to_int_exn exponent_mask64

let mantissa_mask =
  let open Int63 in
  shift_left one mantissa_bits - one
;;

let mantissa_mask64 = Int63.to_int64 mantissa_mask

let ieee_exponent t =
  let bits = Int64.bits_of_float t in
  Int64.to_int_trunc
    (let open Int64.O in
     (bits lsr mantissa_bits) land exponent_mask64)
;;

let ieee_mantissa t =
  let bits = Int64.bits_of_float t in
  Int63.of_int64_trunc
    (let open Int64.O in
     bits land mantissa_mask64)
;;

let create_ieee_exn ~negative ~exponent ~mantissa =
  if let open Int in
     bit_and exponent exponent_mask <> exponent
  then failwithf "exponent %d out of range [0, %d]" exponent exponent_mask ()
  else if let open Int63 in
          bit_and mantissa mantissa_mask <> mantissa
  then
    failwithf
      "mantissa %s out of range [0, %s]"
      (Int63.to_string mantissa)
      (Int63.to_string mantissa_mask)
      ()
  else (
    let sign_bits = if negative then Stdlib.Int64.min_int else Stdlib.Int64.zero in
    let expt_bits =
      Stdlib.Int64.shift_left (Stdlib.Int64.of_int exponent) mantissa_bits
    in
    let mant_bits = Int63.to_int64 mantissa in
    let bits =
      let open Stdlib.Int64 in
      logor sign_bits (logor expt_bits mant_bits)
    in
    Stdlib.Int64.float_of_bits bits)
;;

let create_ieee ~negative ~exponent ~mantissa =
  Or_error.try_with (fun () -> create_ieee_exn ~negative ~exponent ~mantissa) [@nontail]
;;

module Terse = struct
  type nonrec t = t

  let t_of_sexp = t_of_sexp
  let to_string x = format_float "%.8G" x
  let sexp_of_t x = Sexp.Atom (to_string x)
  let of_string x = of_string x
  let t_sexp_grammar = t_sexp_grammar
end

include Comparable.With_zero (struct
    include T

    let zero = zero
  end)

let is_positive t = t > 0.
let is_non_negative t = t >= 0.
let is_negative t = t < 0.
let is_non_positive t = t <= 0.

include Pretty_printer.Register (struct
    include T

    let module_name = "Base.Float"
    let to_string = to_string
  end)

module O = struct
  external ( + ) : t -> t -> t = "%addfloat"
  external ( - ) : t -> t -> t = "%subfloat"
  external ( * ) : t -> t -> t = "%mulfloat"
  external ( / ) : t -> t -> t = "%divfloat"

  external ( % )
    :  t
    -> t
    -> t
    = "Base_caml_modf_positive_float_exn" "Base_caml_modf_positive_float_unboxed_exn"
  [@@unboxed]

  external ( ~- ) : t -> t = "%negfloat"
  external ( ** ) : t -> t -> t = "caml_power_float" "pow" [@@unboxed] [@@noalloc]

  include (
    Float_replace_polymorphic_compare :
    sig
      include Comparisons.Infix_with_local_opt with type t := t
    end)

  external abs : t -> t = "%absfloat"
  external neg : t -> t = "%negfloat"

  let zero = zero
  let of_int = of_int
  let of_float x = x
end

module O_dot = struct
  external ( +. ) : t -> t -> t = "%addfloat"
  external ( -. ) : t -> t -> t = "%subfloat"
  external ( *. ) : t -> t -> t = "%mulfloat"
  external ( /. ) : t -> t -> t = "%divfloat"

  external ( %. )
    :  t
    -> t
    -> t
    = "Base_caml_modf_positive_float_exn" "Base_caml_modf_positive_float_unboxed_exn"
  [@@unboxed]

  external ( ~-. ) : t -> t = "%negfloat"
  external ( **. ) : t -> t -> t = "caml_power_float" "pow" [@@unboxed] [@@noalloc]
end

module Private = struct
  let box = box
  let clamp_unchecked = clamp_unchecked
  let lower_bound_for_int = lower_bound_for_int
  let upper_bound_for_int = upper_bound_for_int
  let specialized_hash = hash_float
  let one_ulp_less_than_half = one_ulp_less_than_half
  let int63_round_nearest_portable_alloc_exn = int63_round_nearest_portable_alloc_exn
  let int63_round_nearest_arch64_noalloc_exn = int63_round_nearest_arch64_noalloc_exn
  let iround_nearest_exn_64 = iround_nearest_exn_64
end

module Shadow = struct
  let min = min
  let max = max
end

include Float_replace_polymorphic_compare
include Shadow
