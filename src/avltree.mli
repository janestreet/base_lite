open! Import0

type ('k, 'v) t = private
  | Empty
  | Node of
      { mutable left : ('k, 'v) t
      ; key : 'k
      ; mutable value : 'v
      ; mutable height : int
      ; mutable right : ('k, 'v) t
      }
  | Leaf of
      { key : 'k
      ; mutable value : 'v
      }

val first : ('k, 'v) t -> ('k * 'v) option
val last : ('k, 'v) t -> ('k * 'v) option

type ('k, 'v) t := ('k, 'v) t

val empty : ('k, 'v) t
val get_empty : 'k 'v. unit -> ('k, 'v) t
val is_empty : 'k 'v. ('k, 'v) t -> bool
val invariant : 'k 'v. ('k, 'v) t -> compare:('k -> 'k -> int) -> unit

val add
  : 'k 'v.
  ('k, 'v) t
  -> replace:bool
  -> compare:('k -> 'k -> int)
  -> added:bool ref
  -> key:'k
  -> data:'v
  -> ('k, 'v) t

val find : ('k, 'v) t -> compare:('k -> 'k -> int) -> 'k -> 'v Option.t

include sig
  val find_and_call
    : 'k 'v 'r.
    ('k, 'v) t
    -> compare:('k -> 'k -> int)
    -> 'k
    -> if_found:('v -> 'r)
    -> if_not_found:('k -> 'r)
    -> 'r

  val findi_and_call
    : 'k 'v 'r.
    ('k, 'v) t
    -> compare:('k -> 'k -> int)
    -> 'k
    -> if_found:(key:'k -> data:'v -> 'r)
    -> if_not_found:('k -> 'r)
    -> 'r

  val find_and_call1
    : 'k 'v 'a 'r.
    ('k, 'v) t
    -> compare:('k -> 'k -> int)
    -> 'k
    -> a:'a
    -> if_found:('v -> 'a -> 'r)
    -> if_not_found:('k -> 'a -> 'r)
    -> 'r

  val findi_and_call1
    : 'k 'v 'a 'r.
    ('k, 'v) t
    -> compare:('k -> 'k -> int)
    -> 'k
    -> a:'a
    -> if_found:(key:'k -> data:'v -> 'a -> 'r)
    -> if_not_found:('k -> 'a -> 'r)
    -> 'r

  val find_and_call2
    : 'k 'v 'a 'b 'r.
    ('k, 'v) t
    -> compare:('k -> 'k -> int)
    -> 'k
    -> a:'a
    -> b:'b
    -> if_found:('v -> 'a -> 'b -> 'r)
    -> if_not_found:('k -> 'a -> 'b -> 'r)
    -> 'r

  val findi_and_call2
    : 'k 'v 'a 'b 'r.
    ('k, 'v) t
    -> compare:('k -> 'k -> int)
    -> 'k
    -> a:'a
    -> b:'b
    -> if_found:(key:'k -> data:'v -> 'a -> 'b -> 'r)
    -> if_not_found:('k -> 'a -> 'b -> 'r)
    -> 'r
end

val mem : 'k 'v. ('k, 'v) t -> compare:('k -> 'k -> int) -> 'k -> bool

val remove
  : 'k 'v.
  ('k, 'v) t -> removed:bool ref -> compare:('k -> 'k -> int) -> 'k -> ('k, 'v) t

val fold
  : 'k 'v 'acc.
  ('k, 'v) t -> init:'acc -> f:(key:'k -> data:'v -> 'acc -> 'acc) -> 'acc

val iter : 'k 'v. ('k, 'v) t -> f:(key:'k -> data:'v -> unit) -> unit
val exists : 'k 'v. ('k, 'v) t -> f:(key:'k -> data:'v -> bool) -> bool
val mapi_inplace : 'k 'v. ('k, 'v) t -> f:(key:'k -> data:'v -> 'v) -> unit
val choose_exn : 'k 'v. ('k, 'v) t -> 'k * 'v
