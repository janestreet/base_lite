module For_generated_code : sig
  type ('perm, 'record, 'field) t =
    { force_variance : 'perm -> unit
    ; name : string
    ; setter : ('record -> 'field -> unit) option
    ; getter : 'record -> 'field
    ; fset : 'record -> 'field -> 'record
    }

  external opaque_identity : 'a. 'a -> 'a = "%opaque"
end

type ('perm, 'record, 'field) t_with_perm =
  | Field of ('perm, 'record, 'field) For_generated_code.t
[@@unboxed]

type ('record, 'field) t = ([ `Read | `Set_and_create ], 'record, 'field) t_with_perm
type ('record, 'field) readonly_t = ([ `Read ], 'record, 'field) t_with_perm

val name : (_, _, _) t_with_perm -> string
val get : 'perm 'r 'a. ('perm, 'r, 'a) t_with_perm -> 'r -> 'a
val fset : 'a 'r. ([> `Set_and_create ], 'r, 'a) t_with_perm -> 'r -> 'a -> 'r

val setter
  : 'a 'r.
  ([> `Set_and_create ], 'r, 'a) t_with_perm -> ('r -> 'a -> unit) option

val map : 'a 'r. ([> `Set_and_create ], 'r, 'a) t_with_perm -> 'r -> f:('a -> 'a) -> 'r

val updater
  : 'a 'r.
  ([> `Set_and_create ], 'r, 'a) t_with_perm -> ('r -> f:('a -> 'a) -> unit) option

type ('perm, 'record, 'result) user =
  { f : 'field. ('perm, 'record, 'field) t_with_perm -> 'result }
