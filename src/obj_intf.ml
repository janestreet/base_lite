open! Import

module Definitions = struct
  type raw_data = Stdlib.Obj.raw_data

  type stack_or_heap =
    | Immediate
    | Stack
    | Heap

  include struct
    let _ = fun (_ : stack_or_heap) -> ()

    let stack_or_heap_of_sexp =
      (let error_source__003_ =
         "../../../../lib/base/src/obj_intf.ml.Definitions.stack_or_heap"
       in
       function
       | Sexplib0.Sexp.Atom ("immediate" | "Immediate") -> Immediate
       | Sexplib0.Sexp.Atom ("stack" | "Stack") -> Stack
       | Sexplib0.Sexp.Atom ("heap" | "Heap") -> Heap
       | Sexplib0.Sexp.List
           (Sexplib0.Sexp.Atom
              ("immediate" | "Immediate" | "stack" | "Stack" | "heap" | "Heap")
           :: _) as sexp__004_ ->
         Sexplib0.Sexp_conv_error.stag_no_args error_source__003_ sexp__004_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__002_ ->
         Sexplib0.Sexp_conv_error.nested_list_invalid_sum error_source__003_ sexp__002_
       | Sexplib0.Sexp.List [] as sexp__002_ ->
         Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__003_ sexp__002_
       | sexp__002_ ->
         Sexplib0.Sexp_conv_error.unexpected_stag
           error_source__003_
           [ "Immediate"; "Stack"; "Heap" ]
           sexp__002_
       : Sexplib0.Sexp.t -> stack_or_heap)
    ;;

    let _ = stack_or_heap_of_sexp

    let sexp_of_stack_or_heap =
      (function
       | Immediate -> Sexplib0.Sexp.Atom "Immediate"
       | Stack -> Sexplib0.Sexp.Atom "Stack"
       | Heap -> Sexplib0.Sexp.Atom "Heap"
       : stack_or_heap -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_stack_or_heap

    let compare_stack_or_heap =
      (Stdlib.compare : stack_or_heap -> (stack_or_heap[@merlin.hide]) -> int)
    ;;

    let _ = compare_stack_or_heap
  end [@@merlin.hide]

  type uniform_or_mixed =
    | Immediate
    | Uniform
    | Mixed of { scannable_prefix_len : int }

  include struct
    let _ = fun (_ : uniform_or_mixed) -> ()

    let uniform_or_mixed_of_sexp =
      (let error_source__009_ =
         "../../../../lib/base/src/obj_intf.ml.Definitions.uniform_or_mixed"
       in
       function
       | Sexplib0.Sexp.Atom ("immediate" | "Immediate") -> Immediate
       | Sexplib0.Sexp.Atom ("uniform" | "Uniform") -> Uniform
       | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom ("mixed" | "Mixed") :: sexps__014_) as
         sexp__013_ ->
         Sexplib0.Sexp_conv_record.record_of_sexps
           ~context:sexp__013_
           ~caller:error_source__009_
           ~fields:
             (Field
                { name = "scannable_prefix_len"
                ; kind = Required
                ; conv =
                    (fun x__011_ ->
                      let _x__012_ = int_of_sexp x__011_ in
                      fun () -> _x__012_)
                ; rest = Empty
                })
           ~index_of_field:(function
             | "scannable_prefix_len" -> 0
             | _ -> -1)
           ~allow_extra_fields:false
           ~create:(fun (scannable_prefix_len, ()) : uniform_or_mixed ->
             let scannable_prefix_len = scannable_prefix_len () in
             Mixed { scannable_prefix_len })
           sexps__014_
       | Sexplib0.Sexp.List
           (Sexplib0.Sexp.Atom ("immediate" | "Immediate" | "uniform" | "Uniform") :: _)
         as sexp__010_ ->
         Sexplib0.Sexp_conv_error.stag_no_args error_source__009_ sexp__010_
       | Sexplib0.Sexp.Atom ("mixed" | "Mixed") as sexp__010_ ->
         Sexplib0.Sexp_conv_error.stag_takes_args error_source__009_ sexp__010_
       | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__008_ ->
         Sexplib0.Sexp_conv_error.nested_list_invalid_sum error_source__009_ sexp__008_
       | Sexplib0.Sexp.List [] as sexp__008_ ->
         Sexplib0.Sexp_conv_error.empty_list_invalid_sum error_source__009_ sexp__008_
       | sexp__008_ ->
         Sexplib0.Sexp_conv_error.unexpected_stag
           error_source__009_
           [ "Immediate"; "Uniform"; "Mixed" ]
           sexp__008_
       : Sexplib0.Sexp.t -> uniform_or_mixed)
    ;;

    let _ = uniform_or_mixed_of_sexp

    let sexp_of_uniform_or_mixed =
      (function
       | Immediate -> Sexplib0.Sexp.Atom "Immediate"
       | Uniform -> Sexplib0.Sexp.Atom "Uniform"
       | Mixed { scannable_prefix_len = scannable_prefix_len__016_ } ->
         let bnds__015_ = ([] : _ Stdlib.List.t) in
         let bnds__015_ =
           let arg__017_ = sexp_of_int scannable_prefix_len__016_ in
           (Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "scannable_prefix_len"; arg__017_ ]
            :: bnds__015_
            : _ Stdlib.List.t)
         in
         Sexplib0.Sexp.List (Sexplib0.Sexp.Atom "Mixed" :: bnds__015_)
       : uniform_or_mixed -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_uniform_or_mixed

    let compare_uniform_or_mixed =
      (fun a__018_ b__019_ ->
         if Stdlib.( == ) a__018_ b__019_
         then 0
         else (
           match a__018_, b__019_ with
           | Immediate, Immediate -> 0
           | Immediate, _ -> -1
           | _, Immediate -> 1
           | Uniform, Uniform -> 0
           | Uniform, _ -> -1
           | _, Uniform -> 1
           | Mixed _a__020_, Mixed _b__021_ ->
             compare_int _a__020_.scannable_prefix_len _b__021_.scannable_prefix_len)
       : uniform_or_mixed -> (uniform_or_mixed[@merlin.hide]) -> int)
    ;;

    let _ = compare_uniform_or_mixed

    let globalize_uniform_or_mixed : uniform_or_mixed -> uniform_or_mixed =
      fun x__022_ ->
      match x__022_ with
      | (Immediate | Uniform) as x__023_ -> x__023_
      | Mixed { scannable_prefix_len = scannable_prefix_len__024_ } ->
        Mixed { scannable_prefix_len = globalize_int scannable_prefix_len__024_ }
    ;;

    let _ = globalize_uniform_or_mixed
  end [@@merlin.hide]
end

module type S = sig
  open Definitions

  type t

  external repr : 'a. 'a -> t = "%obj_magic"
  external dup : t -> t = "%obj_dup"
  external tag : t -> int = "caml_obj_tag" [@@noalloc]
  val size : t -> int
  external is_int : t -> bool = "%obj_is_int"
  val is_block : t -> bool
  external is_stack : t -> bool = "caml_obj_is_stack" [@@noalloc]
  val stack_or_heap : t -> stack_or_heap
  val uniform_or_mixed : t -> uniform_or_mixed
  external reachable_words : t -> int = "caml_obj_reachable_words"

  module Expert : sig
    external obj : 'a. t -> 'a = "%obj_magic"
    val field : t -> int -> t
    val set_field : t -> int -> t -> unit
    external raw_field : t -> int -> raw_data = "caml_obj_raw_field"
    external set_raw_field : t -> int -> raw_data -> unit = "caml_obj_set_raw_field"
  end
end

module type Obj = sig
  include module type of struct
    include Definitions
  end

  type t = Stdlib.Obj.t

  include S with type t := t

  val first_non_constant_constructor_tag : int
  val last_non_constant_constructor_tag : int
  val forcing_tag : int
  val cont_tag : int
  val lazy_tag : int
  val closure_tag : int
  val object_tag : int
  val infix_tag : int
  val forward_tag : int
  val no_scan_tag : int
  val abstract_tag : int
  val string_tag : int
  val double_tag : int
  val double_array_tag : int
  val custom_tag : int
  val int_tag : int
  val out_of_heap_tag : int
  val unaligned_tag : int
  external magic : 'a 'b. 'a -> 'b = "%obj_magic"
  external magic_portable : 'a. 'a -> 'a = "%identity"
  external magic_uncontended : 'a. 'a -> 'a = "%identity"
  external magic_many : 'a. 'a -> 'a = "%identity"
  external magic_unyielding : 'a. 'a -> 'a = "%identity"
  external magic_unique : 'a. 'a -> 'a = "%identity"
  external magic_read_write_uncontended : 'a. 'a -> 'a = "%identity"

  module Ephemeron : sig
    include module type of struct
      include Stdlib.Ephemeron
    end
  end

  module Expert : sig
    include module type of struct
      include Stdlib.Obj
    end

    include module type of Expert

    external new_mixed_block
      :  tag:int
      -> total_words:int
      -> scannable_words:int
      -> t
      = "Base_obj_new_mixed_block"
  end

  module Nullable : sig
    type t

    include S with type t := t

    val is_immediate : t -> bool
    external of_or_null : Stdlib.Obj.t or_null -> t = "%identity"
    external to_or_null : t -> Stdlib.Obj.t or_null = "%identity"
  end

  external nullable : t -> Nullable.t = "%obj_magic"
end
