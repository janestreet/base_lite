open! Import0
module Uchar = Uchar0

module Definitions = struct
  module type Utf = sig
    type t := bytes

    val set : t -> int -> Uchar.t -> int
  end
end

module type Bytes = sig
  include module type of struct
    include Definitions
  end

  open! Import0

  type t = bytes

  include sig
    [@@@ocaml.warning "-32"]

    val globalize : t -> t

    include Sexplib0.Sexpable.S with type t := t

    val t_sexp_grammar : t Sexplib0.Sexp_grammar.t
  end
  [@@merlin.hide]

  include Blit.S with type t := t
  include Comparable.S with type t := t
  include Stringable.S with type t := t
  include Pretty_printer.S with type t := t
  include Invariant.S with type t := t

  module To_string : sig
    val sub : (t, string) Blit.sub
    val subo : (t, string) Blit.subo
  end

  module From_string : Blit.S_distinct with type src := string and type dst := t

  val create_local : int -> t
  val create : int -> t
  val make : int -> char -> t
  val map : t -> f:(char -> char) -> t
  val mapi : t -> f:(int -> char -> char) -> t
  val copy : t -> t
  val init : int -> f:(int -> char) -> t
  val of_char_list : char list -> t
  external length : t -> int = "%bytes_length"
  val get : t -> int -> char
  external unsafe_get : t -> int -> char = "%bytes_unsafe_get"
  external set : t -> int -> char -> unit = "%bytes_safe_set"
  external unsafe_set : t -> int -> char -> unit = "%bytes_unsafe_set"
  external unsafe_get_int64 : t -> int -> int64 = "%caml_bytes_get64u"
  external unsafe_set_int64 : t -> int -> int64 -> unit = "%caml_bytes_set64u"
  external unsafe_get_int32 : t -> int -> int32 = "%caml_bytes_get32u"
  external unsafe_set_int32 : t -> int -> int32 -> unit = "%caml_bytes_set32u"
  external unsafe_get_int16 : t -> int -> int = "%caml_bytes_get16u"
  external unsafe_set_int16 : t -> int -> int -> unit = "%caml_bytes_set16u"
  val fill : t -> pos:int -> len:int -> char -> unit
  val tr : target:char -> replacement:char -> t -> unit
  val tr_multi : target:string -> replacement:string -> (t -> unit) Staged.t
  val to_list : t -> char list
  val to_array : t -> char array
  val fold : t -> init:'acc -> f:('acc -> char -> 'acc) -> 'acc
  val foldi : t -> init:'acc -> f:(int -> 'acc -> char -> 'acc) -> 'acc
  val contains : ?pos:int -> ?len:int -> t -> char -> bool
  val max_length : int

  external unsafe_to_string
    :  no_mutation_while_string_reachable:t
    -> string
    = "%bytes_to_string"

  external unique_to_string : t -> string = "%bytes_to_string"
  external unsafe_of_string_promise_no_mutation : string -> t = "%bytes_of_string"

  module Utf8 : Utf
  module Utf16le : Utf
  module Utf16be : Utf
  module Utf32le : Utf
  module Utf32be : Utf
end
