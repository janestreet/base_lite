open Basement.Or_null_shim.Export

let maybe_globalize globalize value = globalize value

let globalize_bool = function
  | (true | false) as b -> b
;;

let globalize_char = function
  | '\000' .. '\255' as c -> c
;;

external globalize_float : float -> float = "%obj_dup"
external globalize_int : int -> int = "%identity"
external globalize_int32 : int32 -> int32 = "%obj_dup"
external globalize_int64 : int64 -> int64 = "%obj_dup"
external globalize_nativeint : nativeint -> nativeint = "%obj_dup"
external globalize_bytes : bytes -> bytes = "%obj_dup"
external globalize_string : string -> string = "%obj_dup"

let globalize_unit (() as u) = u

external globalize_array' : 'a. 'a array -> 'a array = "%obj_dup"

let globalize_array _ a = globalize_array' a

external globalize_floatarray : floatarray -> floatarray = "%obj_dup"

let rec globalize_list f = function
  | [] -> []
  | x :: xs -> f x :: (globalize_list [@tailcall]) f xs
[@@tail_mod_cons]
;;

let globalize_option f = function
  | None -> None
  | Some x -> Some (f x)
;;

let globalize_or_null f = function
  | Null -> Null
  | This x -> This (f x)
;;

let globalize_result globalize_a globalize_b t =
  match t with
  | Ok a -> Ok (globalize_a a)
  | Error b -> Error (globalize_b b)
;;

let globalize_ref' r = ref !r
let globalize_ref _ r = globalize_ref' r

external globalize_lazy_t_mono : 'a lazy_t -> 'a lazy_t = "%identity"

let globalize_lazy_t _ t = globalize_lazy_t_mono t
