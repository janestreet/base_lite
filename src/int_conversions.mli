open! Import0

val int_to_int32 : int -> int32 option
val int_to_int32_exn : int -> int32
external int_to_int32_trunc : int -> int32 = "%int32_of_int"
external int_to_int64 : int -> int64 = "%int64_of_int"
external int_to_nativeint : int -> nativeint = "%nativeint_of_int"
val int32_to_int : int32 -> int option
val int32_to_int_exn : int32 -> int
val int32_to_int_trunc : int32 -> int
external int32_to_int64 : int32 -> int64 = "%int64_of_int32"
external int32_to_nativeint : int32 -> nativeint = "%nativeint_of_int32"
val int32_is_representable_as_int : int32 -> bool
val int64_to_int : int64 -> int option
val int64_to_int_exn : int64 -> int
val int64_to_int_trunc : int64 -> int
val int64_to_int32 : int64 -> int32 option
val int64_to_int32_exn : int64 -> int32
external int64_to_int32_trunc : int64 -> int32 = "%int64_to_int32"
val int64_to_nativeint : int64 -> nativeint option
val int64_to_nativeint_exn : int64 -> nativeint
external int64_to_nativeint_trunc : int64 -> nativeint = "%int64_to_nativeint"
val int64_fit_on_int63_exn : int64 -> unit
val int64_is_representable_as_int63 : int64 -> bool
val nativeint_to_int : nativeint -> int option
val nativeint_to_int_exn : nativeint -> int
val nativeint_to_int_trunc : nativeint -> int
val nativeint_to_int32 : nativeint -> int32 option
val nativeint_to_int32_exn : nativeint -> int32
external nativeint_to_int32_trunc : nativeint -> int32 = "%nativeint_to_int32"
external nativeint_to_int64 : nativeint -> int64 = "%int64_of_nativeint"
val num_bits_int : int
val num_bits_int32 : int
val num_bits_int64 : int
val num_bits_nativeint : int
