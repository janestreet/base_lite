open! Import0

val ifprintf : 'a -> ('r, 'a, 'c, unit) format4 -> 'r
val sprintf : ('r, unit, string) format -> 'r
val bprintf : Stdlib.Buffer.t -> ('r, Stdlib.Buffer.t, unit) format -> 'r
val ksprintf : (string -> 'a) -> ('r, unit, string, 'a) format4 -> 'r

val kbprintf
  :  (Stdlib.Buffer.t -> 'a)
  -> Stdlib.Buffer.t
  -> ('r, Stdlib.Buffer.t, unit, 'a) format4
  -> 'r

val failwithf : ('r, unit, string, unit -> _) format4 -> 'r
val invalid_argf : ('r, unit, string, unit -> _) format4 -> 'r
