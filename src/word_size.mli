open! Import0

type t =
  | W32
  | W64

include sig
  [@@@ocaml.warning "-32"]

  val sexp_of_t : t -> Sexplib0.Sexp.t
end
[@@merlin.hide]

val num_bits : t -> int
val word_size : t
