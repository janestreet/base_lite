open! Import0
module Int = Int0
module Sexp = Sexp0
module String = String0
module Sys = Sys0

type t = Stdlib.Obj.t array

let invariant t =
  assert (Stdlib.Obj.tag (Stdlib.Obj.repr t) <> Stdlib.Obj.double_array_tag)
;;

let length = Array.length

let sexp_of_t t =
  Sexp.Atom
    (String.concat ~sep:"" [ "<Obj_array.t of length "; Int.to_string (length t); ">" ])
;;

let zero_obj = Stdlib.Obj.magic_portable (Stdlib.Obj.repr (0 : int))
let create_zero ~len = Array.create ~len (Stdlib.Obj.magic_uncontended zero_obj)

let empty =
  (let open Portability_hacks.Cross.Portable in
   cross (array magic))
    [||]
;;

let get_empty () = Portability_hacks.magic_uncontended__promise_deeply_immutable empty

type not_a_float =
  | Not_a_float_0
  | Not_a_float_1 of int

let _not_a_float_0 = Not_a_float_0
let _not_a_float_1 = Not_a_float_1 42

let get t i =
  Obj.repr (Sys.opaque_identity (Obj.magic (t : t) : not_a_float array).(i) : not_a_float)
;;

let unsafe_get t i =
  Stdlib.Obj.repr
    (Array.unsafe_get (Sys.opaque_identity (Obj.magic (t : t) : not_a_float array)) i
     : not_a_float)
;;

let unsafe_set_with_caml_modify t i obj =
  Array.unsafe_set
    (Sys.opaque_identity (Obj.magic (t : t) : not_a_float array))
    i
    (Stdlib.Obj.obj (Sys.opaque_identity obj) : not_a_float)
;;

let set_with_caml_modify t i obj =
  (Sys.opaque_identity (Obj.magic (t : t) : not_a_float array)).(i)
  <- (Stdlib.Obj.obj (Sys.opaque_identity obj) : not_a_float)
;;

let unsafe_set_int_assuming_currently_int t i int =
  Array.unsafe_set
    (Sys.opaque_identity (Obj.magic (t : t) : int array))
    i
    (Sys.opaque_identity int)
;;

let set t i obj =
  let old_obj = get t i in
  if Stdlib.Obj.is_int old_obj && Stdlib.Obj.is_int obj
  then unsafe_set_int_assuming_currently_int t i (Stdlib.Obj.obj obj : int)
  else if not (phys_equal old_obj obj)
  then unsafe_set_with_caml_modify t i obj
;;

let unsafe_set t i obj =
  let old_obj = unsafe_get t i in
  if Stdlib.Obj.is_int old_obj && Stdlib.Obj.is_int obj
  then unsafe_set_int_assuming_currently_int t i (Stdlib.Obj.obj obj : int)
  else if not (phys_equal old_obj obj)
  then unsafe_set_with_caml_modify t i obj
;;

let unsafe_set_omit_phys_equal_check t i obj =
  let old_obj = unsafe_get t i in
  if Stdlib.Obj.is_int old_obj && Stdlib.Obj.is_int obj
  then unsafe_set_int_assuming_currently_int t i (Stdlib.Obj.obj obj : int)
  else unsafe_set_with_caml_modify t i obj
;;

let swap t i j =
  let a = get t i in
  let b = get t j in
  unsafe_set t i b;
  unsafe_set t j a
;;

let create ~len x =
  if Stdlib.Obj.is_int x || Stdlib.Obj.tag x <> Stdlib.Obj.double_tag
  then Array.create ~len x
  else (
    let t = create_zero ~len in
    let x = Sys.opaque_identity x in
    for i = 0 to len - 1 do
      unsafe_set_with_caml_modify t i x
    done;
    t)
;;

let singleton obj = create ~len:1 obj

let unsafe_set_assuming_currently_int t i obj =
  if Stdlib.Obj.is_int obj
  then unsafe_set_int_assuming_currently_int t i (Stdlib.Obj.obj obj : int)
  else unsafe_set_with_caml_modify t i obj
;;

let unsafe_set_int t i int =
  let old_obj = unsafe_get t i in
  if Stdlib.Obj.is_int old_obj
  then unsafe_set_int_assuming_currently_int t i int
  else unsafe_set_with_caml_modify t i (Stdlib.Obj.repr int)
;;

let unsafe_clear_if_pointer t i =
  let old_obj = unsafe_get t i in
  if not (Stdlib.Obj.is_int old_obj)
  then unsafe_set_with_caml_modify t i (Stdlib.Obj.repr 0)
;;

let unsafe_blit ~src ~src_pos ~dst ~dst_pos ~len =
  if dst_pos < src_pos
  then
    for i = 0 to len - 1 do
      unsafe_set dst (dst_pos + i) (unsafe_get src (src_pos + i))
    done
  else
    for i = len - 1 downto 0 do
      unsafe_set dst (dst_pos + i) (unsafe_get src (src_pos + i))
    done
;;

include Blit.Make (struct
    type nonrec t = t

    let create = create_zero
    let length = length
    let unsafe_blit = unsafe_blit
  end)

let sub t ~pos ~len = Array.sub t ~pos ~len
let copy = Array.copy
