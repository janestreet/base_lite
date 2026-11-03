open! Import0
module Modes = Basement.Modes
module Portable_lazy = Basement.Portable_lazy
module Sexp = Sexplib0.Sexp

module Definitions = struct
  module type Internal_repr = sig
    type info

    type t =
      | Could_not_construct of Sexp.t
      | String of string
      | Exn of exn Modes.Global.t
      | Sexp of Sexp.t
      | Tag_sexp of string * Sexp.t * Stdlib.Lexing.position option
      | Tag_t of string * t
      | Tag_arg of string * Sexp.t * t
      | Of_list of int option * t list
      | With_backtrace of t * string

    include sig
      [@@@ocaml.warning "-32"]

      val sexp_of_t : t -> Sexplib0.Sexp.t
    end
    [@@merlin.hide]

    val of_info : info -> t
    val to_info : t -> info
  end

  module type Portable = sig
    type info
    type t = info Modes.Portable.t

    include sig
      [@@@ocaml.warning "-32"]

      include Ppx_compare_lib.Comparable.S with type t := t
      include Ppx_compare_lib.Equal.S with type t := t

      val globalize : t -> t

      include Ppx_hash_lib.Hashable.S with type t := t
      include Sexplib0.Sexpable.S with type t := t

      val t_sexp_grammar : t Sexplib0.Sexp_grammar.t
    end
    [@@merlin.hide]

    val create_s : Sexp.t -> t
    val of_string : string -> t
    val of_list : t list -> t
    val of_portable_lazy : string Portable_lazy.t -> t
    val of_portable_lazy_sexp : Sexp.t Portable_lazy.t -> t
    val of_portable_lazy_t : t Portable_lazy.t -> t

    val create
      : 'a.
      ?here:Stdlib.Lexing.position -> ?strict:unit -> string -> 'a -> ('a -> Sexp.t) -> t

    val tag_s : t -> tag:Sexp.t -> t
    val tag : t -> tag:string -> t
    val tag_arg : 'a. t -> string -> 'a -> ('a -> Sexp.t) -> t
    val of_thunk : (unit -> string) -> t
    val createf : ('a, unit, string, t) format4 -> 'a
  end

  module type S0 = sig
    type t

    include sig
      [@@@ocaml.warning "-32"]

      include Ppx_compare_lib.Comparable.S with type t := t
      include Ppx_compare_lib.Equal.S with type t := t

      val globalize : t -> t

      include Ppx_hash_lib.Hashable.S with type t := t
      include Sexplib0.Sexpable.S with type t := t

      val t_sexp_grammar : t Sexplib0.Sexp_grammar.t
    end
    [@@merlin.hide]

    type info := t

    val t_of_sexp : Sexp.t -> t
    val invariant : t -> unit
    val to_string_hum : t -> string
    val to_string_mach : t -> string
    val of_string : string -> t
    val of_lazy : string lazy_t -> t
    val of_lazy_sexp : Sexp.t lazy_t -> t
    val of_lazy_t : t lazy_t -> t
    val of_thunk : (unit -> string) -> t
    val of_portable_lazy : string Portable_lazy.t -> t
    val of_portable_lazy_sexp : Sexp.t Portable_lazy.t -> t
    val of_portable_lazy_t : t Portable_lazy.t -> t

    val create
      : 'a.
      ?here:Stdlib.Lexing.position -> ?strict:unit -> string -> 'a -> ('a -> Sexp.t) -> t

    val create_s : Sexp.t -> t
    val createf : ('a, unit, string, t) format4 -> 'a
    val createf_portable : ('a, unit, string, unit -> t) format4 -> 'a
    val tag : t -> tag:string -> t
    val tag_s : t -> tag:Sexp.t -> t
    val tag_lazy : t -> tag:string lazy_t -> t
    val tag_portable_lazy : t -> tag:string Portable_lazy.t -> t
    val tag_s_lazy : t -> tag:Sexp.t lazy_t -> t
    val tag_s_portable_lazy : t -> tag:Sexp.t Portable_lazy.t -> t
    val tag_arg : 'a. t -> string -> 'a -> ('a -> Sexp.t) -> t
    val of_list : t list -> t
    val of_exn : ?backtrace:[ `Get | `This of string ] -> exn -> t
    val to_exn : t -> exn
    val pp : Stdlib.Format.formatter -> t -> unit

    module Internal_repr : Internal_repr with type info := t
    module Portable : Portable with type info := info

    val of_portable : Portable.t -> t
    val to_portable : t -> Portable.t
    val portabilize : t -> t
    val to_portable_portabilize : t -> Portable.t
  end

  module type S = sig
    include S0

    module Utf8 : sig
      val to_string_hum : t -> string
      val to_string_mach : t -> string
    end
  end
end

module type Info0 = sig
  include module type of struct
    include Definitions
  end

  include S0
end

module type Info = sig
  include Info0
  include S with type t := t
end
