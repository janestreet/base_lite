open! Import0
module Sexp = Sexp0
include Hashable_intf.Definitions

type 'a t =
  { hash : 'a -> int
  ; compare : 'a -> 'a -> int
  ; sexp_of_t : 'a -> Sexp.t
  }

let equal a b =
  phys_equal a b
  || (phys_equal a.hash b.hash
      && phys_equal a.compare b.compare
      && phys_equal a.sexp_of_t b.sexp_of_t)
;;

let hash_param = Stdlib.Hashtbl.hash_param
let hash = Stdlib.Hashtbl.hash
let poly = { hash; compare = Poly.compare; sexp_of_t = (fun _ -> Sexp.Atom "_") }

let of_key : type a. (module Key with type t = a) -> a t =
  fun (module Key) ->
  { hash = Key.hash; compare = Key.compare; sexp_of_t = Key.sexp_of_t }
;;

let to_key : type a. a t -> (module Key with type t = a) =
  fun { hash; compare; sexp_of_t } ->
  (module struct
    type t = a

    let hash = hash
    let compare = compare
    let sexp_of_t = sexp_of_t
  end : Key
    with type t = a)
;;
