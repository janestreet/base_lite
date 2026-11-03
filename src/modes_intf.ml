open! Import

open struct
  module Either = Either0
  module Result = Result0
end

module Definitions = struct
  module Global = struct
    module type Wrapper = sig
      type 'a t

      val wrap : 'a -> 'a t
      val unwrap : 'a t -> 'a
    end

    module Wrapped_fn1 (Input : T) (Output : T) = struct
      module type S = functor (W : Wrapper) -> sig
        val fn : Input.t W.t -> Output.t W.t
      end
    end

    module Wrapped_fn2 (Input1 : T) (Input2 : T) (Output : T) = struct
      module type S = functor (W : Wrapper) -> sig
        val fn : Input1.t W.t -> Input2.t W.t -> Output.t W.t
      end
    end

    module Wrapped_fn3 (Input1 : T) (Input2 : T) (Input3 : T) (Output : T) = struct
      module type S = functor (W : Wrapper) -> sig
        val fn : Input1.t W.t -> Input2.t W.t -> Input3.t W.t -> Output.t W.t
      end
    end

    module type Poly_fn1 = sig
      type input
      type output

      val fn_local : input -> output
      val fn_global : input -> output
    end

    module type Poly_fn2 = sig
      type input1
      type input2
      type output

      val fn_local : input1 -> input2 -> output
      val fn_global : input1 -> input2 -> output
    end

    module type Poly_fn3 = sig
      type input1
      type input2
      type input3
      type output

      val fn_local : input1 -> input2 -> input3 -> output
      val fn_global : input1 -> input2 -> input3 -> output
    end

    module type Global = sig
      type 'a t

      include sig
        [@@@ocaml.warning "-32"]

        include Ppx_compare_lib.Comparable.S1 with type 'a t := 'a t
        include Ppx_compare_lib.Equal.S1 with type 'a t := 'a t
        include Ppx_hash_lib.Hashable.S1 with type 'a t := 'a t
        include Sexplib0.Sexpable.S1 with type 'a t := 'a t

        val t_sexp_grammar
          : 'a.
          'a Sexplib0.Sexp_grammar.t -> 'a t Sexplib0.Sexp_grammar.t
      end
      [@@merlin.hide]

      val globalize : _ -> 'a t -> 'a t
      val wrap : 'a -> 'a t
      val unwrap : 'a t -> 'a
      val map : 'a t -> f:('a -> 'b) -> 'b t
      external wrap_list : 'a list -> 'a t list = "%identity"
      external unwrap_list : 'a t list -> 'a list = "%identity"
      external wrap_iarray : 'a iarray -> 'a t iarray = "%identity"
      external unwrap_iarray : 'a t iarray -> 'a iarray = "%identity"
      external wrap_or_null : 'a or_null -> 'a t or_null = "%identity"
      external unwrap_or_null : 'a t or_null -> 'a or_null = "%identity"
      external wrap_option : 'a option -> 'a t option = "%identity"
      external unwrap_option : 'a t option -> 'a option = "%identity"
      external wrap_either : ('a, 'b) Either.t -> ('a t, 'b t) Either.t = "%identity"
      external unwrap_either : ('a t, 'b t) Either.t -> ('a, 'b) Either.t = "%identity"
      external wrap_first : ('a, 'b) Either.t -> ('a t, 'b) Either.t = "%identity"
      external unwrap_first : ('a t, 'b) Either.t -> ('a, 'b) Either.t = "%identity"
      external wrap_second : ('a, 'b) Either.t -> ('a, 'b t) Either.t = "%identity"
      external unwrap_second : ('a, 'b t) Either.t -> ('a, 'b) Either.t = "%identity"
      external wrap_result : ('a, 'b) Result.t -> ('a t, 'b t) Result.t = "%identity"
      external unwrap_result : ('a t, 'b t) Result.t -> ('a, 'b) Result.t = "%identity"
      external wrap_ok : ('a, 'b) Result.t -> ('a t, 'b) Result.t = "%identity"
      external unwrap_ok : ('a t, 'b) Result.t -> ('a, 'b) Result.t = "%identity"
      external wrap_error : ('a, 'b) Result.t -> ('a, 'b t) Result.t = "%identity"
      external unwrap_error : ('a, 'b t) Result.t -> ('a, 'b) Result.t = "%identity"
      external wrap_tuple2 : 'a * 'b -> 'a t * 'b t = "%identity"
      external wrap_fst : 'a * 'b -> 'a t * 'b = "%identity"
      external wrap_snd : 'a * 'b -> 'a * 'b t = "%identity"
      external unwrap_tuple2 : 'a t * 'b t -> 'a * 'b = "%identity"
      external unwrap_fst : 'a t * 'b -> 'a * 'b = "%identity"
      external unwrap_snd : 'a * 'b t -> 'a * 'b = "%identity"

      module Poly_fn1 : functor
          (Input : T)
          (Output : T)
          (F : Wrapped_fn1(Input)(Output).S)
          -> Poly_fn1 with type input := Input.t and type output := Output.t

      module Poly_fn2 : functor
          (Input1 : T)
          (Input2 : T)
          (Output : T)
          (F : Wrapped_fn2(Input1)(Input2)(Output).S)
          ->
        Poly_fn2
        with type input1 := Input1.t
         and type input2 := Input2.t
         and type output := Output.t

      module Poly_fn3 : functor
          (Input1 : T)
          (Input2 : T)
          (Input3 : T)
          (Output : T)
          (F : Wrapped_fn3(Input1)(Input2)(Input3)(Output).S)
          ->
        Poly_fn3
        with type input1 := Input1.t
         and type input2 := Input2.t
         and type input3 := Input3.t
         and type output := Output.t
    end
  end

  module Portable = struct
    module type Portable = sig
      type 'a t

      include sig
        [@@@ocaml.warning "-32"]

        include Ppx_compare_lib.Comparable.S1 with type 'a t := 'a t
        include Ppx_compare_lib.Equal.S1 with type 'a t := 'a t
        include Ppx_hash_lib.Hashable.S1 with type 'a t := 'a t

        val sexp_of_t : ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t

        val t_sexp_grammar
          : 'a.
          'a Sexplib0.Sexp_grammar.t -> 'a t Sexplib0.Sexp_grammar.t
      end
      [@@merlin.hide]

      val t_of_sexp : (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a t
      external cross : 'a. 'a -> 'a = "%identity"
      external wrap : 'a -> 'a t = "%identity"
      external unwrap : 'a t -> 'a = "%identity"
      val map : 'a t -> f:('a -> 'b) -> 'b t
      external wrap_list : 'a list -> 'a t list = "%identity"
      external unwrap_list : 'a t list -> 'a list = "%identity"
      external wrap_iarray : 'a iarray -> 'a t iarray = "%identity"
      external unwrap_iarray : 'a t iarray -> 'a iarray = "%identity"
      external wrap_or_null : 'a or_null -> 'a t or_null = "%identity"
      external unwrap_or_null : 'a t or_null -> 'a or_null = "%identity"
      external wrap_option : 'a option -> 'a t option = "%identity"
      external unwrap_option : 'a t option -> 'a option = "%identity"
      external wrap_either : ('a, 'b) Either.t -> ('a t, 'b t) Either.t = "%identity"
      external unwrap_either : ('a t, 'b t) Either.t -> ('a, 'b) Either.t = "%identity"
      external wrap_first : ('a, 'b) Either.t -> ('a t, 'b) Either.t = "%identity"
      external unwrap_first : ('a t, 'b) Either.t -> ('a, 'b) Either.t = "%identity"
      external wrap_second : ('a, 'b) Either.t -> ('a, 'b t) Either.t = "%identity"
      external unwrap_second : ('a, 'b t) Either.t -> ('a, 'b) Either.t = "%identity"
      external wrap_result : ('a, 'b) Result.t -> ('a t, 'b t) Result.t = "%identity"
      external unwrap_result : ('a t, 'b t) Result.t -> ('a, 'b) Result.t = "%identity"

      external wrap_result_list
        :  ('a, 'b) Result.t list
        -> ('a t, 'b t) Result.t list
        = "%identity"

      external unwrap_result_list
        :  ('a t, 'b t) Result.t list
        -> ('a, 'b) Result.t list
        = "%identity"

      external wrap_ok : ('a, 'b) Result.t -> ('a t, 'b) Result.t = "%identity"
      external unwrap_ok : ('a t, 'b) Result.t -> ('a, 'b) Result.t = "%identity"
      external wrap_error : ('a, 'b) Result.t -> ('a, 'b t) Result.t = "%identity"
      external unwrap_error : ('a, 'b t) Result.t -> ('a, 'b) Result.t = "%identity"

      external wrap_ok_list
        :  ('a, 'b) Result.t list
        -> ('a t, 'b) Result.t list
        = "%identity"

      external unwrap_ok_list
        :  ('a t, 'b) Result.t list
        -> ('a, 'b) Result.t list
        = "%identity"

      external wrap_error_list
        :  ('a, 'b) Result.t list
        -> ('a, 'b t) Result.t list
        = "%identity"

      external unwrap_error_list
        :  ('a, 'b t) Result.t list
        -> ('a, 'b) Result.t list
        = "%identity"

      external wrap_tuple2 : 'a * 'b -> 'a t * 'b t = "%identity"
      external wrap_fst : 'a * 'b -> 'a t * 'b = "%identity"
      external wrap_snd : 'a * 'b -> 'a * 'b t = "%identity"
      external unwrap_tuple2 : 'a t * 'b t -> 'a * 'b = "%identity"
      external unwrap_fst : 'a t * 'b -> 'a * 'b = "%identity"
      external unwrap_snd : 'a * 'b t -> 'a * 'b = "%identity"
    end
  end

  module At_locality = struct
    module type Without_crossing = sig
      type actually_local

      type local =
        [ `global
        | `local of actually_local
        ]

      include sig
        [@@@ocaml.warning "-32"]

        val compare_local : local -> (local[@merlin.hide]) -> int
        val equal_local : local -> (local[@merlin.hide]) -> bool

        val hash_fold_local
          :  Ppx_hash_lib.Std.Hash.state
          -> local
          -> Ppx_hash_lib.Std.Hash.state

        val hash_local : local -> Ppx_hash_lib.Std.Hash.hash_value
        val sexp_of_local : local -> Sexplib0.Sexp.t
        val local_sexp_grammar : local Sexplib0.Sexp_grammar.t
      end
      [@@merlin.hide]

      type global = [ `global ]

      include sig
        [@@@ocaml.warning "-32"]

        val compare_global : global -> (global[@merlin.hide]) -> int
        val equal_global : global -> (global[@merlin.hide]) -> bool

        val hash_fold_global
          :  Ppx_hash_lib.Std.Hash.state
          -> global
          -> Ppx_hash_lib.Std.Hash.state

        val hash_global : global -> Ppx_hash_lib.Std.Hash.hash_value
        val sexp_of_global : global -> Sexplib0.Sexp.t
        val global_sexp_grammar : global Sexplib0.Sexp_grammar.t
      end
      [@@merlin.hide]

      type (+'a, 'locality) t

      include sig
        [@@@ocaml.warning "-32"]

        include
          Ppx_compare_lib.Comparable.S2 with type (+'a, 'locality) t := ('a, 'locality) t

        include Ppx_compare_lib.Equal.S2 with type (+'a, 'locality) t := ('a, 'locality) t
        include Ppx_hash_lib.Hashable.S2 with type (+'a, 'locality) t := ('a, 'locality) t

        val globalize
          : 'a 'locality.
          ('a -> 'a) -> ('locality -> 'locality) -> ('a, 'locality) t -> ('a, 'locality) t

        val sexp_of_t
          :  ('a -> Sexplib0.Sexp.t)
          -> ('locality -> Sexplib0.Sexp.t)
          -> ('a, 'locality) t
          -> Sexplib0.Sexp.t

        val t_sexp_grammar
          : 'a 'locality.
          'a Sexplib0.Sexp_grammar.t
          -> 'locality Sexplib0.Sexp_grammar.t
          -> ('a, 'locality) t Sexplib0.Sexp_grammar.t
      end
      [@@merlin.hide]

      val wrap : 'a -> ('a, _) t
      val unwrap : ('a, _) t -> 'a
      val wrap_local : 'a -> ('a, local) t
      val unwrap_local : ('a, _) t -> 'a
      val unwrap_global : ('a, global) t -> 'a
      val to_local : ('a, _) t -> ('a, local) t
      val to_global : ('a, _) t -> ('a, global) t
      val globalize_global : ('a, global) t -> ('a, global) t
    end

    module type At_locality = sig
      type actually_local
      type global = [ `global ]

      type local =
        [ `global
        | `local of actually_local
        ]

      type ('a, _) t = 'a

      include
        Without_crossing
        with type ('a, 'loc) t := ('a, 'loc) t
         and type actually_local := actually_local
         and type global := global
         and type local := local
    end
  end
end

module type Modes = sig
  type 'a t = { modal : 'a } [@@unboxed]

  module Global : sig
    include module type of struct
      include Definitions.Global
    end

    type 'a t = 'a Basement.Modes.global = { global : 'a } [@@unboxed]

    include Global with type 'a t := 'a t
  end

  module Portable : sig
    include module type of struct
      include Definitions.Portable
    end

    type 'a t = 'a Basement.Modes.portable = { portable : 'a } [@@unboxed]

    include Portable with type 'a t := 'a t
  end

  module Contended : sig
    type 'a t = 'a Basement.Modes.contended = { contended : 'a } [@@unboxed]

    include sig
      [@@@ocaml.warning "-32"]

      val t_of_sexp : 'a. (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a t
    end
    [@@merlin.hide]

    external cross : 'a. 'a -> 'a = "%identity"
    external wrap_list : 'a list -> 'a t list = "%identity"
  end

  module Shared : sig
    type 'a t = 'a Basement.Modes.shared = { shared : 'a } [@@unboxed]

    include sig
      [@@@ocaml.warning "-32"]

      val t_of_sexp : 'a. (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a t
    end
    [@@merlin.hide]
  end

  module Portended : sig
    type 'a t = 'a Basement.Modes.portended = { portended : 'a } [@@unboxed]
  end

  module Many : sig
    type 'a t = 'a Basement.Modes.many = { many : 'a } [@@unboxed]

    include sig
      [@@@ocaml.warning "-32"]

      val compare
        : 'a.
        ('a -> ('a[@merlin.hide]) -> int) -> 'a t -> ('a t[@merlin.hide]) -> int

      val equal
        : 'a.
        ('a -> ('a[@merlin.hide]) -> bool) -> 'a t -> ('a t[@merlin.hide]) -> bool

      val hash_fold_t
        : 'a.
        (Ppx_hash_lib.Std.Hash.state -> 'a -> Ppx_hash_lib.Std.Hash.state)
        -> Ppx_hash_lib.Std.Hash.state
        -> 'a t
        -> Ppx_hash_lib.Std.Hash.state

      val sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t
      val t_sexp_grammar : 'a. 'a Sexplib0.Sexp_grammar.t -> 'a t Sexplib0.Sexp_grammar.t
    end
    [@@merlin.hide]
  end

  module Aliased : sig
    type 'a t = 'a Basement.Modes.aliased = { aliased : 'a } [@@unboxed]

    include sig
      [@@@ocaml.warning "-32"]

      val compare
        : 'a.
        ('a -> ('a[@merlin.hide]) -> int) -> 'a t -> ('a t[@merlin.hide]) -> int

      val equal
        : 'a.
        ('a -> ('a[@merlin.hide]) -> bool) -> 'a t -> ('a t[@merlin.hide]) -> bool

      val hash_fold_t
        : 'a.
        (Ppx_hash_lib.Std.Hash.state -> 'a -> Ppx_hash_lib.Std.Hash.state)
        -> Ppx_hash_lib.Std.Hash.state
        -> 'a t
        -> Ppx_hash_lib.Std.Hash.state

      val sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t
      val t_sexp_grammar : 'a. 'a Sexplib0.Sexp_grammar.t -> 'a t Sexplib0.Sexp_grammar.t
    end
    [@@merlin.hide]

    val wrap : 'a -> 'a t
    val unwrap : 'a t -> 'a
  end

  module Aliased_many : sig
    type 'a t = 'a Basement.Modes.aliased_many = { aliased_many : 'a } [@@unboxed]

    include sig
      [@@@ocaml.warning "-32"]

      val compare
        : 'a.
        ('a -> ('a[@merlin.hide]) -> int) -> 'a t -> ('a t[@merlin.hide]) -> int

      val equal
        : 'a.
        ('a -> ('a[@merlin.hide]) -> bool) -> 'a t -> ('a t[@merlin.hide]) -> bool

      val hash_fold_t
        : 'a.
        (Ppx_hash_lib.Std.Hash.state -> 'a -> Ppx_hash_lib.Std.Hash.state)
        -> Ppx_hash_lib.Std.Hash.state
        -> 'a t
        -> Ppx_hash_lib.Std.Hash.state

      val sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t
      val t_sexp_grammar : 'a. 'a Sexplib0.Sexp_grammar.t -> 'a t Sexplib0.Sexp_grammar.t
    end
    [@@merlin.hide]
  end

  module Forkable : sig
    type 'a t = 'a Basement.Modes.forkable = { forkable : 'a } [@@unboxed]
  end

  module Unyielding : sig
    type 'a t = 'a Basement.Modes.unyielding = { unyielding : 'a } [@@unboxed]

    include sig
      [@@@ocaml.warning "-32"]

      val compare
        : 'a.
        ('a -> ('a[@merlin.hide]) -> int) -> 'a t -> ('a t[@merlin.hide]) -> int

      val equal
        : 'a.
        ('a -> ('a[@merlin.hide]) -> bool) -> 'a t -> ('a t[@merlin.hide]) -> bool

      val hash_fold_t
        : 'a.
        (Ppx_hash_lib.Std.Hash.state -> 'a -> Ppx_hash_lib.Std.Hash.state)
        -> Ppx_hash_lib.Std.Hash.state
        -> 'a t
        -> Ppx_hash_lib.Std.Hash.state

      val sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t
      val t_of_sexp : 'a. (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a t
      val t_sexp_grammar : 'a. 'a Sexplib0.Sexp_grammar.t -> 'a t Sexplib0.Sexp_grammar.t
    end
    [@@merlin.hide]
  end

  module Stateless : sig
    type 'a t = 'a Basement.Modes.stateless = { stateless : 'a } [@@unboxed]
  end

  module Reading : sig
    type 'a t = 'a Basement.Modes.reading = { reading : 'a } [@@unboxed]
  end

  module Immutable : sig
    type 'a t = 'a Basement.Modes.immutable = { immutable : 'a } [@@unboxed]
  end

  module Read : sig
    type 'a t = 'a Basement.Modes.read = { read : 'a } [@@unboxed]
  end

  module Immutable_data : sig
    type 'a t = 'a Basement.Modes.immutable_data = { immutable_data : 'a } [@@unboxed]
  end

  module At_locality : sig
    include module type of struct
      include Definitions.At_locality
    end

    include At_locality
  end

  module At_portability : sig
    type nonportable_ [@@warning "-redundant-modality"]
    type portable = [ `portable ]

    include sig
      [@@@ocaml.warning "-32"]

      val compare_portable : portable -> (portable[@merlin.hide]) -> int
      val equal_portable : portable -> (portable[@merlin.hide]) -> bool

      val hash_fold_portable
        :  Ppx_hash_lib.Std.Hash.state
        -> portable
        -> Ppx_hash_lib.Std.Hash.state

      val hash_portable : portable -> Ppx_hash_lib.Std.Hash.hash_value
      val sexp_of_portable : portable -> Sexplib0.Sexp.t
      val portable_sexp_grammar : portable Sexplib0.Sexp_grammar.t
    end
    [@@merlin.hide]

    type nonportable =
      [ `portable
      | `nonportable of nonportable_
      ]

    include sig
      [@@@ocaml.warning "-32"]

      val compare_nonportable : nonportable -> (nonportable[@merlin.hide]) -> int
      val equal_nonportable : nonportable -> (nonportable[@merlin.hide]) -> bool

      val hash_fold_nonportable
        :  Ppx_hash_lib.Std.Hash.state
        -> nonportable
        -> Ppx_hash_lib.Std.Hash.state

      val hash_nonportable : nonportable -> Ppx_hash_lib.Std.Hash.hash_value
      val sexp_of_nonportable : nonportable -> Sexplib0.Sexp.t
      val nonportable_sexp_grammar : nonportable Sexplib0.Sexp_grammar.t
    end
    [@@merlin.hide]

    type (+!'a, +'portability) t [@@warning "-redundant-modality"]

    include sig
      [@@@ocaml.warning "-32"]

      include
        Ppx_compare_lib.Comparable.S2
        with type (+!'a, +'portability) t := ('a, 'portability) t

      include
        Ppx_compare_lib.Equal.S2 with type (+!'a, +'portability) t := ('a, 'portability) t

      include
        Ppx_hash_lib.Hashable.S2 with type (+!'a, +'portability) t := ('a, 'portability) t

      val sexp_of_t
        :  ('a -> Sexplib0.Sexp.t)
        -> ('portability -> Sexplib0.Sexp.t)
        -> ('a, 'portability) t
        -> Sexplib0.Sexp.t

      val t_sexp_grammar
        : 'a 'portability.
        'a Sexplib0.Sexp_grammar.t
        -> 'portability Sexplib0.Sexp_grammar.t
        -> ('a, 'portability) t Sexplib0.Sexp_grammar.t
    end
    [@@merlin.hide]

    external wrap_portable : 'a -> ('a, _) t = "%identity"
    external unwrap_portable : ('a, portable) t -> 'a = "%identity"
    external wrap_nonportable : 'a -> ('a, nonportable) t = "%identity"
    external unwrap_nonportable : ('a, _) t -> 'a = "%identity"

    type portability = nonportable

    include sig
      [@@@ocaml.warning "-32"]

      val compare_portability : portability -> (portability[@merlin.hide]) -> int
      val equal_portability : portability -> (portability[@merlin.hide]) -> bool

      val hash_fold_portability
        :  Ppx_hash_lib.Std.Hash.state
        -> portability
        -> Ppx_hash_lib.Std.Hash.state

      val hash_portability : portability -> Ppx_hash_lib.Std.Hash.hash_value
      val sexp_of_portability : portability -> Sexplib0.Sexp.t
      val portability_sexp_grammar : portability Sexplib0.Sexp_grammar.t
    end
    [@@merlin.hide]

    external wrap : 'a -> ('a, portability) t = "%identity"
    external unwrap : ('a, _) t -> 'a = "%identity"
  end

  module Portable_via_contended : sig
    type +'a t [@@warning "-redundant-modality"]

    external wrap : 'a -> 'a t = "%identity"
    external unwrap : 'a t -> 'a = "%identity"
    external unwrap_contended : 'a. 'a t -> 'a = "%identity"
    external wrap_list : 'a list -> 'a t list = "%identity"
    external unwrap_list : 'a t list -> 'a list = "%identity"
  end

  module Contended_via_portable : sig
    type +'a t [@@warning "-redundant-modality"]

    include sig
      [@@@ocaml.warning "-32"]

      val sexp_of_t : ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t
    end
    [@@merlin.hide]

    external wrap : 'a -> 'a t = "%identity"
    external unwrap : 'a t -> 'a = "%identity"
    val refute_portable : _ t -> _
  end

  module Many_via_aliased : sig
    type +!'a t

    external wrap : 'a -> 'a t = "%identity"
    external unwrap : 'a t -> 'a = "%identity"
  end

  module Aliased_via_many : sig
    type +!'a t

    external wrap : 'a -> 'a t = "%identity"
    external unwrap : 'a t -> 'a = "%identity"
    val refute_many : _ t -> _
  end

  module Mod : sig
    module Generic : sig
      type 'a t = Mod : 'a. 'a t
    end

    include module type of struct
      include Generic
    end

    module Global : sig
      type 'a t = 'a Generic.t = Mod : 'a. 'a t
    end

    module Portable : sig
      type 'a t = 'a Generic.t = Mod : 'a. 'a t
    end

    module Contended : sig
      type 'a t = 'a Generic.t = Mod : 'a. 'a t
    end

    module Shared : sig
      type 'a t = 'a Generic.t = Mod : 'a. 'a t
    end

    module Portended : sig
      type 'a t = 'a Generic.t = Mod : 'a. 'a t
    end

    module Many : sig
      type 'a t = 'a Generic.t = Mod : 'a. 'a t
    end

    module Aliased : sig
      type 'a t = 'a Generic.t = Mod : 'a. 'a t
    end
  end

  module Export : sig
    type 'a global = 'a Global.t = { global : 'a } [@@unboxed]

    include sig
      [@@@ocaml.warning "-32"]

      val compare_global
        : 'a.
        ('a -> ('a[@merlin.hide]) -> int) -> 'a global -> ('a global[@merlin.hide]) -> int

      val equal_global
        : 'a.
        ('a -> ('a[@merlin.hide]) -> bool)
        -> 'a global
        -> ('a global[@merlin.hide])
        -> bool

      val hash_fold_global
        : 'a.
        (Ppx_hash_lib.Std.Hash.state -> 'a -> Ppx_hash_lib.Std.Hash.state)
        -> Ppx_hash_lib.Std.Hash.state
        -> 'a global
        -> Ppx_hash_lib.Std.Hash.state

      val sexp_of_global : 'a. ('a -> Sexplib0.Sexp.t) -> 'a global -> Sexplib0.Sexp.t
      val global_of_sexp : 'a. (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a global

      val global_sexp_grammar
        : 'a.
        'a Sexplib0.Sexp_grammar.t -> 'a global Sexplib0.Sexp_grammar.t
    end
    [@@merlin.hide]

    type 'a portable = 'a Portable.t = { portable : 'a } [@@unboxed]

    include sig
      [@@@ocaml.warning "-32"]

      val compare_portable
        : 'a.
        ('a -> ('a[@merlin.hide]) -> int)
        -> 'a portable
        -> ('a portable[@merlin.hide])
        -> int

      val equal_portable
        : 'a.
        ('a -> ('a[@merlin.hide]) -> bool)
        -> 'a portable
        -> ('a portable[@merlin.hide])
        -> bool

      val hash_fold_portable
        : 'a.
        (Ppx_hash_lib.Std.Hash.state -> 'a -> Ppx_hash_lib.Std.Hash.state)
        -> Ppx_hash_lib.Std.Hash.state
        -> 'a portable
        -> Ppx_hash_lib.Std.Hash.state

      val sexp_of_portable : 'a. ('a -> Sexplib0.Sexp.t) -> 'a portable -> Sexplib0.Sexp.t

      val portable_sexp_grammar
        : 'a.
        'a Sexplib0.Sexp_grammar.t -> 'a portable Sexplib0.Sexp_grammar.t
    end
    [@@merlin.hide]

    type 'a contended = 'a Contended.t = { contended : 'a } [@@unboxed]

    include sig
      [@@@ocaml.warning "-32"]

      val contended_of_sexp
        : 'a.
        (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a contended
    end
    [@@merlin.hide]

    type 'a shared = 'a Shared.t = { shared : 'a } [@@unboxed]

    include sig
      [@@@ocaml.warning "-32"]

      val shared_of_sexp : 'a. (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a shared
    end
    [@@merlin.hide]

    type 'a portended = 'a Portended.t = { portended : 'a } [@@unboxed]
    type 'a many = 'a Many.t = { many : 'a } [@@unboxed]

    include sig
      [@@@ocaml.warning "-32"]

      val compare_many
        : 'a.
        ('a -> ('a[@merlin.hide]) -> int) -> 'a many -> ('a many[@merlin.hide]) -> int

      val equal_many
        : 'a.
        ('a -> ('a[@merlin.hide]) -> bool) -> 'a many -> ('a many[@merlin.hide]) -> bool

      val hash_fold_many
        : 'a.
        (Ppx_hash_lib.Std.Hash.state -> 'a -> Ppx_hash_lib.Std.Hash.state)
        -> Ppx_hash_lib.Std.Hash.state
        -> 'a many
        -> Ppx_hash_lib.Std.Hash.state

      val sexp_of_many : 'a. ('a -> Sexplib0.Sexp.t) -> 'a many -> Sexplib0.Sexp.t

      val many_sexp_grammar
        : 'a.
        'a Sexplib0.Sexp_grammar.t -> 'a many Sexplib0.Sexp_grammar.t
    end
    [@@merlin.hide]

    type 'a aliased = 'a Aliased.t = { aliased : 'a } [@@unboxed]

    include sig
      [@@@ocaml.warning "-32"]

      val compare_aliased
        : 'a.
        ('a -> ('a[@merlin.hide]) -> int)
        -> 'a aliased
        -> ('a aliased[@merlin.hide])
        -> int

      val equal_aliased
        : 'a.
        ('a -> ('a[@merlin.hide]) -> bool)
        -> 'a aliased
        -> ('a aliased[@merlin.hide])
        -> bool

      val hash_fold_aliased
        : 'a.
        (Ppx_hash_lib.Std.Hash.state -> 'a -> Ppx_hash_lib.Std.Hash.state)
        -> Ppx_hash_lib.Std.Hash.state
        -> 'a aliased
        -> Ppx_hash_lib.Std.Hash.state

      val sexp_of_aliased : 'a. ('a -> Sexplib0.Sexp.t) -> 'a aliased -> Sexplib0.Sexp.t

      val aliased_sexp_grammar
        : 'a.
        'a Sexplib0.Sexp_grammar.t -> 'a aliased Sexplib0.Sexp_grammar.t
    end
    [@@merlin.hide]

    type 'a aliased_many = 'a Aliased_many.t = { aliased_many : 'a } [@@unboxed]

    include sig
      [@@@ocaml.warning "-32"]

      val compare_aliased_many
        : 'a.
        ('a -> ('a[@merlin.hide]) -> int)
        -> 'a aliased_many
        -> ('a aliased_many[@merlin.hide])
        -> int

      val equal_aliased_many
        : 'a.
        ('a -> ('a[@merlin.hide]) -> bool)
        -> 'a aliased_many
        -> ('a aliased_many[@merlin.hide])
        -> bool

      val hash_fold_aliased_many
        : 'a.
        (Ppx_hash_lib.Std.Hash.state -> 'a -> Ppx_hash_lib.Std.Hash.state)
        -> Ppx_hash_lib.Std.Hash.state
        -> 'a aliased_many
        -> Ppx_hash_lib.Std.Hash.state

      val sexp_of_aliased_many
        : 'a.
        ('a -> Sexplib0.Sexp.t) -> 'a aliased_many -> Sexplib0.Sexp.t

      val aliased_many_sexp_grammar
        : 'a.
        'a Sexplib0.Sexp_grammar.t -> 'a aliased_many Sexplib0.Sexp_grammar.t
    end
    [@@merlin.hide]

    type 'a forkable = 'a Forkable.t = { forkable : 'a } [@@unboxed]
    type 'a unyielding = 'a Unyielding.t = { unyielding : 'a } [@@unboxed]

    include sig
      [@@@ocaml.warning "-32"]

      val compare_unyielding
        : 'a.
        ('a -> ('a[@merlin.hide]) -> int)
        -> 'a unyielding
        -> ('a unyielding[@merlin.hide])
        -> int

      val equal_unyielding
        : 'a.
        ('a -> ('a[@merlin.hide]) -> bool)
        -> 'a unyielding
        -> ('a unyielding[@merlin.hide])
        -> bool

      val hash_fold_unyielding
        : 'a.
        (Ppx_hash_lib.Std.Hash.state -> 'a -> Ppx_hash_lib.Std.Hash.state)
        -> Ppx_hash_lib.Std.Hash.state
        -> 'a unyielding
        -> Ppx_hash_lib.Std.Hash.state

      val sexp_of_unyielding
        : 'a.
        ('a -> Sexplib0.Sexp.t) -> 'a unyielding -> Sexplib0.Sexp.t

      val unyielding_of_sexp
        : 'a.
        (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a unyielding

      val unyielding_sexp_grammar
        : 'a.
        'a Sexplib0.Sexp_grammar.t -> 'a unyielding Sexplib0.Sexp_grammar.t
    end
    [@@merlin.hide]

    type 'a stateless = 'a Stateless.t = { stateless : 'a } [@@unboxed]
    type 'a reading = 'a Reading.t = { reading : 'a } [@@unboxed]
    type 'a immutable = 'a Immutable.t = { immutable : 'a } [@@unboxed]
    type 'a read = 'a Read.t = { read : 'a } [@@unboxed]
    type 'a immutable_data = 'a Immutable_data.t = { immutable_data : 'a } [@@unboxed]
  end
end
