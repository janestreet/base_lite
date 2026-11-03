open! Import
module Float = Float0
module Sexp = Sexp0
include Int64_replace_polymorphic_compare
module Conv = Int_conversions

module W : sig
  type t = int64

  include sig
    [@@@ocaml.warning "-32"]

    val globalize : t -> t

    include Ppx_hash_lib.Hashable.S with type t := t
    include Sexplib0.Sexpable.S with type t := t

    val t_sexp_grammar : t Sexplib0.Sexp_grammar.t
  end
  [@@merlin.hide]

  include Comparator.S with type t := t

  val to_string : t -> string
  val to_string_hum : ?delimiter:char -> t -> string
  val wrap_exn : int64 -> t
  val wrap_modulo : int64 -> t
  val unwrap : t -> int64
  val unwrap_unsigned : t -> int64
  val invariant : t -> unit
  val add : t -> t -> t
  val sub : t -> t -> t
  val neg : t -> t
  val abs : t -> t
  val abs_local : t -> t
  val succ : t -> t
  val pred : t -> t
  val mul : t -> t -> t
  val pow : t -> t -> t
  val div : t -> t -> t
  val rem : t -> t -> t
  val popcount : t -> t
  val bit_not : t -> t
  val bit_xor : t -> t -> t
  val bit_or : t -> t -> t
  val bit_and : t -> t -> t
  val shift_left : t -> int -> t
  val shift_right : t -> int -> t
  val shift_right_logical : t -> int -> t
  val min_value : t
  val max_value : t
  val to_int64 : t -> int64
  val of_int64 : int64 -> t option
  val of_int64_exn : int64 -> t
  val of_int64_trunc : int64 -> t
  val ceil_pow2 : t -> t
  val floor_pow2 : t -> t
  val ceil_log2 : t -> t
  val floor_log2 : t -> t
  val is_pow2 : t -> bool
  val clz : t -> t
  val ctz : t -> t
end = struct
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

        let t_sexp_grammar : t Sexplib0.Sexp_grammar.t = int64_sexp_grammar
        let _ = t_sexp_grammar
      end [@@merlin.hide]

      include Int64_replace_polymorphic_compare

      let unwrap x = Stdlib.Int64.shift_right x 1
      let to_string x = Integer_to_string.int64_to_string (unwrap x) [@nontail]
    end

    include T0
    include Int_string_conversions.Make (T0)
  end

  include T
  include Comparator.Make (T)

  let wrap_exn x =
    Conv.int64_fit_on_int63_exn x;
    Stdlib.Int64.mul x 2L
  ;;

  let wrap x =
    if Conv.int64_is_representable_as_int63 x
    then Some (Stdlib.Int64.mul (globalize x) 2L)
    else None
  ;;

  let wrap_modulo x = Stdlib.Int64.mul (globalize x) 2L
  let unwrap_unsigned x = Stdlib.Int64.shift_right_logical (globalize x) 1

  let f2 f a b =
    Stdlib.Int64.mul (f (Stdlib.Int64.shift_right a 1) (Stdlib.Int64.shift_right b 1)) 2L
  ;;

  let mask = 0xffff_ffff_ffff_fffeL

  let m x =
    let open Int64.O in
    x land mask
  ;;

  let invariant t = assert (m t = t)
  let add = Int64.( + )
  let sub = Int64.( - )
  let neg = Int64.neg
  let abs = Int64.abs
  let abs_local = Int64.abs_local
  let one = globalize (wrap_exn 1L)
  let succ a = add a one
  let pred a = sub a one
  let min_value = m Stdlib.Int64.min_int
  let max_value = m Stdlib.Int64.max_int
  let bit_not x = m (Int64.lnot x)
  let bit_and = Int64.bit_and
  let bit_xor = Int64.bit_xor
  let bit_or = Int64.bit_or
  let shift_left = Int64.shift_left

  let shift_right x i =
    m
      (let open Int64.O in
       x asr i) [@nontail]
  ;;

  let shift_right_logical x i =
    m
      (let open Int64.O in
       x lsr i) [@nontail]
  ;;

  let pow = f2 Int_math.Private.int63_pow_on_int64

  let mul a b =
    let open Int64.O in
    a * (b asr 1)
  ;;

  let div a b =
    wrap_modulo
      (let open Int64.O in
       a / b)
  ;;

  let rem = Int64.rem
  let popcount x = wrap_modulo (Popcount.int64_popcount x)
  let to_int64 = unwrap
  let of_int64 = wrap
  let of_int64_exn = wrap_exn
  let of_int64_trunc t = wrap_modulo t
  let t_of_sexp x = globalize (wrap_exn (int64_of_sexp x)) [@nontail]
  let is_pow2 x = Int64.is_pow2 (unwrap x) [@nontail]
  let clz x = wrap_modulo (Int64.clz x)
  let ctz x = wrap_modulo (Int64.ctz (unwrap x)) [@nontail]
  let floor_pow2 x = globalize (wrap_exn (Int64.floor_pow2 (unwrap x))) [@nontail]
  let ceil_pow2 x = globalize (wrap_exn (Int64.ceil_pow2 (unwrap x))) [@nontail]
  let floor_log2 x = wrap_modulo (Int64.floor_log2 (unwrap x))
  let ceil_log2 x = wrap_modulo (Int64.ceil_log2 (unwrap x))
end

open W

module T = struct
  type t = W.t

  include struct
    let _ = fun (_ : t) -> ()
    let globalize : t -> t = W.globalize
    let _ = globalize

    let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
      W.hash_fold_t

    and hash : t -> Ppx_hash_lib.Std.Hash.hash_value = fun x -> W.hash x

    let _ = hash_fold_t
    and _ = hash

    let t_of_sexp = (W.t_of_sexp : Sexplib0.Sexp.t -> t)
    let _ = t_of_sexp
    let sexp_of_t = (W.sexp_of_t : t -> Sexplib0.Sexp.t)
    let _ = sexp_of_t
    let t_sexp_grammar : t Sexplib0.Sexp_grammar.t = W.t_sexp_grammar
    let _ = t_sexp_grammar
  end [@@merlin.hide]

  type comparator_witness = W.comparator_witness

  let comparator = W.comparator
  let invariant = W.invariant

  include Int64_replace_polymorphic_compare

  let to_string = W.to_string
  let to_string_hum = W.to_string_hum
  let _ = hash
  let hash (x : t) = Stdlib.Hashtbl.hash x
  let hashable : t Hashable.t = { hash; compare; sexp_of_t }

  let invalid_str x =
    Printf.failwithf "Int63.of_string: invalid input %S" (globalize_string x) ()
  ;;

  let sign_and_signedness x =
    let len = String.length x in
    let open Int_replace_polymorphic_compare in
    let pos, sign =
      if 0 < len
      then (
        match x.[0] with
        | '-' -> 1, `Neg
        | '+' -> 1, `Pos
        | _ -> 0, `Pos)
      else 0, `Pos
    in
    if pos + 2 < len
    then (
      let c1 = x.[pos] in
      let c2 = x.[pos + 1] in
      match c1, c2 with
      | '0', '0' .. '9' -> sign, true
      | '0', _ -> sign, false
      | _ -> sign, true)
    else sign, true
  ;;

  let of_string_raw str =
    let sign, signedness = sign_and_signedness str in
    if signedness
    then globalize (of_int64_exn (Int64.of_string str)) [@nontail]
    else (
      let pos_str =
        match sign with
        | `Neg -> String.unsafe_sub str ~pos:1 ~len:(String.length str - 1)
        | `Pos -> str
      in
      let int64 = Int64.of_string pos_str in
      if Int64_replace_polymorphic_compare.( < ) int64 0L then invalid_str str;
      let int63 = wrap_modulo int64 in
      match sign with
      | `Neg -> neg int63
      | `Pos -> int63)
  ;;

  let of_string str =
    try of_string_raw str with
    | _ -> invalid_str str
  ;;

  let of_string_opt str =
    match of_string_raw str with
    | t -> Some t
    | exception _ -> None
  ;;

  let bswap16 t = wrap_modulo (Int64.bswap16 (unwrap t))
  let bswap32 t = wrap_modulo (Int64.bswap32 (unwrap t))
  let bswap48 t = wrap_modulo (Int64.bswap48 (unwrap t))
end

include T

let num_bits = 63
let float_lower_bound = Float.lower_bound_for_int num_bits
let float_upper_bound = Float.upper_bound_for_int num_bits
let shift_right_logical = shift_right_logical
let shift_right = shift_right
let shift_left = shift_left
let bit_not = bit_not
let bit_xor = bit_xor
let bit_or = bit_or
let bit_and = bit_and
let popcount = popcount
let abs = abs
let abs_local = abs_local
let pred = pred
let succ = succ
let pow = pow
let rem = rem
let neg = neg
let max_value = max_value
let min_value = min_value
let minus_one = globalize (wrap_exn Stdlib.Int64.minus_one)
let one = globalize (wrap_exn Stdlib.Int64.one)
let zero = globalize (wrap_exn Stdlib.Int64.zero)
let is_pow2 = is_pow2
let floor_pow2 = floor_pow2
let ceil_pow2 = ceil_pow2
let floor_log2 = floor_log2
let ceil_log2 = ceil_log2
let clz = clz
let ctz = ctz
let to_float x = Int64.to_float (unwrap x) [@nontail]
let of_float_unchecked x = wrap_modulo (Int64.of_float_unchecked x)

let of_float t =
  let open Float_replace_polymorphic_compare in
  if t >= float_lower_bound && t <= float_upper_bound
  then of_float_unchecked t
  else
    Printf.invalid_argf
      "Int63.of_float: argument (%f) is out of range or NaN"
      (Float.box t)
      ()
;;

let of_int64 = of_int64
let of_local_int64_exn = of_int64_exn
let of_int64_exn x = globalize (of_local_int64_exn x) [@nontail]
let of_int64_trunc = of_int64_trunc
let to_local_int64 = to_int64
let to_int64 x = globalize_int64 (to_local_int64 x) [@nontail]

include Comparable.With_zero (struct
    include T

    let zero = zero
  end)

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

let ( / ) = div
let ( * ) = mul
let ( - ) = sub
let ( + ) = add
let ( ~- ) = neg
let ( ** ) b e = pow b e
let incr r = r := !r + one
let decr r = r := !r - one
let of_int x = globalize (wrap_exn (Conv.int_to_int64 x)) [@nontail]
let of_int_exn = of_int
let to_int x = Conv.int64_to_int (unwrap x) [@nontail]
let to_int_exn x = Conv.int64_to_int_exn (unwrap x) [@nontail]
let to_int_trunc x = Conv.int64_to_int_trunc (unwrap x) [@nontail]
let of_local_int32 x = wrap_exn (Conv.int32_to_int64 x)
let of_local_int32_exn = of_local_int32
let of_int32 x = globalize (of_local_int32 x) [@nontail]
let of_int32_exn = of_int32
let to_int32 x = Conv.int64_to_int32 (unwrap x) [@nontail]
let to_local_int32_exn x = Conv.int64_to_int32_exn (unwrap x)
let to_int32_exn x = globalize_int32 (to_local_int32_exn x) [@nontail]
let to_int32_trunc x = Conv.int64_to_int32_trunc (unwrap x) [@nontail]
let of_nativeint x = of_int64 (Conv.nativeint_to_int64 x) [@nontail]
let of_local_nativeint_exn x = wrap_exn (Conv.nativeint_to_int64 x)
let of_nativeint_exn x = globalize (of_local_nativeint_exn x) [@nontail]
let of_nativeint_trunc x = of_int64_trunc (Conv.nativeint_to_int64 x)
let to_nativeint x = Conv.int64_to_nativeint (unwrap x) [@nontail]
let to_local_nativeint_exn x = Conv.int64_to_nativeint_exn (unwrap x)
let to_nativeint_exn x = globalize_nativeint (to_local_nativeint_exn x) [@nontail]
let to_nativeint_trunc x = Conv.int64_to_nativeint_trunc (unwrap x)
let num_bits = of_int_exn num_bits

include Int_string_conversions.Make_hex (struct
    type t = T.t

    include struct
      let _ = fun (_ : t) -> ()
      let compare = (T.compare : t -> (t[@merlin.hide]) -> int)
      let _ = compare

      let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
        T.hash_fold_t

      and hash : t -> Ppx_hash_lib.Std.Hash.hash_value = fun x -> T.hash x

      let _ = hash_fold_t
      and _ = hash
    end [@@merlin.hide]

    let zero = zero
    let neg = ( ~- )
    let ( < ) = ( < )
    let to_string i = Printf.sprintf "%Lx" (unwrap_unsigned i)
    let of_string s = of_string ("0x" ^ s)
    let module_name = "Base.Int63.Hex"
  end)

include Pretty_printer.Register (struct
    type nonrec t = t

    let to_string x = to_string x
    let module_name = "Base.Int63"
  end)

module Pre_O = struct
  let ( + ) = ( + )
  let ( - ) = ( - )
  let ( * ) = ( * )
  let ( / ) = ( / )
  let ( ~- ) = ( ~- )
  let ( ** ) = ( ** )

  include Int64_replace_polymorphic_compare

  let abs = abs
  let abs_local = abs_local
  let neg = neg
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

  let ( land ) = bit_and
  let ( lor ) = bit_or
  let ( lxor ) = bit_xor
  let lnot = bit_not
  let ( lsl ) = shift_left
  let ( asr ) = shift_right
  let ( lsr ) = shift_right_logical
end

include O

include Int_string_conversions.Make_binary (struct
    type t = T.t

    include struct
      let _ = fun (_ : t) -> ()
      let compare = (T.compare : t -> (t[@merlin.hide]) -> int)
      let _ = compare
      let equal = (T.equal : t -> (t[@merlin.hide]) -> bool)
      let _ = equal

      let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
        T.hash_fold_t

      and hash : t -> Ppx_hash_lib.Std.Hash.hash_value = fun x -> T.hash x

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
    let ( - ) = ( - )
  end)

module Summable = struct
  type nonrec t = t

  let zero = zero
  let ( + ) x y = x + y
  let ( - ) x y = x - y
end

let repr = Int63_type.Repr.Int64

include Int64_replace_polymorphic_compare
