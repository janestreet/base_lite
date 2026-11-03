open! Import

open struct
  module Either = Either0
  module Result = Result0
end

type 'a t = { modal : 'a } [@@unboxed]

module Global = struct
  include Modes_intf.Definitions.Global

  type 'a t = 'a Basement.Modes.global = { global : 'a } [@@unboxed]

  let compare_internal compare a b = compare a.global b.global
  let compare compare a b = compare_internal compare a b
  let equal_internal equal a b = equal a.global b.global
  let equal equal a b = equal_internal equal a b
  let hash_fold_t hash state t = hash state t.global
  let t_of_sexp of_sexp sexp = { global = of_sexp sexp }
  let sexp_of_t sexp_of t = sexp_of t.global

  let t_sexp_grammar : 'a. 'a Sexplib0.Sexp_grammar.t -> 'a t Sexplib0.Sexp_grammar.t =
    Sexplib0.Sexp_grammar.coerce
  ;;

  let globalize _ { global } = { global }
  let wrap global = { global }
  let unwrap { global } = global
  let map { global = x } ~f = { global = f x }

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

  module Global_wrapper = struct
    type nonrec 'a t = 'a t

    let wrap = wrap
    let unwrap = unwrap
  end

  module Local_wrapper = struct
    type 'a t = 'a

    let wrap = Fn.id
    let unwrap = Fn.id
  end

  module Poly_fn1 (Input : T) (Output : T) (F : Wrapped_fn1(Input)(Output).S) :
    Poly_fn1 with type input := Input.t and type output := Output.t = struct
    module Global = F (Global_wrapper)
    module Local = F (Local_wrapper)

    let fn_global a = unwrap (Global.fn (wrap a)) [@nontail]
    let fn_local = Local.fn
  end

  module Poly_fn2
      (Input1 : T)
      (Input2 : T)
      (Output : T)
      (F : Wrapped_fn2(Input1)(Input2)(Output).S) :
    Poly_fn2
    with type input1 := Input1.t
     and type input2 := Input2.t
     and type output := Output.t = struct
    module Global = F (Global_wrapper)
    module Local = F (Local_wrapper)

    let fn_global a b = unwrap (Global.fn (wrap a) (wrap b)) [@nontail]
    let fn_local = Local.fn
  end

  module Poly_fn3
      (Input1 : T)
      (Input2 : T)
      (Input3 : T)
      (Output : T)
      (F : Wrapped_fn3(Input1)(Input2)(Input3)(Output).S) :
    Poly_fn3
    with type input1 := Input1.t
     and type input2 := Input2.t
     and type input3 := Input3.t
     and type output := Output.t = struct
    module Global = F (Global_wrapper)
    module Local = F (Local_wrapper)

    let fn_global a b c = unwrap (Global.fn (wrap a) (wrap b) (wrap c)) [@nontail]
    let fn_local = Local.fn
  end
end

module Portable = struct
  include Modes_intf.Definitions.Portable

  type 'a t = 'a Basement.Modes.portable = { portable : 'a } [@@unboxed]

  include struct
    let _ = fun (_ : 'a t) -> ()

    let compare
      : 'a. ('a -> ('a[@merlin.hide]) -> int) -> 'a t -> ('a t[@merlin.hide]) -> int
      =
      fun _cmp__a a__001_ b__002_ ->
      if Stdlib.( == ) a__001_ b__002_
      then 0
      else _cmp__a a__001_.portable b__002_.portable
    ;;

    let _ = compare

    let equal
      : 'a. ('a -> ('a[@merlin.hide]) -> bool) -> 'a t -> ('a t[@merlin.hide]) -> bool
      =
      fun _cmp__a a__003_ b__004_ ->
      if Stdlib.( == ) a__003_ b__004_
      then true
      else _cmp__a a__003_.portable b__004_.portable
    ;;

    let _ = equal

    let hash_fold_t
      : 'a.
      (Ppx_hash_lib.Std.Hash.state -> 'a -> Ppx_hash_lib.Std.Hash.state)
      -> Ppx_hash_lib.Std.Hash.state
      -> 'a t
      -> Ppx_hash_lib.Std.Hash.state
      =
      fun _hash_fold_a hsv arg ->
      let hsv = hsv in
      _hash_fold_a hsv arg.portable
    ;;

    let _ = hash_fold_t
  end [@@merlin.hide]

  let sexp_of_t sexp_of_a { portable } = sexp_of_a portable
  let t_of_sexp a_of_sexp sexp = { portable = a_of_sexp sexp }

  let t_sexp_grammar : type a. a Sexplib0.Sexp_grammar.t -> a t Sexplib0.Sexp_grammar.t =
    Sexplib0.Sexp_grammar.coerce
  ;;

  external cross : 'a. 'a -> 'a = "%identity"
  external wrap : 'a -> 'a t = "%identity"
  external unwrap : 'a t -> 'a = "%identity"

  let map { portable } ~f = { portable = f portable }

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
  external wrap_ok_list : ('a, 'b) Result.t list -> ('a t, 'b) Result.t list = "%identity"

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

module Contended = struct
  type 'a t = 'a Basement.Modes.contended = { contended : 'a } [@@unboxed]

  let t_of_sexp of_sexp sexp = { contended = of_sexp sexp }

  external cross : 'a. 'a -> 'a = "%identity"
  external wrap_list : 'a list -> 'a t list = "%identity"
end

module Shared = struct
  type 'a t = 'a Basement.Modes.shared = { shared : 'a } [@@unboxed]

  let t_of_sexp of_sexp sexp = { shared = of_sexp sexp }
end

module Portended = struct
  type 'a t = 'a Basement.Modes.portended = { portended : 'a } [@@unboxed]
end

module Many = struct
  type 'a t = 'a Basement.Modes.many = { many : 'a } [@@unboxed]

  include struct
    let _ = fun (_ : 'a t) -> ()

    let compare
      : 'a. ('a -> ('a[@merlin.hide]) -> int) -> 'a t -> ('a t[@merlin.hide]) -> int
      =
      fun _cmp__a a__005_ b__006_ ->
      if Stdlib.( == ) a__005_ b__006_ then 0 else _cmp__a a__005_.many b__006_.many
    ;;

    let _ = compare

    let equal
      : 'a. ('a -> ('a[@merlin.hide]) -> bool) -> 'a t -> ('a t[@merlin.hide]) -> bool
      =
      fun _cmp__a a__007_ b__008_ ->
      if Stdlib.( == ) a__007_ b__008_ then true else _cmp__a a__007_.many b__008_.many
    ;;

    let _ = equal

    let hash_fold_t
      : 'a.
      (Ppx_hash_lib.Std.Hash.state -> 'a -> Ppx_hash_lib.Std.Hash.state)
      -> Ppx_hash_lib.Std.Hash.state
      -> 'a t
      -> Ppx_hash_lib.Std.Hash.state
      =
      fun _hash_fold_a hsv arg ->
      let hsv = hsv in
      _hash_fold_a hsv arg.many
    ;;

    let _ = hash_fold_t

    let sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t =
      fun _of_a__009_ { many = many__011_ } ->
      let bnds__010_ = ([] : _ Stdlib.List.t) in
      let bnds__010_ =
        let arg__012_ = _of_a__009_ many__011_ in
        (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "many"; arg__012_ ] :: bnds__010_
         : _ Stdlib.List.t)
      in
      Sexplib0.Sexp.List bnds__010_
    ;;

    let _ = sexp_of_t

    let t_sexp_grammar : 'a. 'a Sexplib0.Sexp_grammar.t -> 'a t Sexplib0.Sexp_grammar.t =
      fun _'a_sexp_grammar ->
      { untyped =
          List
            (Fields
               { allow_extra_fields = false
               ; fields =
                   [ No_tag
                       { name = "many"
                       ; required = true
                       ; args = Cons (_'a_sexp_grammar.untyped, Empty)
                       }
                   ]
               })
      }
    ;;

    let _ = t_sexp_grammar
  end [@@merlin.hide]
end

module Aliased = struct
  type 'a t = 'a Basement.Modes.aliased = { aliased : 'a } [@@unboxed]

  include struct
    let _ = fun (_ : 'a t) -> ()

    let compare
      : 'a. ('a -> ('a[@merlin.hide]) -> int) -> 'a t -> ('a t[@merlin.hide]) -> int
      =
      fun _cmp__a a__013_ b__014_ ->
      if Stdlib.( == ) a__013_ b__014_ then 0 else _cmp__a a__013_.aliased b__014_.aliased
    ;;

    let _ = compare

    let equal
      : 'a. ('a -> ('a[@merlin.hide]) -> bool) -> 'a t -> ('a t[@merlin.hide]) -> bool
      =
      fun _cmp__a a__015_ b__016_ ->
      if Stdlib.( == ) a__015_ b__016_
      then true
      else _cmp__a a__015_.aliased b__016_.aliased
    ;;

    let _ = equal

    let hash_fold_t
      : 'a.
      (Ppx_hash_lib.Std.Hash.state -> 'a -> Ppx_hash_lib.Std.Hash.state)
      -> Ppx_hash_lib.Std.Hash.state
      -> 'a t
      -> Ppx_hash_lib.Std.Hash.state
      =
      fun _hash_fold_a hsv arg ->
      let hsv = hsv in
      _hash_fold_a hsv arg.aliased
    ;;

    let _ = hash_fold_t

    let sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t =
      fun _of_a__017_ { aliased = aliased__019_ } ->
      let bnds__018_ = ([] : _ Stdlib.List.t) in
      let bnds__018_ =
        let arg__020_ = _of_a__017_ aliased__019_ in
        (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "aliased"; arg__020_ ] :: bnds__018_
         : _ Stdlib.List.t)
      in
      Sexplib0.Sexp.List bnds__018_
    ;;

    let _ = sexp_of_t

    let t_sexp_grammar : 'a. 'a Sexplib0.Sexp_grammar.t -> 'a t Sexplib0.Sexp_grammar.t =
      fun _'a_sexp_grammar ->
      { untyped =
          List
            (Fields
               { allow_extra_fields = false
               ; fields =
                   [ No_tag
                       { name = "aliased"
                       ; required = true
                       ; args = Cons (_'a_sexp_grammar.untyped, Empty)
                       }
                   ]
               })
      }
    ;;

    let _ = t_sexp_grammar
  end [@@merlin.hide]

  let wrap aliased = { aliased }
  let unwrap { aliased } = aliased
end

module Aliased_many = struct
  type 'a t = 'a Basement.Modes.aliased_many = { aliased_many : 'a } [@@unboxed]

  include struct
    let _ = fun (_ : 'a t) -> ()

    let compare
      : 'a. ('a -> ('a[@merlin.hide]) -> int) -> 'a t -> ('a t[@merlin.hide]) -> int
      =
      fun _cmp__a a__021_ b__022_ ->
      if Stdlib.( == ) a__021_ b__022_
      then 0
      else _cmp__a a__021_.aliased_many b__022_.aliased_many
    ;;

    let _ = compare

    let equal
      : 'a. ('a -> ('a[@merlin.hide]) -> bool) -> 'a t -> ('a t[@merlin.hide]) -> bool
      =
      fun _cmp__a a__023_ b__024_ ->
      if Stdlib.( == ) a__023_ b__024_
      then true
      else _cmp__a a__023_.aliased_many b__024_.aliased_many
    ;;

    let _ = equal

    let hash_fold_t
      : 'a.
      (Ppx_hash_lib.Std.Hash.state -> 'a -> Ppx_hash_lib.Std.Hash.state)
      -> Ppx_hash_lib.Std.Hash.state
      -> 'a t
      -> Ppx_hash_lib.Std.Hash.state
      =
      fun _hash_fold_a hsv arg ->
      let hsv = hsv in
      _hash_fold_a hsv arg.aliased_many
    ;;

    let _ = hash_fold_t

    let sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t =
      fun _of_a__025_ { aliased_many = aliased_many__027_ } ->
      let bnds__026_ = ([] : _ Stdlib.List.t) in
      let bnds__026_ =
        let arg__028_ = _of_a__025_ aliased_many__027_ in
        (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "aliased_many"; arg__028_ ] :: bnds__026_
         : _ Stdlib.List.t)
      in
      Sexplib0.Sexp.List bnds__026_
    ;;

    let _ = sexp_of_t

    let t_sexp_grammar : 'a. 'a Sexplib0.Sexp_grammar.t -> 'a t Sexplib0.Sexp_grammar.t =
      fun _'a_sexp_grammar ->
      { untyped =
          List
            (Fields
               { allow_extra_fields = false
               ; fields =
                   [ No_tag
                       { name = "aliased_many"
                       ; required = true
                       ; args = Cons (_'a_sexp_grammar.untyped, Empty)
                       }
                   ]
               })
      }
    ;;

    let _ = t_sexp_grammar
  end [@@merlin.hide]
end

module Forkable = struct
  type 'a t = 'a Basement.Modes.forkable = { forkable : 'a } [@@unboxed]
end

module Unyielding = struct
  type 'a t = 'a Basement.Modes.unyielding = { unyielding : 'a } [@@unboxed]

  include struct
    let _ = fun (_ : 'a t) -> ()

    let compare
      : 'a. ('a -> ('a[@merlin.hide]) -> int) -> 'a t -> ('a t[@merlin.hide]) -> int
      =
      fun _cmp__a a__029_ b__030_ ->
      if Stdlib.( == ) a__029_ b__030_
      then 0
      else _cmp__a a__029_.unyielding b__030_.unyielding
    ;;

    let _ = compare

    let equal
      : 'a. ('a -> ('a[@merlin.hide]) -> bool) -> 'a t -> ('a t[@merlin.hide]) -> bool
      =
      fun _cmp__a a__031_ b__032_ ->
      if Stdlib.( == ) a__031_ b__032_
      then true
      else _cmp__a a__031_.unyielding b__032_.unyielding
    ;;

    let _ = equal

    let hash_fold_t
      : 'a.
      (Ppx_hash_lib.Std.Hash.state -> 'a -> Ppx_hash_lib.Std.Hash.state)
      -> Ppx_hash_lib.Std.Hash.state
      -> 'a t
      -> Ppx_hash_lib.Std.Hash.state
      =
      fun _hash_fold_a hsv arg ->
      let hsv = hsv in
      _hash_fold_a hsv arg.unyielding
    ;;

    let _ = hash_fold_t

    let sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t =
      fun _of_a__033_ { unyielding = unyielding__035_ } ->
      let bnds__034_ = ([] : _ Stdlib.List.t) in
      let bnds__034_ =
        let arg__036_ = _of_a__033_ unyielding__035_ in
        (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "unyielding"; arg__036_ ] :: bnds__034_
         : _ Stdlib.List.t)
      in
      Sexplib0.Sexp.List bnds__034_
    ;;

    let _ = sexp_of_t

    let t_sexp_grammar : 'a. 'a Sexplib0.Sexp_grammar.t -> 'a t Sexplib0.Sexp_grammar.t =
      fun _'a_sexp_grammar ->
      { untyped =
          List
            (Fields
               { allow_extra_fields = false
               ; fields =
                   [ No_tag
                       { name = "unyielding"
                       ; required = true
                       ; args = Cons (_'a_sexp_grammar.untyped, Empty)
                       }
                   ]
               })
      }
    ;;

    let _ = t_sexp_grammar
  end [@@merlin.hide]

  let t_of_sexp of_sexp sexp = { unyielding = of_sexp sexp }
end

module Stateless = struct
  type 'a t = 'a Basement.Modes.stateless = { stateless : 'a } [@@unboxed]
end

module Reading = struct
  type 'a t = 'a Basement.Modes.reading = { reading : 'a } [@@unboxed]
end

module Immutable = struct
  type 'a t = 'a Basement.Modes.immutable = { immutable : 'a } [@@unboxed]
end

module Read = struct
  type 'a t = 'a Basement.Modes.read = { read : 'a } [@@unboxed]
end

module Immutable_data = struct
  type 'a t = 'a Basement.Modes.immutable_data = { immutable_data : 'a } [@@unboxed]
end

module At_locality = struct
  include Modes_intf.Definitions.At_locality

  type actually_local
  type global = [ `global ]

  include struct
    let _ = fun (_ : global) -> ()
    let compare_global = (Stdlib.compare : global -> (global[@merlin.hide]) -> int)
    let _ = compare_global
    let equal_global = (Stdlib.( = ) : global -> (global[@merlin.hide]) -> bool)
    let _ = equal_global

    let hash_fold_global
      : Ppx_hash_lib.Std.Hash.state -> global -> Ppx_hash_lib.Std.Hash.state
      =
      fun hsv arg ->
      match arg with
      | `global -> Ppx_hash_lib.Std.Hash.fold_int hsv 665989475
    ;;

    let _ = hash_fold_global

    let hash_global : global -> Ppx_hash_lib.Std.Hash.hash_value =
      fun x ->
      (fun arg ->
        Ppx_hash_lib.Std.Hash.get_hash_value
          (let hsv = Ppx_hash_lib.Std.Hash.create () in
           hash_fold_global hsv arg))
        x
    ;;

    let _ = hash_global

    let sexp_of_global =
      (fun `global -> Sexplib0.Sexp.Atom "global" : global -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_global

    let global_sexp_grammar : global Sexplib0.Sexp_grammar.t =
      { untyped =
          Variant
            { case_sensitivity = Case_sensitive
            ; clauses = [ No_tag { name = "global"; clause_kind = Atom_clause } ]
            }
      }
    ;;

    let _ = global_sexp_grammar
  end [@@merlin.hide]

  type local =
    [ `global
    | `local of (actually_local[@compare.ignore] [@equal.ignore] [@sexp.opaque])
    ]

  include struct
    let _ = fun (_ : local) -> ()

    let compare_local =
      (fun a__041_ b__042_ ->
         if Stdlib.( == ) a__041_ b__042_
         then 0
         else (
           match a__041_, b__042_ with
           | `global, `global -> 0
           | `local _left__043_, `local _right__044_ ->
             let _ : _ = _left__043_
             and _ : _ = _right__044_ in
             0
           | x, y -> Stdlib.compare x y)
       : local -> (local[@merlin.hide]) -> int)
    ;;

    let _ = compare_local

    let equal_local =
      (fun a__045_ b__046_ ->
         if Stdlib.( == ) a__045_ b__046_
         then true
         else (
           match a__045_, b__046_ with
           | `global, `global -> true
           | `local _left__047_, `local _right__048_ ->
             let _ : _ = _left__047_
             and _ : _ = _right__048_ in
             true
           | x, y -> Stdlib.( = ) x y)
       : local -> (local[@merlin.hide]) -> bool)
    ;;

    let _ = equal_local

    let hash_fold_local
      : Ppx_hash_lib.Std.Hash.state -> local -> Ppx_hash_lib.Std.Hash.state
      =
      fun hsv arg ->
      match arg with
      | `global -> Ppx_hash_lib.Std.Hash.fold_int hsv 665989475
      | `local _v ->
        let hsv = Ppx_hash_lib.Std.Hash.fold_int hsv (-118437525) in
        let _ = _v in
        hsv
    ;;

    let _ = hash_fold_local

    let hash_local : local -> Ppx_hash_lib.Std.Hash.hash_value =
      fun x ->
      (fun arg ->
        Ppx_hash_lib.Std.Hash.get_hash_value
          (let hsv = Ppx_hash_lib.Std.Hash.create () in
           hash_fold_local hsv arg))
        x
    ;;

    let _ = hash_local

    let sexp_of_local =
      (function
       | `global -> Sexplib0.Sexp.Atom "global"
       | `local v__049_ ->
         Sexplib0.Sexp.List
           [ Sexplib0.Sexp.Atom "local"
           ; (let _ = v__049_ in
              Sexplib0.Sexp_conv.sexp_of_opaque ())
           ]
       : local -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_local

    let local_sexp_grammar : local Sexplib0.Sexp_grammar.t =
      { untyped =
          Variant
            { case_sensitivity = Case_sensitive
            ; clauses =
                [ No_tag { name = "global"; clause_kind = Atom_clause }
                ; No_tag
                    { name = "local"
                    ; clause_kind =
                        List_clause
                          { args =
                              Cons (Sexplib0.Sexp_conv.opaque_sexp_grammar.untyped, Empty)
                          }
                    }
                ]
            }
      }
    ;;

    let _ = local_sexp_grammar
  end [@@merlin.hide]

  type ('a, _) t = 'a

  external wrap : 'a 'loc. 'a -> ('a, 'loc) t = "%identity"
  external unwrap : 'a 'loc. ('a, 'loc) t -> 'a = "%identity"
  external wrap_local : 'a. 'a -> ('a, local) t = "%identity"
  external unwrap_local : 'a 'loc. ('a, 'loc) t -> 'a = "%identity"
  external unwrap_global : 'a. ('a, global) t -> 'a = "%identity"

  let to_local t = wrap_local (unwrap_local t)
  let to_global t = wrap (unwrap t)
  let globalize globalize_a _ t = wrap (globalize_a (unwrap_local t))
  let globalize_global t = wrap (unwrap_global t)
  let equal equal_a _ x y = equal_a (unwrap x) (unwrap y)
  let compare compare_a _ x y = compare_a (unwrap x) (unwrap y)
  let hash_fold_t hash_fold_a _ state t = hash_fold_a state (unwrap t)
  let sexp_of_t sexp_of_a _ t = sexp_of_a (unwrap t)

  let t_sexp_grammar
    : type a. a Sexplib0.Sexp_grammar.t -> _ -> (a, _) t Sexplib0.Sexp_grammar.t
    =
    fun grammar _ -> Sexplib0.Sexp_grammar.coerce grammar
  ;;
end

module At_portability = struct
  type nonportable_ [@@warning "-redundant-modality"]

  include struct
    let _ = fun (_ : nonportable_) -> ()

    let compare_nonportable_ =
      (fun a__050_ b__051_ ->
         Ppx_compare_lib.compare_abstract ~type_name:"nonportable_" a__050_ b__051_
       : nonportable_ -> (nonportable_[@merlin.hide]) -> int)
    ;;

    let _ = compare_nonportable_

    let equal_nonportable_ =
      (fun a__052_ b__053_ ->
         Ppx_compare_lib.equal_abstract ~type_name:"nonportable_" a__052_ b__053_
       : nonportable_ -> (nonportable_[@merlin.hide]) -> bool)
    ;;

    let _ = equal_nonportable_

    let hash_fold_nonportable_
      : Ppx_hash_lib.Std.Hash.state -> nonportable_ -> Ppx_hash_lib.Std.Hash.state
      =
      fun hsv arg ->
      let _ = hsv in
      let _ = arg in
      failwith
        "hash called on the type nonportable_, which is abstract in an implementation."
    ;;

    let _ = hash_fold_nonportable_

    let hash_nonportable_ : nonportable_ -> Ppx_hash_lib.Std.Hash.hash_value =
      fun x ->
      (fun arg ->
        Ppx_hash_lib.Std.Hash.get_hash_value
          (let hsv = Ppx_hash_lib.Std.Hash.create () in
           hash_fold_nonportable_ hsv arg))
        x
    ;;

    let _ = hash_nonportable_
    let sexp_of_nonportable_ = (fun _ -> assert false : nonportable_ -> Sexplib0.Sexp.t)
    let _ = sexp_of_nonportable_

    let nonportable__sexp_grammar : nonportable_ Sexplib0.Sexp_grammar.t =
      { untyped = Any "Modes.At_portability.nonportable_" }
    ;;

    let _ = nonportable__sexp_grammar
  end [@@merlin.hide]

  let _ =
    fun (a__054_ : nonportable_) (b__055_ : nonportable_) ->
    compare_nonportable_ a__054_ b__055_ [@merlin.hide]
  ;;

  let _ =
    fun (a__056_ : nonportable_) (b__057_ : nonportable_) ->
    equal_nonportable_ a__056_ b__057_ [@merlin.hide]
  ;;

  let _ = hash_nonportable_

  type portable = [ `portable ]

  include struct
    let _ = fun (_ : portable) -> ()
    let compare_portable = (Stdlib.compare : portable -> (portable[@merlin.hide]) -> int)
    let _ = compare_portable
    let equal_portable = (Stdlib.( = ) : portable -> (portable[@merlin.hide]) -> bool)
    let _ = equal_portable

    let hash_fold_portable
      : Ppx_hash_lib.Std.Hash.state -> portable -> Ppx_hash_lib.Std.Hash.state
      =
      fun hsv arg ->
      match arg with
      | `portable -> Ppx_hash_lib.Std.Hash.fold_int hsv 762529179
    ;;

    let _ = hash_fold_portable

    let hash_portable : portable -> Ppx_hash_lib.Std.Hash.hash_value =
      fun x ->
      (fun arg ->
        Ppx_hash_lib.Std.Hash.get_hash_value
          (let hsv = Ppx_hash_lib.Std.Hash.create () in
           hash_fold_portable hsv arg))
        x
    ;;

    let _ = hash_portable

    let sexp_of_portable =
      (fun `portable -> Sexplib0.Sexp.Atom "portable" : portable -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_portable

    let portable_sexp_grammar : portable Sexplib0.Sexp_grammar.t =
      { untyped =
          Variant
            { case_sensitivity = Case_sensitive
            ; clauses = [ No_tag { name = "portable"; clause_kind = Atom_clause } ]
            }
      }
    ;;

    let _ = portable_sexp_grammar
  end [@@merlin.hide]

  type nonportable =
    [ `portable
    | `nonportable of nonportable_
    ]

  include struct
    let _ = fun (_ : nonportable) -> ()

    let compare_nonportable =
      (fun a__062_ b__063_ ->
         if Stdlib.( == ) a__062_ b__063_
         then 0
         else (
           match a__062_, b__063_ with
           | `portable, `portable -> 0
           | `nonportable _left__064_, `nonportable _right__065_ ->
             compare_nonportable_ _left__064_ _right__065_
           | x, y -> Stdlib.compare x y)
       : nonportable -> (nonportable[@merlin.hide]) -> int)
    ;;

    let _ = compare_nonportable

    let equal_nonportable =
      (fun a__066_ b__067_ ->
         if Stdlib.( == ) a__066_ b__067_
         then true
         else (
           match a__066_, b__067_ with
           | `portable, `portable -> true
           | `nonportable _left__068_, `nonportable _right__069_ ->
             equal_nonportable_ _left__068_ _right__069_
           | x, y -> Stdlib.( = ) x y)
       : nonportable -> (nonportable[@merlin.hide]) -> bool)
    ;;

    let _ = equal_nonportable

    let hash_fold_nonportable
      : Ppx_hash_lib.Std.Hash.state -> nonportable -> Ppx_hash_lib.Std.Hash.state
      =
      fun hsv arg ->
      match arg with
      | `portable -> Ppx_hash_lib.Std.Hash.fold_int hsv 762529179
      | `nonportable _v ->
        let hsv = Ppx_hash_lib.Std.Hash.fold_int hsv 285897640 in
        hash_fold_nonportable_ hsv _v
    ;;

    let _ = hash_fold_nonportable

    let hash_nonportable : nonportable -> Ppx_hash_lib.Std.Hash.hash_value =
      fun x ->
      (fun arg ->
        Ppx_hash_lib.Std.Hash.get_hash_value
          (let hsv = Ppx_hash_lib.Std.Hash.create () in
           hash_fold_nonportable hsv arg))
        x
    ;;

    let _ = hash_nonportable

    let sexp_of_nonportable =
      (function
       | `portable -> Sexplib0.Sexp.Atom "portable"
       | `nonportable v__070_ ->
         Sexplib0.Sexp.List
           [ Sexplib0.Sexp.Atom "nonportable"; sexp_of_nonportable_ v__070_ ]
       : nonportable -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_nonportable

    let nonportable_sexp_grammar : nonportable Sexplib0.Sexp_grammar.t =
      { untyped =
          Variant
            { case_sensitivity = Case_sensitive
            ; clauses =
                [ No_tag { name = "portable"; clause_kind = Atom_clause }
                ; No_tag
                    { name = "nonportable"
                    ; clause_kind =
                        List_clause
                          { args = Cons (nonportable__sexp_grammar.untyped, Empty) }
                    }
                ]
            }
      }
    ;;

    let _ = nonportable_sexp_grammar
  end [@@merlin.hide]

  type (+!'a, +'portability) t [@@warning "-redundant-modality"]

  external wrap_portable : 'a -> ('a, _) t = "%identity"
  external unwrap_portable : ('a, portable) t -> 'a = "%identity"
  external wrap_nonportable : 'a -> ('a, nonportable) t = "%identity"
  external unwrap_nonportable : ('a, _) t -> 'a = "%identity"

  type portability = nonportable

  include struct
    let _ = fun (_ : portability) -> ()

    let compare_portability =
      (compare_nonportable : portability -> (portability[@merlin.hide]) -> int)
    ;;

    let _ = compare_portability

    let equal_portability =
      (equal_nonportable : portability -> (portability[@merlin.hide]) -> bool)
    ;;

    let _ = equal_portability

    let hash_fold_portability
      : Ppx_hash_lib.Std.Hash.state -> portability -> Ppx_hash_lib.Std.Hash.state
      =
      hash_fold_nonportable

    and hash_portability : portability -> Ppx_hash_lib.Std.Hash.hash_value =
      fun x -> hash_nonportable x
    ;;

    let _ = hash_fold_portability
    and _ = hash_portability

    let sexp_of_portability = (sexp_of_nonportable : portability -> Sexplib0.Sexp.t)
    let _ = sexp_of_portability

    let portability_sexp_grammar : portability Sexplib0.Sexp_grammar.t =
      nonportable_sexp_grammar
    ;;

    let _ = portability_sexp_grammar
  end [@@merlin.hide]

  external wrap : 'a -> ('a, portability) t = "%identity"
  external unwrap : ('a, _) t -> 'a = "%identity"

  let equal equal_a _ x y =
    equal_a (unwrap_nonportable x) (unwrap_nonportable y) [@nontail]
  ;;

  let compare compare_a _ x y =
    compare_a (unwrap_nonportable x) (unwrap_nonportable y) [@nontail]
  ;;

  let hash_fold_t hash_fold_a _ state t = hash_fold_a state (unwrap_nonportable t)
  let sexp_of_t sexp_of_a _ t = sexp_of_a (unwrap_nonportable t)

  let t_sexp_grammar
    : type a. a Sexplib0.Sexp_grammar.t -> _ -> (a, _) t Sexplib0.Sexp_grammar.t
    =
    fun grammar _ -> Sexplib0.Sexp_grammar.coerce grammar
  ;;
end

module Portable_via_contended = struct
  type +'a t [@@warning "-redundant-modality"]

  external wrap : 'a -> 'a t = "%identity"
  external unwrap : 'a t -> 'a = "%identity"
  external unwrap_contended : 'a. 'a t -> 'a = "%identity"
  external wrap_list : 'a list -> 'a t list = "%identity"
  external unwrap_list : 'a t list -> 'a list = "%identity"
end

module Contended_via_portable = struct
  type +'a t [@@warning "-redundant-modality"]

  external wrap : 'a -> 'a t = "%identity"
  external unwrap : 'a t -> 'a = "%identity"

  let sexp_of_t sexp_of_a t = sexp_of_a (unwrap t)
  let refute_portable _ = assert false
end

module Many_via_aliased = struct
  type +!'a t

  external wrap : 'a -> 'a t = "%identity"
  external unwrap : 'a t -> 'a = "%identity"
end

module Aliased_via_many = struct
  type +!'a t

  external wrap : 'a -> 'a t = "%identity"
  external unwrap : 'a t -> 'a = "%identity"

  let refute_many (_ : _ t) = assert false
end

module Mod = struct
  module Generic = struct
    type 'a t = Mod : 'a. 'a t
  end

  include Generic

  module Global = struct
    type 'a t = 'a Generic.t = Mod : 'a. 'a t
  end

  module Portable = struct
    type 'a t = 'a Generic.t = Mod : 'a. 'a t
  end

  module Contended = struct
    type 'a t = 'a Generic.t = Mod : 'a. 'a t
  end

  module Shared = struct
    type 'a t = 'a Generic.t = Mod : 'a. 'a t
  end

  module Portended = struct
    type 'a t = 'a Generic.t = Mod : 'a. 'a t
  end

  module Many = struct
    type 'a t = 'a Generic.t = Mod : 'a. 'a t
  end

  module Aliased = struct
    type 'a t = 'a Generic.t = Mod : 'a. 'a t
  end
end

module Export = struct
  type 'a global = 'a Global.t = { global : 'a } [@@unboxed]

  include struct
    let _ = fun (_ : 'a global) -> ()

    let compare_global
      : 'a.
      ('a -> ('a[@merlin.hide]) -> int) -> 'a global -> ('a global[@merlin.hide]) -> int
      =
      fun _cmp__a a__075_ b__076_ ->
      if Stdlib.( == ) a__075_ b__076_ then 0 else _cmp__a a__075_.global b__076_.global
    ;;

    let _ = compare_global

    let equal_global
      : 'a.
      ('a -> ('a[@merlin.hide]) -> bool) -> 'a global -> ('a global[@merlin.hide]) -> bool
      =
      fun _cmp__a a__077_ b__078_ ->
      if Stdlib.( == ) a__077_ b__078_
      then true
      else _cmp__a a__077_.global b__078_.global
    ;;

    let _ = equal_global

    let hash_fold_global
      : 'a.
      (Ppx_hash_lib.Std.Hash.state -> 'a -> Ppx_hash_lib.Std.Hash.state)
      -> Ppx_hash_lib.Std.Hash.state
      -> 'a global
      -> Ppx_hash_lib.Std.Hash.state
      =
      fun _hash_fold_a hsv arg ->
      let hsv = hsv in
      _hash_fold_a hsv arg.global
    ;;

    let _ = hash_fold_global

    let sexp_of_global : 'a. ('a -> Sexplib0.Sexp.t) -> 'a global -> Sexplib0.Sexp.t =
      fun _of_a__079_ { global = global__081_ } ->
      let bnds__080_ = ([] : _ Stdlib.List.t) in
      let bnds__080_ =
        let arg__082_ = _of_a__079_ global__081_ in
        (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "global"; arg__082_ ] :: bnds__080_
         : _ Stdlib.List.t)
      in
      Sexplib0.Sexp.List bnds__080_
    ;;

    let _ = sexp_of_global

    let global_sexp_grammar
      : 'a. 'a Sexplib0.Sexp_grammar.t -> 'a global Sexplib0.Sexp_grammar.t
      =
      fun _'a_sexp_grammar ->
      { untyped =
          List
            (Fields
               { allow_extra_fields = false
               ; fields =
                   [ No_tag
                       { name = "global"
                       ; required = true
                       ; args = Cons (_'a_sexp_grammar.untyped, Empty)
                       }
                   ]
               })
      }
    ;;

    let _ = global_sexp_grammar
  end [@@merlin.hide]

  let global_of_sexp = Global.t_of_sexp

  type 'a portable = 'a Portable.t = { portable : 'a } [@@unboxed]

  include struct
    let _ = fun (_ : 'a portable) -> ()

    let compare_portable
      : 'a.
      ('a -> ('a[@merlin.hide]) -> int)
      -> 'a portable
      -> ('a portable[@merlin.hide])
      -> int
      =
      fun _cmp__a a__083_ b__084_ ->
      if Stdlib.( == ) a__083_ b__084_
      then 0
      else _cmp__a a__083_.portable b__084_.portable
    ;;

    let _ = compare_portable

    let equal_portable
      : 'a.
      ('a -> ('a[@merlin.hide]) -> bool)
      -> 'a portable
      -> ('a portable[@merlin.hide])
      -> bool
      =
      fun _cmp__a a__085_ b__086_ ->
      if Stdlib.( == ) a__085_ b__086_
      then true
      else _cmp__a a__085_.portable b__086_.portable
    ;;

    let _ = equal_portable

    let hash_fold_portable
      : 'a.
      (Ppx_hash_lib.Std.Hash.state -> 'a -> Ppx_hash_lib.Std.Hash.state)
      -> Ppx_hash_lib.Std.Hash.state
      -> 'a portable
      -> Ppx_hash_lib.Std.Hash.state
      =
      fun _hash_fold_a hsv arg ->
      let hsv = hsv in
      _hash_fold_a hsv arg.portable
    ;;

    let _ = hash_fold_portable

    let sexp_of_portable : 'a. ('a -> Sexplib0.Sexp.t) -> 'a portable -> Sexplib0.Sexp.t =
      fun _of_a__087_ { portable = portable__089_ } ->
      let bnds__088_ = ([] : _ Stdlib.List.t) in
      let bnds__088_ =
        let arg__090_ = _of_a__087_ portable__089_ in
        (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "portable"; arg__090_ ] :: bnds__088_
         : _ Stdlib.List.t)
      in
      Sexplib0.Sexp.List bnds__088_
    ;;

    let _ = sexp_of_portable

    let portable_sexp_grammar
      : 'a. 'a Sexplib0.Sexp_grammar.t -> 'a portable Sexplib0.Sexp_grammar.t
      =
      fun _'a_sexp_grammar ->
      { untyped =
          List
            (Fields
               { allow_extra_fields = false
               ; fields =
                   [ No_tag
                       { name = "portable"
                       ; required = true
                       ; args = Cons (_'a_sexp_grammar.untyped, Empty)
                       }
                   ]
               })
      }
    ;;

    let _ = portable_sexp_grammar
  end [@@merlin.hide]

  type 'a contended = 'a Contended.t = { contended : 'a } [@@unboxed]

  let contended_of_sexp = Contended.t_of_sexp

  type 'a shared = 'a Shared.t = { shared : 'a } [@@unboxed]

  let shared_of_sexp = Shared.t_of_sexp

  type 'a portended = 'a Portended.t = { portended : 'a } [@@unboxed]
  type 'a many = 'a Many.t = { many : 'a } [@@unboxed]

  include struct
    let _ = fun (_ : 'a many) -> ()

    let compare_many
      : 'a. ('a -> ('a[@merlin.hide]) -> int) -> 'a many -> ('a many[@merlin.hide]) -> int
      =
      fun _cmp__a a__091_ b__092_ ->
      if Stdlib.( == ) a__091_ b__092_ then 0 else _cmp__a a__091_.many b__092_.many
    ;;

    let _ = compare_many

    let equal_many
      : 'a.
      ('a -> ('a[@merlin.hide]) -> bool) -> 'a many -> ('a many[@merlin.hide]) -> bool
      =
      fun _cmp__a a__093_ b__094_ ->
      if Stdlib.( == ) a__093_ b__094_ then true else _cmp__a a__093_.many b__094_.many
    ;;

    let _ = equal_many

    let hash_fold_many
      : 'a.
      (Ppx_hash_lib.Std.Hash.state -> 'a -> Ppx_hash_lib.Std.Hash.state)
      -> Ppx_hash_lib.Std.Hash.state
      -> 'a many
      -> Ppx_hash_lib.Std.Hash.state
      =
      fun _hash_fold_a hsv arg ->
      let hsv = hsv in
      _hash_fold_a hsv arg.many
    ;;

    let _ = hash_fold_many

    let sexp_of_many : 'a. ('a -> Sexplib0.Sexp.t) -> 'a many -> Sexplib0.Sexp.t =
      fun _of_a__095_ { many = many__097_ } ->
      let bnds__096_ = ([] : _ Stdlib.List.t) in
      let bnds__096_ =
        let arg__098_ = _of_a__095_ many__097_ in
        (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "many"; arg__098_ ] :: bnds__096_
         : _ Stdlib.List.t)
      in
      Sexplib0.Sexp.List bnds__096_
    ;;

    let _ = sexp_of_many

    let many_sexp_grammar
      : 'a. 'a Sexplib0.Sexp_grammar.t -> 'a many Sexplib0.Sexp_grammar.t
      =
      fun _'a_sexp_grammar ->
      { untyped =
          List
            (Fields
               { allow_extra_fields = false
               ; fields =
                   [ No_tag
                       { name = "many"
                       ; required = true
                       ; args = Cons (_'a_sexp_grammar.untyped, Empty)
                       }
                   ]
               })
      }
    ;;

    let _ = many_sexp_grammar
  end [@@merlin.hide]

  type 'a aliased = 'a Aliased.t = { aliased : 'a } [@@unboxed]

  include struct
    let _ = fun (_ : 'a aliased) -> ()

    let compare_aliased
      : 'a.
      ('a -> ('a[@merlin.hide]) -> int) -> 'a aliased -> ('a aliased[@merlin.hide]) -> int
      =
      fun _cmp__a a__099_ b__100_ ->
      if Stdlib.( == ) a__099_ b__100_ then 0 else _cmp__a a__099_.aliased b__100_.aliased
    ;;

    let _ = compare_aliased

    let equal_aliased
      : 'a.
      ('a -> ('a[@merlin.hide]) -> bool)
      -> 'a aliased
      -> ('a aliased[@merlin.hide])
      -> bool
      =
      fun _cmp__a a__101_ b__102_ ->
      if Stdlib.( == ) a__101_ b__102_
      then true
      else _cmp__a a__101_.aliased b__102_.aliased
    ;;

    let _ = equal_aliased

    let hash_fold_aliased
      : 'a.
      (Ppx_hash_lib.Std.Hash.state -> 'a -> Ppx_hash_lib.Std.Hash.state)
      -> Ppx_hash_lib.Std.Hash.state
      -> 'a aliased
      -> Ppx_hash_lib.Std.Hash.state
      =
      fun _hash_fold_a hsv arg ->
      let hsv = hsv in
      _hash_fold_a hsv arg.aliased
    ;;

    let _ = hash_fold_aliased

    let sexp_of_aliased : 'a. ('a -> Sexplib0.Sexp.t) -> 'a aliased -> Sexplib0.Sexp.t =
      fun _of_a__103_ { aliased = aliased__105_ } ->
      let bnds__104_ = ([] : _ Stdlib.List.t) in
      let bnds__104_ =
        let arg__106_ = _of_a__103_ aliased__105_ in
        (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "aliased"; arg__106_ ] :: bnds__104_
         : _ Stdlib.List.t)
      in
      Sexplib0.Sexp.List bnds__104_
    ;;

    let _ = sexp_of_aliased

    let aliased_sexp_grammar
      : 'a. 'a Sexplib0.Sexp_grammar.t -> 'a aliased Sexplib0.Sexp_grammar.t
      =
      fun _'a_sexp_grammar ->
      { untyped =
          List
            (Fields
               { allow_extra_fields = false
               ; fields =
                   [ No_tag
                       { name = "aliased"
                       ; required = true
                       ; args = Cons (_'a_sexp_grammar.untyped, Empty)
                       }
                   ]
               })
      }
    ;;

    let _ = aliased_sexp_grammar
  end [@@merlin.hide]

  type 'a aliased_many = 'a Aliased_many.t = { aliased_many : 'a } [@@unboxed]

  include struct
    let _ = fun (_ : 'a aliased_many) -> ()

    let compare_aliased_many
      : 'a.
      ('a -> ('a[@merlin.hide]) -> int)
      -> 'a aliased_many
      -> ('a aliased_many[@merlin.hide])
      -> int
      =
      fun _cmp__a a__107_ b__108_ ->
      if Stdlib.( == ) a__107_ b__108_
      then 0
      else _cmp__a a__107_.aliased_many b__108_.aliased_many
    ;;

    let _ = compare_aliased_many

    let equal_aliased_many
      : 'a.
      ('a -> ('a[@merlin.hide]) -> bool)
      -> 'a aliased_many
      -> ('a aliased_many[@merlin.hide])
      -> bool
      =
      fun _cmp__a a__109_ b__110_ ->
      if Stdlib.( == ) a__109_ b__110_
      then true
      else _cmp__a a__109_.aliased_many b__110_.aliased_many
    ;;

    let _ = equal_aliased_many

    let hash_fold_aliased_many
      : 'a.
      (Ppx_hash_lib.Std.Hash.state -> 'a -> Ppx_hash_lib.Std.Hash.state)
      -> Ppx_hash_lib.Std.Hash.state
      -> 'a aliased_many
      -> Ppx_hash_lib.Std.Hash.state
      =
      fun _hash_fold_a hsv arg ->
      let hsv = hsv in
      _hash_fold_a hsv arg.aliased_many
    ;;

    let _ = hash_fold_aliased_many

    let sexp_of_aliased_many
      : 'a. ('a -> Sexplib0.Sexp.t) -> 'a aliased_many -> Sexplib0.Sexp.t
      =
      fun _of_a__111_ { aliased_many = aliased_many__113_ } ->
      let bnds__112_ = ([] : _ Stdlib.List.t) in
      let bnds__112_ =
        let arg__114_ = _of_a__111_ aliased_many__113_ in
        (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "aliased_many"; arg__114_ ] :: bnds__112_
         : _ Stdlib.List.t)
      in
      Sexplib0.Sexp.List bnds__112_
    ;;

    let _ = sexp_of_aliased_many

    let aliased_many_sexp_grammar
      : 'a. 'a Sexplib0.Sexp_grammar.t -> 'a aliased_many Sexplib0.Sexp_grammar.t
      =
      fun _'a_sexp_grammar ->
      { untyped =
          List
            (Fields
               { allow_extra_fields = false
               ; fields =
                   [ No_tag
                       { name = "aliased_many"
                       ; required = true
                       ; args = Cons (_'a_sexp_grammar.untyped, Empty)
                       }
                   ]
               })
      }
    ;;

    let _ = aliased_many_sexp_grammar
  end [@@merlin.hide]

  type 'a forkable = 'a Forkable.t = { forkable : 'a } [@@unboxed]
  type 'a unyielding = 'a Unyielding.t = { unyielding : 'a } [@@unboxed]

  include struct
    let _ = fun (_ : 'a unyielding) -> ()

    let compare_unyielding
      : 'a.
      ('a -> ('a[@merlin.hide]) -> int)
      -> 'a unyielding
      -> ('a unyielding[@merlin.hide])
      -> int
      =
      fun _cmp__a a__115_ b__116_ ->
      if Stdlib.( == ) a__115_ b__116_
      then 0
      else _cmp__a a__115_.unyielding b__116_.unyielding
    ;;

    let _ = compare_unyielding

    let equal_unyielding
      : 'a.
      ('a -> ('a[@merlin.hide]) -> bool)
      -> 'a unyielding
      -> ('a unyielding[@merlin.hide])
      -> bool
      =
      fun _cmp__a a__117_ b__118_ ->
      if Stdlib.( == ) a__117_ b__118_
      then true
      else _cmp__a a__117_.unyielding b__118_.unyielding
    ;;

    let _ = equal_unyielding

    let hash_fold_unyielding
      : 'a.
      (Ppx_hash_lib.Std.Hash.state -> 'a -> Ppx_hash_lib.Std.Hash.state)
      -> Ppx_hash_lib.Std.Hash.state
      -> 'a unyielding
      -> Ppx_hash_lib.Std.Hash.state
      =
      fun _hash_fold_a hsv arg ->
      let hsv = hsv in
      _hash_fold_a hsv arg.unyielding
    ;;

    let _ = hash_fold_unyielding

    let sexp_of_unyielding
      : 'a. ('a -> Sexplib0.Sexp.t) -> 'a unyielding -> Sexplib0.Sexp.t
      =
      fun _of_a__119_ { unyielding = unyielding__121_ } ->
      let bnds__120_ = ([] : _ Stdlib.List.t) in
      let bnds__120_ =
        let arg__122_ = _of_a__119_ unyielding__121_ in
        (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "unyielding"; arg__122_ ] :: bnds__120_
         : _ Stdlib.List.t)
      in
      Sexplib0.Sexp.List bnds__120_
    ;;

    let _ = sexp_of_unyielding

    let unyielding_sexp_grammar
      : 'a. 'a Sexplib0.Sexp_grammar.t -> 'a unyielding Sexplib0.Sexp_grammar.t
      =
      fun _'a_sexp_grammar ->
      { untyped =
          List
            (Fields
               { allow_extra_fields = false
               ; fields =
                   [ No_tag
                       { name = "unyielding"
                       ; required = true
                       ; args = Cons (_'a_sexp_grammar.untyped, Empty)
                       }
                   ]
               })
      }
    ;;

    let _ = unyielding_sexp_grammar
  end [@@merlin.hide]

  let unyielding_of_sexp = Unyielding.t_of_sexp

  type 'a stateless = 'a Stateless.t = { stateless : 'a } [@@unboxed]
  type 'a reading = 'a Reading.t = { reading : 'a } [@@unboxed]
  type 'a immutable = 'a Immutable.t = { immutable : 'a } [@@unboxed]
  type 'a read = 'a Read.t = { read : 'a } [@@unboxed]
  type 'a immutable_data = 'a Immutable_data.t = { immutable_data : 'a } [@@unboxed]
end
