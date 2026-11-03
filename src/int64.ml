open! Import
open! Stdlib.Int64
module Float = Float0
module Sexp = Sexp0

module T = struct
  module T0 = struct
    type t = int64

    include struct
      let _ = fun (_ : t) -> ()
      let globalize : t -> t = globalize_int64
      let _ = globalize

      let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
        hash_fold_int64

      and hash : t -> Ppx_hash_lib.Std.Hash.hash_value = fun x -> hash_int64 x

      let _ = hash_fold_t
      and _ = hash

      let t_of_sexp = (int64_of_sexp : Sexplib0.Sexp.t -> t)
      let _ = t_of_sexp
      let t_sexp_grammar : t Sexplib0.Sexp_grammar.t = int64_sexp_grammar
      let _ = t_sexp_grammar
    end [@@merlin.hide]

    let t_u_of_sexp sexp = Int64_u.unbox (t_of_sexp sexp)
    let to_string = Integer_to_string.int64_to_string
  end

  include T0
  include Int_string_conversions.Make (T0)
  include Provide_unboxed (Int64_u)

  let hashable : t Hashable.t = { hash; compare; sexp_of_t }
  let compare = Int64_replace_polymorphic_compare.compare

  external format : string -> int64 -> string = "caml_int64_format"

  external of_string
    :  string
    -> (int64[@unboxed])
    = "caml_int64_of_string" "caml_int64_of_string_unboxed"

  let of_string_opt s =
    try Some (of_string s) with
    | Failure _ -> None
  ;;
end

include T
include Comparator.Make (T)

let num_bits = 64
let float_lower_bound = Float.lower_bound_for_int num_bits
let float_upper_bound = Float.upper_bound_for_int num_bits
let num_bits = of_int num_bits

external float_of_bits
  :  t
  -> float
  = "caml_int64_float_of_bits" "caml_int64_float_of_bits_unboxed"
[@@unboxed] [@@noalloc] [@@builtin]

external bits_of_float
  :  float
  -> t
  = "caml_int64_bits_of_float" "caml_int64_bits_of_float_unboxed"
[@@unboxed] [@@noalloc] [@@builtin]

external shift_right_logical : t -> int -> t = "%int64_lsr"
external shift_right : t -> int -> t = "%int64_asr"
external shift_left : t -> int -> t = "%int64_lsl"
external bit_xor : t -> t -> t = "%int64_xor"
external bit_or : t -> t -> t = "%int64_or"
external bit_and : t -> t -> t = "%int64_and"

let bit_not n = bit_xor n (-1L)
let min_value = min_int
let max_value = max_int
let abs = abs

let abs_local n =
  if let open Int64_replace_polymorphic_compare in
     n >= 0L
  then n
  else neg n
;;

let pow = Int_math.Private.int64_pow

external rem : t -> t -> t = "%int64_mod"

let minus_one = minus_one
let one = one
let zero = zero

external to_float : t -> float = "caml_int64_to_float" "caml_int64_to_float_unboxed"
[@@unboxed] [@@noalloc] [@@builtin]

external of_float_unchecked
  :  float
  -> t
  = "caml_int64_of_float" "caml_int64_of_float_unboxed"
[@@unboxed] [@@noalloc] [@@builtin]

let of_float f =
  if Float_replace_polymorphic_compare.( >= ) f float_lower_bound
     && Float_replace_polymorphic_compare.( <= ) f float_upper_bound
  then of_float_unchecked f
  else
    Printf.invalid_argf
      "Int64.of_float: argument (%f) is out of range or NaN"
      (Float.box f)
      ()
;;

let ( ** ) = pow

external bswap64 : t -> t = "%bswap_int64"

let bswap16 x = shift_right_logical (bswap64 x) 48
let bswap32 x = shift_right_logical (bswap64 x) 32
let bswap48 x = shift_right_logical (bswap64 x) 16

include Comparable.With_zero (struct
    include T

    let zero = zero
  end)

open Int64_replace_polymorphic_compare

let invariant (_ : t) = ()
let between t ~low ~high = low <= t && t <= high
let clamp_unchecked t ~min:min_ ~max:max_ = max min_ (min t max_)

let clamp_exn t ~min ~max =
  assert (min <= max);
  clamp_unchecked t ~min ~max
;;

let clamp t ~min ~max =
  if min > max
  then
    Or_error.error_s
      (Sexp.message
         "clamp requires [min <= max]"
         [ "min", T.sexp_of_t min; "max", T.sexp_of_t max ])
  else Ok (clamp_unchecked t ~min ~max)
;;

let incr r = r := add !r one
let decr r = r := sub !r one

external of_int64 : t -> t = "%identity"

let to_int64 t = t
let of_int64_exn t = t
let to_local_int64 t = t
let of_local_int64_exn t = t
let popcount = Popcount.int64_popcount

module Conv = Int_conversions

external to_int_trunc : t -> int = "%int64_to_int"
external to_int32_trunc : t -> int32 = "%int64_to_int32"
external to_nativeint_trunc : t -> nativeint = "%int64_to_nativeint"
external of_int : int -> t = "%int64_of_int"
external of_int32 : int32 -> t = "%int64_of_int32"

let of_int_exn = of_int
let to_int = Conv.int64_to_int
let to_int_exn = Conv.int64_to_int_exn
let of_int32_exn = of_int32
let of_local_int32_exn = of_int32
let to_int32 = Conv.int64_to_int32
let to_local_int32_exn = Conv.int64_to_int32_exn
let to_int32_exn t = globalize_int32 (to_local_int32_exn t) [@nontail]

external of_nativeint : nativeint -> t = "%int64_of_nativeint"

let of_nativeint_exn = of_nativeint
let of_local_nativeint_exn = of_nativeint
let to_nativeint = Conv.int64_to_nativeint
let to_local_nativeint_exn = Conv.int64_to_nativeint_exn
let to_nativeint_exn t = globalize_nativeint (to_local_nativeint_exn t) [@nontail]

module Pre_O = struct
  external ( + ) : t -> t -> t = "%int64_add"
  external ( - ) : t -> t -> t = "%int64_sub"
  external ( * ) : t -> t -> t = "%int64_mul"
  external ( / ) : t -> t -> t = "%int64_div"
  external ( ~- ) : t -> t = "%int64_neg"

  let ( ** ) = ( ** )

  include Int64_replace_polymorphic_compare

  let abs = abs
  let abs_local = abs_local

  external neg : t -> t = "%int64_neg"

  let zero = zero
  let of_int_exn = of_int_exn
end

module O = struct
  include Pre_O

  include Int_math.Make (struct
      type nonrec t = t

      let globalize = globalize

      include Pre_O

      let rem = rem
      let to_float = to_float
      let of_float = of_float
      let of_string = T.of_string
      let to_string = T.to_string
    end)

  external ( land ) : t -> t -> t = "%int64_and"
  external ( lor ) : t -> t -> t = "%int64_or"
  external ( lxor ) : t -> t -> t = "%int64_xor"

  let lnot = bit_not

  external ( lsl ) : t -> int -> t = "%int64_lsl"
  external ( asr ) : t -> int -> t = "%int64_asr"
  external ( lsr ) : t -> int -> t = "%int64_lsr"
end

include O

let pred n = n - 1L
let succ n = n + 1L

module Pow2 = struct
  open O

  let non_positive_argument () = invalid_arg "argument must be strictly positive"

  let ceil_pow2 x =
    if x <= 0L then non_positive_argument ();
    let x = x - 1L in
    let x = x lor (x lsr 1) in
    let x = x lor (x lsr 2) in
    let x = x lor (x lsr 4) in
    let x = x lor (x lsr 8) in
    let x = x lor (x lsr 16) in
    let x = x lor (x lsr 32) in
    x + 1L
  ;;

  let floor_pow2 x =
    if x <= 0L then non_positive_argument ();
    let x = x lor (x lsr 1) in
    let x = x lor (x lsr 2) in
    let x = x lor (x lsr 4) in
    let x = x lor (x lsr 8) in
    let x = x lor (x lsr 16) in
    let x = x lor (x lsr 32) in
    x - (x lsr 1)
  ;;

  let is_pow2 x =
    if x <= 0L then non_positive_argument ();
    x land (x - 1L) = 0L
  ;;

  let clz = Ocaml_intrinsics_kernel.Int64.count_leading_zeros
  let ctz = Ocaml_intrinsics_kernel.Int64.count_trailing_zeros

  let floor_log2 i =
    if i <= 0L then invalid_arg ("Int64.floor_log2: " ^ to_string i);
    num_bits - 1L - clz i
  ;;

  let ceil_log2 i =
    if i <= 0L then invalid_arg ("Int64.ceil_log2: " ^ to_string i);
    if i = 1L
    then 0L
    else (
      let i = i - 1L in
      num_bits - clz i)
  ;;
end

include Pow2

include Int_string_conversions.Make_hex (struct
    type t = int64

    include struct
      let _ = fun (_ : t) -> ()
      let compare = (compare_int64 : t -> (t[@merlin.hide]) -> int)
      let _ = compare

      let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
        hash_fold_int64

      and hash : t -> Ppx_hash_lib.Std.Hash.hash_value = fun x -> hash_int64 x

      let _ = hash_fold_t
      and _ = hash
    end [@@merlin.hide]

    let zero = zero
    let neg = neg
    let ( < ) = ( < )
    let to_string i = format "%Lx" i
    let of_string s = Stdlib.Scanf.sscanf s "%Lx" Fn.id
    let module_name = "Base.Int64.Hex"
  end)

include Int_string_conversions.Make_binary (struct
    type t = int64

    include struct
      let _ = fun (_ : t) -> ()
      let compare = (compare_int64 : t -> (t[@merlin.hide]) -> int)
      let _ = compare
      let equal = (equal_int64 : t -> (t[@merlin.hide]) -> bool)
      let _ = equal

      let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
        hash_fold_int64

      and hash : t -> Ppx_hash_lib.Std.Hash.hash_value = fun x -> hash_int64 x

      let _ = hash_fold_t
      and _ = hash
    end [@@merlin.hide]

    let ( land ) = ( land )
    let ( lsr ) = ( lsr )
    let clz = clz
    let num_bits = num_bits
    let one = one
    let to_int_trunc = to_int_trunc
    let zero = zero
    let ( - ) = O.( - )
  end)

include Pretty_printer.Register (struct
    type nonrec t = t

    let to_string = to_string
    let module_name = "Base.Int64"
  end)

module Summable = struct
  type nonrec t = t

  let zero = zero
  let ( + ) x y = x + y
  let ( - ) x y = x - y
end

include Int64_replace_polymorphic_compare
