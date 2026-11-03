include module type of struct
  include Sexp0
end

include Comparable.S with type t := t

val cross_portable : t Basement.Portability_hacks.Cross.Portable.t
val cross_contended : t Basement.Portability_hacks.Cross.Contended.t

module type Pretty_printing = Sexplib0.Sexp.Pretty_printing
module type Pretty_printing_to_string = Pretty_printing with type output := string

include Pretty_printing_to_string
module Utf8 : Pretty_printing with type output := String.Utf8.t
module Utf8_as_string : Pretty_printing_to_string

module Private : sig
  module Utf8 : sig
    val escaped : string -> quoted:bool -> string
  end
end
[@@alert
  base_sexp_private "This module is intended only for use in testing [Base.Sexp] itself."]
