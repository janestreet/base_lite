open! Import0
module Array = Array0

module Cheap_option = struct
  let phys_same (type a b) (a : a) (b : b) = phys_equal a (Obj.magic b : a)

  module T0 : sig
    type 'a t

    val none : 'a. 'a t
    val some : 'a. 'a -> 'a t
    val is_none : 'a. 'a t -> bool
    val is_some : 'a. 'a t -> bool
    val value_exn : 'a. 'a t -> 'a
    val value_unsafe : 'a. 'a t -> 'a
    val iter_some : 'a. 'a t -> f:('a -> unit) -> unit
    val get_none : 'a. unit -> 'a t
  end = struct
    type +'a t

    let none_substitute : _ t =
      Stdlib.Obj.magic_portable
        (Stdlib.Obj.obj (Stdlib.Obj.new_block Stdlib.Obj.abstract_tag 1))
    ;;

    let none : _ t = Stdlib.Obj.magic_portable (Stdlib.Obj.magic `x6e8ee3478e1d7449)
    let get_none () = Portability_hacks.magic_uncontended__promise_deeply_immutable none

    let get_none_substitute () =
      Portability_hacks.magic_uncontended__promise_deeply_immutable none_substitute
    ;;

    let is_none x = phys_equal x (get_none ())
    let is_some x = not (phys_equal x (get_none ()))

    let some (type a) (x : a) : a t =
      if phys_same x (get_none ()) then get_none_substitute () else Obj.magic x
    ;;

    let value_unsafe (type a) (x : a t) : a =
      if phys_equal x (get_none_substitute ())
      then Obj.magic (get_none ())
      else Obj.magic x
    ;;

    let value_exn x =
      if is_some x
      then value_unsafe x
      else failwith "Option_array.get_some_exn: the element is [None]"
    ;;

    let iter_some t ~f = if is_some t then f (value_unsafe t)
  end

  module T1 = struct
    include T0

    let of_option = function
      | None -> get_none ()
      | Some x -> some x
    ;;

    let to_option x = if is_some x then Some (value_unsafe x) else None
    let to_or_null x = if is_some x then This (value_unsafe x) else Null
    let to_option_local x = if is_some x then Some (value_unsafe x) else None
    let to_sexpable = to_option
    let of_sexpable = of_option

    let t_sexp_grammar (type a) (grammar : a Sexplib0.Sexp_grammar.t)
      : a t Sexplib0.Sexp_grammar.t
      =
      Sexplib0.Sexp_grammar.coerce (Option.t_sexp_grammar grammar)
    ;;
  end

  include T1
  include Sexpable.Of_sexpable1 (Option) (T1)
end

type 'a t = 'a Cheap_option.t Uniform_array.t

include (
struct
  type 'a t = 'a Cheap_option.t Uniform_array.t

  include struct
    let _ = fun (_ : 'a t) -> ()

    let t_of_sexp : 'a. (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a t =
      fun _of_a__001_ x__003_ ->
      Uniform_array.t_of_sexp (Cheap_option.t_of_sexp _of_a__001_) x__003_
    ;;

    let _ = t_of_sexp

    let sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t =
      fun _of_a__004_ x__005_ ->
      Uniform_array.sexp_of_t (Cheap_option.sexp_of_t _of_a__004_) x__005_
    ;;

    let _ = sexp_of_t

    let t_sexp_grammar : 'a. 'a Sexplib0.Sexp_grammar.t -> 'a t Sexplib0.Sexp_grammar.t =
      fun _'a_sexp_grammar ->
      Uniform_array.t_sexp_grammar (Cheap_option.t_sexp_grammar _'a_sexp_grammar)
    ;;

    let _ = t_sexp_grammar
  end [@@merlin.hide]
end :
  sig
    type 'a t = 'a Cheap_option.t Uniform_array.t

    include sig
      [@@@ocaml.warning "-32"]

      include Sexplib0.Sexpable.S1 with type 'a t := 'a t

      val t_sexp_grammar : 'a. 'a Sexplib0.Sexp_grammar.t -> 'a t Sexplib0.Sexp_grammar.t
    end
    [@@merlin.hide]
  end
  with type 'a t := 'a Cheap_option.t Uniform_array.t)

let empty = Uniform_array.empty
let get_empty __eta_0 = Uniform_array.get_empty __eta_0
let create ~len = Uniform_array.create ~len (Cheap_option.get_none ())
let init n ~f = Uniform_array.init n ~f:(fun i -> Cheap_option.of_option (f i)) [@nontail]
let init_some n ~f = Uniform_array.init n ~f:(fun i -> Cheap_option.some (f i)) [@nontail]
let length = Uniform_array.length
let get t i = Cheap_option.to_option (Uniform_array.get t i)
let get_or_null t i = Cheap_option.to_or_null (Uniform_array.get t i)
let get_local t i = Cheap_option.to_option_local (Uniform_array.get t i)
let get_some_exn t i = Cheap_option.value_exn (Uniform_array.get t i)
let is_none t i = Cheap_option.is_none (Uniform_array.get t i)
let is_some t i = Cheap_option.is_some (Uniform_array.get t i)
let set t i x = Uniform_array.set t i (Cheap_option.of_option x)
let set_some t i x = Uniform_array.set t i (Cheap_option.some x)
let set_none t i = Uniform_array.set t i (Cheap_option.get_none ())
let swap t i j = Uniform_array.swap t i j
let unsafe_get t i = Cheap_option.to_option (Uniform_array.unsafe_get t i)
let unsafe_get_some_exn t i = Cheap_option.value_exn (Uniform_array.unsafe_get t i)

let unsafe_get_some_assuming_some t i =
  Cheap_option.value_unsafe (Uniform_array.unsafe_get t i)
;;

let unsafe_is_some t i = Cheap_option.is_some (Uniform_array.unsafe_get t i)
let unsafe_set t i x = Uniform_array.unsafe_set t i (Cheap_option.of_option x)
let unsafe_set_some t i x = Uniform_array.unsafe_set t i (Cheap_option.some x)
let unsafe_set_none t i = Uniform_array.unsafe_set t i (Cheap_option.get_none ())

let clear t =
  for i = 0 to length t - 1 do
    unsafe_set_none t i
  done
;;

let iteri input ~f =
  for i = 0 to length input - 1 do
    f i (unsafe_get input i)
  done
;;

let iter input ~f = iteri input ~f:(fun (_ : int) x -> f x) [@nontail]

let foldi input ~init ~f =
  let acc = ref init in
  iteri input ~f:(fun i elem -> acc := f i !acc elem);
  !acc
;;

let fold input ~init ~f = foldi input ~init ~f:(fun (_ : int) acc x -> f acc x) [@nontail]

include Indexed_container.Make_gen (struct
    type nonrec ('a, _, _) t = 'a t
    type 'a elt = 'a option

    let fold_until t ~init ~f ~finish = Container.fold_until ~fold t ~init ~f ~finish
    let fold = `Custom fold
    let foldi = `Custom foldi
    let foldi_until = `Define_using_fold_until
    let iter_until = `Define_using_fold_until
    let iter = `Custom iter
    let iteri = `Custom iteri
    let length = `Custom length
  end)

let length = Uniform_array.length

let mapi input ~f =
  let output = create ~len:(length input) in
  iteri input ~f:(fun i elem -> unsafe_set output i (f i elem));
  output
;;

let map input ~f = mapi input ~f:(fun (_ : int) elem -> f elem) [@nontail]

let map_some input ~f =
  let len = length input in
  let output = create ~len in
  let () =
    for i = 0 to len - 1 do
      let opt = Uniform_array.unsafe_get input i in
      Cheap_option.iter_some opt ~f:(fun x -> unsafe_set_some output i (f x))
    done
  in
  output
;;

let of_array array = init (Array.length array) ~f:(fun i -> Array.unsafe_get array i)

let of_array_some array =
  init_some (Array.length array) ~f:(fun i -> Array.unsafe_get array i)
;;

let to_array t = Array.init (length t) ~f:(fun i -> unsafe_get t i)

include Blit.Make1 (struct
    type nonrec 'a t = 'a t

    let length = length
    let create_like ~len _ = create ~len
    let unsafe_blit = Uniform_array.unsafe_blit
  end)

let copy = Uniform_array.copy

module For_testing = struct
  module Unsafe_cheap_option = Cheap_option
end
