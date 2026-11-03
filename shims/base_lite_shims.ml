(* See comment in [mli] about what this library is for. *)

open struct
  (* Initial values for the shims' fresh copies of sexplib0's dynamic variables, read
     before [Basement] and [Sexplib0] are shadowed below. *)
  let initial_default_indent = Basement.Dynamic.get Sexplib0.Sexp.default_indent
  let initial_of_float_style = Basement.Dynamic.get Sexplib0.Sexp.of_float_style
  let initial_of_int_style = Basement.Dynamic.get Sexplib0.Sexp.of_int_style

  let initial_read_old_option_format =
    Basement.Dynamic.get Sexplib0.Sexp_conv.read_old_option_format
  ;;

  let initial_write_old_option_format =
    Basement.Dynamic.get Sexplib0.Sexp_conv.write_old_option_format
  ;;
end

module Shadow_stdlib = struct
  include Shadow_stdlib

  type 'a ref = 'a Stdlib.ref = { mutable contents : 'a }
end

module Basement = struct
  include Basement

  module Stdlib_shim = struct
    include Stdlib_shim

    module Printexc = struct
      include Printexc

      module Safe = struct
        include Safe

        (* The plain single-domain versions, which do not require portable functions. *)
        [@@@alert "-unsafe_multidomain"]

        let register_printer printer = Stdlib.Printexc.register_printer printer

        let set_uncaught_exception_handler handler =
          Stdlib.Printexc.set_uncaught_exception_handler handler
        ;;
      end
    end

    module Domain = struct
      include Domain

      module Safe = struct
        include Safe

        (* A fresh single-domain version of domain-local storage: each key is just a
           lazily initialized mutable cell. [split_from_parent] is ignored because domains
           are never spawned. *)
        module DLS = struct
          type 'a key =
            { compute : unit -> 'a
            ; mutable value : 'a option
            }

          let new_key ?split_from_parent:_ compute = { compute; value = None }

          let get key =
            match key.value with
            | Some value -> value
            | None ->
              let value = key.compute () in
              key.value <- Some value;
              value
          ;;

          let set key value = key.value <- Some value
        end
      end
    end
  end

  module Stdlib_iarray_labels = struct
    include Stdlib_iarray_labels

    (* In the erased code, locality is gone, so the locally-allocating versions are just
       the heap-allocating versions. *)
    let init_local n ~f = Basement.Stdlib_iarray_labels.init n ~f
    let append_local a b = Basement.Stdlib_iarray_labels.append a b
    let iter2_local ~f a b = Basement.Stdlib_iarray_labels.iter2 ~f a b
    let map_local ~f a = Basement.Stdlib_iarray_labels.map ~f a
    let map2_local ~f a b = Basement.Stdlib_iarray_labels.map2 ~f a b
    let sub_local a ~pos ~len = Basement.Stdlib_iarray_labels.sub a ~pos ~len
  end

  (* A fresh single-domain version: a mutable cell, with no atomicity. *)
  module Portable_atomic = struct
    type 'a t = { mutable value : 'a }

    let make ?padded:(_ : bool option) value = { value }
    let get t = t.value
    let set t value = t.value <- value

    let compare_and_set t if_phys_equal_to replace_with =
      if Stdlib.( == ) t.value if_phys_equal_to
      then (
        t.value <- replace_with;
        true)
      else false
    ;;
  end

  module Modes = struct
    include Modes

    type 'a global = { global : 'a } [@@unboxed]
    type 'a portable = { portable : 'a } [@@unboxed]
    type 'a contended = { contended : 'a } [@@unboxed]
    type 'a shared = { shared : 'a } [@@unboxed]
    type 'a portended = { portended : 'a } [@@unboxed]
    type 'a many = { many : 'a } [@@unboxed]
    type 'a aliased = { aliased : 'a } [@@unboxed]
    type 'a aliased_many = { aliased_many : 'a } [@@unboxed]
    type 'a forkable = { forkable : 'a } [@@unboxed]
    type 'a unyielding = { unyielding : 'a } [@@unboxed]
    type 'a stateless = { stateless : 'a } [@@unboxed]
    type 'a reading = { reading : 'a } [@@unboxed]
    type 'a immutable = { immutable : 'a } [@@unboxed]
    type 'a read = { read : 'a } [@@unboxed]
    type 'a immutable_data = { immutable_data : 'a } [@@unboxed]

    module Global = struct
      type 'a t = 'a global = { global : 'a } [@@unboxed]
    end

    module Portable = struct
      type 'a t = 'a portable = { portable : 'a } [@@unboxed]
    end

    module Contended = struct
      type 'a t = 'a contended = { contended : 'a } [@@unboxed]
    end

    module Portended = struct
      type 'a t = 'a portended = { portended : 'a } [@@unboxed]
    end

    module Aliased = struct
      type 'a t = 'a aliased = { aliased : 'a } [@@unboxed]
    end

    module Many = struct
      type 'a t = 'a many = { many : 'a } [@@unboxed]
    end
  end

  module Or_null_shim = struct
    module Export = struct
      type 'a or_null =
        | Null
        | This of 'a
    end

    type 'a t = 'a Export.or_null =
      | Null
      | This of 'a
  end

  module Primitives = struct
    include Primitives

    module Int32_u = struct
      type t = int32

      let box (t : t) = t
      let unbox (t : t) = t
    end

    module Int64_u = struct
      type t = int64

      let box (t : t) = t
      let unbox (t : t) = t
    end

    module Nativeint_u = struct
      type t = nativeint

      let box (t : t) = t
      let unbox (t : t) = t
    end

    let box_float (f : float) = f
    let unbox_float (f : float) = f
  end

  (* A fresh single-domain version of dynamic variables: a mutable cell. *)
  module Dynamic = struct
    type 'a t = 'a ref

    let make value = ref value
    let get t = !t
    let set_root t value = t := value

    let with_temporarily t value ~f =
      let saved = !t in
      t := value;
      Stdlib.Fun.protect ~finally:(fun () -> t := saved) f
    ;;
  end

  (* A fresh single-domain version, in terms of ordinary lazy values. Grammars embed these
     (see the [Sexp_grammar] shim below), so they must not be real portable lazies. *)
  module Portable_lazy = struct
    type 'a t = 'a Stdlib.Lazy.t

    let from_val = Stdlib.Lazy.from_val
    let from_fun = Stdlib.Lazy.from_fun

    let from_fun_fixed f =
      let rec t = lazy (f t) in
      t
    ;;

    let force = Stdlib.Lazy.force
    let map t ~f = Stdlib.Lazy.from_fun (fun () -> f (force t))
    let bind t ~f = Stdlib.Lazy.from_fun (fun () -> force (f (force t)))
    let compare compare_a t1 t2 = compare_a (force t1) (force t2)
    let equal equal_a t1 t2 = equal_a (force t1) (force t2)
    let globalize _ t = t
    let is_val = Stdlib.Lazy.is_val
    let peek t : _ Or_null_shim.Export.or_null = if is_val t then This (force t) else Null
    let peek_opt t = if is_val t then Some (force t) else None
  end
end

(* A fresh capsule implementation: in a single-domain program everything can live in one
   capsule, so keys, access, and passwords carry no information, and data is stored
   directly. *)
module Capsule_prim = struct
  module Access = struct
    type 'k t = T
    type packed = P : 'k t -> packed
  end

  let current () = Access.P Access.T

  module Key = struct
    type 'k t = T
    type packed = P : 'k t -> packed

    let destroy (type k) (T : k t) : k Access.t = Access.T
  end

  let create () = Key.P Key.T

  module Password = struct
    type 'k t = T

    module Shared = struct
      type 'k t = T
    end

    let shared (type k) (T : k t) : k Shared.t = Shared.T
    let with_current (type k) (Access.T : k Access.t) f = f (T : k t)
  end

  module Data = struct
    type ('a, 'k) t = 'a

    let wrap ~access:(_ : _ Access.t) x = x
    let unwrap ~access:(_ : _ Access.t) x = x

    module Local = struct
      let wrap ~access:(_ : _ Access.t) x = x
    end
  end
end

module Ocaml_intrinsics_kernel = struct
  include Ocaml_intrinsics_kernel

  module Float = struct
    include Float

    (* Versions without [local] argument and return modes. *)
    let min (x : float) y = Ocaml_intrinsics_kernel.Float.min x y
    let max (x : float) y = Ocaml_intrinsics_kernel.Float.max x y
    let iround_current (x : float) = Ocaml_intrinsics_kernel.Float.iround_current x
    let round_current (x : float) = Ocaml_intrinsics_kernel.Float.round_current x
    let round_down (x : float) = Ocaml_intrinsics_kernel.Float.round_down x
    let round_up (x : float) = Ocaml_intrinsics_kernel.Float.round_up x

    let round_towards_zero (x : float) =
      Ocaml_intrinsics_kernel.Float.round_towards_zero x
    ;;
  end

  module Nativeint = struct
    include Nativeint

    let count_leading_zeros (x : nativeint) =
      Ocaml_intrinsics_kernel.Nativeint.count_leading_zeros x
    ;;

    let count_trailing_zeros (x : nativeint) =
      Ocaml_intrinsics_kernel.Nativeint.count_trailing_zeros x
    ;;

    let count_set_bits (x : nativeint) =
      Ocaml_intrinsics_kernel.Nativeint.count_set_bits x
    ;;
  end
end

module Ppx_hash_lib = struct
  include Ppx_hash_lib

  module Std = struct
    include Std

    module Hash = struct
      include Hash

      module Builtin = struct
        include Builtin

        (* A boxed version of the [or_null] folder, using the shimmed boxed variant. *)
        let hash_fold_or_null
          hash_fold_elem
          state
          (t : _ Basement.Or_null_shim.Export.or_null)
          =
          match t with
          | Null ->
            Ppx_hash_lib.Std.Hash.Builtin.hash_fold_or_null hash_fold_elem state Null
          | This x ->
            Ppx_hash_lib.Std.Hash.Builtin.hash_fold_or_null hash_fold_elem state (This x)
        ;;
      end
    end
  end
end

module Sexplib0 = struct
  include Sexplib0

  (* A fresh copy of [Sexp_grammar_type.Sexp_grammar], identical to the original except
     that the [Lazy] constructor embeds the shimmed [Portable_lazy] rather than the real
     one, so the erased code can build lazy grammars from its mode-oblivious functions.
     Grammars built by the erased code are therefore a different type from real sexplib0
     grammars. See the original for documentation of the constructors. *)
  module Sexp_grammar = struct
    [@@@warning "-30"] (* allow duplicate field names, as in the original *)

    type grammar =
      | Any of string
      | Bool
      | Char
      | Integer
      | Float
      | String
      | Option of grammar
      | List of list_grammar
      | Variant of variant
      | Union of grammar list
      | Tagged of grammar with_tag
      | Tyvar of string
      | Tycon of string * grammar list * defn list
      | Recursive of string * grammar list
      | Lazy of grammar Basement.Portable_lazy.t

    and list_grammar =
      | Empty
      | Cons of grammar * list_grammar
      | Many of grammar
      | Fields of record

    and case_sensitivity =
      | Case_insensitive
      | Case_sensitive
      | Case_sensitive_except_first_character

    and variant =
      { case_sensitivity : case_sensitivity
      ; clauses : clause with_tag_list list
      }

    and clause =
      { name : string
      ; clause_kind : clause_kind
      }

    and clause_kind =
      | Atom_clause
      | List_clause of { args : list_grammar }

    and record =
      { allow_extra_fields : bool
      ; fields : field with_tag_list list
      }

    and field =
      { name : string
      ; required : bool
      ; args : list_grammar
      }

    and 'a with_tag =
      { key : string
      ; value : Sexplib0.Sexp.t
      ; grammar : 'a
      }

    and 'a with_tag_list =
      | Tag of 'a with_tag_list with_tag
      | No_tag of 'a

    and defn =
      { tycon : string
      ; tyvars : string list
      ; grammar : grammar
      }

    type _ t = { untyped : grammar } [@@unboxed]

    let coerce (type a b) ({ untyped } : a t) : b t = { untyped }

    let tag (type a) ({ untyped } : a t) ~key ~value : a t =
      { untyped = Tagged { key; value; grammar = untyped } }
    ;;

    let assoc_tag = Sexplib0.Sexp_grammar.assoc_tag
    let assoc_key_tag = Sexplib0.Sexp_grammar.assoc_key_tag
    let assoc_value_tag = Sexplib0.Sexp_grammar.assoc_value_tag
  end

  module Sexp = struct
    include Sexplib0.Sexp

    (* Modality-free copies of the pretty-printing module types: the erased code
       implements them with functions that do not check as portable. *)
    module type Pretty_print_to_formatter = sig
      val pp_hum : Stdlib.Format.formatter -> t -> unit
      val pp_hum_indent : int -> Stdlib.Format.formatter -> t -> unit
      val pp_mach : Stdlib.Format.formatter -> t -> unit
      val pp : Stdlib.Format.formatter -> t -> unit
    end

    module type Pretty_printing_helpers_private = sig
      val mach_maybe_esc_str : string -> string
      val must_escape : string -> bool
      val esc_str : string -> string
    end

    module type Pretty_printing_helpers = sig
      include Pretty_print_to_formatter
      include Pretty_printing_helpers_private
    end

    module type Pretty_printing = sig
      type output

      include Pretty_print_to_formatter

      val to_string_hum : ?indent:int -> ?max_width:int -> t -> output
      val to_string_mach : t -> output
      val to_string : t -> output

      val to_buffer_hum
        :  buf:Stdlib.Buffer.t
        -> ?indent:int
        -> ?max_width:int
        -> t
        -> unit

      val to_buffer_mach : buf:Stdlib.Buffer.t -> t -> unit
      val to_buffer : buf:Stdlib.Buffer.t -> t -> unit

      val to_buffer_gen
        :  buf:'buffer
        -> add_char:('buffer -> char -> unit)
        -> add_string:('buffer -> string -> unit)
        -> t
        -> unit

      module Pretty_printing_helpers_private : Pretty_printing_helpers_private
    end

    (* Fresh copies of sexplib0's dynamic variables, since [Dynamic] is shimmed with a
       fresh type above. Note that the real printing functions re-exported here still read
       the originals, so setting these copies does not affect them. *)
    let default_indent = Basement.Dynamic.make initial_default_indent
    let of_float_style = Basement.Dynamic.make initial_of_float_style
    let of_int_style = Basement.Dynamic.make initial_of_int_style

    (* A fresh version of the functor: the real one requires portable helpers. This
       mirrors sexplib0's implementation, minus its stack-allocating fast paths. *)
    module Make_pretty_printing (Helpers : Pretty_printing_helpers) :
      Pretty_printing with type output := string = struct
      include Helpers

      let to_buffer_hum ~buf ?indent ?max_width sexp =
        let indent =
          match indent with
          | Some indent -> indent
          | None -> Basement.Dynamic.get default_indent
        in
        let ppf = Stdlib.Format.formatter_of_buffer buf in
        (match max_width with
         | Some max_width -> Stdlib.Format.pp_set_margin ppf max_width
         | None -> ());
        Stdlib.Format.fprintf ppf "%a@?" (Helpers.pp_hum_indent indent) sexp
      ;;

      let to_buffer_gen ~buf ~add_char ~add_string sexp =
        (* [loop] returns whether a space is needed before the next unescaped atom. *)
        let rec loop may_need_space sexp =
          match (sexp : Sexplib0.Sexp.t) with
          | Atom str ->
            let escaped = Helpers.mach_maybe_esc_str str in
            let is_unescaped = Stdlib.( == ) escaped str in
            if may_need_space && is_unescaped then add_char buf ' ';
            add_string buf escaped;
            is_unescaped
          | List (first :: rest) ->
            add_char buf '(';
            loop_rest (loop false first) rest;
            false
          | List [] ->
            add_string buf "()";
            false
        and loop_rest may_need_space sexps =
          match sexps with
          | first :: rest -> loop_rest (loop may_need_space first) rest
          | [] -> add_char buf ')'
        in
        ignore (loop false sexp : bool)
      ;;

      let to_buffer_mach ~buf sexp =
        to_buffer_gen
          ~buf
          ~add_char:Stdlib.Buffer.add_char
          ~add_string:Stdlib.Buffer.add_string
          sexp
      ;;

      let to_buffer = to_buffer_mach

      let to_string_mach sexp =
        let buf = Stdlib.Buffer.create 64 in
        to_buffer_mach ~buf sexp;
        Stdlib.Buffer.contents buf
      ;;

      let to_string = to_string_mach

      let to_string_hum ?indent ?max_width sexp =
        let buf = Stdlib.Buffer.create 64 in
        to_buffer_hum ~buf ?indent ?max_width sexp;
        Stdlib.Buffer.contents buf
      ;;

      module Pretty_printing_helpers_private = Helpers
    end
  end

  module Sexp_conv = struct
    include Sexp_conv

    (* Fresh versions of sexplib0's grammar builtins, producing the shimmed [Sexp_grammar]
       type. These mirror [Sexplib0.Sexp_conv_grammar]. *)
    let sexp_grammar_with_tags grammar ~tags =
      Stdlib.List.fold_right
        (fun (key, value) grammar -> Sexp_grammar.Tagged { key; value; grammar })
        tags
        grammar
    ;;

    let sexp_grammar_with_tag_list with_tag_list ~tags =
      Stdlib.List.fold_right
        (fun (key, value) grammar -> Sexp_grammar.Tag { key; value; grammar })
        tags
        with_tag_list
    ;;

    let unit_sexp_grammar : unit Sexp_grammar.t = { untyped = List Empty }
    let bool_sexp_grammar : bool Sexp_grammar.t = { untyped = Bool }
    let string_sexp_grammar : string Sexp_grammar.t = { untyped = String }
    let bytes_sexp_grammar : bytes Sexp_grammar.t = { untyped = String }
    let char_sexp_grammar : char Sexp_grammar.t = { untyped = Char }
    let int_sexp_grammar : int Sexp_grammar.t = { untyped = Integer }
    let float_sexp_grammar : float Sexp_grammar.t = { untyped = Float }
    let int32_sexp_grammar : int32 Sexp_grammar.t = { untyped = Integer }
    let int64_sexp_grammar : int64 Sexp_grammar.t = { untyped = Integer }
    let nativeint_sexp_grammar : nativeint Sexp_grammar.t = { untyped = Integer }
    let sexp_t_sexp_grammar : Sexplib0.Sexp.t Sexp_grammar.t = { untyped = Any "Sexp.t" }
    let ref_sexp_grammar grammar = Sexp_grammar.coerce grammar
    let lazy_t_sexp_grammar grammar = Sexp_grammar.coerce grammar

    let option_sexp_grammar ({ untyped } : _ Sexp_grammar.t) : _ option Sexp_grammar.t =
      { untyped = Option untyped }
    ;;

    let list_sexp_grammar ({ untyped } : _ Sexp_grammar.t) : _ list Sexp_grammar.t =
      { untyped = List (Many untyped) }
    ;;

    let array_sexp_grammar ({ untyped } : _ Sexp_grammar.t) : _ array Sexp_grammar.t =
      { untyped = List (Many untyped) }
    ;;

    let floatarray_sexp_grammar : floatarray Sexp_grammar.t =
      { untyped = List (Many Float) }
    ;;

    let opaque_sexp_grammar : _ Sexp_grammar.t = { untyped = Union [] }
    let fun_sexp_grammar : _ Sexp_grammar.t = { untyped = Union [] }

    (* Boxed versions of the [or_null] converters, using the shimmed boxed variant. *)
    let or_null_of_sexp a_of_sexp sexp : _ Basement.Or_null_shim.Export.or_null =
      match Sexplib0.Sexp_conv.or_null_of_sexp a_of_sexp sexp with
      | Null -> Null
      | This x -> This x
    ;;

    let sexp_of_or_null sexp_of_a (t : _ Basement.Or_null_shim.Export.or_null) =
      match t with
      | Null -> Sexplib0.Sexp_conv.sexp_of_or_null sexp_of_a Null
      | This x -> Sexplib0.Sexp_conv.sexp_of_or_null sexp_of_a (This x)
    ;;

    (* Boxed versions of the converters for unboxed types, matching the erased types. *)
    let unit_u_of_sexp = Sexplib0.Sexp_conv.unit_of_sexp
    let bool_u_of_sexp = Sexplib0.Sexp_conv.bool_of_sexp
    let char_u_of_sexp = Sexplib0.Sexp_conv.char_of_sexp
    let float_u_of_sexp = Sexplib0.Sexp_conv.float_of_sexp
    let sexp_of_unit_u = Sexplib0.Sexp_conv.sexp_of_unit
    let sexp_of_bool_u = Sexplib0.Sexp_conv.sexp_of_bool
    let sexp_of_char_u = Sexplib0.Sexp_conv.sexp_of_char
    let sexp_of_float_u = Sexplib0.Sexp_conv.sexp_of_float

    (* Fresh copies of sexplib0's dynamic variables; see [Sexp] above. The real
       [option_of_sexp] and [sexp_of_option] re-exported here still read the originals. *)
    let read_old_option_format = Basement.Dynamic.make initial_read_old_option_format
    let write_old_option_format = Basement.Dynamic.make initial_write_old_option_format

    (* A fresh exception-converter registry: the real [Exn_converter.add] requires
       portable converter functions. Only the [sexp_of_exn] and [sexp_of_exn_opt] shims
       below consult this registry, so converters registered here are not visible to other
       libraries' calls into sexplib0. *)
    module Exn_converter = struct
      let converters
        : (Stdlib.Obj.Extension_constructor.t * (exn -> Sexplib0.Sexp.t)) list ref
        =
        ref []
      ;;

      let find_converter exn =
        let constructor = Stdlib.Obj.Extension_constructor.of_val exn in
        Stdlib.List.find_opt
          (fun (registered, (_ : exn -> Sexplib0.Sexp.t)) ->
            Stdlib.( == ) registered constructor)
          !converters
      ;;

      (* The real [Exn_converter.add] also makes registered exceptions print via
         [Stdlib.Printexc]; without this, exceptions whose converters live in this local
         registry would print opaquely (e.g. as [Base_lite__Info0.Exn(_)]) outside this
         library, for example under the real sexplib0's [sexp_of_exn] fallback. *)
      let () =
        Basement.Stdlib_shim.Printexc.Safe.register_printer (fun exn ->
          match find_converter exn with
          | Some ((_ : Stdlib.Obj.Extension_constructor.t), f) ->
            (match f exn with
             | sexp -> Some (Sexplib0.Sexp.to_string_hum sexp)
             | exception (_ : exn) -> None)
          | None -> None)
      ;;

      let add ?printexc:(_ : bool option) ?finalise:(_ : bool option) constructor f =
        converters := (constructor, f) :: !converters
      ;;
    end

    let sexp_of_exn_opt exn =
      match Exn_converter.find_converter exn with
      | Some ((_ : Stdlib.Obj.Extension_constructor.t), f) -> Some (f exn)
      | None -> Sexplib0.Sexp_conv.sexp_of_exn_opt exn
    ;;

    let sexp_of_exn exn =
      match sexp_of_exn_opt exn with
      | Some sexp -> sexp
      | None -> Sexplib0.Sexp_conv.sexp_of_exn exn
    ;;
  end
end
