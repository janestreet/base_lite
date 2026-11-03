open! Import

module T = struct
  type t = unit

  include struct
    let _ = fun (_ : t) -> ()
    let all = (all_of_unit : t list)
    let _ = all
    let globalize : t -> t = globalize_unit
    let _ = globalize

    let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
      hash_fold_unit

    and hash : t -> Ppx_hash_lib.Std.Hash.hash_value = fun x -> hash_unit x

    let _ = hash_fold_t
    and _ = hash

    let t_of_sexp = (unit_of_sexp : Sexplib0.Sexp.t -> t)
    and t_u_of_sexp = (unit_u_of_sexp : Sexplib0.Sexp.t -> t)

    let _ = t_of_sexp
    and _ = t_u_of_sexp

    let sexp_of_t = (sexp_of_unit : t -> Sexplib0.Sexp.t)
    and sexp_of_t_u = (sexp_of_unit_u : t -> Sexplib0.Sexp.t)

    let _ = sexp_of_t
    and _ = sexp_of_t_u

    let t_sexp_grammar : t Sexplib0.Sexp_grammar.t = unit_sexp_grammar
    let _ = t_sexp_grammar
  end [@@merlin.hide]

  let compare _ _ = 0

  let of_string = function
    | "()" -> ()
    | _ -> failwith "Base.Unit.of_string: () expected"
  ;;

  let to_string () = "()"
  let module_name = "Base.Unit"
end

include T
include Identifiable.Make (T)

let invariant () = ()
