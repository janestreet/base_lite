open! Import
module List = List0

include (
struct
  type 'a t = 'a ref

  include struct
    let _ = fun (_ : 'a t) -> ()

    let compare
      : 'a. ('a -> ('a[@merlin.hide]) -> int) -> 'a t -> ('a t[@merlin.hide]) -> int
      =
      fun _cmp__a a__001_ b__002_ ->
      compare_ref
        (fun a__003_ (b__004_ [@merlin.hide]) -> _cmp__a a__003_ b__004_ [@merlin.hide])
        a__001_
        b__002_
    ;;

    let _ = compare

    let equal
      : 'a. ('a -> ('a[@merlin.hide]) -> bool) -> 'a t -> ('a t[@merlin.hide]) -> bool
      =
      fun _cmp__a a__005_ b__006_ ->
      equal_ref
        (fun a__007_ (b__008_ [@merlin.hide]) -> _cmp__a a__007_ b__008_ [@merlin.hide])
        a__005_
        b__006_
    ;;

    let _ = equal

    let globalize : 'a. ('a -> 'a) -> 'a t -> 'a t =
      fun (type a__009_) : ((a__009_ -> a__009_) -> a__009_ t -> a__009_ t) ->
      globalize_ref
    ;;

    let _ = globalize
    let t_of_sexp : 'a. (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a t = ref_of_sexp
    let _ = t_of_sexp
    let sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t = sexp_of_ref
    let _ = sexp_of_t

    let t_sexp_grammar : 'a. 'a Sexplib0.Sexp_grammar.t -> 'a t Sexplib0.Sexp_grammar.t =
      fun _'a_sexp_grammar -> ref_sexp_grammar _'a_sexp_grammar
    ;;

    let _ = t_sexp_grammar
  end [@@merlin.hide]
end :
sig
  type 'a t = 'a ref

  include sig
    [@@@ocaml.warning "-32"]

    val compare
      : 'a.
      ('a -> ('a[@merlin.hide]) -> int) -> 'a t -> ('a t[@merlin.hide]) -> int

    val equal
      : 'a.
      ('a -> ('a[@merlin.hide]) -> bool) -> 'a t -> ('a t[@merlin.hide]) -> bool

    val globalize : 'a. ('a -> 'a) -> 'a t -> 'a t
    val sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t
    val t_of_sexp : 'a. (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a t
    val t_sexp_grammar : 'a. 'a Sexplib0.Sexp_grammar.t -> 'a t Sexplib0.Sexp_grammar.t
  end
  [@@merlin.hide]
end)

type 'a t = 'a ref = { mutable contents : 'a }

external create : 'a. 'a -> 'a t = "%makemutable"
external ( ! ) : 'a. 'a t -> 'a = "%field0"
external ( := ) : 'a. 'a t -> 'a -> unit = "%setfield0"

let swap t1 t2 =
  let tmp = !t1 in
  t1 := !t2;
  t2 := tmp
;;

let replace t f = t := f !t

let set_temporarily t a ~f =
  let restore_to = !t in
  t := a;
  Exn.protect ~f ~finally:(fun () -> t := restore_to)
;;

module And_value = struct
  type t = T : 'a ref * 'a -> t

  include struct
    let _ = fun (_ : t) -> ()

    let sexp_of_t =
      (fun (T (arg0__018_, arg1__019_)) ->
         let res0__020_ = sexp_of_ref (fun _ -> Sexplib0.Sexp.Atom "_") arg0__018_
         and res1__021_ =
           let _ = arg1__019_ in
           Sexplib0.Sexp.Atom "_"
         in
         Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "T"; res0__020_; res1__021_ ]
       : t -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_t
  end [@@merlin.hide]

  let set (T (r, a)) = r := a
  let sets ts = List.iter ts ~f:set
  let snapshot (T (r, _)) = T (r, !r)
  let snapshots ts = List.map ts ~f:snapshot
end

let sets_temporarily and_values ~f =
  let restore_to = And_value.snapshots and_values in
  And_value.sets and_values;
  Exn.protect ~f ~finally:(fun () -> And_value.sets restore_to)
;;
