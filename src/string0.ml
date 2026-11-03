open! Import0

open struct
  module Sys = Sys0
  module Bool = Bool0
  module Char = Char0
  module Uchar = Uchar0
  module Bytes = Bytes0
end

module String = struct
  external get : string -> int -> char = "%string_safe_get"
  external get_uint8 : string -> int -> int = "%string_safe_get"
  external length : string -> int = "%string_length"
  external unsafe_get : string -> int -> char = "%string_unsafe_get"
  external unsafe_get_uint8 : string -> int -> int = "%string_unsafe_get"
  external unsafe_get_uint16_ne : string -> int -> int = "%caml_string_get16u"
  external swap16 : int -> int = "%bswap16"

  let unsafe_get_uint16_le b i =
    if Sys.big_endian then swap16 (unsafe_get_uint16_ne b i) else unsafe_get_uint16_ne b i
  ;;

  let unsafe_get_uint16_be b i =
    if Sys.big_endian then unsafe_get_uint16_ne b i else swap16 (unsafe_get_uint16_ne b i)
  ;;

  external unsafe_get_int32_ne : string -> int -> int32 = "%caml_string_get32u"
  external swap32 : int32 -> int32 = "%bswap_int32"

  let unsafe_get_int32_le b i =
    if Sys.big_endian then swap32 (unsafe_get_int32_ne b i) else unsafe_get_int32_ne b i
  ;;

  let unsafe_get_int32_be b i =
    if Sys.big_endian then unsafe_get_int32_ne b i else swap32 (unsafe_get_int32_ne b i)
  ;;
end

include String

let max_length = Sys.max_string_length

let append s1 s2 =
  let l1 = length s1
  and l2 = length s2 in
  let s = Bytes.create (l1 + l2) in
  Bytes.unsafe_blit_string ~src:s1 ~src_pos:0 ~dst:s ~dst_pos:0 ~len:l1;
  Bytes.unsafe_blit_string ~src:s2 ~src_pos:0 ~dst:s ~dst_pos:l1 ~len:l2;
  Bytes.unsafe_to_string ~no_mutation_while_string_reachable:s
;;

let ( ^ ) s1 s2 = append s1 s2
let capitalize = Stdlib.String.capitalize_ascii
let compare = Stdlib.String.compare

let escaped s =
  let n = ref 0 in
  for i = 0 to length s - 1 do
    n
    := !n
       +
       match unsafe_get s i with
       | '"' | '\\' | '\n' | '\t' | '\r' | '\b' -> 2
       | ' ' .. '~' -> 1
       | _ -> 4
  done;
  if !n = length s
  then s
  else (
    let s' = Bytes.create !n in
    n := 0;
    for i = 0 to length s - 1 do
      (match unsafe_get s i with
       | ('"' | '\\') as c ->
         Bytes.unsafe_set s' !n '\\';
         incr n;
         Bytes.unsafe_set s' !n c
       | '\n' ->
         Bytes.unsafe_set s' !n '\\';
         incr n;
         Bytes.unsafe_set s' !n 'n'
       | '\t' ->
         Bytes.unsafe_set s' !n '\\';
         incr n;
         Bytes.unsafe_set s' !n 't'
       | '\r' ->
         Bytes.unsafe_set s' !n '\\';
         incr n;
         Bytes.unsafe_set s' !n 'r'
       | '\b' ->
         Bytes.unsafe_set s' !n '\\';
         incr n;
         Bytes.unsafe_set s' !n 'b'
       | ' ' .. '~' as c -> Bytes.unsafe_set s' !n c
       | c ->
         let a = Char.to_int c in
         Bytes.unsafe_set s' !n '\\';
         incr n;
         Bytes.unsafe_set s' !n (Char.unsafe_of_int (48 + (a / 100)));
         incr n;
         Bytes.unsafe_set s' !n (Char.unsafe_of_int (48 + (a / 10 mod 10)));
         incr n;
         Bytes.unsafe_set s' !n (Char.unsafe_of_int (48 + (a mod 10))));
      incr n
    done;
    Bytes.unsafe_to_string ~no_mutation_while_string_reachable:s')
;;

let make n c = Bytes.unsafe_to_string ~no_mutation_while_string_reachable:(Bytes.make n c)

let sub t ~pos ~len =
  let t = Bytes.unsafe_of_string_promise_no_mutation t in
  let t = Bytes.sub t ~pos ~len in
  Bytes.unsafe_to_string ~no_mutation_while_string_reachable:t
;;

let uncapitalize = Stdlib.String.uncapitalize_ascii

open struct
  let dec_invalid = Uchar.utf_decode_invalid
  let dec_ret n u = Uchar.utf_decode n (Uchar.unsafe_of_int u)
  let not_in_x80_to_xBF b = b lsr 6 <> 0b10
  let not_in_xA0_to_xBF b = b lsr 5 <> 0b101
  let not_in_x80_to_x9F b = b lsr 5 <> 0b100
  let not_in_x90_to_xBF b = b < 0x90 || 0xBF < b
  let not_in_x80_to_x8F b = b lsr 4 <> 0x8
  let utf_8_uchar_2 b0 b1 = ((b0 land 0x1F) lsl 6) lor (b1 land 0x3F)

  let utf_8_uchar_3 b0 b1 b2 =
    ((b0 land 0x0F) lsl 12) lor ((b1 land 0x3F) lsl 6) lor (b2 land 0x3F)
  ;;

  let utf_8_uchar_4 b0 b1 b2 b3 =
    ((b0 land 0x07) lsl 18)
    lor ((b1 land 0x3F) lsl 12)
    lor ((b2 land 0x3F) lsl 6)
    lor (b3 land 0x3F)
  ;;
end

let get_utf_8_uchar b i =
  let b0 = get_uint8 b i in
  let get = unsafe_get_uint8 in
  let max = length b - 1 in
  match Char.unsafe_of_int b0 with
  | '\000' .. '\127' -> dec_ret 1 b0
  | '\194' .. '\223' ->
    let i = i + 1 in
    if i > max
    then dec_invalid 1
    else (
      let b1 = get b i in
      if not_in_x80_to_xBF b1 then dec_invalid 1 else dec_ret 2 (utf_8_uchar_2 b0 b1))
  | '\224' ->
    let i = i + 1 in
    if i > max
    then dec_invalid 1
    else (
      let b1 = get b i in
      if not_in_xA0_to_xBF b1
      then dec_invalid 1
      else (
        let i = i + 1 in
        if i > max
        then dec_invalid 2
        else (
          let b2 = get b i in
          if not_in_x80_to_xBF b2
          then dec_invalid 2
          else dec_ret 3 (utf_8_uchar_3 b0 b1 b2))))
  | '\225' .. '\236' | '\238' .. '\239' ->
    let i = i + 1 in
    if i > max
    then dec_invalid 1
    else (
      let b1 = get b i in
      if not_in_x80_to_xBF b1
      then dec_invalid 1
      else (
        let i = i + 1 in
        if i > max
        then dec_invalid 2
        else (
          let b2 = get b i in
          if not_in_x80_to_xBF b2
          then dec_invalid 2
          else dec_ret 3 (utf_8_uchar_3 b0 b1 b2))))
  | '\237' ->
    let i = i + 1 in
    if i > max
    then dec_invalid 1
    else (
      let b1 = get b i in
      if not_in_x80_to_x9F b1
      then dec_invalid 1
      else (
        let i = i + 1 in
        if i > max
        then dec_invalid 2
        else (
          let b2 = get b i in
          if not_in_x80_to_xBF b2
          then dec_invalid 2
          else dec_ret 3 (utf_8_uchar_3 b0 b1 b2))))
  | '\240' ->
    let i = i + 1 in
    if i > max
    then dec_invalid 1
    else (
      let b1 = get b i in
      if not_in_x90_to_xBF b1
      then dec_invalid 1
      else (
        let i = i + 1 in
        if i > max
        then dec_invalid 2
        else (
          let b2 = get b i in
          if not_in_x80_to_xBF b2
          then dec_invalid 2
          else (
            let i = i + 1 in
            if i > max
            then dec_invalid 3
            else (
              let b3 = get b i in
              if not_in_x80_to_xBF b3
              then dec_invalid 3
              else dec_ret 4 (utf_8_uchar_4 b0 b1 b2 b3))))))
  | '\241' .. '\243' ->
    let i = i + 1 in
    if i > max
    then dec_invalid 1
    else (
      let b1 = get b i in
      if not_in_x80_to_xBF b1
      then dec_invalid 1
      else (
        let i = i + 1 in
        if i > max
        then dec_invalid 2
        else (
          let b2 = get b i in
          if not_in_x80_to_xBF b2
          then dec_invalid 2
          else (
            let i = i + 1 in
            if i > max
            then dec_invalid 3
            else (
              let b3 = get b i in
              if not_in_x80_to_xBF b3
              then dec_invalid 3
              else dec_ret 4 (utf_8_uchar_4 b0 b1 b2 b3))))))
  | '\244' ->
    let i = i + 1 in
    if i > max
    then dec_invalid 1
    else (
      let b1 = get b i in
      if not_in_x80_to_x8F b1
      then dec_invalid 1
      else (
        let i = i + 1 in
        if i > max
        then dec_invalid 2
        else (
          let b2 = get b i in
          if not_in_x80_to_xBF b2
          then dec_invalid 2
          else (
            let i = i + 1 in
            if i > max
            then dec_invalid 3
            else (
              let b3 = get b i in
              if not_in_x80_to_xBF b3
              then dec_invalid 3
              else dec_ret 4 (utf_8_uchar_4 b0 b1 b2 b3))))))
  | _ -> dec_invalid 1
;;

let get_utf_8_uchar t ~byte_pos = get_utf_8_uchar t byte_pos

let is_valid_utf_8 b =
  let rec loop max b i =
    if i > max
    then true
    else (
      let get = unsafe_get_uint8 in
      match Char.unsafe_of_int (get b i) with
      | '\000' .. '\127' -> loop max b (i + 1)
      | '\194' .. '\223' ->
        let last = i + 1 in
        if last > max || not_in_x80_to_xBF (get b last)
        then false
        else loop max b (last + 1)
      | '\224' ->
        let last = i + 2 in
        if last > max
           || not_in_xA0_to_xBF (get b (i + 1))
           || not_in_x80_to_xBF (get b last)
        then false
        else loop max b (last + 1)
      | '\225' .. '\236' | '\238' .. '\239' ->
        let last = i + 2 in
        if last > max
           || not_in_x80_to_xBF (get b (i + 1))
           || not_in_x80_to_xBF (get b last)
        then false
        else loop max b (last + 1)
      | '\237' ->
        let last = i + 2 in
        if last > max
           || not_in_x80_to_x9F (get b (i + 1))
           || not_in_x80_to_xBF (get b last)
        then false
        else loop max b (last + 1)
      | '\240' ->
        let last = i + 3 in
        if last > max
           || not_in_x90_to_xBF (get b (i + 1))
           || not_in_x80_to_xBF (get b (i + 2))
           || not_in_x80_to_xBF (get b last)
        then false
        else loop max b (last + 1)
      | '\241' .. '\243' ->
        let last = i + 3 in
        if last > max
           || not_in_x80_to_xBF (get b (i + 1))
           || not_in_x80_to_xBF (get b (i + 2))
           || not_in_x80_to_xBF (get b last)
        then false
        else loop max b (last + 1)
      | '\244' ->
        let last = i + 3 in
        if last > max
           || not_in_x80_to_x8F (get b (i + 1))
           || not_in_x80_to_xBF (get b (i + 2))
           || not_in_x80_to_xBF (get b last)
        then false
        else loop max b (last + 1)
      | _ -> false)
  in
  loop (length b - 1) b 0
;;

let get_utf_16be_uchar b i =
  let get = unsafe_get_uint16_be in
  let max = length b - 1 in
  if i < 0 || i > max
  then invalid_arg "index out of bounds"
  else if i = max
  then dec_invalid 1
  else (
    match get b i with
    | u when u < 0xD800 || u > 0xDFFF -> dec_ret 2 u
    | u when u > 0xDBFF -> dec_invalid 2
    | hi ->
      let last = i + 3 in
      if last > max
      then dec_invalid (max - i + 1)
      else (
        match get b (i + 2) with
        | u when u < 0xDC00 || u > 0xDFFF -> dec_invalid 2
        | lo ->
          let u = (((hi land 0x3FF) lsl 10) lor (lo land 0x3FF)) + 0x10000 in
          dec_ret 4 u))
;;

let get_utf_16be_uchar t ~byte_pos = get_utf_16be_uchar t byte_pos

let is_valid_utf_16be b =
  let rec loop max b i =
    let get = unsafe_get_uint16_be in
    if i > max
    then true
    else if i = max
    then false
    else (
      match get b i with
      | u when u < 0xD800 || u > 0xDFFF -> loop max b (i + 2)
      | u when u > 0xDBFF -> false
      | _hi ->
        let last = i + 3 in
        if last > max
        then false
        else (
          match get b (i + 2) with
          | u when u < 0xDC00 || u > 0xDFFF -> false
          | _lo -> loop max b (i + 4)))
  in
  loop (length b - 1) b 0
;;

let get_utf_16le_uchar b i =
  let get = unsafe_get_uint16_le in
  let max = length b - 1 in
  if i < 0 || i > max
  then invalid_arg "index out of bounds"
  else if i = max
  then dec_invalid 1
  else (
    match get b i with
    | u when u < 0xD800 || u > 0xDFFF -> dec_ret 2 u
    | u when u > 0xDBFF -> dec_invalid 2
    | hi ->
      let last = i + 3 in
      if last > max
      then dec_invalid (max - i + 1)
      else (
        match get b (i + 2) with
        | u when u < 0xDC00 || u > 0xDFFF -> dec_invalid 2
        | lo ->
          let u = (((hi land 0x3FF) lsl 10) lor (lo land 0x3FF)) + 0x10000 in
          dec_ret 4 u))
;;

let get_utf_16le_uchar t ~byte_pos = get_utf_16le_uchar t byte_pos

let is_valid_utf_16le b =
  let rec loop max b i =
    let get = unsafe_get_uint16_le in
    if i > max
    then true
    else if i = max
    then false
    else (
      match get b i with
      | u when u < 0xD800 || u > 0xDFFF -> loop max b (i + 2)
      | u when u > 0xDBFF -> false
      | _hi ->
        let last = i + 3 in
        if last > max
        then false
        else (
          match get b (i + 2) with
          | u when u < 0xDC00 || u > 0xDFFF -> false
          | _lo -> loop max b (i + 4)))
  in
  loop (length b - 1) b 0
;;

open struct
  let get_utf_32_uchar ~get_int32 t ~byte_pos =
    let len = String.length t in
    match byte_pos >= 0 && byte_pos < len with
    | false -> raise (Invalid_argument "index out of bounds")
    | true ->
      (match len - byte_pos with
       | (1 | 2 | 3) as bytes_read -> Uchar.utf_decode_invalid bytes_read
       | _ ->
         let int32 = get_int32 t byte_pos in
         (match Int_conversions.int32_is_representable_as_int int32 with
          | false -> Uchar.utf_decode_invalid 4
          | true ->
            let int = Int_conversions.int32_to_int_trunc int32 in
            (match Uchar.is_valid int with
             | true -> Uchar.utf_decode 4 (Uchar.unsafe_of_int int)
             | false -> Uchar.utf_decode_invalid 4)))
  ;;
end

let get_utf_32le_uchar t ~byte_pos =
  get_utf_32_uchar t ~byte_pos ~get_int32:unsafe_get_int32_le
;;

let get_utf_32be_uchar t ~byte_pos =
  get_utf_32_uchar t ~byte_pos ~get_int32:unsafe_get_int32_be
;;

include struct
  let ensure_ge (x : int) y = if x >= y then x else invalid_arg "String.concat"

  let rec sum_lengths acc seplen = function
    | [] -> acc
    | hd :: [] -> length hd + acc
    | hd :: tl -> sum_lengths (ensure_ge (length hd + seplen + acc) acc) seplen tl
  ;;

  let rec unsafe_blits ~dst ~dst_pos ~sep ~sep_len = function
    | [] -> ()
    | hd :: [] ->
      Bytes.unsafe_blit_string ~src:hd ~src_pos:0 ~dst ~dst_pos ~len:(length hd)
    | hd :: tl ->
      Bytes.unsafe_blit_string ~src:hd ~src_pos:0 ~dst ~dst_pos ~len:(length hd);
      Bytes.unsafe_blit_string
        ~src:sep
        ~src_pos:0
        ~dst
        ~dst_pos:(dst_pos + length hd)
        ~len:sep_len;
      unsafe_blits ~dst ~dst_pos:(dst_pos + length hd + sep_len) ~sep ~sep_len tl
  ;;

  include (
  struct
    let smart_globalize a = Globalize.globalize_string a
  end :
  sig
    val smart_globalize : string -> string
  end)

  let concat ?(sep = "") l =
    match l with
    | [] -> ""
    | x :: [] -> smart_globalize x
    | l ->
      let sep_len = length sep in
      let dst = Bytes.create (sum_lengths 0 sep_len l) in
      unsafe_blits ~dst ~dst_pos:0 ~sep ~sep_len l;
      Bytes.unsafe_to_string ~no_mutation_while_string_reachable:dst
  ;;
end

let lowercase string =
  let string =
    Bytes.map ~f:Char.lowercase (Bytes.unsafe_of_string_promise_no_mutation string)
  in
  Bytes.unsafe_to_string ~no_mutation_while_string_reachable:string
;;

let uppercase string =
  let string =
    Bytes.map ~f:Char.uppercase (Bytes.unsafe_of_string_promise_no_mutation string)
  in
  Bytes.unsafe_to_string ~no_mutation_while_string_reachable:string
;;

let iter t ~f =
  for i = 0 to length t - 1 do
    f (unsafe_get t i)
  done
;;

let split_lines =
  let back_up_pos_and_eol_at_newline ~t ~pos =
    let pos = pos - Bool.select (pos > 0 && Char.equal t.[pos - 1] '\r') 2 1 in
    let eol = pos + 1 in
    pos, eol
  in
  fun t ->
    let n = length t in
    if n = 0
    then []
    else (
      let pos = n - 1 in
      let eol = n in
      let pos, eol =
        if Char.equal t.[pos] '\n'
        then back_up_pos_and_eol_at_newline ~t ~pos
        else pos, eol
      in
      let rec loop ~pos ~eol ac =
        if pos >= 0
        then
          if not (Char.equal t.[pos] '\n')
          then loop ~pos:(pos - 1) ~eol ac
          else (
            let start = pos + 1 in
            let ac = sub t ~pos:start ~len:(eol - start) :: ac in
            let pos, eol = back_up_pos_and_eol_at_newline ~t ~pos in
            loop ~pos ~eol ac)
        else sub t ~pos:0 ~len:eol :: ac
      in
      loop ~pos ~eol [])
;;

let init n ~f =
  if n < 0 then Printf.invalid_argf "String.init %d" n ();
  let t = Bytes.create n in
  for i = 0 to n - 1 do
    Bytes.set t i (f i)
  done;
  Bytes.unsafe_to_string ~no_mutation_while_string_reachable:t
;;

let filter t ~f =
  let n = length t in
  let i = ref 0 in
  while !i < n && f t.[!i] do
    incr i
  done;
  if !i = n
  then smart_globalize t
  else (
    let out = Bytes.create (n - 1) in
    Bytes.blit_string ~src:t ~src_pos:0 ~dst:out ~dst_pos:0 ~len:!i;
    let out_pos = ref !i in
    incr i;
    while !i < n do
      let c = t.[!i] in
      if f c
      then (
        Bytes.set out !out_pos c;
        incr out_pos);
      incr i
    done;
    let out = if !out_pos = n - 1 then out else Bytes.sub out ~pos:0 ~len:!out_pos in
    Bytes.unsafe_to_string ~no_mutation_while_string_reachable:out)
;;

let filteri t ~f =
  let n = length t in
  let i = ref 0 in
  while !i < n && f !i t.[!i] do
    incr i
  done;
  if !i = n
  then smart_globalize t
  else (
    let out = Bytes.create (n - 1) in
    Bytes.blit_string ~src:t ~src_pos:0 ~dst:out ~dst_pos:0 ~len:!i;
    let out_pos = ref !i in
    incr i;
    while !i < n do
      let c = t.[!i] in
      if f !i c
      then (
        Bytes.set out !out_pos c;
        incr out_pos);
      incr i
    done;
    let out = if !out_pos = n - 1 then out else Bytes.sub out ~pos:0 ~len:!out_pos in
    Bytes.unsafe_to_string ~no_mutation_while_string_reachable:out)
;;
