open! Import0
open Int_intf.Definitions
module Sexp := Sexp0

module Make : functor
    (I : sig
       type t

       val to_string : t -> string
     end)
    -> sig
  val to_string_hum : ?delimiter:char -> I.t -> string
  val sexp_of_t : I.t -> Sexp.t

  module Provide_unboxed : functor
      (U : sig
         type t

         val box : t -> I.t
       end)
      -> sig
    val sexp_of_t_u : U.t -> Sexp.t
  end
end

module Make_hex : functor
    (I : sig
       type t

       include sig
         [@@@ocaml.warning "-32"]

         include Ppx_compare_lib.Comparable.S with type t := t
         include Ppx_hash_lib.Hashable.S with type t := t
       end
       [@@merlin.hide]

       val to_string : t -> string
       val of_string : string -> t
       val zero : t
       val ( < ) : t -> t -> bool
       val neg : t -> t
       val module_name : string
     end)
    -> sig
  include Hexable with type t := I.t
end

module Make_binary : functor
    (I : sig
       type t

       include sig
         [@@@ocaml.warning "-32"]

         include Ppx_compare_lib.Comparable.S with type t := t
         include Ppx_compare_lib.Equal.S with type t := t
         include Ppx_hash_lib.Hashable.S with type t := t
       end
       [@@merlin.hide]

       val clz : t -> t
       val ( lsr ) : t -> int -> t
       val ( land ) : t -> t -> t
       val to_int_trunc : t -> int
       val num_bits : t
       val one : t
       val zero : t
       val ( - ) : t -> t -> t
     end)
    -> sig
  include Binaryable with type t := I.t
end

val sexp_of_int_style : [ `No_underscores | `Underscores ] Dynamic.t
val insert_delimiter_every : string -> delimiter:char -> chars_per_delimiter:int -> string
val insert_delimiter : string -> delimiter:char -> string
val insert_underscores : string -> string
