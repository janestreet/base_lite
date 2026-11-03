include (
  Shadow_stdlib :
    module type of struct
      include Shadow_stdlib
    end
    with type ('a, 'b, 'c) format := ('a, 'b, 'c) format
    with type ('a, 'b, 'c, 'd) format4 := ('a, 'b, 'c, 'd) format4
    with type ('a, 'b, 'c, 'd, 'e, 'f) format6 := ('a, 'b, 'c, 'd, 'e, 'f) format6
    with module Array := Shadow_stdlib.Array
    with module Atomic := Shadow_stdlib.Atomic
    with module Bool := Shadow_stdlib.Bool
    with module Buffer := Shadow_stdlib.Buffer
    with module Bytes := Shadow_stdlib.Bytes
    with module Char := Shadow_stdlib.Char
    with module Either := Shadow_stdlib.Either
    with module Float := Shadow_stdlib.Float
    with module Hashtbl := Shadow_stdlib.Hashtbl
    with module Int := Shadow_stdlib.Int
    with module Int32 := Shadow_stdlib.Int32
    with module Int64 := Shadow_stdlib.Int64
    with module Lazy := Shadow_stdlib.Lazy
    with module List := Shadow_stdlib.List
    with module Map := Shadow_stdlib.Map
    with module Nativeint := Shadow_stdlib.Nativeint
    with module Obj := Shadow_stdlib.Obj
    with module Option := Shadow_stdlib.Option
    with module Printf := Shadow_stdlib.Printf
    with module Queue := Shadow_stdlib.Queue
    with module Random := Shadow_stdlib.Random
    with module Result := Shadow_stdlib.Result
    with module Set := Shadow_stdlib.Set
    with module Stack := Shadow_stdlib.Stack
    with module String := Shadow_stdlib.String
    with module Sys := Shadow_stdlib.Sys
    with module Uchar := Shadow_stdlib.Uchar
    with module Unit := Shadow_stdlib.Unit)
[@ocaml.warning "-3"]

type 'a ref = 'a Stdlib.ref = { mutable contents : 'a }
type 'a iarray = 'a Basement.Stdlib_iarray_labels.t

include Basement.Or_null_shim.Export

module Stdlib = struct
  include Stdlib
  include Stdlib.StdLabels
  include Stdlib.MoreLabels

  module Atomic = struct
    include Stdlib.Atomic
    include Basement.Stdlib_shim.Atomic
    include Basement.Stdlib_shim.Atomic.Local
  end

  module Domain = struct
    include Stdlib.Domain
    include Basement.Stdlib_shim.Domain.Safe
  end

  module Format = struct
    include Stdlib.Format
    include Basement.Stdlib_shim.Format.Safe
  end

  module Obj = struct
    include Stdlib.Obj
    include Basement.Stdlib_shim.Obj

    module Extension_constructor = struct
      include Stdlib.Obj.Extension_constructor
      include Basement.Stdlib_shim.Obj.Extension_constructor
    end
  end

  module Printexc = struct
    include Stdlib.Printexc
    include Basement.Stdlib_shim.Printexc.Safe
  end
end

module Portability_hacks = Basement.Portability_hacks
module Primitives = Basement.Primitives
module Int32_u = Primitives.Int32_u
module Int64_u = Primitives.Int64_u
module Nativeint_u = Primitives.Nativeint_u

external ( |> ) : 'a -> ('a -> 'b) -> 'b = "%revapply"
external ( && ) : bool -> bool -> bool = "%sequand"
external ( || ) : bool -> bool -> bool = "%sequor"
external not : bool -> bool = "%boolnot"
external bool_to_int : bool -> int = "%identity"
external ignore : _ -> unit = "%ignore"
external ignore_contended : _ -> unit = "%ignore"

let ( != ) = Stdlib.( != )
let ( * ) = Stdlib.( * )

external ( ** ) : float -> float -> float = "caml_power_float" "pow"
[@@unboxed] [@@noalloc]

external ( *. ) : float -> float -> float = "%mulfloat"

let ( + ) = Stdlib.( + )

external ( +. ) : float -> float -> float = "%addfloat"

let ( - ) = Stdlib.( - )

external ( -. ) : float -> float -> float = "%subfloat"

let ( / ) = Stdlib.( / )

external ( /. ) : float -> float -> float = "%divfloat"

module Hash = Ppx_hash_lib.Std.Hash
include Replace_polymorphic_compare
include Int_replace_polymorphic_compare

external ( := ) : 'a. 'a ref -> 'a -> unit = "%setfield0"
external ( ! ) : 'a. 'a ref -> 'a = "%field0"
external ref : 'a. 'a -> 'a ref = "%makemutable"

let ( @ ) = Stdlib.( @ )
let ( ^ ) = Stdlib.( ^ )
let ( ~- ) = Stdlib.( ~- )

external ( .:() ) : 'a iarray -> int -> 'a = "%array_safe_get"
external ( ~-. ) : float -> float = "%negfloat"

let ( asr ) = Stdlib.( asr )

external ( land ) : int -> int -> int = "%andint"

let lnot = Stdlib.lnot
let ( lor ) = Stdlib.( lor )
let ( lsl ) = Stdlib.( lsl )
let ( lsr ) = Stdlib.( lsr )
let ( lxor ) = Stdlib.( lxor )
let ( mod ) = Stdlib.( mod )
let abs = Stdlib.abs
let failwith = Stdlib.failwith
let invalid_arg = Stdlib.invalid_arg

external fst : 'a 'b. 'a * 'b -> 'a = "%field0"
external snd : 'a 'b. 'a * 'b -> 'b = "%field1"
external raise : 'a. exn -> 'a = "%raise"
external phys_equal : 'a. 'a -> 'a -> bool = "%eq"
external decr : int ref -> unit = "%decr"
external incr : int ref -> unit = "%incr"

let float_of_string = Stdlib.float_of_string

external am_testing : unit -> bool = "Base_am_testing"

let am_testing = am_testing ()
