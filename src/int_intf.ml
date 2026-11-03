open! Import0

module Definitions = struct
  module type Round = sig
    type t

    val round : ?dir:[ `Zero | `Nearest | `Up | `Down ] -> t -> to_multiple_of:t -> t
    val round_towards_zero : t -> to_multiple_of:t -> t
    val round_down : t -> to_multiple_of:t -> t
    val round_up : t -> to_multiple_of:t -> t
    val round_nearest : t -> to_multiple_of:t -> t
  end

  module type To_string_hum = sig
    type t

    val to_string_hum : ?delimiter:char -> t -> string

    module Hum : sig
      val to_string : ?delimiter:char -> t -> string
    end
  end

  module type To_string_format = sig
    type t

    include sig
      [@@@ocaml.warning "-32"]

      val sexp_of_t : t -> Sexplib0.Sexp.t

      include Ppx_compare_lib.Comparable.S with type t := t
      include Ppx_hash_lib.Hashable.S with type t := t
    end
    [@@merlin.hide]

    val to_string : t -> string

    include To_string_hum with type t := t
  end

  module type String_format = sig
    type t

    include sig
      [@@@ocaml.warning "-32"]

      include Sexplib0.Sexpable.S with type t := t

      val t_sexp_grammar : t Sexplib0.Sexp_grammar.t

      include Ppx_compare_lib.Comparable.S with type t := t
      include Ppx_hash_lib.Hashable.S with type t := t
    end
    [@@merlin.hide]

    include Stringable.S with type t := t
    include To_string_hum with type t := t
  end

  module type Binaryable = sig
    type t

    module Binary : To_string_format with type t = t
  end

  module type Hexable = sig
    type t

    module Hex : String_format with type t = t
  end

  module type S_common = sig
    type t

    include sig
      [@@@ocaml.warning "-32"]

      include Sexplib0.Sexpable.S with type t := t

      val t_sexp_grammar : t Sexplib0.Sexp_grammar.t
    end
    [@@merlin.hide]

    include Floatable.S_local_input with type t := t
    include Intable.S with type t := t
    include Identifiable.S with type t := t
    include Stringable.S with type t := t
    include Comparable.With_zero with type t := t
    include Invariant.S with type t := t
    include Hexable with type t := t
    include Binaryable with type t := t

    val of_string_opt : string -> t option
    val to_string_hum : ?delimiter:char -> t -> string
    val zero : t
    val one : t
    val minus_one : t
    val ( + ) : t -> t -> t
    val ( - ) : t -> t -> t
    val ( * ) : t -> t -> t
    val ( ** ) : t -> t -> t
    val neg : t -> t
    val ( ~- ) : t -> t
    val ( /% ) : t -> t -> t
    val ( % ) : t -> t -> t
    val ( / ) : t -> t -> t
    val rem : t -> t -> t
    val ( // ) : t -> t -> float
    val ( land ) : t -> t -> t
    val ( lor ) : t -> t -> t
    val ( lxor ) : t -> t -> t
    val lnot : t -> t
    val ( lsl ) : t -> int -> t
    val ( asr ) : t -> int -> t

    include Round with type t := t

    val abs : t -> t
    val abs_local : t -> t
    val succ : t -> t
    val pred : t -> t
    val pow : t -> t -> t
    val bit_and : t -> t -> t
    val bit_or : t -> t -> t
    val bit_xor : t -> t -> t
    val bit_not : t -> t
    val popcount : t -> t
    val shift_left : t -> int -> t
    val shift_right : t -> int -> t
    val decr : t ref -> unit
    val incr : t ref -> unit
    val of_int32_exn : int32 -> t
    val to_int32_exn : t -> int32
    val of_int64_exn : int64 -> t
    val to_int64 : t -> int64
    val of_nativeint_exn : nativeint -> t
    val to_nativeint_exn : t -> nativeint
    val of_local_int32_exn : int32 -> t
    val to_local_int32_exn : t -> int32
    val of_local_int64_exn : int64 -> t
    val to_local_int64 : t -> int64
    val of_local_nativeint_exn : nativeint -> t
    val to_local_nativeint_exn : t -> nativeint
    val of_float_unchecked : float -> t

    module Summable : sig
      type nonrec t = t

      val zero : t
      val ( + ) : t -> t -> t
      val ( - ) : t -> t -> t
    end
  end

  module type Operators_unbounded = sig
    type t

    val ( + ) : t -> t -> t
    val ( - ) : t -> t -> t
    val ( * ) : t -> t -> t
    val ( / ) : t -> t -> t
    val ( ~- ) : t -> t
    val ( ** ) : t -> t -> t

    include Comparisons.Infix with type t := t

    val abs : t -> t
    val abs_local : t -> t
    val neg : t -> t
    val zero : t
    val ( % ) : t -> t -> t
    val ( /% ) : t -> t -> t
    val ( // ) : t -> t -> float
    val ( land ) : t -> t -> t
    val ( lor ) : t -> t -> t
    val ( lxor ) : t -> t -> t
    val lnot : t -> t
    val ( lsl ) : t -> int -> t
    val ( asr ) : t -> int -> t
  end

  module type Operators = sig
    include Operators_unbounded

    val ( lsr ) : t -> int -> t
  end

  module type S_unbounded = sig
    include S_common
    module O : Operators_unbounded with type t := t
  end

  module type S = sig
    include S_common

    val num_bits : t
    val max_value : t
    val min_value : t
    val ( lsr ) : t -> int -> t
    val shift_right_logical : t -> int -> t
    val ceil_pow2 : t -> t
    val floor_pow2 : t -> t
    val ceil_log2 : t -> t
    val floor_log2 : t -> t
    val is_pow2 : t -> bool
    val clz : t -> t
    val ctz : t -> t

    module O : Operators with type t := t
  end

  module type Int_without_module_types = sig
    type t = int

    include sig
      [@@@ocaml.warning "-32"]

      val globalize : t -> t
    end
    [@@merlin.hide]

    include S with type t := t
    include Intable.S_with_zero_alloc with type t := t

    module O : sig
      external ( + ) : t -> t -> t = "%addint"
      external ( - ) : t -> t -> t = "%subint"
      external ( * ) : t -> t -> t = "%mulint"
      external ( / ) : t -> t -> t = "%divint"
      external ( ~- ) : t -> t = "%negint"
      val ( ** ) : t -> t -> t
      external ( = ) : t -> t -> bool = "%equal"
      external ( <> ) : t -> t -> bool = "%notequal"
      external ( < ) : t -> t -> bool = "%lessthan"
      external ( > ) : t -> t -> bool = "%greaterthan"
      external ( <= ) : t -> t -> bool = "%lessequal"
      external ( >= ) : t -> t -> bool = "%greaterequal"
      external ( land ) : t -> t -> t = "%andint"
      external ( lor ) : t -> t -> t = "%orint"
      external ( lxor ) : t -> t -> t = "%xorint"
      val lnot : t -> t
      val abs : t -> t
      val abs_local : t -> t
      external neg : t -> t = "%negint"
      val zero : t
      val ( % ) : t -> t -> t
      val ( /% ) : t -> t -> t
      val ( // ) : t -> t -> float
      external ( lsl ) : t -> int -> t = "%lslint"
      external ( asr ) : t -> int -> t = "%asrint"
      external ( lsr ) : t -> int -> t = "%lsrint"
    end

    include module type of O
    include Replace_polymorphic_compare.S with type t := t

    val max_value_30_bits : t
    val of_int : int -> t
    val to_int : t -> int
    val of_int32 : int32 -> t option
    val to_int32 : t -> int32 option
    val of_int64 : int64 -> t option
    val of_int64_exn : int64 -> t
    val of_nativeint : nativeint -> t option
    external to_nativeint : t -> nativeint = "%nativeint_of_int"
    external to_int32_trunc : t -> int32 = "%int32_of_int"
    external of_int32_trunc : int32 -> t = "%int32_to_int"
    external of_int64_trunc : int64 -> t = "%int64_to_int"
    external of_nativeint_trunc : nativeint -> t = "%nativeint_to_int"
    external bswap16 : t -> t = "%bswap16"

    module Private : sig
      module O_F : sig
        val ( % ) : int -> int -> int
        val ( /% ) : int -> int -> int
        val ( // ) : int -> int -> float
      end
    end
  end
end

module type Int = sig
  include module type of struct
    include Definitions
  end

  include Int_without_module_types
end
