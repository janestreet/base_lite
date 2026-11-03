open! Import0
module Sexp = Sexp0
module Info = Info0

module type Error0 = sig
  type t = private Info.t

  include Info.S0 with type t := t

  val raise : 'a. t -> 'a
  val raise_s : 'a. Sexp.t -> 'a
  val reraise_uncaught : t -> f:(unit -> 'a) -> 'a
  val to_info : t -> Info.t
  val of_info : Info.t -> t
end

module type Error_with_extras = sig
  include Error0
  include Info.S with type t := t
end
