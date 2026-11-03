open! Import
module Sys = Sys0
open! Float_replace_polymorphic_compare

let is_nan x = (x : float) <> x

let to_int64_preserve_order t =
  if is_nan t
  then None
  else if t = 0.
  then Some 0L
  else if t > 0.
  then Some (Stdlib.Int64.bits_of_float (globalize_float t))
  else Some (Stdlib.Int64.neg (Stdlib.Int64.bits_of_float (globalize_float (-.t))))
;;

let to_int64_preserve_order_exn x =
  match to_int64_preserve_order x with
  | Some x -> x
  | None -> invalid_arg "Float0.to_int64_preserve_order_exn: value is nan"
;;

let of_int64_preserve_order x =
  if Int64_replace_polymorphic_compare.( >= ) x 0L
  then Stdlib.Int64.float_of_bits (globalize_int64 x)
  else -.Stdlib.Int64.float_of_bits (globalize_int64 (Stdlib.Int64.neg x))
;;

let one_ulp dir t =
  match to_int64_preserve_order t with
  | None -> Stdlib.nan
  | Some x ->
    of_int64_preserve_order
      (Stdlib.Int64.add
         x
         (match dir with
          | `Up -> 1L
          | `Down -> -1L))
;;

let upper_bound_for_int num_bits =
  let exp = Stdlib.float_of_int (num_bits - 1) in
  one_ulp `Down (2. ** exp)
;;

let is_x_minus_one_exact x =
  let open Int64_replace_polymorphic_compare in
  not (Stdlib.Int64.bits_of_float x = Stdlib.Int64.bits_of_float (x -. 1.))
;;

let lower_bound_for_int num_bits =
  let exp = Stdlib.float_of_int (num_bits - 1) in
  let min_int_as_float = -.(2. ** exp) in
  let open Int_replace_polymorphic_compare in
  if num_bits - 1 < 53
  then (
    assert (is_x_minus_one_exact min_int_as_float);
    one_ulp `Up (min_int_as_float -. 1.))
  else (
    assert (not (is_x_minus_one_exact min_int_as_float));
    min_int_as_float)
;;

let box =
  let x = Sys.opaque_identity ~-.0. in
  fun f -> globalize_float f +. x
;;
