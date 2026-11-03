open! Import0
module Uchar = Uchar0

module Definitions = struct
  module type Utf = sig
    type t

    include sig
      [@@@ocaml.warning "-32"]

      val t_sexp_grammar : t Sexplib0.Sexp_grammar.t
    end
    [@@merlin.hide]

    include Identifiable.S with type t := t
    include Indexed_container.S0_with_creators with type t := t and type elt = Uchar.t

    val to_sequence : t -> Uchar.t Sequence.t
    val is_valid : string -> bool
    val sanitize : string -> t
    val get : t -> byte_pos:int -> Uchar.t
    val of_string_unchecked : string -> t
    val get_unchecked : string -> byte_pos:int -> Uchar.utf_decode
    val split : t -> on:Uchar.t -> t list
    val codec_name : string
    val length_in_uchars : t -> int

    val length : t -> int
    [@@alert
      length_in_uchars
        "Use [length_in_uchars] to count unicode scalar values or [String.length] to \
         count bytes"]
  end

  module type Utf_as_string = Utf with type t = private string
end

module type String = sig
  include module type of struct
    include Definitions
  end

  open! Import0

  type t = string

  include sig
    [@@@ocaml.warning "-32"]

    val globalize : t -> t

    include Sexplib0.Sexpable.S with type t := t

    val t_sexp_grammar : t Sexplib0.Sexp_grammar.t
  end
  [@@merlin.hide]

  val sub : t -> pos:int -> len:int -> t
  val unsafe_sub : t -> pos:int -> len:int -> t
  val subo : ?pos:int -> ?len:int -> t -> t
  val copy : t -> t

  include Indexed_container.S0_with_creators with type t := t with type elt = char
  include Identifiable.S with type t := t
  include Invariant.S with type t := t

  val max_length : int
  val mem : t -> char -> bool
  external length : t -> int = "%string_length"
  external get : t -> int -> char = "%string_safe_get"
  external unsafe_get : string -> int -> char = "%string_unsafe_get"
  val make : int -> char -> t
  val ( ^ ) : t -> t -> t
  val append : t -> t -> t
  val concat : ?sep:t -> t list -> t
  val escaped : t -> t
  val contains : ?pos:int -> ?len:int -> t -> char -> bool
  val uppercase : t -> t
  val lowercase : t -> t
  val capitalize : t -> t
  val uncapitalize : t -> t

  module Caseless : sig
    type nonrec t = t

    include sig
      [@@@ocaml.warning "-32"]

      include Ppx_compare_lib.Comparable.S with type t := t
      include Ppx_compare_lib.Equal.S with type t := t
      include Ppx_hash_lib.Hashable.S with type t := t
      include Sexplib0.Sexpable.S with type t := t

      val t_sexp_grammar : t Sexplib0.Sexp_grammar.t
    end
    [@@merlin.hide]

    include Comparable.S with type t := t

    val is_suffix : t -> suffix:t -> bool
    val is_prefix : t -> prefix:t -> bool
    val is_substring : t -> substring:t -> bool
    val is_substring_at : t -> pos:int -> substring:t -> bool
    val substr_index : ?pos:int -> t -> pattern:t -> int option
    val substr_index_exn : ?pos:int -> t -> pattern:t -> int
    val substr_index_all : t -> may_overlap:bool -> pattern:t -> int list
    val substr_replace_first : ?pos:int -> t -> pattern:t -> with_:t -> t
    val substr_replace_all : t -> pattern:t -> with_:t -> t
  end

  val index : t -> char -> int option
  val index_exn : t -> char -> int
  val index_from : t -> int -> char -> int option
  val index_from_exn : t -> int -> char -> int
  val rindex : t -> char -> int option
  val rindex_exn : t -> char -> int
  val rindex_from : t -> int -> char -> int option
  val rindex_from_exn : t -> int -> char -> int
  val to_sequence : t -> char Sequence.t
  val of_sequence : char Sequence.t -> t
  val of_iarray : char iarray -> t
  val to_iarray : t -> char iarray

  module Search_pattern : sig
    type t

    include sig
      [@@@ocaml.warning "-32"]

      val sexp_of_t : t -> Sexplib0.Sexp.t
    end
    [@@merlin.hide]

    val create : ?case_sensitive:bool -> string -> t
    val pattern : t -> string
    val case_sensitive : t -> bool
    val matches : t -> string -> bool
    val index : ?pos:int -> t -> in_:string -> int option
    val index_exn : ?pos:int -> t -> in_:string -> int
    val index_all : t -> may_overlap:bool -> in_:string -> int list
    val replace_first : ?pos:int -> t -> in_:string -> with_:string -> string
    val replace_all : t -> in_:string -> with_:string -> string
    val split_on : t -> string -> string list

    module Private : sig
      type public = t

      type t =
        { pattern : string
        ; case_sensitive : bool
        ; kmp_array : int iarray
        }

      include sig
        [@@@ocaml.warning "-32"]

        include Ppx_compare_lib.Equal.S with type t := t

        val sexp_of_t : t -> Sexplib0.Sexp.t
      end
      [@@merlin.hide]

      val representation : public -> t
    end
  end

  val substr_index : ?pos:int -> t -> pattern:t -> int option
  val substr_index_exn : ?pos:int -> t -> pattern:t -> int
  val substr_index_all : t -> may_overlap:bool -> pattern:t -> int list
  val substr_replace_first : ?pos:int -> t -> pattern:t -> with_:t -> t
  val substr_replace_all : t -> pattern:t -> with_:t -> t
  val is_substring : t -> substring:t -> bool
  val is_substring_at : t -> pos:int -> substring:t -> bool
  val to_list_rev : t -> char list
  val rev : t -> t
  val is_suffix : t -> suffix:t -> bool
  val is_prefix : t -> prefix:t -> bool
  val lsplit2_exn : t -> on:char -> t * t
  val rsplit2_exn : t -> on:char -> t * t
  val lsplit2 : t -> on:char -> (t * t) option
  val rsplit2 : t -> on:char -> (t * t) option
  val split : t -> on:char -> t list
  val split_on_chars : t -> on:char list -> t list
  val lstrip : ?drop:(char -> bool) -> t -> t
  val rstrip : ?drop:(char -> bool) -> t -> t
  val strip : ?drop:(char -> bool) -> t -> t
  val split_lines : t -> t list
  val lfindi : ?pos:int -> t -> f:(int -> char -> bool) -> int option
  val rfindi : ?pos:int -> t -> f:(int -> char -> bool) -> int option
  val concat_map : ?sep:t -> t -> f:(char -> t) -> t
  val concat_mapi : ?sep:t -> t -> f:(int -> char -> t) -> t
  val tr : target:char -> replacement:char -> t -> t
  val tr_multi : target:t -> replacement:t -> (t -> t) Staged.t
  val chop_suffix_exn : t -> suffix:t -> t
  val chop_prefix_exn : t -> prefix:t -> t
  val chop_suffix : t -> suffix:t -> t option
  val chop_prefix : t -> prefix:t -> t option
  val chop_suffix_if_exists : t -> suffix:t -> t
  val chop_prefix_if_exists : t -> prefix:t -> t
  val suffix : t -> int -> t
  val prefix : t -> int -> t
  val drop_suffix : t -> int -> t
  val drop_prefix : t -> int -> t
  val common_suffix : t list -> t
  val common_prefix : t list -> t
  val common_suffix_length : t list -> int
  val common_prefix_length : t list -> int
  val common_suffix2 : t -> t -> t
  val common_prefix2 : t -> t -> t
  val common_suffix2_length : t -> t -> int
  val common_prefix2_length : t -> t -> int
  val concat_array : ?sep:t -> t array -> t
  val concat_lines : ?crlf:bool -> string list -> string
  external hash : t -> int = "Base_hash_string" [@@noalloc]
  val of_char : char -> t
  val of_char_list : char list -> t
  val pad_left : ?char:char -> string -> len:int -> string
  val pad_right : ?char:char -> string -> len:int -> string
  val edit_distance : string -> string -> int

  module Escaping : sig
    val escape_gen_exn
      :  escapeworthy_map:(char * char) list
      -> escape_char:char
      -> (string -> string) Staged.t

    val escape_gen
      :  escapeworthy_map:(char * char) list
      -> escape_char:char
      -> (string -> string) Or_error.t

    val escape : escapeworthy:char list -> escape_char:char -> (string -> string) Staged.t

    val unescape_gen_exn
      :  escapeworthy_map:(char * char) list
      -> escape_char:char
      -> (string -> string) Staged.t

    val unescape_gen
      :  escapeworthy_map:(char * char) list
      -> escape_char:char
      -> (string -> string) Or_error.t

    val unescape : escape_char:char -> (string -> string) Staged.t
    val is_char_escaping : string -> escape_char:char -> int -> bool
    val is_char_escaped : string -> escape_char:char -> int -> bool
    val is_char_literal : string -> escape_char:char -> int -> bool
    val index : string -> escape_char:char -> char -> int option
    val index_exn : string -> escape_char:char -> char -> int
    val rindex : string -> escape_char:char -> char -> int option
    val rindex_exn : string -> escape_char:char -> char -> int
    val index_from : string -> escape_char:char -> int -> char -> int option
    val index_from_exn : string -> escape_char:char -> int -> char -> int
    val rindex_from : string -> escape_char:char -> int -> char -> int option
    val rindex_from_exn : string -> escape_char:char -> int -> char -> int
    val split : string -> on:char -> escape_char:char -> string list
    val split_on_chars : string -> on:char list -> escape_char:char -> string list
    val lsplit2 : string -> on:char -> escape_char:char -> (string * string) option
    val lsplit2_exn : string -> on:char -> escape_char:char -> string * string
    val rsplit2 : string -> on:char -> escape_char:char -> (string * string) option
    val rsplit2_exn : string -> on:char -> escape_char:char -> string * string
    val lstrip_literal : ?drop:(char -> bool) -> t -> escape_char:char -> t
    val rstrip_literal : ?drop:(char -> bool) -> t -> escape_char:char -> t
    val strip_literal : ?drop:(char -> bool) -> t -> escape_char:char -> t
  end

  module Utf8 : Utf_as_string
  module Utf16le : Utf_as_string
  module Utf16be : Utf_as_string
  module Utf32le : Utf_as_string
  module Utf32be : Utf_as_string
end
