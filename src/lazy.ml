open! Import
include Stdlib.Lazy

type 'a t = 'a lazy_t

include struct
  let _ = fun (_ : 'a t) -> ()
  let t_of_sexp : 'a. (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a t = lazy_t_of_sexp
  let _ = t_of_sexp
  let sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t = sexp_of_lazy_t
  let _ = sexp_of_t

  let t_sexp_grammar : 'a. 'a Sexplib0.Sexp_grammar.t -> 'a t Sexplib0.Sexp_grammar.t =
    fun _'a_sexp_grammar -> lazy_t_sexp_grammar _'a_sexp_grammar
  ;;

  let _ = t_sexp_grammar
end [@@merlin.hide]

external force : 'a t -> 'a = "%lazy_force"

let globalize = Globalize.globalize_lazy_t
let map t ~f = lazy (f (force t))

let compare_internal compare_a t1 t2 =
  if phys_equal t1 t2 then 0 else compare_a (force t1) (force t2)
;;

let compare compare_a t1 t2 = compare_internal compare_a t1 t2

let equal_internal equal_a t1 t2 =
  if phys_equal t1 t2 then true else equal_a (force t1) (force t2)
;;

let equal equal_a t1 t2 = equal_internal equal_a t1 t2
let hash_fold_t = Hash.Builtin.hash_fold_lazy_t
let peek t = if is_val t then Some (force t) else None

include Monad.Make (struct
    type nonrec 'a t = 'a t

    let return x = from_val x
    let bind t ~f = lazy (force (f (force t)))
    let map = map
    let map = `Custom map
  end)

module T_unforcing = struct
  type nonrec 'a t = 'a t

  let is_val t = Obj.tag (Obj.repr t) <> Stdlib.Obj.lazy_tag

  let sexp_of_t sexp_of_a t =
    if is_val t then sexp_of_a (force t) else sexp_of_string "<unforced lazy>"
  ;;
end
