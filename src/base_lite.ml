include (
  Shadow_stdlib :
    module type of struct
      include Shadow_stdlib
    end
    with module Array := Shadow_stdlib.Array
    with module Bool := Shadow_stdlib.Bool
    with module Buffer := Shadow_stdlib.Buffer
    with module Bytes := Shadow_stdlib.Bytes
    with module Char := Shadow_stdlib.Char
    with module Condition := Shadow_stdlib.Condition
    with module Either := Shadow_stdlib.Either
    with module Float := Shadow_stdlib.Float
    with module Hashtbl := Shadow_stdlib.Hashtbl
    with module In_channel := Shadow_stdlib.In_channel
    with module Int := Shadow_stdlib.Int
    with module Int32 := Shadow_stdlib.Int32
    with module Int64 := Shadow_stdlib.Int64
    with module Lazy := Shadow_stdlib.Lazy
    with module List := Shadow_stdlib.List
    with module Map := Shadow_stdlib.Map
    with module Nativeint := Shadow_stdlib.Nativeint
    with module Obj := Shadow_stdlib.Obj
    with module Option := Shadow_stdlib.Option
    with module Out_channel := Shadow_stdlib.Out_channel
    with module Printf := Shadow_stdlib.Printf
    with module Queue := Shadow_stdlib.Queue
    with module Random := Shadow_stdlib.Random
    with module Result := Shadow_stdlib.Result
    with module Set := Shadow_stdlib.Set
    with module Semaphore := Shadow_stdlib.Semaphore
    with module Stack := Shadow_stdlib.Stack
    with module String := Shadow_stdlib.String
    with module Sys := Shadow_stdlib.Sys
    with module Uchar := Shadow_stdlib.Uchar
    with module Unit := Shadow_stdlib.Unit
    with module Domain := Shadow_stdlib.Domain
    with module Type := Shadow_stdlib.Type
    with module Lexing := Shadow_stdlib.Lexing
    with type ('a, 'b, 'c) format := ('a, 'b, 'c) format
    with type ('a, 'b, 'c, 'd) format4 := ('a, 'b, 'c, 'd) format4
    with type ('a, 'b, 'c, 'd, 'e, 'f) format6 := ('a, 'b, 'c, 'd, 'e, 'f) format6
    with type 'a ref := 'a ref)
[@ocaml.warning "-3"]

open! Import
module Applicative = Applicative
module Array = Array
module Avltree = Avltree
module Backtrace = Backtrace
module Binary_search = Binary_search
module Binary_searchable = Binary_searchable
module Blit = Blit
module Bool = Bool
module Buffer = Buffer
module Bytes = Bytes
module Char = Char
module Comparable = Comparable
module Comparator = Comparator
module Comparisons = Comparisons
module Container = Container
module Dynamic = Dynamic
module Either = Either
module Equal = Equal
module Error = Error
module Exn = Exn
module Field = Field
module Float = Float
module Floatable = Floatable
module Fn = Fn
module Formatter = Formatter
module Hash = Hash
module Hash_set = Hash_set
module Hashable = Hashable
module Hasher = Hasher
module Hashtbl = Hashtbl
module Hlist = Hlist
module Iarray = Iarray
module Identifiable = Identifiable
module Indexed_container = Indexed_container
module Info = Info
module Int = Int
module Int32 = Int32
module Int63 = Int63
module Int64 = Int64
module Intable = Intable
module Int_math = Int_math
module Invariant = Invariant
module Dictionary_immutable = Dictionary_immutable
module Dictionary_mutable = Dictionary_mutable
module Lazy = Lazy
module List = List
module Map = Map
module Maybe_bound = Maybe_bound
module Modes = Modes
module Monad = Monad
module Nativeint = Nativeint
module Nothing = Nothing
module Obj = Obj
module Option = Option
module Option_array = Option_array
module Or_error = Or_error
module Or_null = Or_null
module Or_nullable = Or_nullable
module Ordered_collection_common = Ordered_collection_common
module Ordering = Ordering
module Poly = Poly
module Portability_hacks = Basement.Portability_hacks
module Portable_lazy = Portable_lazy
module Pretty_printer = Pretty_printer
module Printf = Printf
module Linked_queue = Linked_queue
module Nonempty_list = Nonempty_list
module Queue = Queue
module Random = Random
module Ref = Ref
module Result = Result
module Sequence = Sequence
module Set = Set
module Sexp = Sexp
module Sexpable = Sexpable
module Sign = Sign
module Sign_or_nan = Sign_or_nan
module Source_code_position = Source_code_position
module Stack = Stack
module Staged = Staged
module String = String
module Stringable = Stringable
module Sys = Sys
module T = T
module Type_equal = Type_equal
module Uniform_array = Uniform_array
module Unit = Unit
module Uchar = Uchar
module Variant = Variant
module With_return = With_return
module Word_size = Word_size
include T

module Int_conversions = struct
  include Int_conversions
  include Int_string_conversions
end

module Exported_for_specific_uses = struct
  module Globalize = Globalize
  module Integer_to_string = Integer_to_string
  module Obj_array = Obj_array

  let am_testing = am_testing
end

module Export = struct
  type 'a array = 'a Array.t

  include (
  struct
    type 'a array = 'a Array.t

    include struct
      let _ = fun (_ : 'a array) -> ()

      let compare_array
        : 'a.
        ('a -> ('a[@merlin.hide]) -> int) -> 'a array -> ('a array[@merlin.hide]) -> int
        =
        fun _cmp__a a__001_ b__002_ ->
        Array.compare
          (fun a__003_ (b__004_ [@merlin.hide]) -> _cmp__a a__003_ b__004_ [@merlin.hide])
          a__001_
          b__002_
      ;;

      let _ = compare_array

      let equal_array
        : 'a.
        ('a -> ('a[@merlin.hide]) -> bool) -> 'a array -> ('a array[@merlin.hide]) -> bool
        =
        fun _cmp__a a__005_ b__006_ ->
        Array.equal
          (fun a__007_ (b__008_ [@merlin.hide]) -> _cmp__a a__007_ b__008_ [@merlin.hide])
          a__005_
          b__006_
      ;;

      let _ = equal_array

      let globalize_array : 'a. ('a -> 'a) -> 'a array -> 'a array =
        fun (type a__009_) : ((a__009_ -> a__009_) -> a__009_ array -> a__009_ array) ->
        Array.globalize
      ;;

      let _ = globalize_array

      let array_of_sexp : 'a. (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a array =
        Array.t_of_sexp
      ;;

      let _ = array_of_sexp

      let sexp_of_array : 'a. ('a -> Sexplib0.Sexp.t) -> 'a array -> Sexplib0.Sexp.t =
        Array.sexp_of_t
      ;;

      let _ = sexp_of_array

      let array_sexp_grammar
        : 'a. 'a Sexplib0.Sexp_grammar.t -> 'a array Sexplib0.Sexp_grammar.t
        =
        fun _'a_sexp_grammar -> Array.t_sexp_grammar _'a_sexp_grammar
      ;;

      let _ = array_sexp_grammar
    end [@@merlin.hide]
  end :
    sig
      type 'a array = 'a Array.t

      include sig
        [@@@ocaml.warning "-32"]

        val compare_array
          : 'a.
          ('a -> ('a[@merlin.hide]) -> int) -> 'a array -> ('a array[@merlin.hide]) -> int

        val equal_array
          : 'a.
          ('a -> ('a[@merlin.hide]) -> bool)
          -> 'a array
          -> ('a array[@merlin.hide])
          -> bool

        val globalize_array : 'a. ('a -> 'a) -> 'a array -> 'a array
        val sexp_of_array : 'a. ('a -> Sexplib0.Sexp.t) -> 'a array -> Sexplib0.Sexp.t
        val array_of_sexp : 'a. (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a array

        val array_sexp_grammar
          : 'a.
          'a Sexplib0.Sexp_grammar.t -> 'a array Sexplib0.Sexp_grammar.t
      end
      [@@merlin.hide]
    end
    with type 'a array := 'a Array.t)

  type nonrec floatarray = floatarray

  include struct
    let _ = fun (_ : floatarray) -> ()
    let globalize_floatarray : floatarray -> floatarray = globalize_floatarray
    let _ = globalize_floatarray
    let floatarray_of_sexp = (floatarray_of_sexp : Sexplib0.Sexp.t -> floatarray)
    let _ = floatarray_of_sexp
    let sexp_of_floatarray = (sexp_of_floatarray : floatarray -> Sexplib0.Sexp.t)
    let _ = sexp_of_floatarray

    let floatarray_sexp_grammar : floatarray Sexplib0.Sexp_grammar.t =
      floatarray_sexp_grammar
    ;;

    let _ = floatarray_sexp_grammar
  end [@@merlin.hide]

  type bool = Bool.t

  include struct
    let _ = fun (_ : bool) -> ()
    let compare_bool = (Bool.compare : bool -> (bool[@merlin.hide]) -> int)
    let _ = compare_bool
    let equal_bool = (Bool.equal : bool -> (bool[@merlin.hide]) -> bool)
    let _ = equal_bool
    let globalize_bool : bool -> bool = Bool.globalize
    let _ = globalize_bool

    let hash_fold_bool
      : Ppx_hash_lib.Std.Hash.state -> bool -> Ppx_hash_lib.Std.Hash.state
      =
      Bool.hash_fold_t

    and hash_bool : bool -> Ppx_hash_lib.Std.Hash.hash_value = fun x -> Bool.hash x

    let _ = hash_fold_bool
    and _ = hash_bool

    let bool_of_sexp = (Bool.t_of_sexp : Sexplib0.Sexp.t -> bool)
    and bool_u_of_sexp = (Bool.t_u_of_sexp : Sexplib0.Sexp.t -> bool)

    let _ = bool_of_sexp
    and _ = bool_u_of_sexp

    let sexp_of_bool = (Bool.sexp_of_t : bool -> Sexplib0.Sexp.t)
    and sexp_of_bool_u = (Bool.sexp_of_t_u : bool -> Sexplib0.Sexp.t)

    let _ = sexp_of_bool
    and _ = sexp_of_bool_u

    let bool_sexp_grammar : bool Sexplib0.Sexp_grammar.t = Bool.t_sexp_grammar
    let _ = bool_sexp_grammar
  end [@@merlin.hide]

  type char = Char.t

  include struct
    let _ = fun (_ : char) -> ()
    let compare_char = (Char.compare : char -> (char[@merlin.hide]) -> int)
    let _ = compare_char
    let equal_char = (Char.equal : char -> (char[@merlin.hide]) -> bool)
    let _ = equal_char
    let globalize_char : char -> char = Char.globalize
    let _ = globalize_char

    let hash_fold_char
      : Ppx_hash_lib.Std.Hash.state -> char -> Ppx_hash_lib.Std.Hash.state
      =
      Char.hash_fold_t

    and hash_char : char -> Ppx_hash_lib.Std.Hash.hash_value = fun x -> Char.hash x

    let _ = hash_fold_char
    and _ = hash_char

    let char_of_sexp = (Char.t_of_sexp : Sexplib0.Sexp.t -> char)
    and char_u_of_sexp = (Char.t_u_of_sexp : Sexplib0.Sexp.t -> char)

    let _ = char_of_sexp
    and _ = char_u_of_sexp

    let sexp_of_char = (Char.sexp_of_t : char -> Sexplib0.Sexp.t)
    and sexp_of_char_u = (Char.sexp_of_t_u : char -> Sexplib0.Sexp.t)

    let _ = sexp_of_char
    and _ = sexp_of_char_u

    let char_sexp_grammar : char Sexplib0.Sexp_grammar.t = Char.t_sexp_grammar
    let _ = char_sexp_grammar
  end [@@merlin.hide]

  type exn = Exn.t

  include struct
    let _ = fun (_ : exn) -> ()
    let sexp_of_exn = (Exn.sexp_of_t : exn -> Sexplib0.Sexp.t)
    let _ = sexp_of_exn
  end [@@merlin.hide]

  type float = Float.t

  include struct
    let _ = fun (_ : float) -> ()
    let compare_float = (Float.compare : float -> (float[@merlin.hide]) -> int)
    let _ = compare_float
    let equal_float = (Float.equal : float -> (float[@merlin.hide]) -> bool)
    let _ = equal_float
    let globalize_float : float -> float = Float.globalize
    let _ = globalize_float

    let hash_fold_float
      : Ppx_hash_lib.Std.Hash.state -> float -> Ppx_hash_lib.Std.Hash.state
      =
      Float.hash_fold_t

    and hash_float : float -> Ppx_hash_lib.Std.Hash.hash_value = fun x -> Float.hash x

    let _ = hash_fold_float
    and _ = hash_float

    let float_of_sexp = (Float.t_of_sexp : Sexplib0.Sexp.t -> float)
    and float_u_of_sexp = (Float.t_u_of_sexp : Sexplib0.Sexp.t -> float)

    let _ = float_of_sexp
    and _ = float_u_of_sexp

    let sexp_of_float = (Float.sexp_of_t : float -> Sexplib0.Sexp.t)
    and sexp_of_float_u = (Float.sexp_of_t_u : float -> Sexplib0.Sexp.t)

    let _ = sexp_of_float
    and _ = sexp_of_float_u

    let float_sexp_grammar : float Sexplib0.Sexp_grammar.t = Float.t_sexp_grammar
    let _ = float_sexp_grammar
  end [@@merlin.hide]

  type 'a iarray = 'a Iarray.t

  include (
  struct
    type 'a iarray = 'a Iarray.t

    include struct
      let _ = fun (_ : 'a iarray) -> ()

      let compare_iarray
        : 'a.
        ('a -> ('a[@merlin.hide]) -> int) -> 'a iarray -> ('a iarray[@merlin.hide]) -> int
        =
        fun _cmp__a a__041_ b__042_ ->
        Iarray.compare
          (fun a__043_ (b__044_ [@merlin.hide]) -> _cmp__a a__043_ b__044_ [@merlin.hide])
          a__041_
          b__042_
      ;;

      let _ = compare_iarray

      let equal_iarray
        : 'a.
        ('a -> ('a[@merlin.hide]) -> bool)
        -> 'a iarray
        -> ('a iarray[@merlin.hide])
        -> bool
        =
        fun _cmp__a a__045_ b__046_ ->
        Iarray.equal
          (fun a__047_ (b__048_ [@merlin.hide]) -> _cmp__a a__047_ b__048_ [@merlin.hide])
          a__045_
          b__046_
      ;;

      let _ = equal_iarray

      let globalize_iarray : 'a. ('a -> 'a) -> 'a iarray -> 'a iarray =
        fun (type a__049_) : ((a__049_ -> a__049_) -> a__049_ iarray -> a__049_ iarray) ->
        Iarray.globalize
      ;;

      let _ = globalize_iarray

      let iarray_of_sexp : 'a. (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a iarray =
        Iarray.t_of_sexp
      ;;

      let _ = iarray_of_sexp

      let sexp_of_iarray : 'a. ('a -> Sexplib0.Sexp.t) -> 'a iarray -> Sexplib0.Sexp.t =
        Iarray.sexp_of_t
      ;;

      let _ = sexp_of_iarray

      let iarray_sexp_grammar
        : 'a. 'a Sexplib0.Sexp_grammar.t -> 'a iarray Sexplib0.Sexp_grammar.t
        =
        fun _'a_sexp_grammar -> Iarray.t_sexp_grammar _'a_sexp_grammar
      ;;

      let _ = iarray_sexp_grammar
    end [@@merlin.hide]
  end :
    sig
      type 'a iarray = 'a Iarray.t

      include sig
        [@@@ocaml.warning "-32"]

        val compare_iarray
          : 'a.
          ('a -> ('a[@merlin.hide]) -> int)
          -> 'a iarray
          -> ('a iarray[@merlin.hide])
          -> int

        val equal_iarray
          : 'a.
          ('a -> ('a[@merlin.hide]) -> bool)
          -> 'a iarray
          -> ('a iarray[@merlin.hide])
          -> bool

        val globalize_iarray : 'a. ('a -> 'a) -> 'a iarray -> 'a iarray
        val sexp_of_iarray : 'a. ('a -> Sexplib0.Sexp.t) -> 'a iarray -> Sexplib0.Sexp.t
        val iarray_of_sexp : 'a. (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a iarray

        val iarray_sexp_grammar
          : 'a.
          'a Sexplib0.Sexp_grammar.t -> 'a iarray Sexplib0.Sexp_grammar.t
      end
      [@@merlin.hide]
    end
    with type 'a iarray := 'a Iarray.t)

  include (
  struct
    type 'a iarray = 'a Iarray.t

    include struct
      let _ = fun (_ : 'a iarray) -> ()

      let hash_fold_iarray
        : 'a.
        (Ppx_hash_lib.Std.Hash.state -> 'a -> Ppx_hash_lib.Std.Hash.state)
        -> Ppx_hash_lib.Std.Hash.state
        -> 'a iarray
        -> Ppx_hash_lib.Std.Hash.state
        =
        Iarray.hash_fold_t
      ;;

      let _ = hash_fold_iarray
    end [@@merlin.hide]
  end :
    sig
      type 'a iarray = 'a Iarray.t

      include sig
        [@@@ocaml.warning "-32"]

        val hash_fold_iarray
          : 'a.
          (Ppx_hash_lib.Std.Hash.state -> 'a -> Ppx_hash_lib.Std.Hash.state)
          -> Ppx_hash_lib.Std.Hash.state
          -> 'a iarray
          -> Ppx_hash_lib.Std.Hash.state
      end
      [@@merlin.hide]
    end
    with type 'a iarray := 'a Iarray.t)

  type int = Int.t

  include struct
    let _ = fun (_ : int) -> ()
    let compare_int = (Int.compare : int -> (int[@merlin.hide]) -> int)
    let _ = compare_int
    let equal_int = (Int.equal : int -> (int[@merlin.hide]) -> bool)
    let _ = equal_int
    let globalize_int : int -> int = Int.globalize
    let _ = globalize_int

    let hash_fold_int : Ppx_hash_lib.Std.Hash.state -> int -> Ppx_hash_lib.Std.Hash.state =
      Int.hash_fold_t

    and hash_int : int -> Ppx_hash_lib.Std.Hash.hash_value = fun x -> Int.hash x

    let _ = hash_fold_int
    and _ = hash_int

    let int_of_sexp = (Int.t_of_sexp : Sexplib0.Sexp.t -> int)
    let _ = int_of_sexp
    let sexp_of_int = (Int.sexp_of_t : int -> Sexplib0.Sexp.t)
    let _ = sexp_of_int
    let int_sexp_grammar : int Sexplib0.Sexp_grammar.t = Int.t_sexp_grammar
    let _ = int_sexp_grammar
  end [@@merlin.hide]

  type int32 = Int32.t

  include struct
    let _ = fun (_ : int32) -> ()
    let compare_int32 = (Int32.compare : int32 -> (int32[@merlin.hide]) -> int)
    let _ = compare_int32
    let equal_int32 = (Int32.equal : int32 -> (int32[@merlin.hide]) -> bool)
    let _ = equal_int32
    let globalize_int32 : int32 -> int32 = Int32.globalize
    let _ = globalize_int32

    let hash_fold_int32
      : Ppx_hash_lib.Std.Hash.state -> int32 -> Ppx_hash_lib.Std.Hash.state
      =
      Int32.hash_fold_t

    and hash_int32 : int32 -> Ppx_hash_lib.Std.Hash.hash_value = fun x -> Int32.hash x

    let _ = hash_fold_int32
    and _ = hash_int32

    let int32_of_sexp = (Int32.t_of_sexp : Sexplib0.Sexp.t -> int32)
    let _ = int32_of_sexp
    let sexp_of_int32 = (Int32.sexp_of_t : int32 -> Sexplib0.Sexp.t)
    let _ = sexp_of_int32
    let int32_sexp_grammar : int32 Sexplib0.Sexp_grammar.t = Int32.t_sexp_grammar
    let _ = int32_sexp_grammar
  end [@@merlin.hide]

  type int64 = Int64.t

  include struct
    let _ = fun (_ : int64) -> ()
    let compare_int64 = (Int64.compare : int64 -> (int64[@merlin.hide]) -> int)
    let _ = compare_int64
    let equal_int64 = (Int64.equal : int64 -> (int64[@merlin.hide]) -> bool)
    let _ = equal_int64
    let globalize_int64 : int64 -> int64 = Int64.globalize
    let _ = globalize_int64

    let hash_fold_int64
      : Ppx_hash_lib.Std.Hash.state -> int64 -> Ppx_hash_lib.Std.Hash.state
      =
      Int64.hash_fold_t

    and hash_int64 : int64 -> Ppx_hash_lib.Std.Hash.hash_value = fun x -> Int64.hash x

    let _ = hash_fold_int64
    and _ = hash_int64

    let int64_of_sexp = (Int64.t_of_sexp : Sexplib0.Sexp.t -> int64)
    let _ = int64_of_sexp
    let sexp_of_int64 = (Int64.sexp_of_t : int64 -> Sexplib0.Sexp.t)
    let _ = sexp_of_int64
    let int64_sexp_grammar : int64 Sexplib0.Sexp_grammar.t = Int64.t_sexp_grammar
    let _ = int64_sexp_grammar
  end [@@merlin.hide]

  type 'a list = 'a List.t

  include struct
    let _ = fun (_ : 'a list) -> ()

    let compare_list
      : 'a. ('a -> ('a[@merlin.hide]) -> int) -> 'a list -> ('a list[@merlin.hide]) -> int
      =
      fun _cmp__a a__076_ b__077_ ->
      List.compare
        (fun a__078_ (b__079_ [@merlin.hide]) -> _cmp__a a__078_ b__079_ [@merlin.hide])
        a__076_
        b__077_
    ;;

    let _ = compare_list

    let equal_list
      : 'a.
      ('a -> ('a[@merlin.hide]) -> bool) -> 'a list -> ('a list[@merlin.hide]) -> bool
      =
      fun _cmp__a a__080_ b__081_ ->
      List.equal
        (fun a__082_ (b__083_ [@merlin.hide]) -> _cmp__a a__082_ b__083_ [@merlin.hide])
        a__080_
        b__081_
    ;;

    let _ = equal_list

    let globalize_list : 'a. ('a -> 'a) -> 'a list -> 'a list =
      fun (type a__084_) : ((a__084_ -> a__084_) -> a__084_ list -> a__084_ list) ->
      List.globalize
    ;;

    let _ = globalize_list

    let hash_fold_list
      : 'a.
      (Ppx_hash_lib.Std.Hash.state -> 'a -> Ppx_hash_lib.Std.Hash.state)
      -> Ppx_hash_lib.Std.Hash.state
      -> 'a list
      -> Ppx_hash_lib.Std.Hash.state
      =
      List.hash_fold_t
    ;;

    let _ = hash_fold_list

    let list_of_sexp : 'a. (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a list =
      List.t_of_sexp
    ;;

    let _ = list_of_sexp

    let sexp_of_list : 'a. ('a -> Sexplib0.Sexp.t) -> 'a list -> Sexplib0.Sexp.t =
      List.sexp_of_t
    ;;

    let _ = sexp_of_list

    let list_sexp_grammar
      : 'a. 'a Sexplib0.Sexp_grammar.t -> 'a list Sexplib0.Sexp_grammar.t
      =
      fun _'a_sexp_grammar -> List.t_sexp_grammar _'a_sexp_grammar
    ;;

    let _ = list_sexp_grammar
  end [@@merlin.hide]

  type nativeint = Nativeint.t

  include struct
    let _ = fun (_ : nativeint) -> ()

    let compare_nativeint =
      (Nativeint.compare : nativeint -> (nativeint[@merlin.hide]) -> int)
    ;;

    let _ = compare_nativeint

    let equal_nativeint =
      (Nativeint.equal : nativeint -> (nativeint[@merlin.hide]) -> bool)
    ;;

    let _ = equal_nativeint
    let globalize_nativeint : nativeint -> nativeint = Nativeint.globalize
    let _ = globalize_nativeint

    let hash_fold_nativeint
      : Ppx_hash_lib.Std.Hash.state -> nativeint -> Ppx_hash_lib.Std.Hash.state
      =
      Nativeint.hash_fold_t

    and hash_nativeint : nativeint -> Ppx_hash_lib.Std.Hash.hash_value =
      fun x -> Nativeint.hash x
    ;;

    let _ = hash_fold_nativeint
    and _ = hash_nativeint

    let nativeint_of_sexp = (Nativeint.t_of_sexp : Sexplib0.Sexp.t -> nativeint)
    let _ = nativeint_of_sexp
    let sexp_of_nativeint = (Nativeint.sexp_of_t : nativeint -> Sexplib0.Sexp.t)
    let _ = sexp_of_nativeint

    let nativeint_sexp_grammar : nativeint Sexplib0.Sexp_grammar.t =
      Nativeint.t_sexp_grammar
    ;;

    let _ = nativeint_sexp_grammar
  end [@@merlin.hide]

  type 'a option = 'a Option.t

  include struct
    let _ = fun (_ : 'a option) -> ()

    let compare_option
      : 'a.
      ('a -> ('a[@merlin.hide]) -> int) -> 'a option -> ('a option[@merlin.hide]) -> int
      =
      fun _cmp__a a__099_ b__100_ ->
      Option.compare
        (fun a__101_ (b__102_ [@merlin.hide]) -> _cmp__a a__101_ b__102_ [@merlin.hide])
        a__099_
        b__100_
    ;;

    let _ = compare_option

    let equal_option
      : 'a.
      ('a -> ('a[@merlin.hide]) -> bool) -> 'a option -> ('a option[@merlin.hide]) -> bool
      =
      fun _cmp__a a__103_ b__104_ ->
      Option.equal
        (fun a__105_ (b__106_ [@merlin.hide]) -> _cmp__a a__105_ b__106_ [@merlin.hide])
        a__103_
        b__104_
    ;;

    let _ = equal_option

    let globalize_option : 'a. ('a -> 'a) -> 'a option -> 'a option =
      fun (type a__107_) : ((a__107_ -> a__107_) -> a__107_ option -> a__107_ option) ->
      Option.globalize
    ;;

    let _ = globalize_option

    let hash_fold_option
      : 'a.
      (Ppx_hash_lib.Std.Hash.state -> 'a -> Ppx_hash_lib.Std.Hash.state)
      -> Ppx_hash_lib.Std.Hash.state
      -> 'a option
      -> Ppx_hash_lib.Std.Hash.state
      =
      Option.hash_fold_t
    ;;

    let _ = hash_fold_option

    let option_of_sexp : 'a. (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a option =
      Option.t_of_sexp
    ;;

    let _ = option_of_sexp

    let sexp_of_option : 'a. ('a -> Sexplib0.Sexp.t) -> 'a option -> Sexplib0.Sexp.t =
      Option.sexp_of_t
    ;;

    let _ = sexp_of_option

    let option_sexp_grammar
      : 'a. 'a Sexplib0.Sexp_grammar.t -> 'a option Sexplib0.Sexp_grammar.t
      =
      fun _'a_sexp_grammar -> Option.t_sexp_grammar _'a_sexp_grammar
    ;;

    let _ = option_sexp_grammar
  end [@@merlin.hide]

  type ('a, 'b) result = ('a, 'b) Result.t

  include struct
    let _ = fun (_ : ('a, 'b) result) -> ()

    let compare_result
      : 'a 'b.
      ('a -> ('a[@merlin.hide]) -> int)
      -> ('b -> ('b[@merlin.hide]) -> int)
      -> ('a, 'b) result
      -> (('a, 'b) result[@merlin.hide])
      -> int
      =
      fun _cmp__a _cmp__b a__116_ b__117_ ->
      Result.compare
        (fun a__118_ (b__119_ [@merlin.hide]) -> _cmp__a a__118_ b__119_ [@merlin.hide])
        (fun a__120_ (b__121_ [@merlin.hide]) -> _cmp__b a__120_ b__121_ [@merlin.hide])
        a__116_
        b__117_
    ;;

    let _ = compare_result

    let equal_result
      : 'a 'b.
      ('a -> ('a[@merlin.hide]) -> bool)
      -> ('b -> ('b[@merlin.hide]) -> bool)
      -> ('a, 'b) result
      -> (('a, 'b) result[@merlin.hide])
      -> bool
      =
      fun _cmp__a _cmp__b a__122_ b__123_ ->
      Result.equal
        (fun a__124_ (b__125_ [@merlin.hide]) -> _cmp__a a__124_ b__125_ [@merlin.hide])
        (fun a__126_ (b__127_ [@merlin.hide]) -> _cmp__b a__126_ b__127_ [@merlin.hide])
        a__122_
        b__123_
    ;;

    let _ = equal_result

    let globalize_result
      : 'a 'b. ('a -> 'a) -> ('b -> 'b) -> ('a, 'b) result -> ('a, 'b) result
      =
      fun (type a__128_ b__129_)
        :  ((a__128_ -> a__128_) -> (b__129_ -> b__129_) -> (a__128_, b__129_) result
        -> (a__128_, b__129_) result) ->
      Result.globalize
    ;;

    let _ = globalize_result

    let hash_fold_result
      : 'a 'b.
      (Ppx_hash_lib.Std.Hash.state -> 'a -> Ppx_hash_lib.Std.Hash.state)
      -> (Ppx_hash_lib.Std.Hash.state -> 'b -> Ppx_hash_lib.Std.Hash.state)
      -> Ppx_hash_lib.Std.Hash.state
      -> ('a, 'b) result
      -> Ppx_hash_lib.Std.Hash.state
      =
      Result.hash_fold_t
    ;;

    let _ = hash_fold_result

    let result_of_sexp
      : 'a 'b.
      (Sexplib0.Sexp.t -> 'a)
      -> (Sexplib0.Sexp.t -> 'b)
      -> Sexplib0.Sexp.t
      -> ('a, 'b) result
      =
      Result.t_of_sexp
    ;;

    let _ = result_of_sexp

    let sexp_of_result
      : 'a 'b.
      ('a -> Sexplib0.Sexp.t)
      -> ('b -> Sexplib0.Sexp.t)
      -> ('a, 'b) result
      -> Sexplib0.Sexp.t
      =
      Result.sexp_of_t
    ;;

    let _ = sexp_of_result

    let result_sexp_grammar
      : 'a 'b.
      'a Sexplib0.Sexp_grammar.t
      -> 'b Sexplib0.Sexp_grammar.t
      -> ('a, 'b) result Sexplib0.Sexp_grammar.t
      =
      fun _'a_sexp_grammar _'b_sexp_grammar ->
      Result.t_sexp_grammar _'a_sexp_grammar _'b_sexp_grammar
    ;;

    let _ = result_sexp_grammar
  end [@@merlin.hide]

  type 'a ref = 'a Ref.t

  include struct
    let _ = fun (_ : 'a ref) -> ()

    let compare_ref
      : 'a. ('a -> ('a[@merlin.hide]) -> int) -> 'a ref -> ('a ref[@merlin.hide]) -> int
      =
      fun _cmp__a a__142_ b__143_ ->
      Ref.compare
        (fun a__144_ (b__145_ [@merlin.hide]) -> _cmp__a a__144_ b__145_ [@merlin.hide])
        a__142_
        b__143_
    ;;

    let _ = compare_ref

    let equal_ref
      : 'a. ('a -> ('a[@merlin.hide]) -> bool) -> 'a ref -> ('a ref[@merlin.hide]) -> bool
      =
      fun _cmp__a a__146_ b__147_ ->
      Ref.equal
        (fun a__148_ (b__149_ [@merlin.hide]) -> _cmp__a a__148_ b__149_ [@merlin.hide])
        a__146_
        b__147_
    ;;

    let _ = equal_ref

    let globalize_ref : 'a. ('a -> 'a) -> 'a ref -> 'a ref =
      fun (type a__150_) : ((a__150_ -> a__150_) -> a__150_ ref -> a__150_ ref) ->
      Ref.globalize
    ;;

    let _ = globalize_ref

    let ref_of_sexp : 'a. (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a ref =
      Ref.t_of_sexp
    ;;

    let _ = ref_of_sexp

    let sexp_of_ref : 'a. ('a -> Sexplib0.Sexp.t) -> 'a ref -> Sexplib0.Sexp.t =
      Ref.sexp_of_t
    ;;

    let _ = sexp_of_ref

    let ref_sexp_grammar
      : 'a. 'a Sexplib0.Sexp_grammar.t -> 'a ref Sexplib0.Sexp_grammar.t
      =
      fun _'a_sexp_grammar -> Ref.t_sexp_grammar _'a_sexp_grammar
    ;;

    let _ = ref_sexp_grammar
  end [@@merlin.hide]

  type string = String.t

  include struct
    let _ = fun (_ : string) -> ()
    let compare_string = (String.compare : string -> (string[@merlin.hide]) -> int)
    let _ = compare_string
    let equal_string = (String.equal : string -> (string[@merlin.hide]) -> bool)
    let _ = equal_string

    let hash_fold_string
      : Ppx_hash_lib.Std.Hash.state -> string -> Ppx_hash_lib.Std.Hash.state
      =
      String.hash_fold_t

    and hash_string : string -> Ppx_hash_lib.Std.Hash.hash_value = fun x -> String.hash x

    let _ = hash_fold_string
    and _ = hash_string

    let string_of_sexp = (String.t_of_sexp : Sexplib0.Sexp.t -> string)
    let _ = string_of_sexp
    let sexp_of_string = (String.sexp_of_t : string -> Sexplib0.Sexp.t)
    let _ = sexp_of_string
    let string_sexp_grammar : string Sexplib0.Sexp_grammar.t = String.t_sexp_grammar
    let _ = string_sexp_grammar
  end [@@merlin.hide]

  let globalize_string : string -> string = Globalize.globalize_string

  type bytes = Bytes.t

  include struct
    let _ = fun (_ : bytes) -> ()
    let compare_bytes = (Bytes.compare : bytes -> (bytes[@merlin.hide]) -> int)
    let _ = compare_bytes
    let equal_bytes = (Bytes.equal : bytes -> (bytes[@merlin.hide]) -> bool)
    let _ = equal_bytes
    let bytes_of_sexp = (Bytes.t_of_sexp : Sexplib0.Sexp.t -> bytes)
    let _ = bytes_of_sexp
    let sexp_of_bytes = (Bytes.sexp_of_t : bytes -> Sexplib0.Sexp.t)
    let _ = sexp_of_bytes
    let bytes_sexp_grammar : bytes Sexplib0.Sexp_grammar.t = Bytes.t_sexp_grammar
    let _ = bytes_sexp_grammar
  end [@@merlin.hide]

  let globalize_bytes : bytes -> bytes = Globalize.globalize_bytes

  type unit = Unit.t

  include struct
    let _ = fun (_ : unit) -> ()
    let compare_unit = (Unit.compare : unit -> (unit[@merlin.hide]) -> int)
    let _ = compare_unit
    let equal_unit = (Unit.equal : unit -> (unit[@merlin.hide]) -> bool)
    let _ = equal_unit
    let globalize_unit : unit -> unit = Unit.globalize
    let _ = globalize_unit

    let hash_fold_unit
      : Ppx_hash_lib.Std.Hash.state -> unit -> Ppx_hash_lib.Std.Hash.state
      =
      Unit.hash_fold_t

    and hash_unit : unit -> Ppx_hash_lib.Std.Hash.hash_value = fun x -> Unit.hash x

    let _ = hash_fold_unit
    and _ = hash_unit

    let unit_of_sexp = (Unit.t_of_sexp : Sexplib0.Sexp.t -> unit)
    and unit_u_of_sexp = (Unit.t_u_of_sexp : Sexplib0.Sexp.t -> unit)

    let _ = unit_of_sexp
    and _ = unit_u_of_sexp

    let sexp_of_unit = (Unit.sexp_of_t : unit -> Sexplib0.Sexp.t)
    and sexp_of_unit_u = (Unit.sexp_of_t_u : unit -> Sexplib0.Sexp.t)

    let _ = sexp_of_unit
    and _ = sexp_of_unit_u

    let unit_sexp_grammar : unit Sexplib0.Sexp_grammar.t = Unit.t_sexp_grammar
    let _ = unit_sexp_grammar
  end [@@merlin.hide]

  type nonrec ('a, 'b, 'c) format = ('a, 'b, 'c) format
  type nonrec ('a, 'b, 'c, 'd) format4 = ('a, 'b, 'c, 'd) format4
  type nonrec ('a, 'b, 'c, 'd, 'e, 'f) format6 = ('a, 'b, 'c, 'd, 'e, 'f) format6

  include List.Infix
  include Iarray.O
  include Int.O
  include Int_replace_polymorphic_compare
  include Float.O_dot

  external ( |> ) : 'a 'b. 'a -> ('a -> 'b) -> 'b = "%revapply"
  external ( @@ ) : 'a 'b. ('a -> 'b) -> 'a -> 'b = "%apply"
  external ( && ) : bool -> bool -> bool = "%sequand"
  external ( || ) : bool -> bool -> bool = "%sequor"
  external not : bool -> bool = "%boolnot"
  external ignore : 'a. 'a -> unit = "%ignore"

  let ( ^ ) = String.( ^ )

  external ( ! ) : 'a. 'a ref -> 'a = "%field0"
  external ref : 'a. 'a -> 'a ref = "%makemutable"
  external ( := ) : 'a. 'a ref -> 'a -> unit = "%setfield0"
  external fst : 'a 'b. 'a * 'b -> 'a = "%field0"
  external snd : 'a 'b. 'a * 'b -> 'b = "%field1"
  external raise : 'a. exn -> 'a = "%raise"

  let failwith = failwith
  let invalid_arg = invalid_arg
  let raise_s = Error.raise_s

  external phys_equal : 'a. 'a -> 'a -> bool = "%eq"
  external force : 'a lazy_t -> 'a = "%lazy_force"

  type 'a or_null = 'a Or_null.t =
    | Null
    | This of 'a

  include (
  struct
    type 'a or_null = 'a Or_null.t

    include struct
      let _ = fun (_ : 'a or_null) -> ()

      let compare_or_null
        : 'a.
        ('a -> ('a[@merlin.hide]) -> int)
        -> 'a or_null
        -> ('a or_null[@merlin.hide])
        -> int
        =
        fun _cmp__a a__176_ b__177_ ->
        Or_null.compare
          (fun a__178_ (b__179_ [@merlin.hide]) -> _cmp__a a__178_ b__179_ [@merlin.hide])
          a__176_
          b__177_
      ;;

      let _ = compare_or_null

      let equal_or_null
        : 'a.
        ('a -> ('a[@merlin.hide]) -> bool)
        -> 'a or_null
        -> ('a or_null[@merlin.hide])
        -> bool
        =
        fun _cmp__a a__180_ b__181_ ->
        Or_null.equal
          (fun a__182_ (b__183_ [@merlin.hide]) -> _cmp__a a__182_ b__183_ [@merlin.hide])
          a__180_
          b__181_
      ;;

      let _ = equal_or_null

      let globalize_or_null : 'a. ('a -> 'a) -> 'a or_null -> 'a or_null =
        fun (type a__184_) : ((a__184_ -> a__184_) -> a__184_ or_null -> a__184_ or_null) ->
        Or_null.globalize
      ;;

      let _ = globalize_or_null

      let hash_fold_or_null
        : 'a.
        (Ppx_hash_lib.Std.Hash.state -> 'a -> Ppx_hash_lib.Std.Hash.state)
        -> Ppx_hash_lib.Std.Hash.state
        -> 'a or_null
        -> Ppx_hash_lib.Std.Hash.state
        =
        Or_null.hash_fold_t
      ;;

      let _ = hash_fold_or_null

      let or_null_of_sexp : 'a. (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a or_null =
        Or_null.t_of_sexp
      ;;

      let _ = or_null_of_sexp

      let sexp_of_or_null : 'a. ('a -> Sexplib0.Sexp.t) -> 'a or_null -> Sexplib0.Sexp.t =
        Or_null.sexp_of_t
      ;;

      let _ = sexp_of_or_null
    end [@@merlin.hide]
  end :
    sig
      type 'a or_null = 'a Or_null.t

      include sig
        [@@@ocaml.warning "-32"]

        val compare_or_null
          : 'a.
          ('a -> ('a[@merlin.hide]) -> int)
          -> 'a or_null
          -> ('a or_null[@merlin.hide])
          -> int

        val equal_or_null
          : 'a.
          ('a -> ('a[@merlin.hide]) -> bool)
          -> 'a or_null
          -> ('a or_null[@merlin.hide])
          -> bool

        val globalize_or_null : 'a. ('a -> 'a) -> 'a or_null -> 'a or_null

        val hash_fold_or_null
          : 'a.
          (Ppx_hash_lib.Std.Hash.state -> 'a -> Ppx_hash_lib.Std.Hash.state)
          -> Ppx_hash_lib.Std.Hash.state
          -> 'a or_null
          -> Ppx_hash_lib.Std.Hash.state

        val sexp_of_or_null : ('a -> Sexplib0.Sexp.t) -> 'a or_null -> Sexplib0.Sexp.t
        val or_null_of_sexp : (Sexplib0.Sexp.t -> 'a) -> Sexplib0.Sexp.t -> 'a or_null
      end
      [@@merlin.hide]
    end
    with type 'a or_null := 'a Or_null.t)

  let maybe_globalize = Globalize.maybe_globalize
end

include Export
include Container.Export
include Modes.Export
include Ppx_enumerate_lib.Export

exception Not_found_s = Not_found_s

let () = Backtrace.initialize_module ()
