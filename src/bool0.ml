open Basement.Primitives

external bits_of_float
  :  float
  -> int64
  = "caml_int64_bits_of_float" "caml_int64_bits_of_float_unboxed"
[@@unboxed] [@@noalloc] [@@builtin]

external float_of_bits
  :  int64
  -> float
  = "caml_int64_float_of_bits" "caml_int64_float_of_bits_unboxed"
[@@unboxed] [@@noalloc] [@@builtin]

let bits_of_float f = Int64_u.unbox (bits_of_float (box_float f))
let float_of_bits i = unbox_float (float_of_bits (Int64_u.box i))

external magic : 'a 'b. 'a -> 'b = "%identity"

external select : 'a. bool -> 'a -> 'a -> 'a = "caml_csel_value"
[@@noalloc] [@@no_effects] [@@no_coeffects] [@@builtin]
