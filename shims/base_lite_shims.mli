(** Shims for [Base_lite]: versions of libraries whose originals carry OxCaml annotations
    (modes, modalities, kinds, unboxed types, etc.). Used to shadow these libraries in
    [Base_lite] so that it compiles with [Base]'s OxCaml annotations erased.

    Where the original library interfaces interact with modes, the shims are fresh
    single-domain implementations whose types do not. This module is opened automatically
    via [-open] in ../src/jbuild. *)

module Shadow_stdlib : sig
  include module type of struct
    include Shadow_stdlib
  end

  type 'a ref = 'a Stdlib.ref = { mutable contents : 'a }
end

module Basement : sig
  include module type of struct
    include Basement
  end

  module Stdlib_shim : sig
    include module type of struct
      include Stdlib_shim
    end

    module Printexc : sig
      include module type of struct
        include Stdlib_shim.Printexc
      end

      module Safe : sig
        include module type of struct
          include Stdlib_shim.Printexc.Safe
        end

        val register_printer : (exn -> string option) -> unit

        val set_uncaught_exception_handler
          :  (exn -> Stdlib.Printexc.raw_backtrace -> unit)
          -> unit
      end
    end

    module Domain : sig
      include module type of struct
        include Stdlib_shim.Domain
      end

      module Safe : sig
        include module type of struct
          include Stdlib_shim.Domain.Safe
        end

        module DLS : sig
          type 'a key

          val new_key : ?split_from_parent:('a -> unit -> 'a) -> (unit -> 'a) -> 'a key
          val get : 'a key -> 'a
          val set : 'a key -> 'a -> unit
        end
      end
    end
  end

  module Stdlib_iarray_labels : sig
    include module type of struct
      include Stdlib_iarray_labels
    end

    val init_local : int -> f:(int -> 'a) -> 'a iarray
    val append_local : 'a iarray -> 'a iarray -> 'a iarray
    val iter2_local : f:('a -> 'b -> unit) -> 'a iarray -> 'b iarray -> unit
    val map_local : f:('a -> 'b) -> 'a iarray -> 'b iarray
    val map2_local : f:('a -> 'b -> 'c) -> 'a iarray -> 'b iarray -> 'c iarray
    val sub_local : 'a iarray -> pos:int -> len:int -> 'a iarray
  end

  module Portable_atomic : sig
    type 'a t

    val make : ?padded:bool -> 'a -> 'a t
    val get : 'a t -> 'a
    val set : 'a t -> 'a -> unit
    val compare_and_set : 'a t -> 'a -> 'a -> bool
  end

  module Modes : sig
    include module type of struct
      include Modes
    end

    type 'a global = { global : 'a } [@@unboxed]
    type 'a portable = { portable : 'a } [@@unboxed]
    type 'a contended = { contended : 'a } [@@unboxed]
    type 'a shared = { shared : 'a } [@@unboxed]
    type 'a portended = { portended : 'a } [@@unboxed]
    type 'a many = { many : 'a } [@@unboxed]
    type 'a aliased = { aliased : 'a } [@@unboxed]
    type 'a aliased_many = { aliased_many : 'a } [@@unboxed]
    type 'a forkable = { forkable : 'a } [@@unboxed]
    type 'a unyielding = { unyielding : 'a } [@@unboxed]
    type 'a stateless = { stateless : 'a } [@@unboxed]
    type 'a reading = { reading : 'a } [@@unboxed]
    type 'a immutable = { immutable : 'a } [@@unboxed]
    type 'a read = { read : 'a } [@@unboxed]
    type 'a immutable_data = { immutable_data : 'a } [@@unboxed]

    module Global : sig
      type 'a t = 'a global = { global : 'a } [@@unboxed]
    end

    module Portable : sig
      type 'a t = 'a portable = { portable : 'a } [@@unboxed]
    end

    module Contended : sig
      type 'a t = 'a contended = { contended : 'a } [@@unboxed]
    end

    module Portended : sig
      type 'a t = 'a portended = { portended : 'a } [@@unboxed]
    end

    module Aliased : sig
      type 'a t = 'a aliased = { aliased : 'a } [@@unboxed]
    end

    module Many : sig
      type 'a t = 'a many = { many : 'a } [@@unboxed]
    end
  end

  module Or_null_shim : sig
    module Export : sig
      type 'a or_null =
        | Null
        | This of 'a
    end

    type 'a t = 'a Export.or_null =
      | Null
      | This of 'a
  end

  module Primitives : sig
    include module type of struct
      include Primitives
    end

    module Int32_u : sig
      type t = int32

      val box : t -> t
      val unbox : t -> t
    end

    module Int64_u : sig
      type t = int64

      val box : t -> t
      val unbox : t -> t
    end

    module Nativeint_u : sig
      type t = nativeint

      val box : t -> t
      val unbox : t -> t
    end

    val box_float : float -> float
    val unbox_float : float -> float
  end

  module Dynamic : sig
    type 'a t

    val make : 'a -> 'a t
    val get : 'a t -> 'a
    val set_root : 'a t -> 'a -> unit
    val with_temporarily : 'a t -> 'a -> f:(unit -> 'b) -> 'b
  end

  module Portable_lazy : sig
    type 'a t

    val from_val : 'a -> 'a t
    val from_fun : (unit -> 'a) -> 'a t
    val from_fun_fixed : ('a t -> 'a) -> 'a t
    val force : 'a t -> 'a
    val map : 'a t -> f:('a -> 'b) -> 'b t
    val bind : 'a t -> f:('a -> 'b t) -> 'b t
    val compare : ('a -> 'a -> int) -> 'a t -> 'a t -> int
    val equal : ('a -> 'a -> bool) -> 'a t -> 'a t -> bool
    val globalize : 'b -> 'a t -> 'a t
    val is_val : 'a t -> bool
    val peek : 'a t -> 'a Or_null_shim.Export.or_null
    val peek_opt : 'a t -> 'a option
  end
end

module Capsule_prim : sig
  module Access : sig
    type 'k t
    type packed = P : 'k t -> packed
  end

  val current : unit -> Access.packed

  module Key : sig
    type 'k t
    type packed = P : 'k t -> packed

    val destroy : 'k t -> 'k Access.t
  end

  val create : unit -> Key.packed

  module Password : sig
    type 'k t

    module Shared : sig
      type 'k t
    end

    val shared : 'k t -> 'k Shared.t
    val with_current : 'k Access.t -> ('k t -> 'a) -> 'a
  end

  module Data : sig
    type ('a, 'k) t

    val wrap : access:'k Access.t -> 'a -> ('a, 'k) t
    val unwrap : access:'k Access.t -> ('a, 'k) t -> 'a

    module Local : sig
      val wrap : access:'k Access.t -> 'a -> ('a, 'k) t
    end
  end
end

module Ocaml_intrinsics_kernel : sig
  include module type of struct
    include Ocaml_intrinsics_kernel
  end

  module Float : sig
    include module type of struct
      include Ocaml_intrinsics_kernel.Float
    end

    val min : float -> float -> float
    val max : float -> float -> float
    val iround_current : float -> int64
    val round_current : float -> float
    val round_down : float -> float
    val round_up : float -> float
    val round_towards_zero : float -> float
  end

  module Nativeint : sig
    include module type of struct
      include Ocaml_intrinsics_kernel.Nativeint
    end

    val count_leading_zeros : nativeint -> nativeint
    val count_trailing_zeros : nativeint -> nativeint
    val count_set_bits : nativeint -> nativeint
  end
end

module Ppx_hash_lib : sig
  include module type of struct
    include Ppx_hash_lib
  end

  module Std : sig
    include module type of struct
      include Ppx_hash_lib.Std
    end

    module Hash : sig
      include module type of struct
        include Ppx_hash_lib.Std.Hash
      end

      module Builtin : sig
        include module type of struct
          include Ppx_hash_lib.Std.Hash.Builtin
        end

        val hash_fold_or_null
          :  'a folder
          -> state
          -> 'a Basement.Or_null_shim.Export.or_null
          -> state
      end
    end
  end
end

module Sexplib0 : sig
  include module type of struct
    include Sexplib0
  end

  module Sexp_grammar : sig
    [@@@warning "-30"] (* allow duplicate field names, as in the original *)

    type grammar =
      | Any of string
      | Bool
      | Char
      | Integer
      | Float
      | String
      | Option of grammar
      | List of list_grammar
      | Variant of variant
      | Union of grammar list
      | Tagged of grammar with_tag
      | Tyvar of string
      | Tycon of string * grammar list * defn list
      | Recursive of string * grammar list
      | Lazy of grammar Basement.Portable_lazy.t

    and list_grammar =
      | Empty
      | Cons of grammar * list_grammar
      | Many of grammar
      | Fields of record

    and case_sensitivity =
      | Case_insensitive
      | Case_sensitive
      | Case_sensitive_except_first_character

    and variant =
      { case_sensitivity : case_sensitivity
      ; clauses : clause with_tag_list list
      }

    and clause =
      { name : string
      ; clause_kind : clause_kind
      }

    and clause_kind =
      | Atom_clause
      | List_clause of { args : list_grammar }

    and record =
      { allow_extra_fields : bool
      ; fields : field with_tag_list list
      }

    and field =
      { name : string
      ; required : bool
      ; args : list_grammar
      }

    and 'a with_tag =
      { key : string
      ; value : Sexplib0.Sexp.t
      ; grammar : 'a
      }

    and 'a with_tag_list =
      | Tag of 'a with_tag_list with_tag
      | No_tag of 'a

    and defn =
      { tycon : string
      ; tyvars : string list
      ; grammar : grammar
      }

    type _ t = { untyped : grammar } [@@unboxed]

    val coerce : 'a t -> 'b t
    val tag : 'a t -> key:string -> value:Sexplib0.Sexp.t -> 'a t
    val assoc_tag : string
    val assoc_key_tag : string
    val assoc_value_tag : string
  end

  module Sexp : sig
    include module type of struct
      include Sexplib0.Sexp
    end

    module type Pretty_print_to_formatter = sig
      val pp_hum : Stdlib.Format.formatter -> t -> unit
      val pp_hum_indent : int -> Stdlib.Format.formatter -> t -> unit
      val pp_mach : Stdlib.Format.formatter -> t -> unit
      val pp : Stdlib.Format.formatter -> t -> unit
    end

    module type Pretty_printing_helpers_private = sig
      val mach_maybe_esc_str : string -> string
      val must_escape : string -> bool
      val esc_str : string -> string
    end

    module type Pretty_printing_helpers = sig
      include Pretty_print_to_formatter
      include Pretty_printing_helpers_private
    end

    module type Pretty_printing = sig
      type output

      include Pretty_print_to_formatter

      val to_string_hum : ?indent:int -> ?max_width:int -> t -> output
      val to_string_mach : t -> output
      val to_string : t -> output

      val to_buffer_hum
        :  buf:Stdlib.Buffer.t
        -> ?indent:int
        -> ?max_width:int
        -> t
        -> unit

      val to_buffer_mach : buf:Stdlib.Buffer.t -> t -> unit
      val to_buffer : buf:Stdlib.Buffer.t -> t -> unit

      val to_buffer_gen
        :  buf:'buffer
        -> add_char:('buffer -> char -> unit)
        -> add_string:('buffer -> string -> unit)
        -> t
        -> unit

      module Pretty_printing_helpers_private : Pretty_printing_helpers_private
    end

    val default_indent : int Basement.Dynamic.t
    val of_float_style : [ `No_underscores | `Underscores ] Basement.Dynamic.t
    val of_int_style : [ `No_underscores | `Underscores ] Basement.Dynamic.t

    module Make_pretty_printing (Helpers : Pretty_printing_helpers) :
      Pretty_printing with type output := string
  end

  module Sexp_conv : sig
    include module type of struct
      include Sexplib0.Sexp_conv
    end

    val or_null_of_sexp
      :  (Sexplib0.Sexp.t -> 'a)
      -> Sexplib0.Sexp.t
      -> 'a Basement.Or_null_shim.Export.or_null

    val sexp_of_or_null
      :  ('a -> Sexplib0.Sexp.t)
      -> 'a Basement.Or_null_shim.Export.or_null
      -> Sexplib0.Sexp.t

    val unit_u_of_sexp : Sexplib0.Sexp.t -> unit
    val bool_u_of_sexp : Sexplib0.Sexp.t -> bool
    val char_u_of_sexp : Sexplib0.Sexp.t -> char
    val float_u_of_sexp : Sexplib0.Sexp.t -> float
    val sexp_of_unit_u : unit -> Sexplib0.Sexp.t
    val sexp_of_bool_u : bool -> Sexplib0.Sexp.t
    val sexp_of_char_u : char -> Sexplib0.Sexp.t
    val sexp_of_float_u : float -> Sexplib0.Sexp.t

    val sexp_grammar_with_tags
      :  Sexp_grammar.grammar
      -> tags:(string * Sexplib0.Sexp.t) list
      -> Sexp_grammar.grammar

    val sexp_grammar_with_tag_list
      :  'a Sexp_grammar.with_tag_list
      -> tags:(string * Sexplib0.Sexp.t) list
      -> 'a Sexp_grammar.with_tag_list

    val unit_sexp_grammar : unit Sexp_grammar.t
    val bool_sexp_grammar : bool Sexp_grammar.t
    val string_sexp_grammar : string Sexp_grammar.t
    val bytes_sexp_grammar : bytes Sexp_grammar.t
    val char_sexp_grammar : char Sexp_grammar.t
    val int_sexp_grammar : int Sexp_grammar.t
    val float_sexp_grammar : float Sexp_grammar.t
    val int32_sexp_grammar : int32 Sexp_grammar.t
    val int64_sexp_grammar : int64 Sexp_grammar.t
    val nativeint_sexp_grammar : nativeint Sexp_grammar.t
    val sexp_t_sexp_grammar : Sexplib0.Sexp.t Sexp_grammar.t
    val ref_sexp_grammar : 'a Sexp_grammar.t -> 'a ref Sexp_grammar.t
    val lazy_t_sexp_grammar : 'a Sexp_grammar.t -> 'a lazy_t Sexp_grammar.t
    val option_sexp_grammar : 'a Sexp_grammar.t -> 'a option Sexp_grammar.t
    val list_sexp_grammar : 'a Sexp_grammar.t -> 'a list Sexp_grammar.t
    val array_sexp_grammar : 'a Sexp_grammar.t -> 'a array Sexp_grammar.t
    val floatarray_sexp_grammar : floatarray Sexp_grammar.t
    val opaque_sexp_grammar : 'a Sexp_grammar.t
    val fun_sexp_grammar : 'a Sexp_grammar.t
    val read_old_option_format : bool Basement.Dynamic.t
    val write_old_option_format : bool Basement.Dynamic.t
    val sexp_of_exn : exn -> Sexplib0.Sexp.t
    val sexp_of_exn_opt : exn -> Sexplib0.Sexp.t option

    module Exn_converter : sig
      val add
        :  ?printexc:bool
        -> ?finalise:bool
        -> extension_constructor
        -> (exn -> Sexplib0.Sexp.t)
        -> unit
    end
  end
end
