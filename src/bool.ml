open! Import
module Error = Error0
module Sexp = Sexp0
include Bool0

let invalid_argf = Printf.invalid_argf

module T = struct
  type t = bool

  include struct
    let _ = fun (_ : t) -> ()
    let compare = (compare_bool : t -> (t[@merlin.hide]) -> int)
    let _ = compare
    let all = (all_of_bool : t list)
    let _ = all
    let globalize : t -> t = globalize_bool
    let _ = globalize

    let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
      hash_fold_bool

    and hash : t -> Ppx_hash_lib.Std.Hash.hash_value = fun x -> hash_bool x

    let _ = hash_fold_t
    and _ = hash

    let t_of_sexp = (bool_of_sexp : Sexplib0.Sexp.t -> t)
    and t_u_of_sexp = (bool_u_of_sexp : Sexplib0.Sexp.t -> t)

    let _ = t_of_sexp
    and _ = t_u_of_sexp

    let sexp_of_t = (sexp_of_bool : t -> Sexplib0.Sexp.t)
    and sexp_of_t_u = (sexp_of_bool_u : t -> Sexplib0.Sexp.t)

    let _ = sexp_of_t
    and _ = sexp_of_t_u

    let t_sexp_grammar : t Sexplib0.Sexp_grammar.t = bool_sexp_grammar
    let _ = t_sexp_grammar
  end [@@merlin.hide]

  let hashable : t Hashable.t = { hash; compare; sexp_of_t }

  let of_string = function
    | "true" -> true
    | "false" -> false
    | s -> invalid_argf "Bool.of_string: expected true or false but got %s" s ()
  ;;

  let to_string = Stdlib.string_of_bool
end

include T
include Comparator.Make (T)

include Pretty_printer.Register (struct
    type nonrec t = t

    let to_string = to_string
    let module_name = "Base.Bool"
  end)

open! Bool_replace_polymorphic_compare

let invariant (_ : t) = ()
let between t ~low ~high = low <= t && t <= high
let clamp_unchecked t ~min ~max = if t < min then min else if t <= max then t else max

let clamp_exn t ~min ~max =
  assert (min <= max);
  clamp_unchecked t ~min ~max
;;

let clamp t ~min ~max =
  if min > max
  then
    Error
      (Error.create_s
         (Sexp.message
            "clamp requires [min <= max]"
            [ "min", T.sexp_of_t min; "max", T.sexp_of_t max ]))
  else Ok (clamp_unchecked t ~min ~max)
;;

let to_int x = bool_to_int x

module Non_short_circuiting = struct
  external unsafe_of_int : int -> bool = "%identity"

  let ( || ) a b = unsafe_of_int (to_int a lor to_int b)
  let ( && ) a b = unsafe_of_int (to_int a land to_int b)
end

module Branch_free = Non_short_circuiting

let () = assert (Poly.( = ) (to_int true) 1 && Poly.( = ) (to_int false) 0)

include Bool_replace_polymorphic_compare
