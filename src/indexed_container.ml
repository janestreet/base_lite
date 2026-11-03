open! Import0
module Array = Array0
module Either = Either0
open Container.Export
include Indexed_container_intf.Definitions

module Derived : Derived = struct
  let foldi_alloc ~fold t ~init ~f =
    let i = ref 0 in
    fold t ~init ~f:(fun acc v ->
      let idx = !i in
      i := idx + 1;
      f idx acc v)
    [@nontail]
  ;;

  let foldi = foldi_alloc

  let foldi_until ~fold_until t ~init ~f ~finish =
    let i = ref 0 in
    fold_until
      t
      ~init
      ~f:(fun acc v ->
        let idx = !i in
        i := idx + 1;
        f idx acc v)
      ~finish:(fun acc ->
        let i = !i in
        finish i acc) [@nontail]
  ;;

  let foldi_until = foldi_until

  let iteri_until_alloc ~foldi_until t ~f ~finish =
    foldi_until
      t
      ~init:()
      ~f:(fun i () x -> f i x)
      ~finish:(fun i () -> finish i) [@nontail]
  ;;

  let iteri_until = iteri_until_alloc

  include struct
    let iteri ~fold t ~f =
      ignore
        (fold t ~init:0 ~f:(fun i x ->
           f i x;
           i + 1)
         : int)
    ;;

    let counti ~foldi t ~f =
      foldi t ~init:0 ~f:(fun i n a -> if f i a then n + 1 else n) [@nontail]
    ;;

    let existsi ~iteri_until c ~f =
      iteri_until
        c
        ~f:(fun i x ->
          if f i x then Continue_or_stop.Stop true else Continue_or_stop.Continue ())
        ~finish:(fun _ -> false) [@nontail]
    ;;

    let for_alli ~iteri_until c ~f =
      iteri_until
        c
        ~f:(fun i x ->
          if f i x then Continue_or_stop.Continue () else Continue_or_stop.Stop false)
        ~finish:(fun _ -> true) [@nontail]
    ;;
  end

  let findi_alloc ~iteri_until c ~f =
    iteri_until
      c
      ~f:(fun i x ->
        if f i x
        then Continue_or_stop.Stop (Some (i, x))
        else Continue_or_stop.Continue ())
      ~finish:(fun _ -> None) [@nontail]
  ;;

  let findi = findi_alloc

  let find_mapi_alloc ~iteri_until t ~f =
    iteri_until
      t
      ~f:(fun i x ->
        match f i x with
        | None -> Continue_or_stop.Continue ()
        | Some _ as res -> Continue_or_stop.Stop res)
      ~finish:(fun _ -> None) [@nontail]
  ;;

  let find_mapi = find_mapi_alloc
end

include Derived

module Make_gen_with_container
    (T : Make_gen_arg)
    (C : Container.Generic
         with type ('a, 'phantom1, 'phantom2) t := ('a, 'phantom1, 'phantom2) T.t
          and type 'a elt := 'a T.elt) :
  Generic
  with type ('a, 'phantom1, 'phantom2) t := ('a, 'phantom1, 'phantom2) T.t
   and type 'a elt := 'a T.elt = struct
  include C

  let iteri =
    match T.iteri with
    | `Custom iteri -> iteri
    | `Define_using_fold -> fun t ~f -> iteri ~fold t ~f [@nontail]
  ;;

  let foldi =
    match T.foldi with
    | `Custom foldi -> foldi
    | `Define_using_fold -> fun t ~init ~f -> foldi ~fold t ~init ~f
  ;;

  let foldi_until t ~init ~f ~finish = foldi_until ~fold_until t ~init ~f ~finish
  let iteri_until t ~f ~finish = iteri_until ~foldi_until t ~f ~finish
  let counti t ~f = counti ~foldi t ~f
  let existsi t ~f = existsi ~iteri_until t ~f
  let for_alli t ~f = for_alli ~iteri_until t ~f
  let find_mapi t ~f = find_mapi ~iteri_until t ~f
  let findi t ~f = findi ~iteri_until t ~f
end

module Make_gen (T : Make_gen_arg) :
  Generic
  with type ('a, 'phantom1, 'phantom2) t := ('a, 'phantom1, 'phantom2) T.t
   and type 'a elt := 'a T.elt = struct
  module C = Container.Make_gen (T)
  include C
  include Make_gen_with_container (T) (C)
end

module Make (T : Make_arg) = struct
  include Make_gen (struct
      include T

      type ('a, _, _) t = 'a T.t
      type 'a elt = 'a
    end)

  let to_array t = Container.to_array ~length ~iter t
end

module Make0 (T : Make0_arg) = struct
  include Make_gen (struct
      include T

      type (_, _, _) t = T.t
      type 'a elt = T.Elt.t
    end)

  let mem t x = mem t x ~equal:T.Elt.equal
  let to_array t = Container.to_array ~length ~iter t
end

module Make_gen_with_creators (T : Make_gen_with_creators_arg) :
  Generic_with_creators
  with type ('a, 'phantom1, 'phantom2) t := ('a, 'phantom1, 'phantom2) T.t
   and type 'a elt := 'a T.elt
   and type ('a, 'phantom1, 'phantom2) concat := ('a, 'phantom1, 'phantom2) T.concat =
struct
  module C = Container.Make_gen_with_creators (T)
  include C
  include Make_gen_with_container (T) (C)

  let of_array = T.of_array
  let to_array t = Container.to_array ~length ~iter t
  let derived_init n ~f = of_array (Array.init n ~f)

  let init =
    match T.init with
    | `Custom init -> init
    | `Define_using_of_array -> derived_init
  ;;

  let derived_concat_mapi t ~f = concat (T.concat_of_array (Array.mapi (to_array t) ~f))

  let concat_mapi =
    match T.concat_mapi with
    | `Custom concat_mapi -> concat_mapi
    | `Define_using_concat -> derived_concat_mapi
  ;;

  let filter_mapi t ~f =
    concat_mapi t ~f:(fun i x ->
      match f i x with
      | None -> of_array [||]
      | Some y -> of_array [| y |])
    [@nontail]
  ;;

  let mapi t ~f = filter_mapi t ~f:(fun i x -> Some (f i x)) [@nontail]

  let filteri t ~f =
    filter_mapi t ~f:(fun i x -> if f i x then Some x else None) [@nontail]
  ;;

  let partition_mapi t ~f =
    let array = Array.mapi (to_array t) ~f in
    let xs =
      Array.fold_right array ~init:[] ~f:(fun either acc ->
        match (either : _ Either.t) with
        | First x -> x :: acc
        | Second _ -> acc)
    in
    let ys =
      Array.fold_right array ~init:[] ~f:(fun either acc ->
        match (either : _ Either.t) with
        | First _ -> acc
        | Second x -> x :: acc)
    in
    of_list xs, of_list ys
  ;;

  let partitioni_tf t ~f =
    partition_mapi t ~f:(fun i x -> if f i x then First x else Second x) [@nontail]
  ;;
end

module Make_with_creators (T : Make_with_creators_arg) = struct
  include Make_gen_with_creators (struct
      include T

      type ('a, _, _) t = 'a T.t
      type 'a elt = 'a
      type ('a, _, _) concat = 'a T.t

      let concat_of_array = of_array
    end)

  let to_array t = Container.to_array ~length ~iter t
  let of_array = T.of_array
end

module Make0_with_creators (T : Make0_with_creators_arg) = struct
  include Make_gen_with_creators (struct
      include T

      type (_, _, _) t = T.t
      type 'a elt = T.Elt.t
      type ('a, _, _) concat = 'a list

      let concat_of_array = Array.to_list
    end)

  let mem t x = mem t x ~equal:T.Elt.equal
  let to_array t = Container.to_array ~length ~iter t
  let of_array = T.of_array
end
