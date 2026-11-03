open! Import0
module Sexp = Sexp0

module Definitions = struct
  module Key = Hashtbl.Key

  module Ok_or_absent = struct
    type t =
      | Absent
      | Ok

    include struct
      let _ = fun (_ : t) -> ()
      let compare = (Stdlib.compare : t -> (t[@merlin.hide]) -> int)
      let _ = compare
      let all = ([ Absent; Ok ] : t list)
      let _ = all
      let equal = (Stdlib.( = ) : t -> (t[@merlin.hide]) -> bool)
      let _ = equal

      let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
        fun hsv arg ->
        Ppx_hash_lib.Std.Hash.fold_int
          hsv
          (match arg with
           | Absent -> 0
           | Ok -> 1)
      ;;

      let _ = hash_fold_t

      let hash : t -> Ppx_hash_lib.Std.Hash.hash_value =
        fun x ->
        (fun arg ->
          Ppx_hash_lib.Std.Hash.get_hash_value
            (let hsv = Ppx_hash_lib.Std.Hash.create () in
             hash_fold_t hsv arg))
          x
      ;;

      let _ = hash

      let sexp_of_t =
        (function
         | Absent -> Sexplib0.Sexp.Atom "Absent"
         | Ok -> Sexplib0.Sexp.Atom "Ok"
         : t -> Sexplib0.Sexp.t)
      ;;

      let _ = sexp_of_t
    end [@@merlin.hide]

    let is_ok = function
      | Absent -> false
      | Ok -> true
    ;;

    let is_absent = function
      | Absent -> true
      | Ok -> false
    ;;
  end

  module Ok_or_duplicate = struct
    type t =
      | Duplicate
      | Ok

    include struct
      let _ = fun (_ : t) -> ()
      let compare = (Stdlib.compare : t -> (t[@merlin.hide]) -> int)
      let _ = compare
      let all = ([ Duplicate; Ok ] : t list)
      let _ = all
      let equal = (Stdlib.( = ) : t -> (t[@merlin.hide]) -> bool)
      let _ = equal

      let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
        fun hsv arg ->
        Ppx_hash_lib.Std.Hash.fold_int
          hsv
          (match arg with
           | Duplicate -> 0
           | Ok -> 1)
      ;;

      let _ = hash_fold_t

      let hash : t -> Ppx_hash_lib.Std.Hash.hash_value =
        fun x ->
        (fun arg ->
          Ppx_hash_lib.Std.Hash.get_hash_value
            (let hsv = Ppx_hash_lib.Std.Hash.create () in
             hash_fold_t hsv arg))
          x
      ;;

      let _ = hash

      let sexp_of_t =
        (function
         | Duplicate -> Sexplib0.Sexp.Atom "Duplicate"
         | Ok -> Sexplib0.Sexp.Atom "Ok"
         : t -> Sexplib0.Sexp.t)
      ;;

      let _ = sexp_of_t
    end [@@merlin.hide]

    let is_ok = function
      | Duplicate -> false
      | Ok -> true
    ;;

    let is_duplicate = function
      | Duplicate -> true
      | Ok -> false
    ;;
  end

  module type Accessors = sig
    type 'a t

    include Container.Generic with type ('a, _, _) t := 'a t

    val mem : 'a t -> 'a -> bool
    val copy : 'a t -> 'a t
    val add : 'a t -> 'a -> unit
    val get_or_add : 'a t -> 'a -> 'a
    val strict_add : 'a t -> 'a -> Ok_or_duplicate.t
    val strict_add_or_error : 'a t -> 'a -> unit Or_error.t
    val strict_add_exn : 'a t -> 'a -> unit
    val remove : 'a t -> 'a -> unit
    val strict_remove : 'a t -> 'a -> Ok_or_absent.t
    val strict_remove_or_error : 'a t -> 'a -> unit Or_error.t
    val strict_remove_exn : 'a t -> 'a -> unit
    val clear : 'a t -> unit
    val equal : 'a t -> 'a t -> bool
    val filter : 'a t -> f:('a -> bool) -> 'a t
    val filter_inplace : 'a t -> f:('a -> bool) -> unit
    val inter : 'key t -> 'key t -> 'key t
    val union : 'a t -> 'a t -> 'a t
    val union_in_place : dst:'a t -> src:'a t -> unit
    val diff : 'a t -> 'a t -> 'a t
    val of_hashtbl_keys : ('a, _) Hashtbl.t -> 'a t
    val to_hashtbl : 'key t -> f:('key -> 'data) -> ('key, 'data) Hashtbl.t
    val capacity : _ t -> int
  end

  type ('key, 'z) create_options = ('key, unit, 'z) Hashtbl.create_options

  type ('key, 'z) create_options_without_first_class_module =
    ('key, unit, 'z) Hashtbl.create_options_without_first_class_module

  module type Creators = sig
    type 'a t

    val create : ?growth_allowed:bool -> ?size:int -> 'a Key.t -> 'a t
    val of_list : ?growth_allowed:bool -> ?size:int -> 'a Key.t -> 'a list -> 'a t
    val of_array : ?growth_allowed:bool -> ?size:int -> 'a Key.t -> 'a array -> 'a t
  end

  module type Creators_generic = sig
    type 'a t
    type 'a elt
    type ('a, 'z) create_options

    val create : ('a, unit -> 'a t) create_options
    val of_list : ('a, 'a elt list -> 'a t) create_options
    val of_array : ('a, 'a elt array -> 'a t) create_options
  end

  module type Sexp_of_m = sig
    type t

    include sig
      [@@@ocaml.warning "-32"]

      val sexp_of_t : t -> Sexplib0.Sexp.t
    end
    [@@merlin.hide]
  end

  module type M_of_sexp = sig
    type t

    include sig
      [@@@ocaml.warning "-32"]

      val t_of_sexp : Sexplib0.Sexp.t -> t
    end
    [@@merlin.hide]

    include Hashtbl.Key.S with type t := t
  end

  module type M_sexp_grammar = sig
    type t

    include sig
      [@@@ocaml.warning "-32"]

      val t_sexp_grammar : t Sexplib0.Sexp_grammar.t
    end
    [@@merlin.hide]
  end

  module type Equal_m = sig end

  module type For_deriving = sig
    type 'a t

    module type M_of_sexp = M_of_sexp
    module type Sexp_of_m = Sexp_of_m
    module type Equal_m = Equal_m
    module type M_sexp_grammar = M_sexp_grammar

    module M : functor (Elt : T.T) -> sig
      type nonrec t = Elt.t t
    end

    val sexp_of_m__t : (module Sexp_of_m with type t = 'elt) -> 'elt t -> Sexp.t
    val m__t_of_sexp : (module M_of_sexp with type t = 'elt) -> Sexp.t -> 'elt t

    val m__t_sexp_grammar
      :  (module M_sexp_grammar with type t = 'elt)
      -> 'elt t Sexplib0.Sexp_grammar.t

    val equal_m__t : (module Equal_m) -> 'elt t -> 'elt t -> bool
  end
end

module type Hash_set = sig
  include module type of struct
    include Definitions
  end

  type !'a t

  include sig
    [@@@ocaml.warning "-32"]

    val sexp_of_t : ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t
  end
  [@@merlin.hide]

  include Creators with type 'a t := 'a t
  include Accessors with type 'a t := 'a t with type 'a elt := 'a

  val hashable_s : 'key t -> 'key Key.t

  module Poly : sig
    type nonrec 'a t = 'a t

    include sig
      [@@@ocaml.warning "-32"]

      include Sexplib0.Sexpable.S1 with type 'a t := 'a t

      val t_sexp_grammar : 'a. 'a Sexplib0.Sexp_grammar.t -> 'a t Sexplib0.Sexp_grammar.t
    end
    [@@merlin.hide]

    include
      Creators_generic
      with type 'a t := 'a t
      with type 'a elt = 'a
      with type ('key, 'z) create_options :=
        ('key, 'z) create_options_without_first_class_module

    include Accessors with type 'a t := 'a t with type 'a elt := 'a elt
  end

  module Creators : functor
      (Elt : sig
         type 'a t

         val hashable : 'a t Hashable.t
       end)
      -> sig
    val t_of_sexp : (Sexp.t -> 'a Elt.t) -> Sexp.t -> 'a Elt.t t

    include
      Creators_generic
      with type 'a t := 'a Elt.t t
      with type 'a elt := 'a Elt.t
      with type ('elt, 'z) create_options :=
        ('elt, 'z) create_options_without_first_class_module
  end

  include For_deriving with type 'a t := 'a t

  module Private : sig
    val hashable : 'a t -> 'a Hashable.t
  end
end
