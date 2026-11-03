open! Import0
include Sign0
include Identifiable.Make (Sign0)
open! Replace_polymorphic_compare

let to_string_hum = function
  | Neg -> "negative"
  | Zero -> "zero"
  | Pos -> "positive"
;;

let to_float = function
  | Neg -> -1.
  | Zero -> 0.
  | Pos -> 1.
;;

let flip = function
  | Neg -> Pos
  | Zero -> Zero
  | Pos -> Neg
;;

let ( * ) t t' = of_int (to_int t * to_int t')

include Replace_polymorphic_compare
