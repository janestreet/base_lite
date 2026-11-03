open! Import0
module Sexp = Sexp0

type ('a, 'witness) t =
  { compare : 'a -> 'a -> int
  ; sexp_of_t : 'a -> Sexp.t
  }

let compare { compare; _ } = compare
let sexp_of_t { sexp_of_t; _ } = sexp_of_t

module T = struct
  type ('a, 'b) comparator = ('a, 'b) t
end

include T
include Comparator_intf.Definitions (T)

module Module = struct
  type ('a, 'b) t = (module S with type t = 'a and type comparator_witness = 'b)
end

let of_module (type a b) ((module M) : (a, b) Module.t) = M.comparator

let to_module (type a b) t : (a, b) Module.t =
  (module struct
    type t = a
    type comparator_witness = b

    let comparator = t
  end)
;;

let make (type t) ~compare ~sexp_of_t =
  (module struct
    type comparable_t = t
    type comparator_witness

    let comparator : (t, comparator_witness) comparator = { compare; sexp_of_t }
  end : S_fc
    with type comparable_t = t)
;;

module S_to_S1 (S : S) = struct
  type 'a t = S.t
  type comparator_witness = S.comparator_witness

  open S

  let comparator = comparator
end

module Make (M : sig
    type t

    include sig
      [@@@ocaml.warning "-32"]

      include Ppx_compare_lib.Comparable.S with type t := t

      val sexp_of_t : t -> Sexplib0.Sexp.t
    end
    [@@merlin.hide]
  end) =
struct
  type comparator_witness

  let comparator =
    let compare = M.compare in
    let sexp_of_t = M.sexp_of_t in
    { compare; sexp_of_t }
  ;;
end

module Make1 (M : sig
    type 'a t

    val compare : 'a t -> 'a t -> int
    val sexp_of_t : 'a t -> Sexp.t
  end) : S1 with type 'a t := 'a M.t = struct
  type comparator_witness

  let comparator =
    let compare = M.compare in
    let sexp_of_t = M.sexp_of_t in
    { compare; sexp_of_t }
  ;;
end

module Poly = struct
  type 'a t = 'a

  include Make1 (struct
      type 'a t = 'a

      let compare = Poly.compare
      let sexp_of_t _ = Sexp.Atom "_"
    end)
end

module Derived_phantom (M : sig
    type ('a, 'b) t

    val compare : ('a -> 'a -> int) -> ('a, 'b) t -> ('a, 'b) t -> int
    val sexp_of_t : ('a -> Sexp.t) -> ('a, _) t -> Sexp.t
  end) =
struct
  type !'cmp_a comparator_witness

  open struct
    let _comparator (type a cmp_a) (a : (a, cmp_a) comparator) =
      let compare __eta_0 __eta_1 = M.compare a.compare __eta_0 __eta_1 in
      let sexp_of_t __eta_0 = M.sexp_of_t a.sexp_of_t __eta_0 in
      { compare; sexp_of_t }
    ;;
  end

  let comparator a =
    let compare __eta_0 __eta_1 = M.compare a.compare __eta_0 __eta_1 in
    let sexp_of_t __eta_0 = M.sexp_of_t a.sexp_of_t __eta_0 in
    { compare; sexp_of_t }
  ;;
end

module Derived2_phantom (M : sig
    type ('a, 'b, 'c) t

    val compare
      :  ('a -> 'a -> int)
      -> ('b -> 'b -> int)
      -> ('a, 'b, 'c) t
      -> ('a, 'b, 'c) t
      -> int

    val sexp_of_t : ('a -> Sexp.t) -> ('b -> Sexp.t) -> ('a, 'b, _) t -> Sexp.t
  end) =
struct
  type (!'cmp_a, !'cmp_b) comparator_witness

  open struct
    let _comparator
      (type a cmp_a b cmp_b)
      (a : (a, cmp_a) comparator)
      (b : (b, cmp_b) comparator)
      =
      let compare __eta_0 __eta_1 = M.compare a.compare b.compare __eta_0 __eta_1 in
      let sexp_of_t __eta_0 = M.sexp_of_t a.sexp_of_t b.sexp_of_t __eta_0 in
      { compare; sexp_of_t }
    ;;
  end

  let comparator a b =
    let compare __eta_0 __eta_1 = M.compare a.compare b.compare __eta_0 __eta_1 in
    let sexp_of_t __eta_0 = M.sexp_of_t a.sexp_of_t b.sexp_of_t __eta_0 in
    { compare; sexp_of_t }
  ;;
end

module Derived (M : sig
    type 'a t

    include sig
      [@@@ocaml.warning "-32"]

      include Ppx_compare_lib.Comparable.S1 with type 'a t := 'a t

      val sexp_of_t : ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t
    end
    [@@merlin.hide]
  end) =
Derived_phantom (struct
    include M

    type ('a, _) t = 'a M.t
  end)

module Derived2 (M : sig
    type ('a, 'b) t

    include sig
      [@@@ocaml.warning "-32"]

      include Ppx_compare_lib.Comparable.S2 with type ('a, 'b) t := ('a, 'b) t

      val sexp_of_t
        :  ('a -> Sexplib0.Sexp.t)
        -> ('b -> Sexplib0.Sexp.t)
        -> ('a, 'b) t
        -> Sexplib0.Sexp.t
    end
    [@@merlin.hide]
  end) =
Derived2_phantom (struct
    include M

    type ('a, 'b, _) t = ('a, 'b) M.t
  end)
