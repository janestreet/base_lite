open! Import0
module Array = Array0
module Sexp = Sexp0
open Ppx_compare_lib.Builtin

type +'a t = 'a iarray

let equal = equal_iarray
let compare = compare_iarray

external unsafe_to_array__promise_no_mutation : 'a. 'a t -> 'a array = "%array_of_iarray"
external unsafe_of_array__promise_no_mutation : 'a. 'a array -> 'a t = "%array_to_iarray"

module O = struct
  external ( .:() ) : 'a. 'a t -> int -> 'a = "%array_safe_get"
end

open O

external get : 'a. 'a t -> int -> 'a = "%array_safe_get"
external unsafe_get : 'a. 'a t -> int -> 'a = "%array_unsafe_get"
external length : 'a. 'a t -> int = "%array_length"

let init len ~f = unsafe_of_array__promise_no_mutation (Array.init len ~f)
let map t ~f = init (length t) ~f:(fun i -> f (unsafe_get t i)) [@nontail]

let sexp_of_t sexp_of__a (ar : _ t) =
  let lst_ref = ref [] in
  for i = length ar - 1 downto 0 do
    lst_ref := sexp_of__a ar.:(i) :: !lst_ref
  done;
  Sexp.List !lst_ref
;;
