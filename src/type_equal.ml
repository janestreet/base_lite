open! Import
open Type_equal_intf.Definitions
module Error = Error0
module Sexp = Sexp0

type ('a, 'b) t = T : 'a. ('a, 'a) t

include struct
  let _ = fun (_ : ('a, 'b) t) -> ()

  let sexp_of_t
    : 'a 'b.
    ('a -> Sexplib0.Sexp.t) -> ('b -> Sexplib0.Sexp.t) -> ('a, 'b) t -> Sexplib0.Sexp.t
    =
    fun (type a__008_ b__009_)
      :  ((a__008_ -> Sexplib0.Sexp.t) -> (b__009_ -> Sexplib0.Sexp.t)
      -> (a__008_, b__009_) t -> Sexplib0.Sexp.t) ->
    fun _of_a__006_ _of_b__007_ T -> Sexplib0.Sexp.Atom "T"
  ;;

  let _ = sexp_of_t
end [@@merlin.hide]

type ('a, 'b) equal = ('a, 'b) t

include Type_equal_defns (struct
    type ('a, 'b) t = ('a, 'b) equal
  end)

let refl = T
let sym (type a b) (T : (a, b) t) : (b, a) t = T
let trans (type a b c) (T : (a, b) t) (T : (b, c) t) : (a, c) t = T
let conv (type a b) (T : (a, b) t) (a : a) : b = a

module Lift (X : sig
    type 'a t
  end) =
struct
  let lift (type a b) (T : (a, b) t) : (a X.t, b X.t) t = T
end

module Lift2 (X : sig
    type ('a1, 'a2) t
  end) =
struct
  let lift (type a1 b1 a2 b2) (T : (a1, b1) t) (T : (a2, b2) t)
    : ((a1, a2) X.t, (b1, b2) X.t) t
    =
    T
  ;;
end

module Lift3 (X : sig
    type ('a1, 'a2, 'a3) t
  end) =
struct
  let lift (type a1 b1 a2 b2 a3 b3) (T : (a1, b1) t) (T : (a2, b2) t) (T : (a3, b3) t)
    : ((a1, a2, a3) X.t, (b1, b2, b3) X.t) t
    =
    T
  ;;
end

module Lift4 (X : sig
    type ('a1, 'a2, 'a3, 'a4) t
  end) =
struct
  let lift
    (type a1 b1 a2 b2 a3 b3 a4 b4)
    (T : (a1, b1) t)
    (T : (a2, b2) t)
    (T : (a3, b3) t)
    (T : (a4, b4) t)
    : ((a1, a2, a3, a4) X.t, (b1, b2, b3, b4) X.t) t
    =
    T
  ;;
end

let detuple2 (type a1 a2 b1 b2) (T : (a1 * a2, b1 * b2) t) : (a1, b1) t * (a2, b2) t =
  T, T
;;

let tuple2 (type a1 a2 b1 b2) (T : (a1, b1) t) (T : (a2, b2) t) : (a1 * a2, b1 * b2) t = T

module Id = struct
  type _ key = ..

  module Uid = struct
    type t = T of int * t list

    include struct
      let _ = fun (_ : t) -> ()

      let rec compare =
        (fun a__010_ b__011_ ->
           if Stdlib.( == ) a__010_ b__011_
           then 0
           else (
             match a__010_, b__011_ with
             | T (_a__012_, _a__014_), T (_b__013_, _b__015_) ->
               (match compare_int _a__012_ _b__013_ with
                | 0 ->
                  compare_list
                    (fun a__016_ (b__017_ [@merlin.hide]) ->
                      compare a__016_ b__017_ [@merlin.hide])
                    _a__014_
                    _b__015_
                | n -> n))
         : t -> (t[@merlin.hide]) -> int)
      ;;

      let _ = compare

      let rec hash_fold_t
        : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state
        =
        fun hsv arg ->
        match arg with
        | T (_a0, _a1) ->
          let hsv = hsv in
          let hsv =
            let hsv = hsv in
            hash_fold_int hsv _a0
          in
          hash_fold_list hash_fold_t hsv _a1

      and hash : t -> Ppx_hash_lib.Std.Hash.hash_value =
        fun x ->
        (fun arg ->
          Ppx_hash_lib.Std.Hash.get_hash_value
            (let hsv = Ppx_hash_lib.Std.Hash.create () in
             hash_fold_t hsv arg))
          x
      ;;

      let _ = hash_fold_t
      and _ = hash

      let rec sexp_of_t =
        (fun (T (arg0__018_, arg1__019_)) ->
           let res0__020_ = sexp_of_int arg0__018_
           and res1__021_ = sexp_of_list sexp_of_t arg1__019_ in
           Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "T"; res0__020_; res1__021_ ]
         : t -> Sexplib0.Sexp.t)
      ;;

      let _ = sexp_of_t
    end [@@merlin.hide]

    include Comparable.Make (struct
        type nonrec t = t

        let compare = compare
        let sexp_of_t = sexp_of_t
      end)

    let create (key : _ key) args =
      let tag =
        Stdlib.Obj.Extension_constructor.id (Stdlib.Obj.Extension_constructor.of_val key)
      in
      T (tag, args)
    ;;
  end

  module type S = sig
    type t

    val sexp_of_t : t -> Sexp.t
    val uid : Uid.t
    val id_name : string
    val id_sexp : Sexp.t
    val type_key : t key
    val type_equal : 'a. 'a key -> (t, 'a) equal option
  end

  type 'a t = { immutable : (module S with type t = 'a) } [@@unboxed]

  let uid (type a) ({ immutable = (module M) } : a t) = M.uid
  let name (type a) ({ immutable = (module M) } : a t) = M.id_name
  let sexp_of_t (type a) _ ({ immutable = (module M) } : a t) = M.id_sexp
  let to_sexp (type a) ({ immutable = (module M) } : a t) = M.sexp_of_t
  let hash t = Uid.hash (uid t)
  let hash_fold_t state t = Uid.hash_fold_t state (uid t)

  let same_witness
    (type a b)
    ({ immutable = (module A) } : a t)
    ({ immutable = (module B) } : b t)
    =
    A.type_equal B.type_key
  ;;

  let same_witness_exn t1 t2 =
    match same_witness t1 t2 with
    | Some equal -> equal
    | None ->
      Error.raise_s
        (Sexp.message
           "Type_equal.Id.same_witness_exn got different ids"
           [ ( ""
             , sexp_of_pair (sexp_of_t sexp_of_opaque) (sexp_of_t sexp_of_opaque) (t1, t2)
             )
           ])
  ;;

  let same t1 t2 =
    match same_witness t1 t2 with
    | Some _ -> true
    | None -> false
  ;;

  include Type_equal_id_defns (struct
      type nonrec 'a t = 'a t
    end)

  module Create0 (T : Arg0) = struct
    type _ key += T0 : T.t key

    let type_equal_id : T.t t =
      { immutable =
          (module struct
            type t = T.t

            let id_name = T.name
            let id_sexp = Sexp.Atom id_name
            let sexp_of_t = T.sexp_of_t
            let type_key = T0
            let uid = Uid.create type_key []

            let type_equal (type other) (otherkey : other key) : (T.t, other) equal option
              =
              match otherkey with
              | T0 -> Some T
              | _ -> None
            ;;
          end)
      }
    ;;
  end

  module Create1 (T : Arg1) = struct
    type _ key += T1 : 'a key -> 'a T.t key

    let type_equal_id (type a) ({ immutable = (module A) } : a t) : a T.t t =
      { immutable =
          (module struct
            type t = a T.t

            let id_name = T.name
            let id_sexp = Sexp.List [ Atom id_name; A.id_sexp ]
            let sexp_of_t t = T.sexp_of_t A.sexp_of_t t
            let type_key = T1 A.type_key
            let uid = Uid.create type_key [ A.uid ]

            let type_equal (type other) (otherkey : other key)
              : (a T.t, other) equal option
              =
              match otherkey with
              | T1 akey ->
                (match A.type_equal akey with
                 | Some T -> Some T
                 | None -> None)
              | _ -> None
            ;;
          end)
      }
    ;;
  end

  module Create2 (T : Arg2) = struct
    type _ key += T2 : 'a 'b. 'a key * 'b key -> ('a, 'b) T.t key

    let type_equal_id
      (type a b)
      ({ immutable = (module A) } : a t)
      ({ immutable = (module B) } : b t)
      : (a, b) T.t t
      =
      { immutable =
          (module struct
            type t = (a, b) T.t

            let id_name = T.name
            let id_sexp = Sexp.List [ Atom id_name; A.id_sexp; B.id_sexp ]
            let sexp_of_t t = T.sexp_of_t A.sexp_of_t B.sexp_of_t t
            let type_key = T2 (A.type_key, B.type_key)
            let uid = Uid.create type_key [ A.uid; B.uid ]

            let type_equal (type other) (otherkey : other key)
              : ((a, b) T.t, other) equal option
              =
              match otherkey with
              | T2 (akey, bkey) ->
                (match A.type_equal akey, B.type_equal bkey with
                 | Some T, Some T -> Some T
                 | None, _ | _, None -> None)
              | _ -> None
            ;;
          end)
      }
    ;;
  end

  module Create3 (T : Arg3) = struct
    type _ key += T3 : 'a key * 'b key * 'c key -> ('a, 'b, 'c) T.t key

    let type_equal_id
      (type a b c)
      ({ immutable = (module A) } : a t)
      ({ immutable = (module B) } : b t)
      ({ immutable = (module C) } : c t)
      : (a, b, c) T.t t
      =
      { immutable =
          (module struct
            type t = (a, b, c) T.t

            let id_name = T.name
            let id_sexp = Sexp.List [ Atom id_name; A.id_sexp; B.id_sexp; C.id_sexp ]
            let sexp_of_t t = T.sexp_of_t A.sexp_of_t B.sexp_of_t C.sexp_of_t t
            let type_key = T3 (A.type_key, B.type_key, C.type_key)
            let uid = Uid.create type_key [ A.uid; B.uid; C.uid ]

            let type_equal (type other) (otherkey : other key)
              : ((a, b, c) T.t, other) equal option
              =
              match otherkey with
              | T3 (akey, bkey, ckey) ->
                (match A.type_equal akey, B.type_equal bkey, C.type_equal ckey with
                 | Some T, Some T, Some T -> Some T
                 | None, _, _ | _, None, _ | _, _, None -> None)
              | _ -> None
            ;;
          end)
      }
    ;;
  end

  module Create4 (T : Arg4) = struct
    type _ key += T4 : 'a key * 'b key * 'c key * 'd key -> ('a, 'b, 'c, 'd) T.t key

    let type_equal_id
      (type a b c d)
      ({ immutable = (module A) } : a t)
      ({ immutable = (module B) } : b t)
      ({ immutable = (module C) } : c t)
      ({ immutable = (module D) } : d t)
      : (a, b, c, d) T.t t
      =
      { immutable =
          (module struct
            type t = (a, b, c, d) T.t

            let id_name = T.name

            let id_sexp =
              Sexp.List [ Atom id_name; A.id_sexp; B.id_sexp; C.id_sexp; D.id_sexp ]
            ;;

            let sexp_of_t t =
              T.sexp_of_t A.sexp_of_t B.sexp_of_t C.sexp_of_t D.sexp_of_t t
            ;;

            let type_key = T4 (A.type_key, B.type_key, C.type_key, D.type_key)
            let uid = Uid.create type_key [ A.uid; B.uid; C.uid; D.uid ]

            let type_equal (type other) (otherkey : other key)
              : ((a, b, c, d) T.t, other) equal option
              =
              match otherkey with
              | T4 (akey, bkey, ckey, dkey) ->
                (match
                   ( A.type_equal akey
                   , B.type_equal bkey
                   , C.type_equal ckey
                   , D.type_equal dkey )
                 with
                 | Some T, Some T, Some T, Some T -> Some T
                 | None, _, _, _ | _, None, _, _ | _, _, None, _ | _, _, _, None -> None)
              | _ -> None
            ;;
          end)
      }
    ;;
  end

  let create (type a) ~name sexp_of_t : a t =
    let open struct
      type _ key += T0 : a key
    end in
    { immutable =
        (module struct
          type t = a

          let id_name = name
          let id_sexp = Sexp.Atom id_name
          let sexp_of_t = sexp_of_t
          let type_key = T0
          let uid = Uid.create type_key []

          let type_equal (type other) (otherkey : other key) : (a, other) equal option =
            match otherkey with
            | T0 -> Some T
            | _ -> None
          ;;
        end)
    }
  ;;
end
