open! Import
module Bool = Bool0
module Error = Error0
module Source_code_position = Source_code_position0

module T = struct
  type 'a t = 'a or_null =
    | Null
    | This of 'a
end

include T

external is_null : 'a t -> bool = "%obj_is_int"
external unsafe_value : 'a t -> 'a = "%field0"
external really_unsafe_value : 'a t -> 'a = "%field0"

module Optional_syntax = struct
  module Optional_syntax = struct
    let is_none t = is_null t

    let unsafe_value t =
      (really_unsafe_value [@alert "-unsafe_optimizations_if_misapplied"]) t
    ;;
  end
end

include (
struct
  type 'a t = 'a or_null

  include struct
    let _ = fun (_ : 'a t) -> ()

    let globalize : 'a. ('a -> 'a) -> 'a t -> 'a t =
      fun (type a__001_) : ((a__001_ -> a__001_) -> a__001_ t -> a__001_ t) ->
      globalize_or_null
    ;;

    let _ = globalize

    let t_of_sexp : 'a. (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a t =
      or_null_of_sexp
    ;;

    let _ = t_of_sexp

    let sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t =
      sexp_of_or_null
    ;;

    let _ = sexp_of_t

    let hash_fold_t
      : 'a.
      (Ppx_hash_lib.Std.Hash.state -> 'a -> Ppx_hash_lib.Std.Hash.state)
      -> Ppx_hash_lib.Std.Hash.state
      -> 'a t
      -> Ppx_hash_lib.Std.Hash.state
      =
      hash_fold_or_null
    ;;

    let _ = hash_fold_t
  end [@@merlin.hide]
end :
  sig
    type 'a t = 'a or_null

    include sig
      [@@@ocaml.warning "-32"]

      val globalize : 'a. ('a -> 'a) -> 'a t -> 'a t
      val sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t
      val t_of_sexp : 'a. (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a t

      val hash_fold_t
        : 'a.
        (Ppx_hash_lib.Std.Hash.state -> 'a -> Ppx_hash_lib.Std.Hash.state)
        -> Ppx_hash_lib.Std.Hash.state
        -> 'a t
        -> Ppx_hash_lib.Std.Hash.state
    end
    [@@merlin.hide]
  end
  with type 'a t := 'a or_null)

let raise_value_exn ~here =
  let error =
    if Source_code_position.is_dummy here
    then Error.of_string "Or_null.value_exn Null"
    else Error.create "Or_null.value_exn Null" here Source_code_position.sexp_of_t
  in
  Error.raise error
[@@cold]
;;

let compare compare_elt t1 t2 =
  match t1, t2 with
  | Null, Null -> 0
  | Null, This _ -> -1
  | This _, Null -> 1
  | This elt1, This elt2 -> compare_elt elt1 elt2
;;

let equal equal_elt t1 t2 =
  match t1, t2 with
  | Null, Null -> true
  | Null, This _ | This _, Null -> false
  | This elt1, This elt2 -> equal_elt elt1 elt2
;;

let value_exn ?(here = Stdlib.Lexing.dummy_pos) t =
  match t with
  | This x -> x
  | Null -> raise_value_exn ~here
;;

let value_or_thunk o ~default =
  match o with
  | This x -> x
  | Null -> default ()
;;

let iter o ~f =
  match o with
  | Null -> ()
  | This a -> f a
;;

let value_map t ~default ~f =
  match t with
  | This x -> f x
  | Null -> default
;;

let both t1 t2 =
  match t1, t2 with
  | Null, _ | _, Null -> Null
  | This x, This y -> This (x, y)
;;

let bind t ~f =
  match t with
  | This x -> f x
  | Null -> Null
;;

let to_list t =
  match t with
  | Null -> []
  | This x -> [ x ]
;;

let this a = This a

let first_this_thunk t t' =
  match t with
  | This _ -> t
  | Null -> t' ()
;;

let fold t ~init ~f =
  match t with
  | Null -> init
  | This x -> f init x
;;

let mem t a ~equal =
  match t with
  | Null -> false
  | This a' -> equal a a'
;;

let exists t ~f =
  match t with
  | Null -> false
  | This x -> f x
;;

let for_all t ~f =
  match t with
  | Null -> true
  | This x -> f x
;;

let find t ~f =
  match t with
  | Null -> Null
  | This x when f x -> This x
  | This _ -> Null
;;

let to_array = function
  | Null -> [||]
  | This x -> [| x |]
;;

let call x ~f =
  match f with
  | Null -> ()
  | This f -> f x
;;

let to_option = function
  | Null -> None
  | This x -> Some x
;;

let of_option = function
  | None -> Null
  | Some x -> This x
;;

let map_to_option t ~f =
  match t with
  | Null -> None
  | This x -> Some (f x)
;;

let map t ~f =
  match t with
  | Null -> Null
  | This a -> This (f a)
;;

let this_if_thunk b f =
  match b with
  | true -> This (f ())
  | false -> Null
;;

let merge a b ~f =
  match a, b with
  | Null, Null -> Null
  | Null, This x | This x, Null -> This x
  | This x, This y -> This (f x y)
;;

let try_with f =
  match f () with
  | x -> This x
  | exception _ -> Null
;;

let try_with_join f =
  match f () with
  | x -> x
  | exception _ -> Null
;;

let value t ~default =
  match t with
  | Null -> default
  | This x -> x
;;

let this_if b x =
  let this = This x in
  Bool.select b this Null
;;

let first_this t t' =
  let is_null = is_null t in
  Bool.select is_null t' t
;;

let is_null t = is_null t
let is_this t = not (is_null t)
let length t = bool_to_int (is_this t)

module Let_syntax = struct
  let return = this
  let ( >>= ) t f = bind t ~f
  let ( >>| ) t f = map t ~f

  module Let_syntax = struct
    let return = this
    let bind = bind
    let map = map
    let both = both

    module Open_on_rhs = struct end
  end
end

module Local = struct
  module Let_syntax = struct
    let return = this

    module Let_syntax = struct
      let return = this
      let bind = bind
      let map = map
      let both = both

      module Open_on_rhs = struct end
    end
  end
end

let invariant invariant_a = iter ~f:invariant_a

module Export = Basement.Or_null_shim.Export
