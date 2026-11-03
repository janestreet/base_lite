open! Import0
module Ordered_collection_common = Ordered_collection_common0
open Int_replace_polymorphic_compare

let rec linear_search_first_satisfying t ~get ~lo ~hi ~pred =
  if lo > hi
  then None
  else if pred (get t lo)
  then Some lo
  else linear_search_first_satisfying t ~get ~lo:(lo + 1) ~hi ~pred
;;

let rec find_range_near_first_satisfying t ~get ~lo ~hi ~pred =
  if hi - lo <= 8
  then lo, hi
  else (
    let mid = lo + ((hi - lo) / 2) in
    if pred (get t mid)
    then find_range_near_first_satisfying t ~get ~lo ~hi:mid ~pred
    else find_range_near_first_satisfying t ~get ~lo:(mid + 1) ~hi ~pred)
;;

let find_first_satisfying ?pos ?len t ~get ~length ~pred =
  let pos, len =
    Ordered_collection_common.get_pos_len_exn () ?pos ?len ~total_length:(length t)
  in
  let lo = pos in
  let hi = pos + len - 1 in
  let lo, hi = find_range_near_first_satisfying t ~get ~lo ~hi ~pred in
  linear_search_first_satisfying t ~get ~lo ~hi ~pred
;;

let find_last_satisfying ?pos ?len t ~pred ~get ~length =
  let pos, len =
    Ordered_collection_common.get_pos_len_exn () ?pos ?len ~total_length:(length t)
  in
  if len = 0
  then None
  else (
    match
      find_first_satisfying ~pos ~len t ~get ~length ~pred:(fun x -> not (pred x))
    with
    | None -> Some (pos + len - 1)
    | Some i when i = pos -> None
    | Some i -> Some (i - 1))
;;

let binary_search
  ?pos
  ?len
  t
  ~(length : _ -> _)
  ~(get : _ -> _ -> _)
  ~(compare : _ -> _ -> _)
  how
  v
  =
  match how with
  | `Last_strictly_less_than ->
    find_last_satisfying ?pos ?len t ~get ~length ~pred:(fun x -> compare x v < 0)
  | `Last_less_than_or_equal_to ->
    find_last_satisfying ?pos ?len t ~get ~length ~pred:(fun x -> compare x v <= 0)
  | `First_equal_to ->
    (match
       find_first_satisfying ?pos ?len t ~get ~length ~pred:(fun x -> compare x v >= 0)
     with
     | Some x when compare (get t x) v = 0 -> Some x
     | None | Some _ -> None)
  | `Last_equal_to ->
    (match
       find_last_satisfying ?pos ?len t ~get ~length ~pred:(fun x -> compare x v <= 0)
     with
     | Some x when compare (get t x) v = 0 -> Some x
     | None | Some _ -> None)
  | `First_greater_than_or_equal_to ->
    find_first_satisfying ?pos ?len t ~get ~length ~pred:(fun x -> compare x v >= 0)
  | `First_strictly_greater_than ->
    find_first_satisfying ?pos ?len t ~get ~length ~pred:(fun x -> compare x v > 0)
;;

let binary_search_segmented ?pos ?len t ~length ~get ~segment_of how =
  let is_left x =
    match segment_of x with
    | `Left -> true
    | `Right -> false
  in
  let is_right x = not (is_left x) in
  match how with
  | `Last_on_left -> find_last_satisfying ?pos ?len t ~length ~get ~pred:is_left
  | `First_on_right -> find_first_satisfying ?pos ?len t ~length ~get ~pred:is_right
;;
