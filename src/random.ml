open! Import0
module Int = Int0
module Char = Char0
module Capsule = Capsule_prim

module Random_repr : sig
  val assign : src:Stdlib.Random.State.t -> dst:Stdlib.Random.State.t -> unit
end = struct
  module Repr = struct
    open Stdlib.Bigarray

    type t = (int64, int64_elt, c_layout) Array1.t

    external of_state : Stdlib.Random.State.t -> t = "%identity"
  end

  module Array1 = struct
    external blit
      :  ('a, 'b, 'c) Stdlib.Bigarray.Array1.t
      -> ('a, 'b, 'c) Stdlib.Bigarray.Array1.t
      -> unit
      = "caml_ba_blit"
  end

  let assign ~src ~dst =
    let dst = Repr.of_state dst in
    let src = Repr.of_state src in
    Array1.blit src dst
  ;;
end

let forbid_nondeterminism_in_tests ~allow_in_tests =
  if am_testing
  then (
    match allow_in_tests with
    | Some true -> ()
    | None | Some false ->
      failwith
        "initializing Random with a nondeterministic seed is forbidden in inline tests")
;;

external random_seed : unit -> int array = "caml_sys_random_seed"

let random_seed ?allow_in_tests () =
  forbid_nondeterminism_in_tests ~allow_in_tests;
  random_seed ()
;;

open (
struct
  external magic_unwrap_capsule : ('a, 'k) Capsule.Data.t -> 'a = "%identity"

  let assign_capsule ~password:_ ~src ~dst =
    Random_repr.assign ~src:(magic_unwrap_capsule src) ~dst [@nontail]
  ;;

  external magic_wrap_capsule : 'a -> ('a, 'k) Capsule.Data.t = "%identity"

  let copy_into_capsule src = magic_wrap_capsule (Stdlib.Random.State.copy src)
  let split_into_capsule src = magic_wrap_capsule (Stdlib.Random.State.split src)
end :
sig
  val assign_capsule
    :  password:'k Capsule.Password.Shared.t
    -> src:(Stdlib.Random.State.t, 'k) Capsule.Data.t
    -> dst:Stdlib.Random.State.t
    -> unit

  val copy_into_capsule
    :  Stdlib.Random.State.t
    -> (Stdlib.Random.State.t, 'k) Capsule.Data.t

  val split_into_capsule
    :  Stdlib.Random.State.t
    -> (Stdlib.Random.State.t, 'k) Capsule.Data.t
end)

module State = struct
  module T : sig
    type t

    val default : t
    val get_default : unit -> t
    val of_stdlib : Stdlib.Random.State.t -> t
    val of_stdlib_lazy : f:(unit -> Stdlib.Random.State.t) -> t
    val with_stdlib : 'a. f:(Stdlib.Random.State.t -> 'a) -> t -> 'a
  end = struct
    module DLS = Basement.Stdlib_shim.Domain.Safe.DLS

    let default_state =
      let state_initializer =
        if am_testing
        then (
          let (P (type k) (key : k Capsule.Key.t)) = Capsule.create () in
          let initial_state = copy_into_capsule (Stdlib.Random.get_state ()) in
          Stdlib.Random.init 137;
          Obj.magic_many (fun () ->
            if Stdlib.Domain.is_main_domain ()
            then (
              let access = Capsule.Key.destroy key in
              Capsule.Data.unwrap ~access initial_state)
            else Stdlib.Random.State.make_self_init ()))
        else Stdlib.Random.State.make_self_init
      in
      let default_state_key =
        DLS.new_key
          ~split_from_parent:(fun state ->
            let (P (type k) (key : k Capsule.Key.t)) = Capsule.create () in
            let state = split_into_capsule state in
            fun () ->
              let access = Capsule.Key.destroy key in
              Capsule.Data.unwrap ~access state)
          state_initializer
      in
      default_state_key
    ;;

    type inner =
      | Default
      | Custom of Stdlib.Random.State.t lazy_t

    type t = inner Modes.Portable_via_contended.t

    let wrap = Modes.Portable_via_contended.wrap
    let unwrap = Modes.Portable_via_contended.unwrap
    let default = wrap Default
    let get_default () = wrap Default
    let of_stdlib st = wrap (Custom (Lazy.from_val st))
    let of_stdlib_lazy ~f = wrap (Custom (Lazy.from_fun f))

    let with_stdlib ~f t =
      match unwrap t with
      | Default ->
        let default_state = Obj.magic_uncontended (DLS.get default_state) in
        f default_state [@nontail]
      | Custom st -> f (Lazy.force st)
    ;;
  end

  include T

  let make_self_init ?allow_in_tests () =
    forbid_nondeterminism_in_tests ~allow_in_tests;
    of_stdlib_lazy ~f:Stdlib.Random.State.make_self_init
  ;;

  let bits t = with_stdlib ~f:Stdlib.Random.State.bits t
  let bits64 t = with_stdlib ~f:Stdlib.Random.State.bits64 t
  let bool t = with_stdlib ~f:Stdlib.Random.State.bool t
  let int t x = with_stdlib ~f:(fun state -> Stdlib.Random.State.int state x) t
  let int32 t x = with_stdlib ~f:(fun state -> Stdlib.Random.State.int32 state x) t
  let int64 t x = with_stdlib ~f:(fun state -> Stdlib.Random.State.int64 state x) t

  let nativeint t x =
    with_stdlib ~f:(fun state -> Stdlib.Random.State.nativeint state x) t
  ;;

  let make seed = of_stdlib (Stdlib.Random.State.make seed)

  let copy t =
    let (P access) = Capsule.current () in
    of_stdlib
      (Capsule.Data.unwrap
         ~access
         (with_stdlib ~f:(fun state -> copy_into_capsule state) t))
  ;;

  let char t = Char.unsafe_of_int (int t 256)
  let ascii t = Char.unsafe_of_int (int t 128)

  let full_init t seed =
    let seed = Stdlib.Random.State.make seed in
    let (P access) = Capsule.current () in
    let seed = Capsule.Data.wrap ~access seed in
    Capsule.Password.with_current access (fun password ->
      let password = Capsule.Password.shared password in
      with_stdlib t ~f:(fun state -> assign_capsule ~password ~src:seed ~dst:state)
      [@nontail])
    [@nontail]
  ;;

  let int_on_64bits t bound =
    if bound <= 0x3FFFFFFF
    then int t bound
    else Stdlib.Int64.to_int (int64 t (Stdlib.Int64.of_int bound))
  ;;

  let int_on_32bits t bound =
    if bound <= 0x3FFFFFFF
    then int t bound
    else Stdlib.Int32.to_int (int32 t (Stdlib.Int32.of_int bound))
  ;;

  let int =
    match Word_size.word_size with
    | W64 -> int_on_64bits
    | W32 -> int_on_32bits
  ;;

  let full_range_int64 =
    let open Stdlib.Int64 in
    let bits state = of_int (bits state) in
    fun state ->
      logxor
        (bits state)
        (logxor (shift_left (bits state) 30) (shift_left (bits state) 60))
  ;;

  let full_range_int32 =
    let open Stdlib.Int32 in
    let bits state = of_int (bits state) in
    fun state -> logxor (bits state) (shift_left (bits state) 30)
  ;;

  let full_range_int_on_64bits state = Stdlib.Int64.to_int (full_range_int64 state)
  let full_range_int_on_32bits state = Stdlib.Int32.to_int (full_range_int32 state)

  let full_range_int =
    match Word_size.word_size with
    | W64 -> full_range_int_on_64bits
    | W32 -> full_range_int_on_32bits
  ;;

  let full_range_nativeint_on_64bits state =
    Stdlib.Int64.to_nativeint (full_range_int64 state)
  ;;

  let full_range_nativeint_on_32bits state =
    Stdlib.Nativeint.of_int32 (full_range_int32 state)
  ;;

  let full_range_nativeint =
    match Word_size.word_size with
    | W64 -> full_range_nativeint_on_64bits
    | W32 -> full_range_nativeint_on_32bits
  ;;

  let raise_crossed_bounds name lower_bound upper_bound string_of_bound =
    Printf.failwithf
      "Random.%s: crossed bounds [%s > %s]"
      name
      (string_of_bound lower_bound)
      (string_of_bound upper_bound)
      ()
  [@@cold]
  ;;

  let int_incl =
    let rec in_range state lo hi =
      let int = full_range_int state in
      if int >= lo && int <= hi then int else in_range state lo hi
    in
    fun state lo hi ->
      if lo > hi then raise_crossed_bounds "int" lo hi Int.to_string;
      let diff = hi - lo in
      if diff = Int.max_value
      then lo + (full_range_int state land Int.max_value)
      else if diff >= 0
      then lo + int state (Int.succ diff)
      else in_range state lo hi
  ;;

  let int32_incl =
    let open Int32_replace_polymorphic_compare in
    let rec in_range state lo hi =
      let int = full_range_int32 state in
      if int >= lo && int <= hi then int else in_range state lo hi
    in
    let open Stdlib.Int32 in
    fun state lo hi ->
      if lo > hi then raise_crossed_bounds "int32" lo hi to_string;
      let diff = sub hi lo in
      if diff = max_int
      then add lo (logand (full_range_int32 state) max_int)
      else if diff >= 0l
      then add lo (int32 state (succ diff))
      else in_range state lo hi
  ;;

  let nativeint_incl =
    let open Nativeint_replace_polymorphic_compare in
    let rec in_range state lo hi =
      let int = full_range_nativeint state in
      if int >= lo && int <= hi then int else in_range state lo hi
    in
    let open Stdlib.Nativeint in
    fun state lo hi ->
      if lo > hi then raise_crossed_bounds "nativeint" lo hi to_string;
      let diff = sub hi lo in
      if diff = max_int
      then add lo (logand (full_range_nativeint state) max_int)
      else if diff >= 0n
      then add lo (nativeint state (succ diff))
      else in_range state lo hi
  ;;

  let int64_incl =
    let open Int64_replace_polymorphic_compare in
    let rec in_range state lo hi =
      let int = full_range_int64 state in
      if int >= lo && int <= hi then int else in_range state lo hi
    in
    let open Stdlib.Int64 in
    fun state lo hi ->
      if lo > hi then raise_crossed_bounds "int64" lo hi to_string;
      let diff = sub hi lo in
      if diff = max_int
      then add lo (logand (full_range_int64 state) max_int)
      else if diff >= 0L
      then add lo (int64 state (succ diff))
      else in_range state lo hi
  ;;

  let rawfloat state =
    let result = ref 0.0 in
    while
      let open Float_replace_polymorphic_compare in
      let scale = 0x1p-30 in
      let r1 = Stdlib.float_of_int (bits state) in
      let r2 = Stdlib.float_of_int (bits state) in
      result := ((r1 *. scale) +. r2) *. scale;
      !result >= 1.0
    do
      ()
    done;
    !result
  ;;

  let float state hi = rawfloat state *. hi

  let float_range state lo hi =
    let open Float_replace_polymorphic_compare in
    if lo > hi then raise_crossed_bounds "float" lo hi Stdlib.string_of_float;
    lo +. float state (hi -. lo)
  ;;
end

let bits () = State.bits (State.get_default ())
let bits64 () = State.bits64 (State.get_default ())
let int x = State.int (State.get_default ()) x
let int32 x = State.int32 (State.get_default ()) x
let nativeint x = State.nativeint (State.get_default ()) x
let int64 x = State.int64 (State.get_default ()) x
let float x = State.float (State.get_default ()) x
let int_incl x y = State.int_incl (State.get_default ()) x y
let int32_incl x y = State.int32_incl (State.get_default ()) x y
let nativeint_incl x y = State.nativeint_incl (State.get_default ()) x y
let int64_incl x y = State.int64_incl (State.get_default ()) x y
let float_range x y = State.float_range (State.get_default ()) x y
let bool () = State.bool (State.get_default ())
let char () = State.char (State.get_default ())
let ascii () = State.ascii (State.get_default ())
let full_init seed = State.full_init (State.get_default ()) seed
let init seed = full_init [| seed |]
let self_init ?allow_in_tests () = full_init (random_seed ?allow_in_tests ())

let set_state s =
  State.with_stdlib s ~f:(fun state ->
    let (P access) = Capsule.current () in
    let capsule = Capsule.Data.Local.wrap ~access state in
    Capsule.Password.with_current access (fun password ->
      let password = Capsule.Password.shared password in
      State.with_stdlib (State.get_default ()) ~f:(fun default ->
        assign_capsule ~password ~src:capsule ~dst:default)
      [@nontail])
    [@nontail])
  [@nontail]
;;
