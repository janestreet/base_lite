open! Import0

module type To_stringable = sig
  type t

  val to_string : t -> string
  val to_string : t -> string
end

module type Of_stringable = sig
  type t

  val of_string : string -> t
end

module type S = sig
  type t

  include Of_stringable with type t := t
  include To_stringable with type t := t
end
