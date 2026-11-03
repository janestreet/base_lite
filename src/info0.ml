open! Import
module List = List0
module Source_code_position = Source_code_position0
include Info_intf.Definitions
module Sexp = Sexp0
module String = String0
module Domain = Basement.Stdlib_shim.Domain
module Portable_atomic = Basement.Portable_atomic

type global_exn = exn Modes.Global.t

let sexp_of_global_exn g = sexp_of_exn (Modes.Global.unwrap g)

module Message = struct
  type t =
    | Could_not_construct of Sexp.t
    | String of string
    | Exn of global_exn
    | Sexp of Sexp.t
    | Tag_sexp of string * Sexp.t * Source_code_position.t option
    | Tag_t of string * t
    | Tag_arg of string * Sexp.t * t
    | Of_list of int option * t list
    | With_backtrace of t * string

  include struct
    let _ = fun (_ : t) -> ()

    let rec sexp_of_t =
      (function
       | Could_not_construct arg0__001_ ->
         let res0__002_ = Sexp.sexp_of_t arg0__001_ in
         Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Could_not_construct"; res0__002_ ]
       | String arg0__003_ ->
         let res0__004_ = sexp_of_string arg0__003_ in
         Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "String"; res0__004_ ]
       | Exn arg0__005_ ->
         let res0__006_ = sexp_of_global_exn arg0__005_ in
         Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Exn"; res0__006_ ]
       | Sexp arg0__007_ ->
         let res0__008_ = Sexp.sexp_of_t arg0__007_ in
         Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Sexp"; res0__008_ ]
       | Tag_sexp (arg0__009_, arg1__010_, arg2__011_) ->
         let res0__012_ = sexp_of_string arg0__009_
         and res1__013_ = Sexp.sexp_of_t arg1__010_
         and res2__014_ = sexp_of_option Source_code_position.sexp_of_t arg2__011_ in
         Sexplib0.Sexp.List
           [ Sexplib0.Sexp.Atom "Tag_sexp"; res0__012_; res1__013_; res2__014_ ]
       | Tag_t (arg0__015_, arg1__016_) ->
         let res0__017_ = sexp_of_string arg0__015_
         and res1__018_ = sexp_of_t arg1__016_ in
         Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Tag_t"; res0__017_; res1__018_ ]
       | Tag_arg (arg0__019_, arg1__020_, arg2__021_) ->
         let res0__022_ = sexp_of_string arg0__019_
         and res1__023_ = Sexp.sexp_of_t arg1__020_
         and res2__024_ = sexp_of_t arg2__021_ in
         Sexplib0.Sexp.List
           [ Sexplib0.Sexp.Atom "Tag_arg"; res0__022_; res1__023_; res2__024_ ]
       | Of_list (arg0__025_, arg1__026_) ->
         let res0__027_ = sexp_of_option sexp_of_int arg0__025_
         and res1__028_ = sexp_of_list sexp_of_t arg1__026_ in
         Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Of_list"; res0__027_; res1__028_ ]
       | With_backtrace (arg0__029_, arg1__030_) ->
         let res0__031_ = sexp_of_t arg0__029_
         and res1__032_ = sexp_of_string arg1__030_ in
         Sexplib0.Sexp.List
           [ Sexplib0.Sexp.Atom "With_backtrace"; res0__031_; res1__032_ ]
       : t -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_t
  end [@@merlin.hide]

  let rec to_sexps_hum (t : t) ac =
    match t with
    | Could_not_construct _ as t -> sexp_of_t t :: ac
    | String string -> Atom string :: ac
    | Exn { global = exn } -> Exn.sexp_of_t exn :: ac
    | Sexp sexp -> sexp :: ac
    | Tag_sexp (tag, sexp, here) ->
      List
        (Atom tag
         :: sexp
         ::
         (match here with
          | None -> []
          | Some here -> [ Source_code_position.sexp_of_t here ]))
      :: ac
    | Tag_t (tag, t) -> List (Atom tag :: to_sexps_hum t []) :: ac
    | Tag_arg (tag, sexp, t) ->
      let body = sexp :: to_sexps_hum t [] in
      if String.length tag = 0 then List body :: ac else List (Atom tag :: body) :: ac
    | With_backtrace (t, backtrace) ->
      Sexp.List
        [ to_sexp_hum t; sexp_of_list sexp_of_string (String.split_lines backtrace) ]
      :: ac
    | Of_list (_, ts) ->
      List.fold (List.rev ts) ~init:ac ~f:(fun ac t -> to_sexps_hum t ac)

  and to_sexp_hum t =
    match to_sexps_hum t [] with
    | sexp :: [] -> sexp
    | sexps -> Sexp.List sexps
  ;;
end

open Message

module Computed = struct
  type info = unstaged_info Modes.Global.t

  and unstaged_info =
    | Constant of Message.t
    | Staged_portable of portable_staged_info
    | Staged_nonportable of staged_info

  and portable_staged_info = { state : portable_state Portable_atomic.t } [@@unboxed]
  and staged_info = { state : state ref Modes.Contended_via_portable.t } [@@unboxed]

  and state =
    | Initial of info lazy_t constructor
    | Computing
    | Final of Message.t

  and portable_state =
    | Portable_initial of info Portable_lazy.t constructor
    | Portable_computing of Domain.id
    | Portable_final of Message.t

  and 'lazy_cons constructor =
    | Cons_lazy_info of 'lazy_cons
    | Cons_list of info list
    | Cons_tag_arg of string * Sexp.t * info
    | Cons_tag_t of string * info

  type 'info stack_frame =
    | In_tag_arg of string * Sexp.t
    | In_tag_t of string
    | In_list of
        { fwd_prefix : info list
        ; rev_suffix : Message.t list
        }
    | In_info of 'info

  module Portable_stack = struct
    type t =
      { portable : portable_staged_info stack_frame list
      ; nonportable : staged_info stack_frame list Modes.Portable_via_contended.t
      }

    let of_nonportable_suffix nonportable =
      { portable = []; nonportable = Modes.Portable_via_contended.wrap nonportable }
    ;;

    let push x { portable; nonportable } = { portable = x :: portable; nonportable }
  end

  let compute_frame frame message =
    match frame with
    | In_info info -> `Info info
    | In_tag_arg (tag, arg) -> `Frame (Tag_arg (tag, arg, message))
    | In_tag_t tag -> `Frame (Tag_t (tag, message))
    | In_list { fwd_prefix; rev_suffix } -> `List (fwd_prefix, message :: rev_suffix)
  ;;

  let compute_constructor_wrapper
    cons
    stack
    ~compute_info
    ~compute_message
    ~compute_info_list
    ~lazy_force
    ~push_stack
    =
    match cons with
    | Cons_tag_arg (tag, arg, info) ->
      compute_info info (push_stack (In_tag_arg (tag, arg)) stack)
    | Cons_tag_t (tag, info) -> compute_info info (push_stack (In_tag_t tag) stack)
    | Cons_list infos -> compute_info_list ~fwd_prefix:infos ~rev_suffix:[] stack
    | Cons_lazy_info lazy_info ->
      (match lazy_force lazy_info with
       | info -> compute_info info stack
       | exception exn -> compute_message (Could_not_construct (sexp_of_exn exn)) stack)
  ;;

  let rec compute_info (info : info) stack =
    match info.global with
    | Constant message -> compute_message message stack
    | Staged_portable portable_info ->
      compute_staged_portable portable_info (Portable_stack.of_nonportable_suffix stack)
    | Staged_nonportable info -> compute_staged_nonportable info stack

  and compute_info_portable (info : info) stack =
    match info.global with
    | Constant message -> compute_message_portable message stack
    | Staged_portable portable_info -> compute_staged_portable portable_info stack
    | Staged_nonportable info -> Modes.Contended_via_portable.refute_portable info.state

  and compute_staged_nonportable info stack =
    let state = Modes.Contended_via_portable.unwrap info.state in
    match !state with
    | Initial cons ->
      state := Computing;
      compute_constructor cons (In_info info :: stack)
    | Computing ->
      compute_message (Could_not_construct (Atom "cycle while computing message")) stack
    | Final message -> compute_message message stack

  and compute_staged_portable info stack =
    match Portable_atomic.get info.state with
    | Portable_initial cons as uncomputed ->
      let computing = Portable_computing (Domain.self ()) in
      (match Portable_atomic.compare_and_set info.state uncomputed computing with
       | false -> compute_staged_portable info stack
       | true ->
         compute_constructor_portable cons (Portable_stack.push (In_info info) stack))
    | Portable_computing id ->
      if equal (Domain.self () :> int) (id :> int)
      then
        compute_message_portable
          (Could_not_construct (Atom "cycle while computing message"))
          stack
      else (
        Domain.cpu_relax ();
        compute_staged_portable info stack)
    | Portable_final message -> compute_message_portable message stack

  and compute_info_list ~fwd_prefix ~rev_suffix stack =
    match fwd_prefix with
    | info :: fwd_prefix -> compute_info info (In_list { fwd_prefix; rev_suffix } :: stack)
    | [] ->
      let infos =
        List.fold rev_suffix ~init:[] ~f:(fun tail message ->
          match message with
          | Of_list (_, messages) -> messages @ tail
          | message -> message :: tail)
      in
      compute_message (Of_list (None, infos)) stack

  and compute_info_list_portable ~fwd_prefix ~rev_suffix stack =
    match fwd_prefix with
    | info :: fwd_prefix ->
      compute_info_portable
        info
        (Portable_stack.push (In_list { fwd_prefix; rev_suffix }) stack)
    | [] ->
      let infos =
        Modes.Portable.unwrap
          (List.fold
             (Modes.Portable.wrap_list rev_suffix)
             ~init:(Modes.Portable.wrap [])
             ~f:(fun tail message ->
               let tail = Modes.Portable.unwrap tail in
               let message =
                 match Modes.Portable.unwrap message with
                 | Of_list (_, messages) ->
                   Modes.Portable.unwrap_list
                     (Modes.Portable.wrap_list messages @ Modes.Portable.wrap_list tail)
                 | message -> message :: tail
               in
               Modes.Portable.wrap message))
      in
      compute_message_portable (Of_list (None, infos)) stack

  and compute_constructor cons stack =
    compute_constructor_wrapper
      cons
      stack
      ~compute_info
      ~compute_message
      ~compute_info_list
      ~lazy_force:Lazy.force
      ~push_stack:(fun x xs -> x :: xs)

  and compute_constructor_portable cons stack =
    compute_constructor_wrapper
      cons
      stack
      ~compute_info:compute_info_portable
      ~compute_message:compute_message_portable
      ~compute_info_list:compute_info_list_portable
      ~lazy_force:Portable_lazy.force
      ~push_stack:Portable_stack.push

  and compute_message_portable message (stack : Portable_stack.t) =
    match stack with
    | { portable = []; nonportable } ->
      compute_message message (Modes.Portable_via_contended.unwrap nonportable)
    | { portable = frame :: portable; nonportable } ->
      let stack : Portable_stack.t = { portable; nonportable } in
      (match compute_frame frame message with
       | `Frame message -> compute_message_portable message stack
       | `List (fwd_prefix, rev_suffix) ->
         compute_info_list_portable ~fwd_prefix ~rev_suffix stack
       | `Info info ->
         Portable_atomic.set info.state (Portable_final message);
         compute_message_portable message stack)

  and compute_message message stack =
    match stack with
    | [] -> message
    | frame :: stack ->
      (match compute_frame frame message with
       | `Frame message -> compute_message message stack
       | `List (fwd_prefix, rev_suffix) -> compute_info_list ~fwd_prefix ~rev_suffix stack
       | `Info info ->
         Modes.Contended_via_portable.unwrap info.state := Final message;
         compute_message message stack)
  ;;

  let to_message info = compute_info info []
  let of_message message : info = { global = Constant message }

  let is_computed : info -> bool =
    fun t ->
    match t.global with
    | Constant _ -> true
    | Staged_portable info ->
      (match Portable_atomic.get info.state with
       | Portable_initial _ | Portable_computing _ -> false
       | Portable_final _ -> true)
    | Staged_nonportable info ->
      let state = Modes.Contended_via_portable.unwrap info.state in
      (match !state with
       | Initial _ | Computing -> false
       | Final _ -> true)
  ;;

  let of_cons cons : info =
    Modes.Global.wrap
      (Staged_nonportable
         { state = Modes.Contended_via_portable.wrap (ref (Initial cons)) })
  ;;

  let of_portable_cons cons : info =
    { global = Staged_portable { state = Portable_atomic.make (Portable_initial cons) } }
  ;;

  let of_lazy_info lazy_info = of_cons (Cons_lazy_info lazy_info)
  let of_portable_lazy_info lazy_info = of_portable_cons (Cons_lazy_info lazy_info)
  let of_thunked_cons lazy_cons = of_cons (Cons_lazy_info (lazy (of_cons (lazy_cons ()))))

  let of_portable_thunked_cons lazy_cons =
    of_portable_cons
      (Cons_lazy_info (Portable_lazy.from_fun (fun () -> of_portable_cons (lazy_cons ()))))
  ;;

  let of_thunked_message lazy_message =
    of_cons (Cons_lazy_info (lazy (of_message (lazy_message ()))))
  ;;
end

open Computed

type t = Computed.info

let globalize x = x
let invariant _ = ()
let sexp_of_t t = Message.to_sexp_hum (to_message t)
let t_of_sexp sexp = of_message (Sexp sexp)
let t_sexp_grammar : t Sexplib0.Sexp_grammar.t = { untyped = Any "Info.t" }
let compare t1 t2 = Sexp.compare (sexp_of_t t1) (sexp_of_t t2)
let equal t1 t2 = Sexp.equal (sexp_of_t t1) (sexp_of_t t2)
let hash_fold_t state t = Sexp.hash_fold_t state (sexp_of_t t)
let hash t = Hash.run hash_fold_t t

let to_string_hum t =
  match to_message t with
  | String s -> s
  | message -> Sexp.to_string_hum (Message.to_sexp_hum message)
;;

let to_string_mach t = Sexp.to_string_mach (sexp_of_t t)
let of_string message = of_message (String message)
let create_s sexp = of_message (Sexp sexp)
let createf format = Printf.ksprintf of_string format
let createf_portable format = Printf.ksprintf (fun string () -> of_string string) format
let of_lazy_t = of_lazy_info
let of_lazy l = of_thunked_message (fun () -> String (Lazy.force l))
let of_lazy_sexp l = of_thunked_message (fun () -> Sexp (Lazy.force l))
let of_portable_lazy_t = of_portable_lazy_info
let of_portable_lazy l = of_thunked_message (fun () -> String (Portable_lazy.force l))
let of_portable_lazy_sexp l = of_thunked_message (fun () -> Sexp (Portable_lazy.force l))
let of_thunk f = of_thunked_message (fun () -> String (f ()))

let create ?here ?strict tag x sexp_of_x =
  match strict with
  | None -> of_thunked_message (fun () -> Tag_sexp (tag, sexp_of_x x, here))
  | Some () -> of_message (Tag_sexp (tag, sexp_of_x x, here))
;;

let tag t ~tag = of_cons (Cons_tag_t (tag, t))
let tag_s t ~tag = of_cons (Cons_tag_arg ("", tag, t))
let of_list ts = of_cons (Cons_list ts)
let tag_lazy t ~tag = of_thunked_cons (fun () -> Cons_tag_t (Lazy.force tag, t))

let tag_portable_lazy t ~tag =
  of_thunked_cons (fun () -> Cons_tag_t (Portable_lazy.force tag, t))
;;

let tag_s_lazy t ~tag = of_thunked_cons (fun () -> Cons_tag_arg ("", Lazy.force tag, t))

let tag_s_portable_lazy t ~tag =
  of_thunked_cons (fun () -> Cons_tag_arg ("", Portable_lazy.force tag, t))
;;

let tag_arg t tag x sexp_of_x =
  of_thunked_cons (fun () -> Cons_tag_arg (tag, sexp_of_x x, t))
;;

exception Exn of t

let () =
  Sexplib0.Sexp_conv.Exn_converter.add [%extension_constructor Exn] (function
    | Exn t -> sexp_of_t t
    | _ -> assert false)
;;

let portabilize (t : t) : t =
  match t.global with
  | Staged_portable x -> { global = Staged_portable x }
  | Constant x -> { global = Constant x }
  | Staged_nonportable _ -> of_message (to_message t)
;;

let to_exn t =
  if not (is_computed t)
  then Exn (portabilize t)
  else (
    match to_message t with
    | Exn { global = exn } -> exn
    | _ -> Exn (portabilize t))
;;

let of_exn ?backtrace exn =
  let backtrace =
    match backtrace with
    | None -> None
    | Some `Get -> Some (Stdlib.Printexc.get_backtrace ())
    | Some (`This s) -> Some s
  in
  match exn, backtrace with
  | Exn t, None -> t
  | Exn t, Some backtrace ->
    of_thunked_message (fun () -> With_backtrace (to_message t, backtrace))
  | _, None -> of_message (Exn { global = exn })
  | _, Some backtrace ->
    of_thunked_message (fun () -> With_backtrace (Sexp (Exn.sexp_of_t exn), backtrace))
;;

include Pretty_printer.Register_pp (struct
    type nonrec t = t

    let module_name = "Base.Info"
    let pp ppf t = Stdlib.Format.pp_print_string ppf (to_string_hum t)
  end)

module Internal_repr = struct
  include Message

  let to_info = of_message
  let of_info = to_message
end

module Portable = struct
  type nonrec t = t Modes.Portable.t

  include struct
    let _ = fun (_ : t) -> ()

    let compare =
      (fun a__033_ b__034_ ->
         Modes.Portable.compare
           (fun a__035_ (b__036_ [@merlin.hide]) ->
             compare a__035_ b__036_ [@merlin.hide])
           a__033_
           b__034_
       : t -> (t[@merlin.hide]) -> int)
    ;;

    let _ = compare

    let equal =
      (fun a__037_ b__038_ ->
         Modes.Portable.equal
           (fun a__039_ (b__040_ [@merlin.hide]) -> equal a__039_ b__040_ [@merlin.hide])
           a__037_
           b__038_
       : t -> (t[@merlin.hide]) -> bool)
    ;;

    let _ = equal

    let hash_fold_t : Ppx_hash_lib.Std.Hash.state -> t -> Ppx_hash_lib.Std.Hash.state =
      fun hsv arg -> Modes.Portable.hash_fold_t hash_fold_t hsv arg
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

    let t_of_sexp =
      (fun x__042_ -> Modes.Portable.t_of_sexp t_of_sexp x__042_ : Sexplib0.Sexp.t -> t)
    ;;

    let _ = t_of_sexp

    let sexp_of_t =
      (fun x__043_ -> Modes.Portable.sexp_of_t sexp_of_t x__043_ : t -> Sexplib0.Sexp.t)
    ;;

    let _ = sexp_of_t

    let t_sexp_grammar : t Sexplib0.Sexp_grammar.t =
      { untyped =
          Lazy
            (Basement.Portable_lazy.from_fun (fun () : Sexplib0.Sexp_grammar.grammar ->
               (Modes.Portable.t_sexp_grammar t_sexp_grammar).untyped))
      }
    ;;

    let _ = t_sexp_grammar
  end [@@merlin.hide]

  let globalize t =
    Modes.Portable.wrap (portabilize (globalize (Modes.Portable.unwrap t)))
  ;;

  let create_s sexp = Modes.Portable.wrap (create_s sexp)
  let of_string str = Modes.Portable.wrap (of_string str)
  let of_list xs = Modes.Portable.wrap (of_list (Modes.Portable.unwrap_list xs))
  let of_portable_lazy_sexp sexp = Modes.Portable.wrap (of_portable_lazy_sexp sexp)
  let of_portable_lazy str = Modes.Portable.wrap (of_portable_lazy str)

  let of_portable_lazy_t t =
    Modes.Portable.wrap
      (of_portable_lazy_t
         (Portable_lazy.map ~f:(fun (t : t) -> Modes.Portable.unwrap t) t))
  ;;

  let create ?here ?strict message arg sexp_of_arg =
    Modes.Portable.wrap (create ?here ?strict message arg sexp_of_arg)
  ;;

  let tag_s t ~tag = Modes.Portable.wrap (tag_s ~tag (Modes.Portable.unwrap t))
  let tag t ~tag:string = Modes.Portable.wrap (tag ~tag:string (Modes.Portable.unwrap t))

  let tag_arg t message x f =
    Modes.Portable.wrap (tag_arg (Modes.Portable.unwrap t) message x f)
  ;;

  let of_thunk f = Modes.Portable.wrap (of_thunk f)
  let createf fmt = Printf.ksprintf of_string fmt
end

let of_portable = Modes.Portable.unwrap
let to_portable = Modes.Portable.wrap
let to_portable_portabilize t = to_portable (portabilize t)
