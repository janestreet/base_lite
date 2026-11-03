val maybe_globalize : ('a -> 'a) -> 'a -> 'a
val globalize_bool : bool -> bool
val globalize_char : char -> char
val globalize_float : float -> float
val globalize_int : int -> int
val globalize_int32 : int32 -> int32
val globalize_int64 : int64 -> int64
val globalize_nativeint : nativeint -> nativeint
val globalize_bytes : bytes -> bytes
val globalize_string : string -> string
val globalize_unit : unit -> unit
val globalize_array : 'a 'b. ('a -> 'b) -> 'a array -> 'a array
val globalize_floatarray : floatarray -> floatarray
val globalize_lazy_t : ('a -> 'b) -> 'a lazy_t -> 'a lazy_t
val globalize_list : 'a 'b. ('a -> 'b) -> 'a list -> 'b list
val globalize_option : 'a 'b. ('a -> 'b) -> 'a option -> 'b option

val globalize_or_null
  :  ('a -> 'b)
  -> 'a Basement.Or_null_shim.t
  -> 'b Basement.Or_null_shim.t

val globalize_result
  : 'ok 'err.
  ('ok -> 'ok) -> ('err -> 'err) -> ('ok, 'err) result -> ('ok, 'err) result

val globalize_ref : 'a 'b. ('a -> 'b) -> 'a ref -> 'a ref
