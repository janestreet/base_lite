open! Import0

val all : unit -> string list

module type S = sig
  type t

  val pp : Formatter.t -> t -> unit
end

module Register : functor
    (M : sig
       type t

       val module_name : string
       val to_string : t -> string
     end)
    -> S with type t := M.t

module Register_pp : functor
    (M : sig
       include S

       val module_name : string
     end)
    -> S with type t := M.t

val register : string -> unit
