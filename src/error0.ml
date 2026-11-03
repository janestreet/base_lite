open! Import0
include Info0

let t_sexp_grammar : t Sexplib0.Sexp_grammar.t = { untyped = Any "Error.t" }
let raise (type a) t : a = raise (to_exn t) [@@cold]
let raise_s (type a) sexp : a = raise (create_s sexp) [@@cold]
let raise (type a) t : a = raise t [@nontail]
let raise_s (type a) sexp : a = raise_s sexp [@nontail]
let to_info t = t
let of_info t = t

let reraise_uncaught t ~f =
  try f () with
  | exn ->
    let bt = Stdlib.Printexc.get_raw_backtrace () in
    Exn.raise_with_original_backtrace
      (to_exn (tag_s_lazy (of_exn exn) ~tag:(lazy (sexp_of_t t))))
      bt
;;

include Pretty_printer.Register_pp (struct
    type nonrec t = t

    let module_name = "Base.Error"
    let pp = pp
  end)
