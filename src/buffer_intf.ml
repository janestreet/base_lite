open! Import0

module Definitions = struct
  module type S = sig
    type t

    include sig
      [@@@ocaml.warning "-32"]

      val sexp_of_t : t -> Sexplib0.Sexp.t
    end
    [@@merlin.hide]

    val create : int -> t
    val contents : t -> string
    val contents_bytes : t -> bytes

    include Blit.S_distinct with type src := t with type dst := bytes
    module To_string : Blit.S_to_string with type t := t

    val nth : t -> int -> char
    val length : t -> int
    val clear : t -> unit
    val reset : t -> unit
    val truncate : t -> int -> unit
    val add_char : t -> char -> unit
    val add_string : t -> string -> unit
    val add_substring : t -> string -> pos:int -> len:int -> unit
    val add_bytes : t -> bytes -> unit
    val add_subbytes : t -> bytes -> pos:int -> len:int -> unit
    val add_buffer : t -> t -> unit
  end
end

module type Buffer = sig
  include module type of struct
    include Definitions
  end

  include S with type t = Stdlib.Buffer.t
  include Blit.S_distinct_global with type src := t and type dst := bytes
  module To_string : Blit.S_to_string_global with type t := t
end
