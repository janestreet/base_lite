[@@@ocaml.flambda_o3]

open Import
open Ppx_compare_lib.Builtin
open Globalize
module Error = Error0
module Nothing = Nothing0
module Sexp = Sexp0

module T = struct
  type 'a t = 'a Nonempty_list_type.Nonempty_list.t = ( :: ) of 'a * 'a list

  let to_list (hd :: tl) : _ List.t = hd :: tl

  let of_list_exn : _ List.t -> _ t = function
    | [] -> Error.raise_s (Atom "Nonempty_list.of_list_exn: empty list")
    | hd :: tl -> hd :: tl
  ;;
end

include T
module For_deriving = struct end
include For_deriving

module Format = struct
  type 'a t = 'a list

  include struct
    let _ = fun (_ : 'a t) -> ()
    let t_of_sexp : 'a. (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a t = list_of_sexp
    let _ = t_of_sexp
    let sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t = sexp_of_list
    let _ = sexp_of_t
  end [@@merlin.hide]
end

module To = struct
  include T

  let to_sexpable = to_list
  let of_sexpable = of_list_exn
end

include Sexpable.Of_sexpable1 (Format) (To)

let t_sexp_grammar (type a) ({ untyped = element } : a Sexplib0.Sexp_grammar.t)
  : a t Sexplib0.Sexp_grammar.t
  =
  { untyped = List (Cons (element, Many element)) }
;;

type nonrec 'a t = 'a t = ( :: ) of 'a * 'a list

include struct
  let _ = fun (_ : 'a t) -> ()

  let compare
    : 'a. ('a -> ('a[@merlin.hide]) -> int) -> 'a t -> ('a t[@merlin.hide]) -> int
    =
    fun _cmp__a a__006_ b__007_ ->
    if Stdlib.( == ) a__006_ b__007_
    then 0
    else (
      match a__006_, b__007_ with
      | _a__008_ :: _a__010_, _b__009_ :: _b__011_ ->
        (match _cmp__a _a__008_ _b__009_ with
         | 0 ->
           compare_list
             (fun a__012_ (b__013_ [@merlin.hide]) ->
               _cmp__a a__012_ b__013_ [@merlin.hide])
             _a__010_
             _b__011_
         | n -> n))
  ;;

  let _ = compare

  let equal
    : 'a. ('a -> ('a[@merlin.hide]) -> bool) -> 'a t -> ('a t[@merlin.hide]) -> bool
    =
    fun _cmp__a a__014_ b__015_ ->
    if Stdlib.( == ) a__014_ b__015_
    then true
    else (
      match a__014_, b__015_ with
      | _a__016_ :: _a__018_, _b__017_ :: _b__019_ ->
        Stdlib.( && )
          (_cmp__a _a__016_ _b__017_)
          (equal_list
             (fun a__020_ (b__021_ [@merlin.hide]) ->
               _cmp__a a__020_ b__021_ [@merlin.hide])
             _a__018_
             _b__019_))
  ;;

  let _ = equal

  let hash_fold_t
    : 'a.
    (Ppx_hash_lib.Std.Hash.state -> 'a -> Ppx_hash_lib.Std.Hash.state)
    -> Ppx_hash_lib.Std.Hash.state
    -> 'a t
    -> Ppx_hash_lib.Std.Hash.state
    =
    fun (type a)
      :  ((Ppx_hash_lib.Std.Hash.state -> a -> Ppx_hash_lib.Std.Hash.state)
      -> Ppx_hash_lib.Std.Hash.state -> a t -> Ppx_hash_lib.Std.Hash.state) ->
    fun _hash_fold_a hsv arg ->
    match arg with
    | _a0 :: _a1 ->
      let hsv = hsv in
      let hsv =
        let hsv = hsv in
        _hash_fold_a hsv _a0
      in
      hash_fold_list _hash_fold_a hsv _a1
  ;;

  let _ = hash_fold_t

  let globalize : 'a. ('a -> 'a) -> 'a t -> 'a t =
    fun (type a__022_) : ((a__022_ -> a__022_) -> a__022_ t -> a__022_ t) ->
    fun _globalize_a__023_ x__024_ ->
    match x__024_ with
    | arg__027_ :: arg__025_ ->
      _globalize_a__023_ arg__027_ :: globalize_list _globalize_a__023_ arg__025_
  ;;

  let _ = globalize
end [@@merlin.hide]

include Comparator.Derived (struct
    type nonrec 'a t = 'a t

    include struct
      let _ = fun (_ : 'a t) -> ()

      let compare
        : 'a. ('a -> ('a[@merlin.hide]) -> int) -> 'a t -> ('a t[@merlin.hide]) -> int
        =
        fun _cmp__a a__028_ b__029_ ->
        compare
          (fun a__030_ (b__031_ [@merlin.hide]) -> _cmp__a a__030_ b__031_ [@merlin.hide])
          a__028_
          b__029_
      ;;

      let _ = compare
      let sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t = sexp_of_t
      let _ = sexp_of_t
    end [@@merlin.hide]
  end)

open struct
  type nonrec 'a t = 'a t = ( :: ) of 'a * 'a List.t
end

let length (_ :: tl) = 1 + List.length tl

include struct
  let of_list : _ List.t -> _ t option = function
    | [] -> None
    | hd :: tl -> Some (hd :: tl)
  ;;

  let of_list_or_null : _ List.t -> _ t or_null = function
    | [] -> Null
    | hd :: tl -> This (hd :: tl)
  ;;

  let of_list_error : _ List.t -> _ t Or_error.t = function
    | [] -> Or_error.error_s (Atom "empty list")
    | hd :: tl -> Ok (hd :: tl)
  ;;

  let of_list_exn l = of_list_exn l
  let to_list t = to_list t
  let hd (hd :: _) = hd
  let tl (_ :: tl) : _ List.t = tl

  let nth (hd :: tl) n : _ Option.t =
    match n with
    | 0 -> Some hd
    | n -> List.nth tl (n - 1)
  ;;

  let nth_exn t n =
    match nth t n with
    | Some a -> a
    | None ->
      (match
         Printf.invalid_argf
           "Nonempty_list.nth_exn %d called on list of length %d"
           n
           (length t)
           ()
       with
       | (_ : Nothing.t) -> .)
  ;;

  let reduce (hd :: tl) ~f = List.fold ~init:hd tl ~f
  let last (hd :: tl) = List.fold tl ~init:hd ~f:(fun _ elt -> elt)

  let iter (type a) (hd :: tl : a t) ~f =
    f hd;
    List.iter ~f tl [@nontail]
  ;;

  let iteri (type a) (hd :: tl : a t) ~f =
    f 0 hd;
    List.iteri ~f:(fun i x -> f (i + 1) x) tl [@nontail]
  ;;

  let min_elt' (type a) (hd :: tl : a t) ~compare =
    List.fold tl ~init:hd ~f:(fun min elt -> if compare min elt > 0 then elt else min)
    [@nontail]
  ;;

  let max_elt' (type a) (t : a t) ~compare =
    min_elt' t ~compare:(fun x y -> compare y x) [@nontail]
  ;;
end

include struct
  let create hd tl = hd :: tl
  let singleton hd = [ hd ]
  let cons (type a) (x : a) (hd :: tl : a t) : a t = x :: hd :: tl

  let filter (hd :: tl) ~f : _ List.t =
    match f hd with
    | false -> List.filter tl ~f
    | true -> hd :: List.filter tl ~f
  ;;

  let filteri (hd :: tl) ~f : _ List.t =
    let include_hd = f 0 hd in
    let f i x = f (i + 1) x in
    match include_hd with
    | false -> List.filteri tl ~f [@nontail]
    | true -> hd :: List.filteri tl ~f
  ;;

  let reverse (hd :: tl) =
    let rec loop acc x (xs : _ List.t) =
      match xs with
      | [] -> x :: acc
      | y :: ys -> loop (x :: acc) y ys
    in
    loop [] hd tl
  ;;

  let init n ~f =
    if n < 1 then Printf.invalid_argf "Nonempty_list.init %d" n ();
    let tl = List.init (n - 1) ~f:(fun i -> f (i + 1)) in
    let hd = f 0 in
    hd :: tl
  ;;

  let append (type a) (hd :: tl : a t) l : a t = hd :: List.append tl l
end

let ( @ ) t1 t2 = append t1 (to_list t2)

open struct
  type nonrec 'a t = 'a t = ( :: ) of 'a * 'a List.t
end

let mapi (hd :: tl) ~f : _ t =
  let hd = f 0 hd in
  hd :: List.mapi tl ~f:(fun i x -> f (i + 1) x)
;;

let rev_mapi (hd :: tl : _ t) ~f =
  let rec rev_mapi_loop i acc last (rest : _ List.t) : _ t =
    match rest with
    | [] -> last :: acc
    | hd :: tl -> rev_mapi_loop (i + 1) (last :: acc) (f i hd) tl
  in
  rev_mapi_loop 1 [] (f 0 hd) tl [@nontail]
;;

let filter_map (hd :: tl) ~f : _ List.t =
  match (f hd : _ Option.t) with
  | None -> List.filter_map tl ~f
  | Some hd -> hd :: List.filter_map tl ~f
;;

let filter_map_or_null (hd :: tl) ~f : _ list =
  match (f hd : _ or_null) with
  | Null -> List.filter_map_or_null tl ~f
  | This hd -> hd :: List.filter_map_or_null tl ~f
;;

let filter_mapi (hd :: tl) ~f : _ List.t =
  let hd = f 0 hd in
  let f i x = f (i + 1) x in
  match (hd : _ Option.t) with
  | None -> List.filter_mapi tl ~f [@nontail]
  | Some hd -> hd :: List.filter_mapi tl ~f
;;

let filter_mapi_or_null (hd :: tl) ~f : _ list =
  let hd = f 0 hd in
  let f i x = f (i + 1) x in
  match (hd : _ or_null) with
  | Null -> List.filter_mapi_or_null tl ~f [@nontail]
  | This hd -> hd :: List.filter_mapi_or_null tl ~f
;;

let map t ~f = mapi t ~f:(fun (_ : int) x -> f x) [@nontail]
let rev_map t ~f = rev_mapi t ~f:(fun (_ : int) x -> f x) [@nontail]

let concat_map (type a b) (hd :: tl : a t) ~(f : a -> b t) =
  let f_hd = f hd in
  append
    f_hd
    (List.concat_map tl ~f:(fun x ->
       let x = f x in
       to_list x))
;;

let bind = concat_map

let map2 t1 t2 ~f : _ List.Or_unequal_lengths.t =
  match List.map2 (to_list t1) (to_list t2) ~f with
  | Ok x -> Ok (of_list_exn x)
  | Unequal_lengths -> Unequal_lengths
;;

let map2_exn t1 t2 ~f = of_list_exn (List.map2_exn (to_list t1) (to_list t2) ~f)
let filter_opt t = List.filter_opt (to_list t)

let append' l t =
  match l with
  | [] -> t
  | x :: xs -> x :: List.append xs (to_list t)
;;

include Monad.Make (struct
    type nonrec 'a t = 'a t

    let return hd = [ hd ]
    let map = `Custom map
    let bind = bind
  end)

let unzip ((hd1, hd2) :: tl) =
  let tl1, tl2 = List.unzip tl in
  hd1 :: tl1, hd2 :: tl2
;;

let unzip3 ((hd1, hd2, hd3) :: tl) =
  let tl1, tl2, tl3 = List.unzip3 tl in
  hd1 :: tl1, hd2 :: tl2, hd3 :: tl3
;;

let concat t = bind t ~f:Fn.id

let zip t1 t2 : _ List.Or_unequal_lengths.t =
  match List.zip (to_list t1) (to_list t2) with
  | Ok x -> Ok (of_list_exn x)
  | Unequal_lengths -> Unequal_lengths
;;

let zip_exn t1 t2 = of_list_exn (List.zip_exn (to_list t1) (to_list t2))

let zip3 t1 t2 t3 : _ List.Or_unequal_lengths.t =
  match List.zip3 (to_list t1) (to_list t2) (to_list t3) with
  | Ok x -> Ok (of_list_exn x)
  | Unequal_lengths -> Unequal_lengths
;;

let zip3_exn t1 t2 t3 = of_list_exn (List.zip3_exn (to_list t1) (to_list t2) (to_list t3))

let drop_last (hd :: tl) =
  match List.drop_last tl with
  | None -> []
  | Some l -> hd :: l
;;

let of_iarray t = of_list (Iarray.to_list t)
let to_iarray t = Iarray.of_list (to_list t)
let to_sequence t = Sequence.of_list (to_list t)
let sort t ~compare = of_list_exn (List.sort (to_list t) ~compare)

let sort_and_group t ~compare =
  map ~f:of_list_exn (of_list_exn (List.sort_and_group (to_list t) ~compare))
;;

let group t ~break = map ~f:of_list_exn (of_list_exn (List.group (to_list t) ~break))
let stable_sort t ~compare = of_list_exn (List.stable_sort (to_list t) ~compare)
let stable_dedup t ~compare = of_list_exn (List.stable_dedup (to_list t) ~compare)
let dedup_and_sort t ~compare = of_list_exn (List.dedup_and_sort ~compare (to_list t))
let permute ?random_state t = of_list_exn (List.permute ?random_state (to_list t))
let random_element ?random_state t = List.random_element_exn ?random_state (to_list t)
let all_equal t ~equal = List.all_equal ~equal (to_list t)
let is_sorted t = List.is_sorted (to_list t)
let is_sorted_strictly t = List.is_sorted_strictly (to_list t)
let map_add_multi map ~key ~data = Map.add_multi_nonempty map ~key ~data

let hashtbl_add_multi map ~key ~data =
  Hashtbl.update map key ~f:(function
    | None -> singleton data
    | Some t -> cons data t)
;;

let map_of_container_multi_rev fold container ~comparator =
  fold container ~init:(Map.empty comparator) ~f:(fun acc (key, data) ->
    map_add_multi acc ~key ~data)
;;

let map_of_alist_multi alist ~comparator = Map.of_alist_multi_nonempty comparator alist
let map_of_alist_multi_rev alist = map_of_container_multi_rev List.fold alist

let map_of_sequence_multi sequence ~comparator =
  Map.of_sequence_multi_nonempty comparator sequence
;;

let map_of_sequence_multi_rev sequence = map_of_container_multi_rev Sequence.fold sequence
let fold_nonempty (type a) (hd :: tl : a t) ~init ~f = List.fold tl ~init:(init hd) ~f

let map_of_list_with_key_multi_rev list ~comparator ~get_key =
  List.fold list ~init:(Map.empty comparator) ~f:(fun acc data ->
    let key = get_key data in
    map_add_multi acc ~key ~data)
;;

let map_of_list_with_key_multi list ~comparator ~get_key =
  Map.of_list_with_key_multi_nonempty comparator list ~get_key
;;

let fold_right (hd :: tl) ~init:acc ~f =
  let acc = List.fold_right tl ~init:acc ~f in
  f hd acc
;;

let folding_map (hd :: tl) ~init ~f =
  let acc, hd = f init hd in
  hd :: List.folding_map tl ~init:acc ~f
;;

let fold_map (hd :: tl) ~init:acc ~f =
  let acc, hd = f acc hd in
  let acc, tl = List.fold_map tl ~init:acc ~f in
  acc, hd :: tl
;;

let map2_opt t1 t2 ~f : _ option =
  match map2 t1 t2 ~f with
  | Unequal_lengths -> None
  | Ok x -> Some x
;;

let rec transpose (hd :: tl) =
  match tl with
  | [] -> Some (map hd ~f:return)
  | hd' :: tl ->
    let rest = hd' :: tl in
    Option.bind (transpose rest) ~f:(fun transposed -> map2_opt ~f:cons hd transposed)
;;

let transpose_exn list =
  match transpose list with
  | Some list -> list
  | None ->
    Error.raise_s
      (Sexp.message
         "transpose got lists of different lengths"
         [ "lengths", sexp_of_t sexp_of_int (map list ~f:length) ])
;;

let combine_errors t =
  match Result.combine_errors (to_list t) with
  | Ok oks -> Ok (of_list_exn oks)
  | Error errors -> Error (of_list_exn errors)
;;

let combine_errors_unit t =
  match Result.combine_errors_unit (to_list t) with
  | Ok _ as ok -> ok
  | Error errors -> Error (of_list_exn errors)
;;

let combine_or_errors t =
  match Or_error.combine_errors (to_list t) with
  | Ok oks -> Ok (of_list_exn oks)
  | Error _ as e -> e
;;

let combine_or_errors_unit t = Or_error.combine_errors_unit (to_list t)

let filter_ok_at_least_one t =
  match Or_error.filter_ok_at_least_one (to_list t) with
  | Ok oks -> Ok (of_list_exn oks)
  | Error _ as e -> e
;;

let option_all t =
  let (hd :: tl) = t in
  Option.map2 hd (Option.all tl) ~f:create
;;

let remove_consecutive_duplicates ?(which_to_keep = `Last) (hd :: tl) ~equal =
  let tl = List.remove_consecutive_duplicates tl ~which_to_keep ~equal in
  match tl with
  | [] -> [ hd ]
  | snd :: tl ->
    if equal snd hd
    then (
      match which_to_keep with
      | `Last -> snd :: tl
      | `First -> hd :: tl)
    else hd :: snd :: tl
;;

type 'a nonempty_list = 'a t

include struct
  let _ = fun (_ : 'a nonempty_list) -> ()

  let sexp_of_nonempty_list
    : 'a. ('a -> Sexplib0.Sexp.t) -> 'a nonempty_list -> Sexplib0.Sexp.t
    =
    sexp_of_t
  ;;

  let _ = sexp_of_nonempty_list
end [@@merlin.hide]

module Partition = struct
  type ('fst, 'snd) t =
    | Fst of 'fst nonempty_list
    | Snd of 'snd nonempty_list
    | Both of ('fst nonempty_list * 'snd nonempty_list)

  include struct
    let _ = fun (_ : ('fst, 'snd) t) -> ()

    let sexp_of_t
      : 'fst 'snd.
      ('fst -> Sexplib0.Sexp.t)
      -> ('snd -> Sexplib0.Sexp.t)
      -> ('fst, 'snd) t
      -> Sexplib0.Sexp.t
      =
      fun (type fst__048_ snd__049_)
        :  ((fst__048_ -> Sexplib0.Sexp.t) -> (snd__049_ -> Sexplib0.Sexp.t)
        -> (fst__048_, snd__049_) t -> Sexplib0.Sexp.t) ->
      fun _of_fst__036_ _of_snd__037_ -> function
      | Fst arg0__038_ ->
        let res0__039_ = sexp_of_nonempty_list _of_fst__036_ arg0__038_ in
        Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Fst"; res0__039_ ]
      | Snd arg0__040_ ->
        let res0__041_ = sexp_of_nonempty_list _of_snd__037_ arg0__040_ in
        Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Snd"; res0__041_ ]
      | Both arg0__046_ ->
        let res0__047_ =
          let arg0__042_, arg1__043_ = arg0__046_ in
          let res0__044_ = sexp_of_nonempty_list _of_fst__036_ arg0__042_
          and res1__045_ = sexp_of_nonempty_list _of_snd__037_ arg1__043_ in
          Sexplib0.Sexp.List [ res0__044_; res1__045_ ]
        in
        Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Both"; res0__047_ ]
    ;;

    let _ = sexp_of_t
  end [@@merlin.hide]

  let of_lists_exn ((xs : _ list), (ys : _ list)) =
    match xs, ys with
    | x :: xs, [] -> Fst (x :: xs)
    | [], y :: ys -> Snd (y :: ys)
    | x :: xs, y :: ys -> Both (x :: xs, y :: ys)
    | [], [] ->
      failwith "Partition of [Nonempty_list.t] unexpectedly resulted in two empty lists!"
  ;;

  let fst = function
    | Both (xs, _) | Fst xs -> Some xs
    | Snd _ -> None
  ;;

  let snd = function
    | Both (_, ys) | Snd ys -> Some ys
    | Fst _ -> None
  ;;
end

let partition_tf t ~f = Partition.of_lists_exn (List.partition_tf ~f (to_list t))
let partition_tf' t ~f = List.partition_tf ~f (to_list t)
let partition_map t ~f = Partition.of_lists_exn (List.partition_map ~f (to_list t))
let partition_map' t ~f = List.partition_map ~f (to_list t)
let partition_result t = Partition.of_lists_exn (List.partition_result (to_list t))
let partition_result' t = List.partition_result (to_list t)

module Partition3 = struct
  type ('fst, 'snd, 'trd) t =
    | Fst of 'fst nonempty_list
    | Snd of 'snd nonempty_list
    | Trd of 'trd nonempty_list
    | Fst_snd of 'fst nonempty_list * 'snd nonempty_list
    | Fst_trd of 'fst nonempty_list * 'trd nonempty_list
    | Snd_trd of 'snd nonempty_list * 'trd nonempty_list
    | Fst_snd_trd of 'fst nonempty_list * 'snd nonempty_list * 'trd nonempty_list

  include struct
    let _ = fun (_ : ('fst, 'snd, 'trd) t) -> ()

    let sexp_of_t
      : 'fst 'snd 'trd.
      ('fst -> Sexplib0.Sexp.t)
      -> ('snd -> Sexplib0.Sexp.t)
      -> ('trd -> Sexplib0.Sexp.t)
      -> ('fst, 'snd, 'trd) t
      -> Sexplib0.Sexp.t
      =
      fun (type fst__077_ snd__078_ trd__079_)
        :  ((fst__077_ -> Sexplib0.Sexp.t) -> (snd__078_ -> Sexplib0.Sexp.t)
        -> (trd__079_ -> Sexplib0.Sexp.t) -> (fst__077_, snd__078_, trd__079_) t
        -> Sexplib0.Sexp.t) ->
      fun _of_fst__050_ _of_snd__051_ _of_trd__052_ -> function
      | Fst arg0__053_ ->
        let res0__054_ = sexp_of_nonempty_list _of_fst__050_ arg0__053_ in
        Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Fst"; res0__054_ ]
      | Snd arg0__055_ ->
        let res0__056_ = sexp_of_nonempty_list _of_snd__051_ arg0__055_ in
        Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Snd"; res0__056_ ]
      | Trd arg0__057_ ->
        let res0__058_ = sexp_of_nonempty_list _of_trd__052_ arg0__057_ in
        Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Trd"; res0__058_ ]
      | Fst_snd (arg0__059_, arg1__060_) ->
        let res0__061_ = sexp_of_nonempty_list _of_fst__050_ arg0__059_
        and res1__062_ = sexp_of_nonempty_list _of_snd__051_ arg1__060_ in
        Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Fst_snd"; res0__061_; res1__062_ ]
      | Fst_trd (arg0__063_, arg1__064_) ->
        let res0__065_ = sexp_of_nonempty_list _of_fst__050_ arg0__063_
        and res1__066_ = sexp_of_nonempty_list _of_trd__052_ arg1__064_ in
        Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Fst_trd"; res0__065_; res1__066_ ]
      | Snd_trd (arg0__067_, arg1__068_) ->
        let res0__069_ = sexp_of_nonempty_list _of_snd__051_ arg0__067_
        and res1__070_ = sexp_of_nonempty_list _of_trd__052_ arg1__068_ in
        Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Snd_trd"; res0__069_; res1__070_ ]
      | Fst_snd_trd (arg0__071_, arg1__072_, arg2__073_) ->
        let res0__074_ = sexp_of_nonempty_list _of_fst__050_ arg0__071_
        and res1__075_ = sexp_of_nonempty_list _of_snd__051_ arg1__072_
        and res2__076_ = sexp_of_nonempty_list _of_trd__052_ arg2__073_ in
        Sexplib0.Sexp.List
          [ Sexplib0.Sexp.Atom "Fst_snd_trd"; res0__074_; res1__075_; res2__076_ ]
    ;;

    let _ = sexp_of_t
  end [@@merlin.hide]
end

let partition3_map t ~f : _ Partition3.t =
  let open Either.Export in
  match
    partition_map t ~f:(fun elem ->
      match f elem with
      | `Fst elem -> First (First elem)
      | `Snd elem -> First (Second elem)
      | `Trd elem -> Second elem)
  with
  | Snd trds -> Trd trds
  | Fst fsts_and_snds ->
    (match partition_map fsts_and_snds ~f:Fn.id with
     | Fst fsts -> Fst fsts
     | Snd snds -> Snd snds
     | Both (fsts, snds) -> Fst_snd (fsts, snds))
  | Both (fsts_and_snds, trds) ->
    (match partition_map fsts_and_snds ~f:Fn.id with
     | Fst fsts -> Fst_trd (fsts, trds)
     | Snd snds -> Snd_trd (snds, trds)
     | Both (fsts, snds) -> Fst_snd_trd (fsts, snds, trds))
;;

let cartesian_product t t' = of_list_exn (List.cartesian_product (to_list t) (to_list t'))
let invariant f t = iter t ~f

module From_indexed_container_make = Indexed_container.Make (struct
    type nonrec 'a t = 'a t

    let iter = `Custom iter
    let iteri = `Custom iteri
    let fold (hd :: tl) ~init ~f = List.fold tl ~init:(f init hd) ~f

    let fold_until (hd :: tl) ~init ~f ~finish =
      match (f init hd : _ Container.Continue_or_stop.t) with
      | Continue init -> List.fold_until tl ~init ~f ~finish
      | Stop x -> x
    ;;

    let fold = `Custom fold
    let iter_until = `Define_using_fold_until
    let foldi = `Define_using_fold
    let foldi_until = `Define_using_fold_until
    let length = `Custom length
  end)

let is_empty (_ :: _) = false
let to_array = From_indexed_container_make.to_array
let count = From_indexed_container_make.count
let counti = From_indexed_container_make.counti
let exists = From_indexed_container_make.exists
let existsi = From_indexed_container_make.existsi
let find = From_indexed_container_make.find
let findi = From_indexed_container_make.findi
let for_all = From_indexed_container_make.for_all
let for_alli = From_indexed_container_make.for_alli
let max_elt = From_indexed_container_make.max_elt
let mem = From_indexed_container_make.mem
let min_elt = From_indexed_container_make.min_elt
let find_map = From_indexed_container_make.find_map
let find_mapi = From_indexed_container_make.find_mapi
let fold = From_indexed_container_make.fold
let fold_result = From_indexed_container_make.fold_result
let fold_until = From_indexed_container_make.fold_until
let foldi = From_indexed_container_make.foldi
let foldi_until = From_indexed_container_make.foldi_until
let iter_until = From_indexed_container_make.iter_until
let iteri_until = From_indexed_container_make.iteri_until
let sum = From_indexed_container_make.sum

let findi_exn =
  let not_found () = Not_found_s (Atom "Nonempty_list.findi_exn: not found") in
  let findi_exn t ~f =
    match findi t ~f with
    | None -> raise (not_found ())
    | Some x -> x
  in
  findi_exn
;;
