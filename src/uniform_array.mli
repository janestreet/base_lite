open! Import0

type 'a t

include sig
  [@@@ocaml.warning "-32"]

  val sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t
  val t_of_sexp : 'a. (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a t
  val t_sexp_grammar : 'a. 'a Sexplib0.Sexp_grammar.t -> 'a t Sexplib0.Sexp_grammar.t

  val compare
    : 'a.
    ('a -> ('a[@merlin.hide]) -> int) -> 'a t -> ('a t[@merlin.hide]) -> int
end
[@@merlin.hide]

val invariant : 'a. 'a t -> unit
val empty : 'a. 'a t
val get_empty : 'a. unit -> 'a t
val create : 'a. len:int -> 'a -> 'a t
val singleton : 'a. 'a -> 'a t
val init : 'a. int -> f:(int -> 'a) -> 'a t
val length : 'a. 'a t -> int
val get : 'a. 'a t -> int -> 'a
val unsafe_get : 'a. 'a t -> int -> 'a
val set : 'a. 'a t -> int -> 'a -> unit
val unsafe_set : 'a. 'a t -> int -> 'a -> unit
val swap : 'a. 'a t -> int -> int -> unit
val unsafe_set_omit_phys_equal_check : 'a. 'a t -> int -> 'a -> unit
val unsafe_set_with_caml_modify : 'a. 'a t -> int -> 'a -> unit
val set_with_caml_modify : 'a. 'a t -> int -> 'a -> unit
val map : 'a 'b. 'a t -> f:('a -> 'b) -> 'b t
val mapi : 'a 'b. 'a t -> f:(int -> 'a -> 'b) -> 'b t
val iter : 'a. 'a t -> f:('a -> unit) -> unit
val iteri : 'a. 'a t -> f:(int -> 'a -> unit) -> unit
val fold : 'a 'acc. 'a t -> init:'acc -> f:('acc -> 'a -> 'acc) -> 'acc
val foldi : 'a 'acc. 'a t -> init:'acc -> f:(int -> 'acc -> 'a -> 'acc) -> 'acc

val fold_until
  : 'a 'acc 'final.
  'a t
  -> init:'acc
  -> f:('acc -> 'a -> ('acc, 'final) Container.Continue_or_stop.t)
  -> finish:('acc -> 'final)
  -> 'final

val unsafe_to_array_inplace__promise_not_a_float : 'a t -> 'a array
val of_array : 'a array -> 'a t
val to_array : 'a t -> 'a array
val of_list : 'a. 'a list -> 'a t
val of_list_rev : 'a. 'a list -> 'a t
val to_list : 'a. 'a t -> 'a list

include Blit.S1 with type 'a t := 'a t

val copy : 'a. 'a t -> 'a t
val exists : 'a. 'a t -> f:('a -> bool) -> bool
val existsi : 'a. 'a t -> f:(int -> 'a -> bool) -> bool
val for_all : 'a. 'a t -> f:('a -> bool) -> bool
val for_alli : 'a. 'a t -> f:(int -> 'a -> bool) -> bool
val concat : 'a. 'a t list -> 'a t
val concat_map : 'a 'b. 'a t -> f:('a -> 'b t) -> 'b t
val concat_mapi : 'a 'b. 'a t -> f:(int -> 'a -> 'b t) -> 'b t
val partition_map : 'a 'b 'c. 'a t -> f:('a -> ('b, 'c) Either.t) -> 'b t * 'c t
val filter : 'a. 'a t -> f:('a -> bool) -> 'a t
val filteri : 'a. 'a t -> f:(int -> 'a -> bool) -> 'a t
val filter_map : 'a 'b. 'a t -> f:('a -> 'b option) -> 'b t
val filter_mapi : 'a 'b. 'a t -> f:(int -> 'a -> 'b option) -> 'b t
val find : 'a. 'a t -> f:('a -> bool) -> 'a option
val findi : 'a. 'a t -> f:(int -> 'a -> bool) -> (int * 'a) option
val find_map : 'a 'b. 'a t -> f:('a -> 'b option) -> 'b option
val find_mapi : 'a 'b. 'a t -> f:(int -> 'a -> 'b option) -> 'b option
val map2_exn : 'a 'b 'c. 'a t -> 'b t -> f:('a -> 'b -> 'c) -> 'c t

val fold2_exn
  : 'a 'b 'acc.
  'a t -> 'b t -> init:'acc -> f:('acc -> 'a -> 'b -> 'acc) -> 'acc

val min_elt : 'a t -> compare:('a -> 'a -> int) -> 'a option
val max_elt : 'a t -> compare:('a -> 'a -> int) -> 'a option
val sort : ?pos:int -> ?len:int -> 'a t -> compare:('a -> 'a -> int) -> unit

include Binary_searchable.S1 with type 'a t := 'a t

val unsafe_create_uninitialized : 'a. len:int -> 'a t
val create_obj_array : len:int -> Stdlib.Obj.t t
val create_nullable_obj_array : len:int -> Obj.Nullable.t t
val unsafe_set_assuming_currently_int : Stdlib.Obj.t t -> int -> Stdlib.Obj.t -> unit
val unsafe_set_int_assuming_currently_int : Stdlib.Obj.t t -> int -> int -> unit
val unsafe_set_int : Stdlib.Obj.t t -> int -> int -> unit
val unsafe_clear_if_pointer : Stdlib.Obj.t t -> int -> unit
