open! Import0
module Sys = Sys0
include Obj_intf.Definitions

external magic : 'a 'b. 'a -> 'b = "%identity"
external magic_portable : 'a. 'a -> 'a = "%identity"
external magic_uncontended : 'a. 'a -> 'a = "%identity"
external magic_many : 'a. 'a -> 'a = "%identity"
external magic_unyielding : 'a. 'a -> 'a = "%identity"
external magic_unique : 'a. 'a -> 'a = "%identity"
external magic_read_write_uncontended : 'a. 'a -> 'a = "%identity"

module Make (T : sig
    type t

    val is_immediate : t -> bool
  end) =
struct
  open T

  external repr : 'a. 'a -> t = "%identity"
  external dup : t -> t = "caml_obj_dup"
  external tag : t -> int = "caml_obj_tag" [@@noalloc]
  external size : t -> int = "%obj_size"

  let size t = size (Sys.opaque_identity t)
  let is_immediate t = is_immediate t
  let is_block t = not (is_immediate t)

  external is_stack : t -> bool = "caml_dummy_obj_is_stack" [@@noalloc]

  let stack_or_heap repr : stack_or_heap =
    let repr = magic_many repr in
    if is_immediate repr
    then Immediate
    else (
      match Sys.backend_type with
      | Sys.Native -> if is_stack repr then Stack else Heap
      | Sys.Bytecode -> Heap
      | Sys.Other _ -> Heap)
  ;;

  external reserved_header_bits : t -> int = "caml_dummy_succ_scannable_prefix_len"
  [@@noalloc]

  let uniform_or_mixed repr : uniform_or_mixed =
    let repr = magic_many repr in
    if is_immediate repr
    then Immediate
    else (
      match Sys.backend_type with
      | Sys.Native ->
        (match reserved_header_bits repr with
         | 0 -> Uniform
         | n -> Mixed { scannable_prefix_len = n - 1 })
      | Sys.Bytecode -> Uniform
      | Sys.Other _ -> Uniform)
  ;;

  external reachable_words : t -> int = "caml_obj_reachable_words"

  module Expert = struct
    external obj : 'a. t -> 'a = "%identity"
    external field : t -> int -> t = "%obj_field"

    let field t i = field (Sys.opaque_identity t) i

    external set_field : t -> int -> t -> unit = "%obj_set_field"

    let set_field t i f = set_field (Sys.opaque_identity t) i f

    external raw_field : t -> int -> raw_data = "caml_obj_raw_field"
    external set_raw_field : t -> int -> raw_data -> unit = "caml_obj_set_raw_field"
  end
end

type t = Stdlib.Obj.t

external is_int : t -> bool = "%obj_is_int"

include Make (struct
    type nonrec t = t

    let is_immediate t = is_int t
  end)

let first_non_constant_constructor_tag = Stdlib.Obj.first_non_constant_constructor_tag
let last_non_constant_constructor_tag = Stdlib.Obj.last_non_constant_constructor_tag
let forcing_tag = Stdlib.Obj.forcing_tag
let cont_tag = Stdlib.Obj.cont_tag
let lazy_tag = Stdlib.Obj.lazy_tag
let closure_tag = Stdlib.Obj.closure_tag
let object_tag = Stdlib.Obj.object_tag
let infix_tag = Stdlib.Obj.infix_tag
let forward_tag = Stdlib.Obj.forward_tag
let no_scan_tag = Stdlib.Obj.no_scan_tag
let abstract_tag = Stdlib.Obj.abstract_tag
let string_tag = Stdlib.Obj.string_tag
let double_tag = Stdlib.Obj.double_tag
let double_array_tag = Stdlib.Obj.double_array_tag
let custom_tag = Stdlib.Obj.custom_tag
let int_tag = Stdlib.Obj.int_tag
let out_of_heap_tag = Stdlib.Obj.out_of_heap_tag
let unaligned_tag = Stdlib.Obj.unaligned_tag

module Ephemeron = struct
  include Stdlib.Ephemeron
end

module Expert = struct
  include Stdlib.Obj
  include Expert

  external new_mixed_block
    :  tag:int
    -> total_words:int
    -> scannable_words:int
    -> t
    = "Base_obj_new_mixed_block"
end

module Nullable = struct
  type t

  external is_int : t -> bool = "%obj_is_int"

  include Make (struct
      type nonrec t = t

      let is_immediate t = is_int t
    end)

  external of_or_null : Stdlib.Obj.t or_null -> t = "%identity"
  external to_or_null : t -> Stdlib.Obj.t or_null = "%identity"
end

external nullable : t -> Nullable.t = "%identity"
