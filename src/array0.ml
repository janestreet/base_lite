open! Import0
module Sys = Sys0
module Int = Int0
module List = List0
module Ordered_collection_common = Ordered_collection_common0

let invalid_argf = Printf.invalid_argf

module Array = struct
  external create : len:int -> 'a -> 'a array = "caml_array_make"

  let create_local = create
  let magic_create_uninitialized ~len = create ~len (Stdlib.Obj.magic 0)

  external create_float_uninitialized : int -> float array = "caml_array_create_float"
  external get : 'a. 'a array -> int -> 'a = "%array_safe_get"
  external length : 'a. 'a array -> int = "%array_length"
  external set : 'a. 'a array -> int -> 'a -> unit = "%array_safe_set"
  external unsafe_get : 'a. 'a array -> int -> 'a = "%array_unsafe_get"
  external unsafe_set : 'a. 'a array -> int -> 'a -> unit = "%array_unsafe_set"

  external unsafe_blit
    : 'a.
    src:'a array -> src_pos:int -> dst:'a array -> dst_pos:int -> len:int -> unit
    = "caml_array_blit"

  external unsafe_fill : 'a. 'a array -> int -> int -> 'a -> unit = "caml_array_fill"
  external unsafe_sub : 'a. 'a array -> int -> int -> 'a array = "caml_array_sub"
  external concat : 'a. 'a array list -> 'a array = "caml_array_concat"
end

include Array

let max_length = Sys.max_array_length

let create_float_uninitialized ~len =
  try create_float_uninitialized len with
  | Invalid_argument _ ->
    invalid_argf "Array.create_float_uninitialized ~len:%d: invalid length" len ()
;;

include struct
  external append_prim : 'a. 'a array -> 'a array -> 'a array = "caml_array_append"

  let copy a =
    let l = length a in
    if l = 0 then [||] else unsafe_sub a 0 l
  ;;

  let append : type a. a array -> a array -> a array =
    fun a1 a2 ->
    let l1 = length a1 in
    if l1 = 0
    then copy a2
    else if length a2 = 0
    then unsafe_sub a1 0 l1
    else append_prim a1 a2
  ;;
end

let blit ~src ~src_pos ~dst ~dst_pos ~len =
  Ordered_collection_common.check_pos_len_exn ~pos:src_pos ~len ~total_length:(length src);
  Ordered_collection_common.check_pos_len_exn ~pos:dst_pos ~len ~total_length:(length dst);
  unsafe_blit ~src ~src_pos ~dst ~dst_pos ~len
;;

let make_matrix = Stdlib.Array.make_matrix

let fold_right t ~(f : _ -> _ -> _) ~init =
  let r = ref init in
  for i = length t - 1 downto 0 do
    r := f (unsafe_get t i) !r
  done;
  !r
;;

let init len ~(f : _ -> _) : _ array =
  if len = 0
  then [||]
  else if len < 0
  then invalid_arg "Array.init"
  else (
    let res = create ~len (f 0) in
    for i = 1 to Int.pred len do
      unsafe_set res i (f i)
    done;
    res)
;;

let sub : type a. a array -> pos:int -> len:int -> a array =
  fun a ~pos ~len ->
  if pos < 0 || len < 0 || pos > length a - len
  then invalid_arg "Array.sub"
  else unsafe_sub a pos len
;;

let to_list : type a. a array -> a List.Constructors.t =
  fun t ->
  let rec tolist t i res : _ List.Constructors.t =
    if i < 0 then res else tolist t (i - 1) (unsafe_get t i :: res)
  in
  tolist t (length t - 1) []
;;

let of_list : type a. a List.Constructors.t -> a array = function
  | ([] : _ List.Constructors.t) -> [||]
  | hd :: tl as l ->
    let a = create ~len:(List.length l) hd in
    let rec fill i = function
      | ([] : _ List.Constructors.t) -> a
      | hd :: tl ->
        unsafe_set a i hd;
        fill (i + 1) tl
    in
    fill 1 tl
;;

let fill : type a. a array -> pos:int -> len:int -> a -> unit =
  fun a ~pos ~len v ->
  if pos < 0 || len < 0 || pos > length a - len
  then invalid_arg "Array.fill"
  else unsafe_fill a pos len v
;;

let swap (t : _ array) i j =
  let elt_i = t.(i) in
  let elt_j = t.(j) in
  unsafe_set t i elt_j;
  unsafe_set t j elt_i
;;

let iter (type a) (t : a array) ~(f : _ -> _) =
  for i = 0 to length t - 1 do
    f (unsafe_get t i)
  done
;;

let iteri (type a) (t : a array) ~(f : _ -> _ -> _) =
  for i = 0 to length t - 1 do
    f i (unsafe_get t i)
  done
;;

let fold (type a b) (t : a array) ~init ~(f : _ -> _ -> _) : b =
  let length = length t in
  let rec loop i acc =
    if i < length then loop (i + 1) (f acc (unsafe_get t i)) else acc
  in
  loop 0 init [@nontail]
;;

let map (type a b) (t : a array) ~(f : _ -> _) : b array =
  let len = length t in
  if len = 0
  then [||]
  else (
    let r = create ~len (f (unsafe_get t 0)) in
    for i = 1 to len - 1 do
      unsafe_set r i (f (unsafe_get t i))
    done;
    r)
;;

let mapi (type a b) (t : a array) ~(f : _ -> _ -> _) : b array =
  let len = length t in
  if len = 0
  then [||]
  else (
    let r = create ~len (f 0 (unsafe_get t 0)) in
    for i = 1 to len - 1 do
      unsafe_set r i (f i (unsafe_get t i))
    done;
    r)
;;

let stable_sort t ~compare = Stdlib.Array.stable_sort t ~cmp:compare
