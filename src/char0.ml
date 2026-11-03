open! Import0

let failwithf = Printf.failwithf
let escaped = Stdlib.Char.escaped
let lowercase = Stdlib.Char.lowercase_ascii
let to_int = Stdlib.Char.code
let unsafe_of_int = Stdlib.Char.unsafe_chr
let uppercase = Stdlib.Char.uppercase_ascii
let int_is_ok i = 0 <= i && i <= 255
let min_value = unsafe_of_int 0
let max_value = unsafe_of_int 255
let of_int i = if int_is_ok i then Some (unsafe_of_int i) else None

let of_int_exn i =
  if int_is_ok i
  then unsafe_of_int i
  else failwithf "Char.of_int_exn got integer out of range: %d" i ()
;;

let equal (t1 : char) t2 = Poly.equal t1 t2
