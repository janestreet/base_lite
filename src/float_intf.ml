open! Import0
module Int63 = Int63_type
module Sign = Sign0

module Definitions = struct
  module type S = sig
    open! Import0

    type t = float

    include sig
      [@@@ocaml.warning "-32"]

      val globalize : t -> t
      val sexp_of_t : t -> Sexplib0.Sexp.t [@@ocaml.warning "-32"]
      val sexp_of_t_u : t -> Sexplib0.Sexp.t
      val t_of_sexp : Sexplib0.Sexp.t -> t [@@ocaml.warning "-32"]
      val t_u_of_sexp : Sexplib0.Sexp.t -> t
      val t_sexp_grammar : t Sexplib0.Sexp_grammar.t
    end
    [@@merlin.hide]

    include Floatable.S with type t := t
    include Identifiable.S with type t := t

    val of_string : string -> t
    val of_string_opt : string -> t option

    include Comparable.With_zero with type t := t
    include Invariant.S with type t := t
    include Comparisons.S_with_local_opt with type t := t

    val nan : t
    val infinity : t
    val neg_infinity : t
    val max_value : t
    val min_value : t
    val zero : t
    val one : t
    val minus_one : t
    val pi : t
    val sqrt_pi : t
    val sqrt_2pi : t
    val euler_gamma_constant : t
    val epsilon_float : t
    val max_finite_value : t
    val min_positive_subnormal_value : t
    val min_positive_normal_value : t
    val to_int64_preserve_order : t -> int64 option
    val to_int64_preserve_order_exn : t -> int64
    val of_int64_preserve_order : int64 -> t
    val one_ulp : [ `Up | `Down ] -> t -> t
    val of_int : int -> t
    val to_int : t -> int
    val of_int63 : Int63.t -> t
    val of_int64 : int64 -> t
    val to_int64 : t -> int64
    val round : ?dir:[ `Zero | `Nearest | `Up | `Down ] -> t -> t
    val iround : ?dir:[ `Zero | `Nearest | `Up | `Down ] -> t -> int option
    val iround_exn : ?dir:[ `Zero | `Nearest | `Up | `Down ] -> t -> int
    val round_towards_zero : t -> t
    val round_down : t -> t
    val round_up : t -> t
    val round_nearest : t -> t
    val round_nearest_half_to_even : t -> t
    val iround_towards_zero : t -> int option
    val iround_down : t -> int option
    val iround_up : t -> int option
    val iround_nearest : t -> int option
    val iround_towards_zero_or_null : t -> int or_null
    val iround_down_or_null : t -> int or_null
    val iround_up_or_null : t -> int or_null
    val iround_nearest_or_null : t -> int or_null
    val iround_towards_zero_exn : t -> int
    val iround_down_exn : t -> int
    val iround_up_exn : t -> int
    val iround_nearest_exn : t -> int
    val int63_round_down_or_null : t -> Int63.t or_null
    val int63_round_up_or_null : t -> Int63.t or_null
    val int63_round_nearest_or_null : t -> Int63.t or_null
    val int63_round_down_exn : t -> Int63.t
    val int63_round_up_exn : t -> Int63.t
    val int63_round_nearest_exn : t -> Int63.t
    val iround_nearest_half_to_even : t -> int64
    val iround_lbound : t
    val iround_ubound : t
    val int63_round_lbound : t
    val int63_round_ubound : t
    val round_significant : t -> significant_digits:int -> t
    val round_decimal : t -> decimal_digits:int -> t
    val is_nan : t -> bool
    val is_inf : t -> bool
    val is_finite : t -> bool
    val is_integer : t -> bool
    val min_inan : t -> t -> t
    val max_inan : t -> t -> t
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

    module Parts : sig
        type outer
        type t

        val fractional : t -> outer
        val integral : t -> outer
      end
      with type outer := t

    external modf : t -> Parts.t = "caml_modf_float"
    external mod_float : t -> t -> t = "caml_fmod_float" "fmod" [@@unboxed] [@@noalloc]
    external add : t -> t -> t = "%addfloat"
    external sub : t -> t -> t = "%subfloat"
    external neg : t -> t = "%negfloat"
    external scale : t -> t -> t = "%mulfloat"
    external abs : t -> t = "%absfloat"

    module O : sig
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

      include Comparisons.Infix_with_local_opt with type t := t

      external abs : t -> t = "%absfloat"
      external neg : t -> t = "%negfloat"
      val zero : t
      val of_int : int -> t
      val of_float : float -> t
    end

    module O_dot : sig
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

      external ( **. ) : t -> t -> t = "caml_power_float" "pow" [@@unboxed] [@@noalloc]
      external ( ~-. ) : t -> t = "%negfloat"
    end

    val to_string : t -> string

    val to_string_hum
      :  ?delimiter:char
      -> ?decimals:int
      -> ?strip_zero:bool
      -> ?explicit_plus:bool
      -> t
      -> string

    val to_padded_compact_string : t -> string

    val to_padded_compact_string_custom
      :  t
      -> ?prefix:string
      -> kilo:string
      -> mega:string
      -> giga:string
      -> tera:string
      -> ?peta:string
      -> unit
      -> string

    val int_pow : t -> int -> t
    val square : t -> t

    external ldexp
      :  (t[@unboxed])
      -> (int[@untagged])
      -> (t[@unboxed])
      = "caml_ldexp_float" "caml_ldexp_float_unboxed"
    [@@noalloc]

    external frexp : t -> t * int = "caml_frexp_float"
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
    external atan2 : t -> t -> t = "caml_atan2_float" "atan2" [@@unboxed] [@@noalloc]
    external hypot : t -> t -> t = "caml_hypot_float" "caml_hypot" [@@unboxed] [@@noalloc]
    external cosh : t -> t = "caml_cosh_float" "cosh" [@@unboxed] [@@noalloc]
    external sinh : t -> t = "caml_sinh_float" "sinh" [@@unboxed] [@@noalloc]
    external tanh : t -> t = "caml_tanh_float" "tanh" [@@unboxed] [@@noalloc]
    external acosh : t -> t = "caml_acosh_float" "caml_acosh" [@@unboxed] [@@noalloc]
    external asinh : t -> t = "caml_asinh_float" "caml_asinh" [@@unboxed] [@@noalloc]
    external atanh : t -> t = "caml_atanh_float" "caml_atanh" [@@unboxed] [@@noalloc]
    external sqrt : t -> t = "caml_sqrt_float" "sqrt" [@@unboxed] [@@noalloc]
    external cbrt : t -> t = "caml_cbrt_float" "caml_cbrt" [@@unboxed] [@@noalloc]
    external exp : t -> t = "caml_exp_float" "exp" [@@unboxed] [@@noalloc]
    external log : t -> t = "caml_log_float" "log" [@@unboxed] [@@noalloc]

    module Class : sig
      type t =
        | Infinite
        | Nan
        | Normal
        | Subnormal
        | Zero

      include sig
        [@@@ocaml.warning "-32"]

        include Ppx_compare_lib.Comparable.S with type t := t
        include Ppx_enumerate_lib.Enumerable.S with type t := t
        include Ppx_compare_lib.Equal.S with type t := t
        include Sexplib0.Sexpable.S with type t := t

        val t_sexp_grammar : t Sexplib0.Sexp_grammar.t
      end
      [@@merlin.hide]

      include Stringable.S with type t := t
    end

    val classify : t -> Class.t

    val sign : t -> Sign.t
    [@@deprecated "[since 2016-01] Replace [sign] with [robust_sign] or [sign_exn]"]

    val sign_exn : t -> Sign.t
    val sign_or_nan : t -> Sign_or_nan.t
    val create_ieee : negative:bool -> exponent:int -> mantissa:Int63.t -> t Or_error.t
    val create_ieee_exn : negative:bool -> exponent:int -> mantissa:Int63.t -> t
    val ieee_negative : t -> bool
    val ieee_exponent : t -> int
    val ieee_mantissa : t -> Int63.t

    module Terse : sig
      type nonrec t = t

      include sig
        [@@@ocaml.warning "-32"]

        include Sexplib0.Sexpable.S with type t := t

        val t_sexp_grammar : t Sexplib0.Sexp_grammar.t
      end
      [@@merlin.hide]

      include Stringable.S with type t := t
    end
  end
end

module type Float = sig
  include module type of struct
    include Definitions
  end

  include S

  module Private : sig
    val box : t -> t

    val clamp_unchecked
      :  to_clamp_maybe_nan:t
      -> min_which_is_not_nan:t
      -> max_which_is_not_nan:t
      -> t

    val lower_bound_for_int : int -> t
    val upper_bound_for_int : int -> t
    val specialized_hash : t -> int
    val one_ulp_less_than_half : t
    val int63_round_nearest_portable_alloc_exn : t -> Int63.t
    val int63_round_nearest_arch64_noalloc_exn : t -> Int63.t
    val iround_nearest_exn_64 : t -> int
  end
end
