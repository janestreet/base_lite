open! Import
include Array_intf.Definitions
module Array = Array0
module Bool = Bool0
module Either = Either0
module List = List0
module Option = Option0
module Ordered_collection_common = Ordered_collection_common0
module Result = Result0
module Sexp = Sexp0
include Array

type 'a t = 'a array

include (
struct
  type nonrec 'a t = 'a array

  include struct
    let _ = fun (_ : 'a t) -> ()

    let globalize : 'a. ('a -> 'a) -> 'a t -> 'a t =
      fun (type a__001_) : ((a__001_ -> a__001_) -> a__001_ t -> a__001_ t) ->
      globalize_array
    ;;

    let _ = globalize
    let t_of_sexp : 'a. (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a t = array_of_sexp
    let _ = t_of_sexp
    let sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t = sexp_of_array
    let _ = sexp_of_t

    let t_sexp_grammar : 'a. 'a Sexplib0.Sexp_grammar.t -> 'a t Sexplib0.Sexp_grammar.t =
      fun _'a_sexp_grammar -> array_sexp_grammar _'a_sexp_grammar
    ;;

    let _ = t_sexp_grammar
  end [@@merlin.hide]
end :
  sig
    type nonrec 'a t = 'a array

    include sig
      [@@@ocaml.warning "-32"]

      val globalize : 'a. ('a -> 'a) -> 'a t -> 'a t
      val sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t
      val t_of_sexp : 'a. (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a t
      val t_sexp_grammar : 'a. 'a Sexplib0.Sexp_grammar.t -> 'a t Sexplib0.Sexp_grammar.t
    end
    [@@merlin.hide]
  end
  with type 'a t := 'a array)

module Sorter (S : sig
    type 'a t

    val get : 'a. 'a t -> int -> 'a
    val set : 'a. 'a t -> int -> 'a -> unit
    val length : 'a. 'a t -> int
  end) =
struct
  include S

  let swap arr i j =
    let tmp = get arr i in
    set arr i (get arr j);
    set arr j tmp
  ;;

  module type Sort = sig
    val sort : 'a. 'a t -> compare:('a -> 'a -> int) -> left:int -> right:int -> unit
  end

  module Insertion_sort : Sort = struct
    let rec insert_loop arr ~left ~compare i v =
      let i_next = i - 1 in
      if i_next >= left && compare (get arr i_next) v > 0
      then (
        set arr i (get arr i_next);
        insert_loop arr ~left ~compare i_next v)
      else i
    ;;

    let sort arr ~compare ~left ~right =
      for pos = left + 1 to right do
        let v = get arr pos in
        let final_pos = insert_loop arr ~left ~compare pos v in
        set arr final_pos v
      done
    ;;
  end

  module Heap_sort : Sort = struct
    let rec heapify arr ~compare root ~left ~right =
      let relative_root = root - left in
      let left_child = (2 * relative_root) + left + 1 in
      let right_child = (2 * relative_root) + left + 2 in
      let largest =
        if left_child <= right && compare (get arr left_child) (get arr root) > 0
        then left_child
        else root
      in
      let largest =
        if right_child <= right && compare (get arr right_child) (get arr largest) > 0
        then right_child
        else largest
      in
      if largest <> root
      then (
        swap arr root largest;
        heapify arr ~compare largest ~left ~right)
    ;;

    let build_heap arr ~compare ~left ~right =
      for i = (left + right) / 2 downto left do
        heapify arr ~compare i ~left ~right
      done
    ;;

    let sort arr ~compare ~left ~right =
      build_heap arr ~compare ~left ~right;
      for i = right downto left + 1 do
        swap arr left i;
        heapify arr ~compare left ~left ~right:(i - 1)
      done
    ;;
  end

  module Intro_sort : sig
    include Sort

    val five_element_sort
      : 'a.
      'a t -> compare:('a -> 'a -> int) -> int -> int -> int -> int -> int -> unit
  end = struct
    let five_element_sort (type a) (arr : a t) ~(compare : _ -> _ -> _) m1 m2 m3 m4 m5 =
      let compare_and_swap i j =
        if compare (get arr i) (get arr j) > 0 then swap arr i j
      in
      compare_and_swap m1 m2;
      compare_and_swap m4 m5;
      compare_and_swap m1 m3;
      compare_and_swap m2 m3;
      compare_and_swap m1 m4;
      compare_and_swap m3 m4;
      compare_and_swap m2 m5;
      compare_and_swap m2 m3;
      compare_and_swap m4 m5 [@nontail]
    ;;

    let choose_pivots (type a) (arr : a t) ~(compare : _ -> _ -> _) ~left ~right =
      let sixth = (right - left) / 6 in
      let m1 = left + sixth in
      let m2 = m1 + sixth in
      let m3 = m2 + sixth in
      let m4 = m3 + sixth in
      let m5 = m4 + sixth in
      five_element_sort arr ~compare m1 m2 m3 m4 m5;
      let m2_val = get arr m2 in
      let m3_val = get arr m3 in
      let m4_val = get arr m4 in
      if compare m2_val m3_val = 0
      then m2_val, m3_val, true
      else if compare m3_val m4_val = 0
      then m3_val, m4_val, true
      else m2_val, m4_val, false
    ;;

    let dual_pivot_partition (type a) (arr : a t) ~(compare : _ -> _ -> _) ~left ~right =
      let pivot1, pivot2, pivots_equal = choose_pivots arr ~compare ~left ~right in
      let rec loop l p r =
        if p > r
        then l, r
        else (
          let pv = get arr p in
          if compare pv pivot1 < 0
          then (
            swap arr p l;
            loop (l + 1) (p + 1) r)
          else if compare pv pivot2 > 0
          then (
            let rec scan_backwards r =
              if r > p && compare (get arr r) pivot2 > 0
              then scan_backwards (r - 1)
              else r
            in
            let r = scan_backwards r in
            swap arr r p;
            loop l p (r - 1))
          else loop l (p + 1) r)
      in
      let l, r = loop left left right in
      l, r, pivots_equal
    ;;

    let rec intro_sort
      : type a. a t -> max_depth:_ -> compare:(a -> a -> int) -> left:_ -> right:_ -> _
      =
      fun (arr : a t) ~max_depth ~compare ~left ~right ->
      let len = right - left + 1 in
      if len <= 32
      then Insertion_sort.sort arr ~compare ~left ~right
      else if max_depth < 0
      then Heap_sort.sort arr ~compare ~left ~right
      else (
        let max_depth = max_depth - 1 in
        let l, r, middle_sorted = dual_pivot_partition arr ~compare ~left ~right in
        intro_sort arr ~max_depth ~compare ~left ~right:(l - 1);
        if not middle_sorted then intro_sort arr ~max_depth ~compare ~left:l ~right:r;
        intro_sort arr ~max_depth ~compare ~left:(r + 1) ~right)
    ;;

    let sort (type a) (arr : a t) ~compare ~left ~right =
      let heap_sort_switch_depth = 32 in
      intro_sort arr ~max_depth:heap_sort_switch_depth ~compare ~left ~right
    ;;
  end

  let sort (type a) ?pos ?len (arr : a t) ~compare =
    let pos, len =
      Ordered_collection_common.get_pos_len_exn () ?pos ?len ~total_length:(length arr)
    in
    Intro_sort.sort arr ~compare ~left:pos ~right:(pos + len - 1)
  ;;
end

module Sort = Sorter (struct
    type nonrec 'a t = 'a t

    let get = unsafe_get
    let set = unsafe_set
    let length = length
  end)

let sort =
  let module Sort = Sort in
  Sort.sort
;;

let get_opt arr n : _ Option.t =
  if 0 <= n && n < length arr then Some (unsafe_get arr n) else None
;;

let get_or_null arr n : _ or_null =
  if 0 <= n && n < length arr then This (unsafe_get arr n) else Null
;;

let folding_map t ~init ~f =
  let acc = ref init in
  map t ~f:(fun x ->
    let new_acc, y = f !acc x in
    acc := new_acc;
    y)
  [@nontail]
;;

let fold_map t ~init ~f =
  let acc = ref init in
  let result =
    map t ~f:(fun x ->
      let new_acc, y = f !acc x in
      acc := new_acc;
      y)
  in
  !acc, result
;;

let raise_length_mismatch name n1 n2 =
  Printf.invalid_argf "length mismatch in %s: %d <> %d" name n1 n2 ()
[@@cold]
;;

let is_sorted_internal t ~in_order =
  let n = length t in
  match n < 2 with
  | true -> true
  | false ->
    let rec loop next i =
      let elt = unsafe_get t i in
      match in_order elt next with
      | false -> false
      | true ->
        let i = i - 1 in
        (match i >= 0 with
         | true -> loop elt i
         | false -> true)
    in
    loop (unsafe_get t (n - 1)) (n - 2)
;;

let is_sorted t ~compare =
  is_sorted_internal t ~in_order:(fun x y -> compare x y <= 0) [@nontail]
;;

let is_sorted_strictly t ~compare =
  is_sorted_internal t ~in_order:(fun x y -> compare x y < 0) [@nontail]
;;

let to_array t = t
let of_array t = t
let is_empty t = length t = 0

let for_all t ~f =
  let i = ref (length t - 1) in
  let result = ref true in
  while !i >= 0 && !result do
    if not (f (unsafe_get t !i)) then result := false else decr i
  done;
  !result
;;

let for_alli t ~f =
  let length = length t in
  let i = ref (length - 1) in
  let result = ref true in
  while !i >= 0 && !result do
    if not (f !i (unsafe_get t !i)) then result := false else decr i
  done;
  !result
;;

let count t ~f =
  let result = ref 0 in
  for i = 0 to Array.length t - 1 do
    result := !result + bool_to_int (f (Array.unsafe_get t i))
  done;
  !result
;;

let counti t ~f =
  let result = ref 0 in
  for i = 0 to Array.length t - 1 do
    result := !result + bool_to_int (f i (Array.unsafe_get t i))
  done;
  !result
;;

let exists t ~f =
  let i = ref (length t - 1) in
  let result = ref false in
  while !i >= 0 && not !result do
    if f (unsafe_get t !i) then result := true else decr i
  done;
  !result
;;

let existsi t ~f =
  let i = ref (length t - 1) in
  let result = ref false in
  while !i >= 0 && not !result do
    if f !i (unsafe_get t !i) then result := true else decr i
  done;
  !result
;;

let mem t a ~equal = exists t ~f:(equal a) [@nontail]

let extremal_element t ~compare ~keep_left_if : _ Option.t =
  if is_empty t
  then None
  else (
    let length = length t in
    let rec loop i result =
      if i < length
      then (
        let x = unsafe_get t i in
        loop (i + 1) (Bool.select (keep_left_if (compare x result)) x result))
      else result
    in
    Some (loop 1 (unsafe_get t 0)))
;;

let min_elt t ~compare =
  extremal_element t ~compare ~keep_left_if:(fun compare_result -> compare_result < 0)
;;

let max_elt t ~compare =
  extremal_element t ~compare ~keep_left_if:(fun compare_result -> compare_result > 0)
;;

let findi_internal t ~f ~if_found ~if_not_found =
  let length = length t in
  let rec loop i =
    if i < length
    then (
      let x = unsafe_get t i in
      if f i x then if_found ~i ~value:x else loop (i + 1))
    else if_not_found ()
  in
  loop 0 [@nontail]
;;

let find t ~f =
  findi_internal
    t
    ~f:(fun _ v -> f v)
    ~if_found:(fun ~i:_ ~value : _ Option.t -> Some value)
    ~if_not_found:(fun () -> None) [@nontail]
;;

let find_exn t ~f =
  findi_internal
    t
    ~f:(fun _i x -> f x)
    ~if_found:(fun ~i:_ ~value -> value)
    ~if_not_found:(fun () -> raise (Not_found_s (Atom "Array.find_exn: not found")))
  [@nontail]
;;

let findi t ~f =
  findi_internal
    t
    ~f
    ~if_found:(fun ~i ~value : _ Option.t -> Some (i, value))
    ~if_not_found:(fun () -> None)
;;

let findi_exn t ~f =
  findi_internal
    t
    ~f
    ~if_found:(fun ~i ~value -> i, value)
    ~if_not_found:(fun () -> raise (Not_found_s (Atom "Array.findi_exn: not found")))
;;

let copy t = unsafe_sub t 0 (length t)

let rev_inplace t =
  let i = ref 0 in
  let j = ref (length t - 1) in
  while !i < !j do
    swap t !i !j;
    incr i;
    decr j
  done
;;

let rev t =
  let t = copy t in
  rev_inplace t;
  t
;;

let of_list_rev (l : _ List.Constructors.t) : _ t =
  match l with
  | [] -> [||]
  | a :: l ->
    let len = 1 + List.length l in
    let t = create ~len a in
    let r = ref l in
    for i = len - 2 downto 0 do
      match !r with
      | [] -> assert false
      | a :: l ->
        t.(i) <- a;
        r := l
    done;
    t
;;

let sum (type sum) (module M : Container.Summable with type t = sum) t ~f =
  fold t ~init:M.zero ~f:(fun n a -> M.( + ) n (f a)) [@nontail]
;;

let iteri_until t ~f ~finish =
  let length = length t in
  let rec loop i =
    if i < length
    then (
      match (f i (unsafe_get t i) : _ Container.Continue_or_stop.t) with
      | Continue () -> loop (i + 1)
      | Stop res -> res)
    else finish i
  in
  loop 0 [@nontail]
;;

let iter_until t ~f ~finish =
  iteri_until t ~f:(fun _i x -> f x) ~finish:(fun _i -> finish ()) [@nontail]
;;

let fold_result t ~init ~f =
  let length = length t in
  let rec loop i acc =
    if i < length
    then (
      match (f acc (unsafe_get t i) : _ Result.t) with
      | Error _ as result -> result
      | Ok acc -> loop (i + 1) acc)
    else Ok acc
  in
  loop 0 init [@nontail]
;;

let find_map t ~f : _ Option.t =
  let length = length t in
  if length = 0
  then None
  else (
    let rec loop i : _ Option.t =
      if i < length
      then (
        let value = unsafe_get t i in
        match (f value : _ Option.t) with
        | None -> loop (i + 1)
        | Some _ as result -> result)
      else None
    in
    loop 0 [@nontail])
;;

let find_map_exn =
  let not_found = Not_found_s (Atom "Array.find_map_exn: not found") in
  let find_map_exn t ~f =
    match find_map t ~f with
    | None ->
      raise (Portability_hacks.magic_uncontended__promise_deeply_immutable not_found)
    | Some x -> x
  in
  find_map_exn
;;

let find_mapi t ~f : _ Option.t =
  let length = length t in
  if length = 0
  then None
  else (
    let i = ref 0 in
    let value_found = ref (None : _ Option.t) in
    while Option.is_none !value_found && !i < length do
      let value = unsafe_get t !i in
      value_found := f !i value;
      incr i
    done;
    !value_found)
;;

let find_mapi_exn =
  let not_found = Not_found_s (Atom "Array.find_mapi_exn: not found") in
  let find_mapi_exn t ~f =
    match find_mapi t ~f with
    | None ->
      raise (Portability_hacks.magic_uncontended__promise_deeply_immutable not_found)
    | Some x -> x
  in
  find_mapi_exn
;;

let foldi t ~init ~f =
  let length = length t in
  let rec loop i acc =
    if i < length
    then (
      let acc = f i acc (unsafe_get t i) in
      loop (i + 1) acc)
    else acc
  in
  loop 0 init [@nontail]
;;

let filter_mapi (t : _ t) ~f : _ t =
  let r = ref [||] in
  let k = ref 0 in
  for i = 0 to length t - 1 do
    match (f i (unsafe_get t i) : _ Option.t) with
    | None -> ()
    | Some a ->
      if !k = 0 then r := create ~len:(length t) a;
      unsafe_set !r !k a;
      incr k
  done;
  if !k = length t then !r else if !k > 0 then sub ~pos:0 ~len:!k !r else [||]
;;

let filter_map t ~f = filter_mapi t ~f:(fun _i a -> f a) [@nontail]
let concat_map t ~f = concat (to_list (map ~f t))
let concat_mapi t ~f = concat (to_list (mapi ~f t))

let check_length2_exn name t1 t2 =
  let n1 = length t1 in
  let n2 = length t2 in
  if n1 <> n2 then raise_length_mismatch name n1 n2
;;

let of_list_map (xs : _ List.Constructors.t) ~f : _ t =
  match xs with
  | [] -> [||]
  | hd :: tl ->
    let a = create ~len:(1 + List.length tl) (f hd) in
    let rec fill i : _ List.Constructors.t -> _ = function
      | [] -> a
      | hd :: tl ->
        unsafe_set a i (f hd);
        fill (i + 1) tl
    in
    fill 1 tl [@nontail]
;;

let of_list_mapi (xs : _ List.Constructors.t) ~f : _ t =
  match xs with
  | [] -> [||]
  | hd :: tl ->
    let a = create ~len:(1 + List.length tl) (f 0 hd) in
    let rec fill a i : _ List.Constructors.t -> _ = function
      | [] -> a
      | hd :: tl ->
        unsafe_set a i (f i hd);
        fill a (i + 1) tl
    in
    fill a 1 tl [@nontail]
;;

let exists2_exn t1 t2 ~f =
  check_length2_exn "Array.exists2_exn" t1 t2;
  let rec loop i =
    if i >= 0 then f (unsafe_get t1 i) (unsafe_get t2 i) || loop (i - 1) else false
  in
  loop (length t1 - 1) [@nontail]
;;

let for_all2_exn t1 t2 ~f =
  check_length2_exn "Array.for_all2_exn" t1 t2;
  let rec loop i =
    if i >= 0 then f (unsafe_get t1 i) (unsafe_get t2 i) && loop (i - 1) else true
  in
  loop (length t1 - 1) [@nontail]
;;

let globalize = globalize_array
let equal = equal_array
let compare = compare_array
let filter t ~f = filter_map t ~f:(fun x -> if f x then Some x else None) [@nontail]
let filteri t ~f = filter_mapi t ~f:(fun i x -> if f i x then Some x else None) [@nontail]

let of_list_rev_map xs ~f =
  let t = of_list_map xs ~f in
  rev_inplace t;
  t
;;

let of_list_rev_mapi xs ~f =
  let t = of_list_mapi xs ~f in
  rev_inplace t;
  t
;;

let partition_mapi t ~f =
  let both : _ Either.t t = mapi t ~f in
  let firsts =
    filter_map both ~f:(function
      | First x -> (Some x : _ Option.t)
      | Second _ -> None)
  in
  let seconds =
    filter_map both ~f:(function
      | First _ -> (None : _ Option.t)
      | Second x -> Some x)
  in
  firsts, seconds
;;

let partition_map t ~f = partition_mapi t ~f:(fun _ x -> f x) [@nontail]

let foldi_until t ~init ~f ~finish =
  let length = length t in
  let rec loop i acc =
    if i < length
    then (
      match (f i acc (unsafe_get t i) : _ Container.Continue_or_stop.t) with
      | Continue acc -> loop (i + 1) acc
      | Stop res -> res)
    else finish i acc
  in
  loop 0 init [@nontail]
;;

let fold_until t ~init ~f ~finish =
  foldi_until
    t
    ~init
    ~f:(fun _i acc x -> f acc x)
    ~finish:(fun _i acc -> finish acc) [@nontail]
;;

let partitioni_tf t ~f =
  partition_mapi t ~f:(fun i x -> if f i x then First x else Second x) [@nontail]
;;

let partition_tf t ~f = partitioni_tf t ~f:(fun _ x -> f x) [@nontail]

let sexp_of_t (sexp_of_elt : _ -> Sexp.t) t : Sexp.t =
  let rec loop i res =
    if i < 0 then res else loop (i - 1) (sexp_of_elt (unsafe_get t i) :: res)
  in
  List (loop (length t - 1) [])
;;

let findi t ~f =
  match findi t ~f with
  | Some (i, value) -> Some (i, value)
  | None -> None
;;

let findi_exn t ~f =
  let i, value = findi_exn t ~f in
  i, value
;;

let merge (type a) (a1 : a t) a2 ~compare =
  let l1 = Array.length a1 in
  let l2 = Array.length a2 in
  if l1 = 0
  then copy a2
  else if l2 = 0
  then copy a1
  else if compare (unsafe_get a2 0) (unsafe_get a1 (l1 - 1)) >= 0
  then append a1 a2
  else if compare (unsafe_get a1 0) (unsafe_get a2 (l2 - 1)) > 0
  then append a2 a1
  else (
    let len = l1 + l2 in
    let merged = create ~len (unsafe_get a1 0) in
    let a1_index = ref 0 in
    let a2_index = ref 0 in
    for i = 0 to len - 1 do
      let use_a1 =
        if l1 = !a1_index
        then false
        else if l2 = !a2_index
        then true
        else compare (unsafe_get a1 !a1_index) (unsafe_get a2 !a2_index) <= 0
      in
      if use_a1
      then (
        unsafe_set merged i (unsafe_get a1 !a1_index);
        a1_index := !a1_index + 1)
      else (
        unsafe_set merged i (unsafe_get a2 !a2_index);
        a2_index := !a2_index + 1)
    done;
    merged)
;;

let copy_matrix tt = map ~f:copy tt

let foldi_right t ~init ~f =
  let rec aux t ~idx ~acc ~f =
    if idx < 0
    then acc
    else (
      let acc = f idx (unsafe_get t idx) acc in
      aux t ~idx:(idx - 1) ~acc ~f)
  in
  aux t ~idx:(length t - 1) ~acc:init ~f [@nontail]
;;

let folding_mapi t ~init ~f =
  let acc = ref init in
  mapi t ~f:(fun i x ->
    let new_acc, y = f i !acc x in
    acc := new_acc;
    y)
  [@nontail]
;;

let fold_mapi t ~init ~f =
  let acc = ref init in
  let result =
    mapi t ~f:(fun i x ->
      let new_acc, y = f i !acc x in
      acc := new_acc;
      y)
  in
  !acc, result
;;

let filter_opt t = filter_map t ~f:Fn.id

let iter2_exn t1 t2 ~f =
  check_length2_exn "Array.iter2_exn" t1 t2;
  iteri t1 ~f:(fun i x1 -> f x1 (unsafe_get t2 i)) [@nontail]
;;

let map2_exn t1 t2 ~f =
  check_length2_exn "Array.map2_exn" t1 t2;
  init (length t1) ~f:(fun i -> f (unsafe_get t1 i) (unsafe_get t2 i)) [@nontail]
;;

let fold2_exn t1 t2 ~init ~f =
  check_length2_exn "Array.fold2_exn" t1 t2;
  foldi t1 ~init ~f:(fun i ac x -> f ac x (unsafe_get t2 i)) [@nontail]
;;

let map_inplace t ~f =
  for i = 0 to length t - 1 do
    unsafe_set t i (f (unsafe_get t i))
  done
;;

let find_or_null t ~f =
  findi_internal
    t
    ~f:(fun _i x -> f x)
    ~if_not_found:(fun () -> Null)
    ~if_found:(fun ~i:_ ~value:v -> This v) [@nontail]
;;

let findi_or_null t ~f =
  findi_internal
    t
    ~f
    ~if_not_found:(fun () -> Null)
    ~if_found:(fun ~i ~value:v -> This (i, v)) [@nontail]
;;

let find_consecutive_duplicate t ~equal =
  let n = length t in
  if n <= 1
  then None
  else (
    let result = ref None in
    let i = ref 1 in
    let prev = ref (unsafe_get t 0) in
    while !i < n do
      let cur = unsafe_get t !i in
      if equal cur !prev
      then (
        result := Some (!prev, cur);
        i := n)
      else (
        prev := cur;
        incr i)
    done;
    !result)
;;

let reduce t ~f =
  if length t = 0
  then None
  else (
    let r = ref (unsafe_get t 0) in
    for i = 1 to length t - 1 do
      r := f !r (unsafe_get t i)
    done;
    Some !r)
;;

let reduce_exn t ~f =
  match reduce t ~f with
  | None -> invalid_arg "Array.reduce_exn"
  | Some v -> v
;;

let permute = Array_permute.permute

let random_element_exn ?(random_state = Random.State.get_default ()) t =
  if is_empty t
  then failwith "Array.random_element_exn: empty array"
  else t.(Random.State.int random_state (length t))
;;

let random_element ?(random_state = Random.State.get_default ()) t =
  try Some (random_element_exn ~random_state t) with
  | _ -> None
;;

let zip t1 t2 =
  if length t1 <> length t2 then None else Some (map2_exn t1 t2 ~f:(fun x1 x2 -> x1, x2))
;;

let zip_exn t1 t2 =
  if length t1 <> length t2
  then failwith "Array.zip_exn"
  else map2_exn t1 t2 ~f:(fun x1 x2 -> x1, x2)
;;

let unzip t =
  let n = length t in
  if n = 0
  then [||], [||]
  else (
    let x, y = t.(0) in
    let res1 = create ~len:n x in
    let res2 = create ~len:n y in
    for i = 1 to n - 1 do
      let x, y = t.(i) in
      res1.(i) <- x;
      res2.(i) <- y
    done;
    res1, res2)
;;

let sorted_copy t ~compare =
  let t1 = copy t in
  sort t1 ~compare;
  t1
;;

let last_exn t = t.(length t - 1)
let last = last_exn

let to_sequence_mutable t =
  Sequence.unfold_step ~init:0 ~f:(fun i ->
    if i >= length t
    then Sequence.Step.Done
    else Sequence.Step.Yield { value = t.(i); state = i + 1 })
;;

let to_sequence t = to_sequence_mutable (copy t)

let cartesian_product t1 t2 =
  if is_empty t1 || is_empty t2
  then [||]
  else (
    let n1 = length t1 in
    let n2 = length t2 in
    let t = create ~len:(n1 * n2) (t1.(0), t2.(0)) in
    let r = ref 0 in
    for i1 = 0 to n1 - 1 do
      for i2 = 0 to n2 - 1 do
        t.(!r) <- t1.(i1), t2.(i2);
        incr r
      done
    done;
    t)
;;

let transpose tt =
  if length tt = 0
  then Some [||]
  else (
    let width = length tt in
    let depth = length tt.(0) in
    if exists tt ~f:(fun t -> length t <> depth)
    then None
    else Some (init depth ~f:(fun d -> init width ~f:(fun w -> tt.(w).(d)))))
;;

let transpose_exn tt =
  match transpose tt with
  | None -> invalid_arg "Array.transpose_exn"
  | Some tt' -> tt'
;;

let map t ~f = map t ~f

include Binary_searchable.Make1 (struct
    type nonrec 'a t = 'a t

    let get = get
    let length = length
  end)

let blito ~src ?(src_pos = 0) ?(src_len = length src - src_pos) ~dst ?(dst_pos = 0) () =
  blit ~src ~src_pos ~len:src_len ~dst ~dst_pos
;;

let split_n t_orig n =
  if n <= 0
  then [||], t_orig
  else (
    let length = length t_orig in
    if n >= length
    then t_orig, [||]
    else (
      let first = sub t_orig ~pos:0 ~len:n in
      let second = sub t_orig ~pos:n ~len:(length - n) in
      first, second))
;;

let chunks_of t ~length:chunk_length =
  if chunk_length <= 0
  then Printf.invalid_argf "Array.chunks_of: Expected length > 0, got %d" chunk_length ();
  let length = length t in
  if length = 0
  then [||]
  else (
    let num_chunks = (length + chunk_length - 1) / chunk_length in
    init num_chunks ~f:(fun i ->
      let start = i * chunk_length in
      let current_chunk_length = min chunk_length (length - start) in
      sub t ~pos:start ~len:current_chunk_length))
;;

let subo ?(pos = 0) ?len src =
  sub
    src
    ~pos
    ~len:
      (match len with
       | Some i -> i
       | None -> length src - pos)
;;

let sub t ~pos ~len = sub t ~pos ~len
let invariant invariant_a t = iter t ~f:invariant_a

module Private = struct
  module Sort = Sort
  module Sorter = Sorter
end
