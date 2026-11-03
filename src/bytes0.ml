open! Import0
module Uchar = Uchar0
module Sys = Sys0

module Primitives = struct
  external get : bytes -> int -> char = "%bytes_safe_get"
  external length : bytes -> int = "%bytes_length"
  external unsafe_get : bytes -> int -> char = "%bytes_unsafe_get"
  external set : bytes -> int -> char -> unit = "%bytes_safe_set"
  external unsafe_set : bytes -> int -> char -> unit = "%bytes_unsafe_set"

  external unsafe_blit
    :  src:bytes
    -> src_pos:int
    -> dst:bytes
    -> dst_pos:int
    -> len:int
    -> unit
    = "caml_blit_bytes"
  [@@noalloc]

  external unsafe_blit_string
    :  src:string
    -> src_pos:int
    -> dst:bytes
    -> dst_pos:int
    -> len:int
    -> unit
    = "caml_blit_string"
  [@@noalloc]

  external unsafe_get_int64 : bytes -> int -> int64 = "%caml_bytes_get64u"
  external unsafe_set_int64 : bytes -> int -> int64 -> unit = "%caml_bytes_set64u"
  external unsafe_get_int32 : bytes -> int -> int32 = "%caml_bytes_get32u"
  external unsafe_set_int32 : bytes -> int -> int32 -> unit = "%caml_bytes_set32u"
  external unsafe_get_int16 : bytes -> int -> int = "%caml_bytes_get16u"
  external unsafe_set_int16 : bytes -> int -> int -> unit = "%caml_bytes_set16u"
end

include Primitives

let max_length = Sys.max_string_length

let blit ~src ~src_pos ~dst ~dst_pos ~len =
  if len < 0
     || src_pos < 0
     || src_pos > length src - len
     || dst_pos < 0
     || dst_pos > length dst - len
  then invalid_arg "Bytes.blit"
  else unsafe_blit ~src ~src_pos ~dst ~dst_pos ~len
;;

external string_length : string -> int = "%string_length"

let blit_string ~src ~src_pos ~dst ~dst_pos ~len =
  if len < 0
     || src_pos < 0
     || src_pos > string_length src - len
     || dst_pos < 0
     || dst_pos > length dst - len
  then invalid_arg "String.blit / Bytes.blit_string"
  else unsafe_blit_string ~src ~src_pos ~dst ~dst_pos ~len
;;

let compare = Stdlib.Bytes.compare

external create : int -> bytes = "caml_create_bytes"

include struct
  open struct
    external unsafe_set_uint8 : bytes -> int -> int -> unit = "%bytes_unsafe_set"
    external unsafe_set_uint16_ne : bytes -> int -> int -> unit = "%caml_bytes_set16u"
    external set_int8 : bytes -> int -> int -> unit = "%bytes_safe_set"
    external set_int32_ne : bytes -> int -> int32 -> unit = "%caml_bytes_set32"
    external swap16 : int -> int = "%bswap16"
    external swap32 : int32 -> int32 = "%bswap_int32"

    let set_uint8 = set_int8

    let unsafe_set_uint16_le b i x =
      if Sys.big_endian
      then unsafe_set_uint16_ne b i (swap16 x)
      else unsafe_set_uint16_ne b i x
    ;;

    let unsafe_set_uint16_be b i x =
      if Sys.big_endian
      then unsafe_set_uint16_ne b i x
      else unsafe_set_uint16_ne b i (swap16 x)
    ;;

    let set_int32_le b i x =
      if Sys.big_endian then set_int32_ne b i (swap32 x) else set_int32_ne b i x
    ;;

    let set_int32_be b i x =
      if not Sys.big_endian then set_int32_ne b i (swap32 x) else set_int32_ne b i x
    ;;
  end

  let set_uchar_utf_8 b i u =
    let set = unsafe_set_uint8 in
    let max = length b - 1 in
    match Uchar.to_int u with
    | u when u < 0 -> assert false
    | u when u <= 0x007F ->
      set_uint8 b i u;
      1
    | u when u <= 0x07FF ->
      let last = i + 1 in
      if last > max
      then 0
      else (
        set_uint8 b i (0xC0 lor (u lsr 6));
        set b last (0x80 lor (u land 0x3F));
        2)
    | u when u <= 0xFFFF ->
      let last = i + 2 in
      if last > max
      then 0
      else (
        set_uint8 b i (0xE0 lor (u lsr 12));
        set b (i + 1) (0x80 lor ((u lsr 6) land 0x3F));
        set b last (0x80 lor (u land 0x3F));
        3)
    | u when u <= 0x10FFFF ->
      let last = i + 3 in
      if last > max
      then 0
      else (
        set_uint8 b i (0xF0 lor (u lsr 18));
        set b (i + 1) (0x80 lor ((u lsr 12) land 0x3F));
        set b (i + 2) (0x80 lor ((u lsr 6) land 0x3F));
        set b last (0x80 lor (u land 0x3F));
        4)
    | _ -> assert false
  ;;

  let set_uchar_utf_16le b i u =
    let set = unsafe_set_uint16_le in
    let max = length b - 1 in
    if i < 0 || i > max
    then invalid_arg "index out of bounds"
    else (
      match Uchar.to_int u with
      | u when u < 0 -> assert false
      | u when u <= 0xFFFF ->
        let last = i + 1 in
        if last > max
        then 0
        else (
          set b i u;
          2)
      | u when u <= 0x10FFFF ->
        let last = i + 3 in
        if last > max
        then 0
        else (
          let u' = u - 0x10000 in
          let hi = 0xD800 lor (u' lsr 10) in
          let lo = 0xDC00 lor (u' land 0x3FF) in
          set b i hi;
          set b (i + 2) lo;
          4)
      | _ -> assert false)
  ;;

  let set_uchar_utf_16be b i u =
    let set = unsafe_set_uint16_be in
    let max = length b - 1 in
    if i < 0 || i > max
    then invalid_arg "index out of bounds"
    else (
      match Uchar.to_int u with
      | u when u < 0 -> assert false
      | u when u <= 0xFFFF ->
        let last = i + 1 in
        if last > max
        then 0
        else (
          set b i u;
          2)
      | u when u <= 0x10FFFF ->
        let last = i + 3 in
        if last > max
        then 0
        else (
          let u' = u - 0x10000 in
          let hi = 0xD800 lor (u' lsr 10) in
          let lo = 0xDC00 lor (u' land 0x3FF) in
          set b i hi;
          set b (i + 2) lo;
          4)
      | _ -> assert false)
  ;;

  let set_utf_32_uchar ~set_int32 bytes idx uchar =
    set_int32 bytes idx (Int_conversions.int_to_int32_trunc (Uchar.to_int uchar));
    4
  ;;

  let set_uchar_utf_32le b i c = set_utf_32_uchar ~set_int32:set_int32_le b i c
  let set_uchar_utf_32be b i c = set_utf_32_uchar ~set_int32:set_int32_be b i c
end

external unsafe_create_local : int -> bytes = "Base_unsafe_create_local_bytes"

let create_local len =
  if len < 0 || len > Sys.max_string_length then invalid_arg "Bytes.create_local";
  unsafe_create_local len
;;

external unsafe_fill : bytes -> pos:int -> len:int -> char -> unit = "caml_fill_bytes"
[@@noalloc]

let fill t ~pos ~len c =
  if pos < 0 || len < 0 || pos > length t - len
  then invalid_arg "Bytes.fill"
  else unsafe_fill t ~pos ~len c
;;

let empty = Stdlib.Bytes.empty
let get_empty () = Portability_hacks.magic_uncontended__promise_deeply_immutable empty

external unsafe_to_string
  :  no_mutation_while_string_reachable:bytes
  -> string
  = "%bytes_to_string"

external unique_to_string : bytes -> string = "%bytes_to_string"
external unsafe_of_string_promise_no_mutation : string -> bytes = "%bytes_of_string"

let make n c =
  let t = create n in
  unsafe_fill t ~pos:0 ~len:n c;
  t
;;

let map t ~f =
  let l = length t in
  if l = 0
  then Obj.magic_unique (unsafe_of_string_promise_no_mutation "")
  else (
    let r = create l in
    for i = 0 to l - 1 do
      unsafe_set r i (f (unsafe_get t i))
    done;
    r)
;;

let mapi t ~f =
  let l = length t in
  if l = 0
  then Obj.magic_unique (unsafe_of_string_promise_no_mutation "")
  else (
    let r = create l in
    for i = 0 to l - 1 do
      unsafe_set r i (f i (unsafe_get t i))
    done;
    r)
;;

let copy src =
  let len = length src in
  let dst = create len in
  unsafe_blit ~src ~src_pos:0 ~dst ~dst_pos:0 ~len;
  dst
;;

let sub src ~pos:src_pos ~len =
  if src_pos < 0 || len < 0 || src_pos > length src - len
  then invalid_arg "Bytes0.sub"
  else (
    let dst = create len in
    unsafe_blit ~src ~src_pos ~dst ~dst_pos:0 ~len;
    dst)
;;

let to_string b = unique_to_string (copy b)
let of_string s = copy (unsafe_of_string_promise_no_mutation s) [@nontail]
