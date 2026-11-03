module For_generated_code = struct
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

let name (Field field) = field.name
let get (Field field) = field.getter
let fset (Field field) = field.fset
let setter (Field field) = field.setter
let map (Field field) r ~f = field.fset r (f (field.getter r))

let updater (Field field) =
  match field.setter with
  | None -> None
  | Some setter -> Some (fun r ~f -> setter r (f (field.getter r)))
;;

type ('perm, 'record, 'result) user =
  { f : 'field. ('perm, 'record, 'field) t_with_perm -> 'result }
