open! Import0
module Uchar = Uchar0

module Definitions = struct
  module type Utf = sig
    include Stringable.S with type t := Uchar.t

    val byte_length : Uchar.t -> int
    val codec_name : string
  end
end

module type Uchar = sig
  include module type of struct
    include Definitions
  end

  open! Import0

  type t = Uchar.t

  include sig
    [@@@ocaml.warning "-32"]

    include Ppx_hash_lib.Hashable.S with type t := t
    include Sexplib0.Sexpable.S with type t := t

    val t_sexp_grammar : t Sexplib0.Sexp_grammar.t
  end
  [@@merlin.hide]

  type uchar := t

  include Comparable.S with type t := t
  include Pretty_printer.S with type t := t
  include Invariant.S with type t := t

  val succ : t -> t option
  val succ_exn : t -> t
  val pred : t -> t option
  val pred_exn : t -> t
  val is_char : t -> bool
  val to_char : t -> char option
  val to_char_exn : t -> char
  val of_char : char -> t
  val int_is_scalar : int -> bool
  val of_scalar : int -> t option
  val of_scalar_exn : int -> t
  val to_scalar : t -> int
  val utf_8_byte_length : t -> int [@@deprecated "[since 2023-11] use [Utf8.byte_length]"]

  val utf_16_byte_length : t -> int
  [@@deprecated "[since 2023-11] use [Utf16le.byte_length] or [Utf16be.byte_length]"]

  val min_value : t
  val max_value : t
  val byte_order_mark : t
  val replacement_char : t

  module Decode_result : sig
    type t = Uchar.utf_decode

    include sig
      [@@@ocaml.warning "-32"]

      include Ppx_compare_lib.Comparable.S with type t := t
      include Ppx_compare_lib.Equal.S with type t := t
      include Ppx_hash_lib.Hashable.S with type t := t

      val sexp_of_t : t -> Sexplib0.Sexp.t
    end
    [@@merlin.hide]

    val is_valid : t -> bool
    val bytes_consumed : t -> int
    val uchar : t -> uchar option
    val uchar_exn : t -> uchar
    val uchar_or_replacement_char : t -> uchar
  end

  module Utf8 : Utf
  module Utf16le : Utf
  module Utf16be : Utf
  module Utf32le : Utf
  module Utf32be : Utf
end
