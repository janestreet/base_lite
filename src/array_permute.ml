open! Import0
module Ordered_collection_common = Ordered_collection_common0
include Array0

let permute ?(random_state = Random.State.get_default ()) ?(pos = 0) ?len t =
  let total_length = length t in
  let len =
    match len with
    | Some l -> l
    | None -> total_length - pos
  in
  Ordered_collection_common.check_pos_len_exn ~pos ~len ~total_length;
  let num_swaps = len - 1 in
  for i = num_swaps downto 1 do
    let this_i = pos + i in
    let random_i = pos + Random.State.int random_state (i + 1) in
    swap t this_i random_i
  done
;;
