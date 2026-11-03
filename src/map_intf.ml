open! Import0
module Either = Either0
module Nonempty_list = Nonempty_list_type.Nonempty_list
module Result = Result0
module Sexp = Sexp0

module Definitions = struct
  module Or_duplicate = struct
    type 'a t =
      [ `Ok of 'a
      | `Duplicate
      ]

    include struct
      let _ = fun (_ : 'a t) -> ()

      let compare
        : 'a. ('a -> ('a[@merlin.hide]) -> int) -> 'a t -> ('a t[@merlin.hide]) -> int
        =
        fun _cmp__a a__004_ b__005_ ->
        if Stdlib.( == ) a__004_ b__005_
        then 0
        else (
          match a__004_, b__005_ with
          | `Ok _left__006_, `Ok _right__007_ -> _cmp__a _left__006_ _right__007_
          | `Duplicate, `Duplicate -> 0
          | x, y -> Stdlib.compare x y)
      ;;

      let _ = compare

      let equal
        : 'a. ('a -> ('a[@merlin.hide]) -> bool) -> 'a t -> ('a t[@merlin.hide]) -> bool
        =
        fun _cmp__a a__008_ b__009_ ->
        if Stdlib.( == ) a__008_ b__009_
        then true
        else (
          match a__008_, b__009_ with
          | `Ok _left__010_, `Ok _right__011_ -> _cmp__a _left__010_ _right__011_
          | `Duplicate, `Duplicate -> true
          | x, y -> Stdlib.( = ) x y)
      ;;

      let _ = equal

      let sexp_of_t : 'a. ('a -> Sexplib0.Sexp.t) -> 'a t -> Sexplib0.Sexp.t =
        fun _of_a__012_ -> function
        | `Ok v__013_ ->
          Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Ok"; _of_a__012_ v__013_ ]
        | `Duplicate -> Sexplib0.Sexp.Atom "Duplicate"
      ;;

      let _ = sexp_of_t
    end [@@merlin.hide]
  end

  module Without_comparator = struct
    type ('key, 'cmp, 'z) t = 'z
  end

  module With_comparator = struct
    type ('key, 'cmp, 'z) t = comparator:('key, 'cmp) Comparator.t -> 'z
  end

  module With_first_class_module = struct
    type ('key, 'cmp, 'z) t = ('key, 'cmp) Comparator.Module.t -> 'z
  end

  module Symmetric_diff_element = struct
    type ('k, 'v) t = 'k * [ `Left of 'v | `Right of 'v | `Unequal of 'v * 'v ]

    include struct
      let _ = fun (_ : ('k, 'v) t) -> ()

      let compare
        : 'k 'v.
        ('k -> ('k[@merlin.hide]) -> int)
        -> ('v -> ('v[@merlin.hide]) -> int)
        -> ('k, 'v) t
        -> (('k, 'v) t[@merlin.hide])
        -> int
        =
        fun _cmp__k _cmp__v a__014_ b__015_ ->
        let t__016_, t__017_ = a__014_ in
        let t__018_, t__019_ = b__015_ in
        match _cmp__k t__016_ t__018_ with
        | 0 ->
          if Stdlib.( == ) t__017_ t__019_
          then 0
          else (
            match t__017_, t__019_ with
            | `Left _left__020_, `Left _right__021_ -> _cmp__v _left__020_ _right__021_
            | `Right _left__022_, `Right _right__023_ -> _cmp__v _left__022_ _right__023_
            | `Unequal _left__024_, `Unequal _right__025_ ->
              let t__026_, t__027_ = _left__024_ in
              let t__028_, t__029_ = _right__025_ in
              (match _cmp__v t__026_ t__028_ with
               | 0 -> _cmp__v t__027_ t__029_
               | n -> n)
            | x, y -> Stdlib.compare x y)
        | n -> n
      ;;

      let _ = compare

      let equal
        : 'k 'v.
        ('k -> ('k[@merlin.hide]) -> bool)
        -> ('v -> ('v[@merlin.hide]) -> bool)
        -> ('k, 'v) t
        -> (('k, 'v) t[@merlin.hide])
        -> bool
        =
        fun _cmp__k _cmp__v a__030_ b__031_ ->
        let t__032_, t__033_ = a__030_ in
        let t__034_, t__035_ = b__031_ in
        Stdlib.( && )
          (_cmp__k t__032_ t__034_)
          (if Stdlib.( == ) t__033_ t__035_
           then true
           else (
             match t__033_, t__035_ with
             | `Left _left__036_, `Left _right__037_ -> _cmp__v _left__036_ _right__037_
             | `Right _left__038_, `Right _right__039_ -> _cmp__v _left__038_ _right__039_
             | `Unequal _left__040_, `Unequal _right__041_ ->
               let t__042_, t__043_ = _left__040_ in
               let t__044_, t__045_ = _right__041_ in
               Stdlib.( && ) (_cmp__v t__042_ t__044_) (_cmp__v t__043_ t__045_)
             | x, y -> Stdlib.( = ) x y))
      ;;

      let _ = equal

      let t_of_sexp
        : 'k 'v.
        (Sexplib0.Sexp.t -> 'k)
        -> (Sexplib0.Sexp.t -> 'v)
        -> Sexplib0.Sexp.t
        -> ('k, 'v) t
        =
        let error_source__060_ =
          "../../../../lib/base/src/map_intf.ml.Definitions.Symmetric_diff_element.t"
        in
        fun _of_k__046_ _of_v__047_ -> function
          | Sexplib0.Sexp.List [ arg0__070_; arg1__071_ ] ->
            let res0__072_ = _of_k__046_ arg0__070_
            and res1__073_ =
              let sexp__069_ = arg1__071_ in
              try
                match sexp__069_ with
                | Sexplib0.Sexp.Atom atom__050_ as _sexp__052_ ->
                  (match atom__050_ with
                   | "Left" ->
                     Sexplib0.Sexp_conv_error.ptag_takes_args
                       error_source__060_
                       _sexp__052_
                   | "Right" ->
                     Sexplib0.Sexp_conv_error.ptag_takes_args
                       error_source__060_
                       _sexp__052_
                   | "Unequal" ->
                     Sexplib0.Sexp_conv_error.ptag_takes_args
                       error_source__060_
                       _sexp__052_
                   | _ -> Sexplib0.Sexp_conv_error.no_variant_match ())
                | Sexplib0.Sexp.List (Sexplib0.Sexp.Atom atom__050_ :: sexp_args__053_) as
                  _sexp__052_ ->
                  (match atom__050_ with
                   | "Left" as _tag__066_ ->
                     (match sexp_args__053_ with
                      | arg0__067_ :: [] ->
                        let res0__068_ = _of_v__047_ arg0__067_ in
                        `Left res0__068_
                      | _ ->
                        Sexplib0.Sexp_conv_error.ptag_incorrect_n_args
                          error_source__060_
                          _tag__066_
                          _sexp__052_)
                   | "Right" as _tag__063_ ->
                     (match sexp_args__053_ with
                      | arg0__064_ :: [] ->
                        let res0__065_ = _of_v__047_ arg0__064_ in
                        `Right res0__065_
                      | _ ->
                        Sexplib0.Sexp_conv_error.ptag_incorrect_n_args
                          error_source__060_
                          _tag__063_
                          _sexp__052_)
                   | "Unequal" as _tag__054_ ->
                     (match sexp_args__053_ with
                      | arg0__061_ :: [] ->
                        let res0__062_ =
                          match arg0__061_ with
                          | Sexplib0.Sexp.List [ arg0__055_; arg1__056_ ] ->
                            let res0__057_ = _of_v__047_ arg0__055_
                            and res1__058_ = _of_v__047_ arg1__056_ in
                            res0__057_, res1__058_
                          | sexp__059_ ->
                            Sexplib0.Sexp_conv_error.tuple_of_size_n_expected
                              error_source__060_
                              2
                              sexp__059_
                        in
                        `Unequal res0__062_
                      | _ ->
                        Sexplib0.Sexp_conv_error.ptag_incorrect_n_args
                          error_source__060_
                          _tag__054_
                          _sexp__052_)
                   | _ -> Sexplib0.Sexp_conv_error.no_variant_match ())
                | Sexplib0.Sexp.List (Sexplib0.Sexp.List _ :: _) as sexp__051_ ->
                  Sexplib0.Sexp_conv_error.nested_list_invalid_poly_var
                    error_source__060_
                    sexp__051_
                | Sexplib0.Sexp.List [] as sexp__051_ ->
                  Sexplib0.Sexp_conv_error.empty_list_invalid_poly_var
                    error_source__060_
                    sexp__051_
              with
              | Sexplib0.Sexp_conv_error.No_variant_match ->
                Sexplib0.Sexp_conv_error.no_matching_variant_found
                  error_source__060_
                  sexp__069_
            in
            res0__072_, res1__073_
          | sexp__074_ ->
            Sexplib0.Sexp_conv_error.tuple_of_size_n_expected
              error_source__060_
              2
              sexp__074_
      ;;

      let _ = t_of_sexp

      let sexp_of_t
        : 'k 'v.
        ('k -> Sexplib0.Sexp.t)
        -> ('v -> Sexplib0.Sexp.t)
        -> ('k, 'v) t
        -> Sexplib0.Sexp.t
        =
        fun _of_k__075_ _of_v__076_ (arg0__084_, arg1__085_) ->
        let res0__086_ = _of_k__075_ arg0__084_
        and res1__087_ =
          match arg1__085_ with
          | `Left v__077_ ->
            Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Left"; _of_v__076_ v__077_ ]
          | `Right v__078_ ->
            Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Right"; _of_v__076_ v__078_ ]
          | `Unequal v__079_ ->
            Sexplib0.Sexp.List
              [ Sexplib0.Sexp.Atom "Unequal"
              ; (let arg0__080_, arg1__081_ = v__079_ in
                 let res0__082_ = _of_v__076_ arg0__080_
                 and res1__083_ = _of_v__076_ arg1__081_ in
                 Sexplib0.Sexp.List [ res0__082_; res1__083_ ])
              ]
        in
        Sexplib0.Sexp.List [ res0__086_; res1__087_ ]
      ;;

      let _ = sexp_of_t

      let t_sexp_grammar
        : 'k 'v.
        'k Sexplib0.Sexp_grammar.t
        -> 'v Sexplib0.Sexp_grammar.t
        -> ('k, 'v) t Sexplib0.Sexp_grammar.t
        =
        fun _'k_sexp_grammar _'v_sexp_grammar ->
        { untyped =
            List
              (Cons
                 ( _'k_sexp_grammar.untyped
                 , Cons
                     ( Variant
                         { case_sensitivity = Case_sensitive
                         ; clauses =
                             [ No_tag
                                 { name = "Left"
                                 ; clause_kind =
                                     List_clause
                                       { args = Cons (_'v_sexp_grammar.untyped, Empty) }
                                 }
                             ; No_tag
                                 { name = "Right"
                                 ; clause_kind =
                                     List_clause
                                       { args = Cons (_'v_sexp_grammar.untyped, Empty) }
                                 }
                             ; No_tag
                                 { name = "Unequal"
                                 ; clause_kind =
                                     List_clause
                                       { args =
                                           Cons
                                             ( List
                                                 (Cons
                                                    ( _'v_sexp_grammar.untyped
                                                    , Cons
                                                        (_'v_sexp_grammar.untyped, Empty)
                                                    ))
                                             , Empty )
                                       }
                                 }
                             ]
                         }
                     , Empty ) ))
        }
      ;;

      let _ = t_sexp_grammar
    end [@@merlin.hide]
  end

  module Merge_element = struct
    type ('left, 'right) t =
      [ `Left of 'left
      | `Right of 'right
      | `Both of 'left * 'right
      ]

    include struct
      let _ = fun (_ : ('left, 'right) t) -> ()

      let compare
        : 'left 'right.
        ('left -> ('left[@merlin.hide]) -> int)
        -> ('right -> ('right[@merlin.hide]) -> int)
        -> ('left, 'right) t
        -> (('left, 'right) t[@merlin.hide])
        -> int
        =
        fun _cmp__left _cmp__right a__088_ b__089_ ->
        if Stdlib.( == ) a__088_ b__089_
        then 0
        else (
          match a__088_, b__089_ with
          | `Left _left__090_, `Left _right__091_ -> _cmp__left _left__090_ _right__091_
          | `Right _left__092_, `Right _right__093_ ->
            _cmp__right _left__092_ _right__093_
          | `Both _left__094_, `Both _right__095_ ->
            let t__096_, t__097_ = _left__094_ in
            let t__098_, t__099_ = _right__095_ in
            (match _cmp__left t__096_ t__098_ with
             | 0 -> _cmp__right t__097_ t__099_
             | n -> n)
          | x, y -> Stdlib.compare x y)
      ;;

      let _ = compare

      let equal
        : 'left 'right.
        ('left -> ('left[@merlin.hide]) -> bool)
        -> ('right -> ('right[@merlin.hide]) -> bool)
        -> ('left, 'right) t
        -> (('left, 'right) t[@merlin.hide])
        -> bool
        =
        fun _cmp__left _cmp__right a__100_ b__101_ ->
        if Stdlib.( == ) a__100_ b__101_
        then true
        else (
          match a__100_, b__101_ with
          | `Left _left__102_, `Left _right__103_ -> _cmp__left _left__102_ _right__103_
          | `Right _left__104_, `Right _right__105_ ->
            _cmp__right _left__104_ _right__105_
          | `Both _left__106_, `Both _right__107_ ->
            let t__108_, t__109_ = _left__106_ in
            let t__110_, t__111_ = _right__107_ in
            Stdlib.( && ) (_cmp__left t__108_ t__110_) (_cmp__right t__109_ t__111_)
          | x, y -> Stdlib.( = ) x y)
      ;;

      let _ = equal

      let sexp_of_t
        : 'left 'right.
        ('left -> Sexplib0.Sexp.t)
        -> ('right -> Sexplib0.Sexp.t)
        -> ('left, 'right) t
        -> Sexplib0.Sexp.t
        =
        fun _of_left__112_ _of_right__113_ -> function
        | `Left v__114_ ->
          Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Left"; _of_left__112_ v__114_ ]
        | `Right v__115_ ->
          Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Right"; _of_right__113_ v__115_ ]
        | `Both v__116_ ->
          Sexplib0.Sexp.List
            [ Sexplib0.Sexp.Atom "Both"
            ; (let arg0__117_, arg1__118_ = v__116_ in
               let res0__119_ = _of_left__112_ arg0__117_
               and res1__120_ = _of_right__113_ arg1__118_ in
               Sexplib0.Sexp.List [ res0__119_; res1__120_ ])
            ]
      ;;

      let _ = sexp_of_t
    end [@@merlin.hide]
  end

  module When_unmatched = struct
    type ('k, 'a, 'b) t =
      | Drop
      | Keep : (_, 'a, 'a) t
      | Map of (key:'k -> data:'a -> 'b)
      | Filter : (key:'k -> data:'a -> bool) -> ('k, 'a, 'a) t
      | Filter_map of (key:'k -> data:'a -> 'b option)

    include struct
      let _ = fun (_ : ('k, 'a, 'b) t) -> ()

      let sexp_of_t
        : 'k 'a 'b.
        ('k -> Sexplib0.Sexp.t)
        -> ('a -> Sexplib0.Sexp.t)
        -> ('b -> Sexplib0.Sexp.t)
        -> ('k, 'a, 'b) t
        -> Sexplib0.Sexp.t
        =
        fun (type k__130_ a__131_ b__132_)
          :  ((k__130_ -> Sexplib0.Sexp.t) -> (a__131_ -> Sexplib0.Sexp.t)
          -> (b__132_ -> Sexplib0.Sexp.t) -> (k__130_, a__131_, b__132_) t
          -> Sexplib0.Sexp.t) ->
        fun _of_k__121_ _of_a__122_ _of_b__123_ -> function
        | Drop -> Sexplib0.Sexp.Atom "Drop"
        | Keep -> Sexplib0.Sexp.Atom "Keep"
        | Map arg0__124_ ->
          let res0__125_ =
            let _ = arg0__124_ in
            Sexplib0.Sexp_conv.sexp_of_fun Sexplib0.Sexp_conv.ignore
          in
          Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Map"; res0__125_ ]
        | Filter arg0__126_ ->
          let res0__127_ =
            let _ = arg0__126_ in
            Sexplib0.Sexp_conv.sexp_of_fun Sexplib0.Sexp_conv.ignore
          in
          Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Filter"; res0__127_ ]
        | Filter_map arg0__128_ ->
          let res0__129_ =
            let _ = arg0__128_ in
            Sexplib0.Sexp_conv.sexp_of_fun Sexplib0.Sexp_conv.ignore
          in
          Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Filter_map"; res0__129_ ]
      ;;

      let _ = sexp_of_t
    end [@@merlin.hide]
  end

  module When_matched = struct
    type ('k, 'a, 'b, 'c) t =
      | Drop
      | Keep_first : (_, 'a, _, 'a) t
      | Keep_second : (_, _, 'a, 'a) t
      | Map of (key:'k -> 'a -> 'b -> 'c)
      | Filter_first : (key:'k -> 'a -> 'b -> bool) -> ('k, 'a, 'b, 'a) t
      | Filter_second : (key:'k -> 'a -> 'b -> bool) -> ('k, 'a, 'b, 'b) t
      | Filter_map of (key:'k -> 'a -> 'b -> 'c option)

    include struct
      let _ = fun (_ : ('k, 'a, 'b, 'c) t) -> ()

      let sexp_of_t
        : 'k 'a 'b 'c.
        ('k -> Sexplib0.Sexp.t)
        -> ('a -> Sexplib0.Sexp.t)
        -> ('b -> Sexplib0.Sexp.t)
        -> ('c -> Sexplib0.Sexp.t)
        -> ('k, 'a, 'b, 'c) t
        -> Sexplib0.Sexp.t
        =
        fun (type k__145_ a__146_ b__147_ c__148_)
          :  ((k__145_ -> Sexplib0.Sexp.t) -> (a__146_ -> Sexplib0.Sexp.t)
          -> (b__147_ -> Sexplib0.Sexp.t) -> (c__148_ -> Sexplib0.Sexp.t)
          -> (k__145_, a__146_, b__147_, c__148_) t -> Sexplib0.Sexp.t) ->
        fun _of_k__133_ _of_a__134_ _of_b__135_ _of_c__136_ -> function
        | Drop -> Sexplib0.Sexp.Atom "Drop"
        | Keep_first -> Sexplib0.Sexp.Atom "Keep_first"
        | Keep_second -> Sexplib0.Sexp.Atom "Keep_second"
        | Map arg0__137_ ->
          let res0__138_ =
            let _ = arg0__137_ in
            Sexplib0.Sexp_conv.sexp_of_fun Sexplib0.Sexp_conv.ignore
          in
          Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Map"; res0__138_ ]
        | Filter_first arg0__139_ ->
          let res0__140_ =
            let _ = arg0__139_ in
            Sexplib0.Sexp_conv.sexp_of_fun Sexplib0.Sexp_conv.ignore
          in
          Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Filter_first"; res0__140_ ]
        | Filter_second arg0__141_ ->
          let res0__142_ =
            let _ = arg0__141_ in
            Sexplib0.Sexp_conv.sexp_of_fun Sexplib0.Sexp_conv.ignore
          in
          Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Filter_second"; res0__142_ ]
        | Filter_map arg0__143_ ->
          let res0__144_ =
            let _ = arg0__143_ in
            Sexplib0.Sexp_conv.sexp_of_fun Sexplib0.Sexp_conv.ignore
          in
          Sexplib0.Sexp.List [ Sexplib0.Sexp.Atom "Filter_map"; res0__144_ ]
      ;;

      let _ = sexp_of_t
    end [@@merlin.hide]
  end

  module Continue_or_stop = struct
    type t =
      | Continue
      | Stop

    include struct
      let _ = fun (_ : t) -> ()
      let compare = (Stdlib.compare : t -> (t[@merlin.hide]) -> int)
      let _ = compare
      let all = ([ Continue; Stop ] : t list)
      let _ = all
      let equal = (Stdlib.( = ) : t -> (t[@merlin.hide]) -> bool)
      let _ = equal

      let sexp_of_t =
        (function
         | Continue -> Sexplib0.Sexp.Atom "Continue"
         | Stop -> Sexplib0.Sexp.Atom "Stop"
         : t -> Sexplib0.Sexp.t)
      ;;

      let _ = sexp_of_t
    end [@@merlin.hide]
  end

  module Finished_or_unfinished = struct
    type t =
      | Finished
      | Unfinished

    include struct
      let _ = fun (_ : t) -> ()
      let compare = (Stdlib.compare : t -> (t[@merlin.hide]) -> int)
      let _ = compare
      let all = ([ Finished; Unfinished ] : t list)
      let _ = all
      let equal = (Stdlib.( = ) : t -> (t[@merlin.hide]) -> bool)
      let _ = equal

      let sexp_of_t =
        (function
         | Finished -> Sexplib0.Sexp.Atom "Finished"
         | Unfinished -> Sexplib0.Sexp.Atom "Unfinished"
         : t -> Sexplib0.Sexp.t)
      ;;

      let _ = sexp_of_t
    end [@@merlin.hide]
  end

  module type Accessors_generic = sig
    type ('a, 'b, 'cmp) t
    type ('a, 'b, 'cmp) tree
    type 'a key
    type 'cmp cmp
    type ('a, 'cmp, 'z) access_options

    include
      Dictionary_immutable.Accessors
      with type 'key key := 'key key
       and type ('key, 'data, 'cmp) t := ('key, 'data, 'cmp) t
       and type ('fn, 'key, _, 'cmp) accessor := ('key, 'cmp, 'fn) access_options

    val invariants : ('k, 'cmp, ('k, 'v, 'cmp) t -> bool) access_options
    val find_or_null : ('k, 'cmp, ('k, 'v, 'cmp) t -> 'k key -> 'v or_null) access_options

    val iteri_until
      :  ('k, 'v, _) t
      -> f:(key:'k key -> data:'v -> Continue_or_stop.t)
      -> Finished_or_unfinished.t

    val iter2
      : ( 'k
          , 'cmp
          , ('k, 'v1, 'cmp) t
            -> ('k, 'v2, 'cmp) t
            -> f:(key:'k key -> data:('v1, 'v2) Merge_element.t -> unit)
            -> unit )
          access_options

    val fold_right
      :  ('k, 'v, _) t
      -> init:'acc
      -> f:(key:'k key -> data:'v -> 'acc -> 'acc)
      -> 'acc

    val fold2
      : ( 'k
          , 'cmp
          , ('k, 'v1, 'cmp) t
            -> ('k, 'v2, 'cmp) t
            -> init:'acc
            -> f:(key:'k key -> data:('v1, 'v2) Merge_element.t -> 'acc -> 'acc)
            -> 'acc )
          access_options

    val compare_direct
      : ( 'k
          , 'cmp
          , ('v -> 'v -> int) -> ('k, 'v, 'cmp) t -> ('k, 'v, 'cmp) t -> int )
          access_options

    val equal
      : ( 'k
          , 'cmp
          , ('v -> 'v -> bool) -> ('k, 'v, 'cmp) t -> ('k, 'v, 'cmp) t -> bool )
          access_options

    val to_alist
      :  ?key_order:[ `Increasing | `Decreasing ]
      -> ('k, 'v, _) t
      -> ('k key * 'v) list

    val fold_range_inclusive
      : ( 'k
          , 'cmp
          , ('k, 'v, 'cmp) t
            -> min:'k key
            -> max:'k key
            -> init:'acc
            -> f:(key:'k key -> data:'v -> 'acc -> 'acc)
            -> 'acc )
          access_options

    val range_to_alist
      : ( 'k
          , 'cmp
          , ('k, 'v, 'cmp) t -> min:'k key -> max:'k key -> ('k key * 'v) list )
          access_options

    val closest_key
      : ( 'k
          , 'cmp
          , ('k, 'v, 'cmp) t
            -> [ `Greater_or_equal_to | `Greater_than | `Less_or_equal_to | `Less_than ]
            -> 'k key
            -> ('k key * 'v) option )
          access_options

    val nth : ('k, 'v, 'cmp) t -> int -> ('k key * 'v) option
    val nth_exn : ('k, 'v, 'cmp) t -> int -> 'k key * 'v
    val rank : ('k, 'cmp, ('k, _, 'cmp) t -> 'k key -> int option) access_options
    val count_lt : ('k, 'cmp, ('k, _, 'cmp) t -> 'k key -> int) access_options
    val count_le : ('k, 'cmp, ('k, _, 'cmp) t -> 'k key -> int) access_options
    val count_gt : ('k, 'cmp, ('k, _, 'cmp) t -> 'k key -> int) access_options
    val count_ge : ('k, 'cmp, ('k, _, 'cmp) t -> 'k key -> int) access_options
    val to_tree : ('k, 'v, 'cmp) t -> ('k key, 'v, 'cmp) tree

    val to_sequence
      : ( 'k
          , 'cmp
          , ?order:[ `Increasing_key | `Decreasing_key ]
            -> ?keys_greater_or_equal_to:'k key
            -> ?keys_less_or_equal_to:'k key
            -> ('k, 'v, 'cmp) t
            -> ('k key * 'v) Sequence.t )
          access_options

    val binary_search
      : ( 'k
          , 'cmp
          , ('k, 'v, 'cmp) t
            -> compare:(key:'k key -> data:'v -> 'key -> int)
            -> Binary_searchable.Which_target_by_key.t
            -> 'key
            -> ('k key * 'v) option )
          access_options

    val binary_search_segmented
      : ( 'k
          , 'cmp
          , ('k, 'v, 'cmp) t
            -> segment_of:(key:'k key -> data:'v -> [ `Left | `Right ])
            -> Binary_searchable.Which_target_by_segment.t
            -> ('k key * 'v) option )
          access_options

    val binary_search_subrange
      : ( 'k
          , 'cmp
          , ('k, 'v, 'cmp) t
            -> compare:(key:'k key -> data:'v -> 'bound -> int)
            -> lower_bound:'bound Maybe_bound.t
            -> upper_bound:'bound Maybe_bound.t
            -> ('k, 'v, 'cmp) t )
          access_options
  end

  module type Transformers_generic = sig
    type ('a, 'b, 'cmp) t
    type ('a, 'b, 'cmp) tree
    type 'a key
    type 'cmp cmp
    type ('a, 'cmp, 'z) access_options

    include
      Dictionary_immutable.Transformers
      with type 'key key := 'key key
       and type ('key, 'data, 'cmp) t := ('key, 'data, 'cmp) t
       and type ('fn, 'key, _, 'cmp) transformer := ('key, 'cmp, 'fn) access_options

    val change_or_null
      : ( 'k
          , 'cmp
          , ('k, 'v, 'cmp) t -> 'k key -> f:('v or_null -> 'v or_null) -> ('k, 'v, 'cmp) t
          )
          access_options

    val update_or_null
      : ( 'k
          , 'cmp
          , ('k, 'v, 'cmp) t -> 'k key -> f:('v or_null -> 'v) -> ('k, 'v, 'cmp) t )
          access_options

    val split
      : ( 'k
          , 'cmp
          , ('k, 'v, 'cmp) t
            -> 'k key
            -> ('k, 'v, 'cmp) t * ('k key * 'v) option * ('k, 'v, 'cmp) t )
          access_options

    val split_le_gt
      : ( 'k
          , 'cmp
          , ('k, 'v, 'cmp) t -> 'k key -> ('k, 'v, 'cmp) t * ('k, 'v, 'cmp) t )
          access_options

    val split_lt_ge
      : ( 'k
          , 'cmp
          , ('k, 'v, 'cmp) t -> 'k key -> ('k, 'v, 'cmp) t * ('k, 'v, 'cmp) t )
          access_options

    val split_n : ('k, 'v, 'cmp) t -> int -> ('k, 'v, 'cmp) t * ('k, 'v, 'cmp) t

    val append
      : ( 'k
          , 'cmp
          , lower_part:('k, 'v, 'cmp) t
            -> upper_part:('k, 'v, 'cmp) t
            -> [ `Ok of ('k, 'v, 'cmp) t | `Overlapping_key_ranges ] )
          access_options

    val subrange
      : ( 'k
          , 'cmp
          , ('k, 'v, 'cmp) t
            -> lower_bound:'k key Maybe_bound.t
            -> upper_bound:'k key Maybe_bound.t
            -> ('k, 'v, 'cmp) t )
          access_options

    val merge
      : ( 'k
          , 'cmp
          , ('k, 'v1, 'cmp) t
            -> ('k, 'v2, 'cmp) t
            -> f:(key:'k key -> ('v1, 'v2) Merge_element.t -> 'v3 option)
            -> ('k, 'v3, 'cmp) t )
          access_options

    val merge_disjoint_exn
      : ( 'k
          , 'cmp
          , ('k, 'v, 'cmp) t -> ('k, 'v, 'cmp) t -> ('k, 'v, 'cmp) t )
          access_options

    val merge_skewed
      : ( 'k
          , 'cmp
          , ('k, 'v, 'cmp) t
            -> ('k, 'v, 'cmp) t
            -> combine:(key:'k key -> 'v -> 'v -> 'v)
            -> ('k, 'v, 'cmp) t )
          access_options

    val merge_by_case
      : ( 'k
          , 'cmp
          , ('k, 'v1, 'cmp) t
            -> ('k, 'v2, 'cmp) t
            -> first:('k key, 'v1, 'v3) When_unmatched.t
            -> second:('k key, 'v2, 'v3) When_unmatched.t
            -> both:('k key, 'v1, 'v2, 'v3) When_matched.t
            -> ('k, 'v3, 'cmp) t )
          access_options

    val merge_aligned
      : ( 'k
          , 'cmp
          , ('k, 'v1, 'cmp) t
            -> ('k, 'v2, 'cmp) t
            -> f:(key:'k key -> 'v1 -> 'v2 -> 'v)
            -> ('k, 'v, 'cmp) t Or_error.t )
          access_options

    val zip
      : ( 'k
          , 'cmp
          , ('k, 'v1, 'cmp) t -> ('k, 'v2, 'cmp) t -> ('k, 'v1 * 'v2, 'cmp) t Or_error.t
          )
          access_options

    val zip_exn
      : ( 'k
          , 'cmp
          , ('k, 'v1, 'cmp) t -> ('k, 'v2, 'cmp) t -> ('k, 'v1 * 'v2, 'cmp) t )
          access_options

    val filter_map_or_null
      :  ('k, 'v1, 'cmp) t
      -> f:('v1 -> 'v2 or_null)
      -> ('k, 'v2, 'cmp) t

    val filter_mapi_or_null
      :  ('k, 'v1, 'cmp) t
      -> f:(key:'k key -> data:'v1 -> 'v2 or_null)
      -> ('k, 'v2, 'cmp) t

    val filter_opt : ('k, 'v option, 'cmp) t -> ('k, 'v, 'cmp) t

    module Make_applicative_traversals : functor (A : Applicative.Lazy_applicative) -> sig
      val mapi
        :  ('k, 'v1, 'cmp) t
        -> f:(key:'k key -> data:'v1 -> 'v2 A.t)
        -> ('k, 'v2, 'cmp) t A.t

      val filter_mapi
        :  ('k, 'v1, 'cmp) t
        -> f:(key:'k key -> data:'v1 -> 'v2 option A.t)
        -> ('k, 'v2, 'cmp) t A.t
    end
  end

  module type Creators_generic = sig
    type ('k, 'v, 'cmp) t
    type ('k, 'v, 'cmp) map
    type ('k, 'v, 'cmp) tree
    type 'k key
    type 'k map_key
    type ('a, 'cmp, 'z) create_options
    type ('a, 'cmp, 'z) access_options
    type 'cmp cmp

    include
      Dictionary_immutable.Creators
      with type 'key key := 'key key
       and type ('key, 'data, 'cmp) t := ('key, 'data, 'cmp) t
       and type ('fn, 'key, _, 'cmp) creator := ('key, 'cmp, 'fn) create_options

    val map_keys
      : ( 'k2
          , 'cmp2
          , ('k1, 'v, 'cmp1) map
            -> f:('k1 map_key -> 'k2 key)
            -> [ `Ok of ('k2, 'v, 'cmp2) t | `Duplicate_key of 'k2 key ] )
          create_options

    val map_keys_exn
      : ( 'k2
          , 'cmp2
          , ('k1, 'v, 'cmp1) map -> f:('k1 map_key -> 'k2 key) -> ('k2, 'v, 'cmp2) t )
          create_options

    val transpose_keys
      : ( 'k1
          , 'cmp1
          , ( 'k2
              , 'cmp2
              , ('k1, ('k2, 'a, 'cmp2) t, 'cmp1) map
                -> ('k2, ('k1, 'a, 'cmp1) map, 'cmp2) t )
              create_options )
          access_options

    val of_sorted_array
      : ('k, 'cmp, ('k key * 'v) array -> ('k, 'v, 'cmp) t Or_error.t) create_options

    val of_sorted_array_unchecked
      : ('k, 'cmp, ('k key * 'v) array -> ('k, 'v, 'cmp) t) create_options

    val of_increasing_iterator_unchecked
      : ('k, 'cmp, len:int -> f:(int -> 'k key * 'v) -> ('k, 'v, 'cmp) t) create_options

    val of_increasing_sequence
      : ('k, 'cmp, ('k key * 'v) Sequence.t -> ('k, 'v, 'cmp) t Or_error.t) create_options

    val of_list_with_key_fold
      : ( 'k
          , 'cmp
          , 'v list
            -> get_key:('v -> 'k key)
            -> init:'acc
            -> f:('acc -> 'v -> 'acc)
            -> ('k, 'acc, 'cmp) t )
          create_options

    val of_list_with_key_reduce
      : ( 'k
          , 'cmp
          , 'v list -> get_key:('v -> 'k key) -> f:('v -> 'v -> 'v) -> ('k, 'v, 'cmp) t
          )
          create_options

    val of_tree : ('k, 'cmp, ('k key, 'v, 'cmp) tree -> ('k, 'v, 'cmp) t) create_options
  end

  module type Creators_and_accessors_and_transformers_generic = sig
    type ('a, 'b, 'c) t
    type ('a, 'b, 'c) map
    type ('a, 'b, 'c) tree
    type 'a key
    type 'a map_key
    type 'a cmp
    type ('a, 'b, 'c) create_options
    type ('a, 'b, 'c) access_options

    include
      Creators_generic
      with type ('a, 'b, 'c) t := ('a, 'b, 'c) t
      with type ('a, 'b, 'c) map := ('a, 'b, 'c) map
      with type ('a, 'b, 'c) tree := ('a, 'b, 'c) tree
      with type 'a key := 'a key
      with type 'a map_key := 'a map_key
      with type 'a cmp := 'a cmp
      with type ('a, 'b, 'c) create_options := ('a, 'b, 'c) create_options
      with type ('a, 'b, 'c) access_options := ('a, 'b, 'c) access_options

    include
      Transformers_generic
      with type ('a, 'b, 'c) t := ('a, 'b, 'c) t
      with type ('a, 'b, 'c) tree := ('a, 'b, 'c) tree
      with type 'a key := 'a key
      with type 'a cmp := 'a cmp
      with type ('a, 'b, 'c) access_options := ('a, 'b, 'c) access_options

    include
      Accessors_generic
      with type ('a, 'b, 'c) t := ('a, 'b, 'c) t
      with type ('a, 'b, 'c) tree := ('a, 'b, 'c) tree
      with type 'a key := 'a key
      with type 'a cmp := 'a cmp
      with type ('a, 'b, 'c) access_options := ('a, 'b, 'c) access_options
  end

  module type S_poly = sig
    type ('a, 'b) t
    type ('a, 'b) map
    type ('a, 'b) tree
    type comparator_witness

    include
      Creators_and_accessors_and_transformers_generic
      with type ('a, 'b, 'c) t := ('a, 'b) t
      with type ('a, 'b, 'c) map := ('a, 'b) map
      with type ('a, 'b, 'c) tree := ('a, 'b) tree
      with type 'k key := 'k
      with type 'k map_key := 'k
      with type 'c cmp := comparator_witness
      with type ('a, 'b, 'c) create_options := ('a, 'b, 'c) Without_comparator.t
      with type ('a, 'b, 'c) access_options := ('a, 'b, 'c) Without_comparator.t
  end

  module type For_deriving = sig
    type ('a, 'b, 'c) t

    module type Sexp_of_m = Sexpable.Sexp_of

    module type M_of_sexp = sig
      type t

      include sig
        [@@@ocaml.warning "-32"]

        val t_of_sexp : Sexplib0.Sexp.t -> t
      end
      [@@merlin.hide]

      include Comparator.S with type t := t
    end

    module type M_sexp_grammar = sig
      type t

      include sig
        [@@@ocaml.warning "-32"]

        val t_sexp_grammar : t Sexplib0.Sexp_grammar.t
      end
      [@@merlin.hide]
    end

    module type Compare_m = sig end
    module type Equal_m = sig end
    module type Hash_fold_m = Hasher.S
    module type Globalize_m = sig end

    val sexp_of_m__t
      :  (module Sexp_of_m with type t = 'k)
      -> ('v -> Sexp.t)
      -> ('k, 'v, 'cmp) t
      -> Sexp.t

    val m__t_of_sexp
      :  (module M_of_sexp with type t = 'k and type comparator_witness = 'cmp)
      -> (Sexp.t -> 'v)
      -> Sexp.t
      -> ('k, 'v, 'cmp) t

    val m__t_sexp_grammar
      :  (module M_sexp_grammar with type t = 'k)
      -> 'v Sexplib0.Sexp_grammar.t
      -> ('k, 'v, 'cmp) t Sexplib0.Sexp_grammar.t

    val compare_m__t
      :  (module Compare_m)
      -> ('v -> 'v -> int)
      -> ('k, 'v, 'cmp) t
      -> ('k, 'v, 'cmp) t
      -> int

    val equal_m__t
      :  (module Equal_m)
      -> ('v -> 'v -> bool)
      -> ('k, 'v, 'cmp) t
      -> ('k, 'v, 'cmp) t
      -> bool

    val globalize_m__t : (module Globalize_m) -> _ -> ('k, 'v, 'cmp) t -> ('k, 'v, 'cmp) t

    val hash_fold_m__t
      :  (module Hash_fold_m with type t = 'k)
      -> (Hash.state -> 'v -> Hash.state)
      -> Hash.state
      -> ('k, 'v, _) t
      -> Hash.state
  end

  module type Enum = sig
    type ('k, 'v, 'cmp) tree
    type increasing
    type decreasing

    type ('k, 'v, 'cmp, 'direction) nonempty
    and ('k, 'v, 'cmp, 'direction) t = ('k, 'v, 'cmp, 'direction) nonempty or_null

    include sig
      [@@@ocaml.warning "-32"]

      val sexp_of_nonempty
        :  ('k -> Sexplib0.Sexp.t)
        -> ('v -> Sexplib0.Sexp.t)
        -> ('cmp -> Sexplib0.Sexp.t)
        -> ('direction -> Sexplib0.Sexp.t)
        -> ('k, 'v, 'cmp, 'direction) nonempty
        -> Sexplib0.Sexp.t

      val sexp_of_t
        :  ('k -> Sexplib0.Sexp.t)
        -> ('v -> Sexplib0.Sexp.t)
        -> ('cmp -> Sexplib0.Sexp.t)
        -> ('direction -> Sexplib0.Sexp.t)
        -> ('k, 'v, 'cmp, 'direction) t
        -> Sexplib0.Sexp.t
    end
    [@@merlin.hide]

    val to_list_with_trees
      :  ('k, 'v, 'cmp, 'dir) t
      -> ('k * 'v * ('k, 'v, 'cmp) tree) list

    val of_list_with_trees
      :  ('k * 'v * ('k, 'v, 'cmp) tree) list
      -> ('k, 'v, 'cmp, 'dir) t

    val cons
      :  ('k, 'v, 'cmp) tree
      -> ('k, 'v, 'cmp, increasing) t
      -> ('k, 'v, 'cmp, increasing) t

    val cons_right
      :  ('k, 'v, 'cmp) tree
      -> ('k, 'v, 'cmp, decreasing) t
      -> ('k, 'v, 'cmp, decreasing) t

    val of_tree : ('k, 'v, 'cmp) tree -> ('k, 'v, 'cmp, increasing) t
    val of_tree_right : ('k, 'v, 'cmp) tree -> ('k, 'v, 'cmp, decreasing) t

    val starting_at_increasing
      :  ('k, 'v, 'cmp) tree
      -> 'k
      -> ('k -> 'k -> int)
      -> ('k, 'v, 'cmp, increasing) t

    val starting_at_decreasing
      :  ('k, 'v, 'cmp) tree
      -> 'k
      -> ('k -> 'k -> int)
      -> ('k, 'v, 'cmp, decreasing) t

    val length : _ t -> int
    val key : ('k, 'v, 'cmp, 'dir) nonempty -> 'k
    val data : ('k, 'v, 'cmp, 'dir) nonempty -> 'v
    val next : ('k, 'v, 'cmp, increasing) nonempty -> ('k, 'v, 'cmp, increasing) t

    val next_decreasing
      :  ('k, 'v, 'cmp, decreasing) nonempty
      -> ('k, 'v, 'cmp, decreasing) t

    module Which : sig
      type t =
        | Left
        | Right
        | Both
    end

    val which
      :  ('k, 'v1, 'cmp, increasing) nonempty
      -> ('k, 'v2, 'cmp, increasing) nonempty
      -> compare_key:('k -> 'k -> int)
      -> Which.t

    val which_key
      :  ('k, 'v1, 'cmp, increasing) nonempty
      -> ('k, 'v2, 'cmp, increasing) nonempty
      -> which:Which.t
      -> 'k

    val which_merge_element
      :  ('k, 'v1, 'cmp, increasing) nonempty
      -> ('k, 'v2, 'cmp, increasing) nonempty
      -> which:Which.t
      -> ('v1, 'v2) Merge_element.t

    val split_n
      :  ('k, 'v, 'cmp, increasing) t
      -> int
      -> ('k, 'v, 'cmp, increasing) t * ('k, 'v, 'cmp, increasing) t

    val next2
      :  ('k, 'v1, 'cmp, increasing) nonempty
      -> ('k, 'v2, 'cmp, increasing) nonempty
      -> which:Which.t
      -> ('k, 'v1, 'cmp, increasing) t * ('k, 'v2, 'cmp, increasing) t

    val next2_drop_phys_equal
      :  ('k, 'v, 'cmp, increasing) nonempty
      -> ('k, 'v, 'cmp, increasing) nonempty
      -> which:Which.t
      -> ('k, 'v, 'cmp, increasing) t * ('k, 'v, 'cmp, increasing) t

    val split2
      :  ('k, 'v1, 'cmp, increasing) t
      -> ('k, 'v2, 'cmp, increasing) t
      -> compare_key:('k -> 'k -> int)
      -> (('k, 'v1, 'cmp, increasing) t
         * ('k, 'v2, 'cmp, increasing) t
         * ('k, 'v1, 'cmp, increasing) t
         * ('k, 'v2, 'cmp, increasing) t)
           or_null

    val drop_phys_equal_prefix_of
      :  ('k, 'v, 'cmp) tree
      -> ('k, 'v, 'cmp) tree
      -> ('k, 'v, 'cmp, increasing) t * ('k, 'v, 'cmp, increasing) t
  end
end

module type Map = sig
  include module type of struct
    include Definitions
  end

  type (!'key, +!'value, !'cmp) t [@@sexp.phantom: 'cmp]

  include sig
    [@@@ocaml.warning "-32"]

    val globalize
      : 'key 'value 'cmp.
      ('key -> 'key)
      -> ('value -> 'value)
      -> ('cmp -> 'cmp)
      -> ('key, 'value, 'cmp) t
      -> ('key, 'value, 'cmp) t

    val sexp_of_t
      :  ('key -> Sexplib0.Sexp.t)
      -> ('value -> Sexplib0.Sexp.t)
      -> ('key, 'value, 'cmp) t
      -> Sexplib0.Sexp.t
  end
  [@@merlin.hide]

  module Finished_or_unfinished : sig
    type t = Finished_or_unfinished.t =
      | Finished
      | Unfinished

    include sig
      [@@@ocaml.warning "-32"]

      include Ppx_compare_lib.Comparable.S with type t := t
      include Ppx_enumerate_lib.Enumerable.S with type t := t
      include Ppx_compare_lib.Equal.S with type t := t

      val sexp_of_t : t -> Sexplib0.Sexp.t
    end
    [@@merlin.hide]

    val of_continue_or_stop : Continue_or_stop.t -> t
    val to_continue_or_stop : t -> Continue_or_stop.t
  end

  module Merge_element : sig
    type ('left, 'right) t =
      [ `Left of 'left
      | `Right of 'right
      | `Both of 'left * 'right
      ]

    include sig
      [@@@ocaml.warning "-32"]

      val compare
        : 'left 'right.
        ('left -> ('left[@merlin.hide]) -> int)
        -> ('right -> ('right[@merlin.hide]) -> int)
        -> ('left, 'right) t
        -> (('left, 'right) t[@merlin.hide])
        -> int

      val equal
        : 'left 'right.
        ('left -> ('left[@merlin.hide]) -> bool)
        -> ('right -> ('right[@merlin.hide]) -> bool)
        -> ('left, 'right) t
        -> (('left, 'right) t[@merlin.hide])
        -> bool

      val sexp_of_t
        :  ('left -> Sexplib0.Sexp.t)
        -> ('right -> Sexplib0.Sexp.t)
        -> ('left, 'right) t
        -> Sexplib0.Sexp.t
    end
    [@@merlin.hide]

    val left : ('left, _) t -> 'left option
    val right : (_, 'right) t -> 'right option
    val left_value : ('left, _) t -> default:'left -> 'left
    val right_value : (_, 'right) t -> default:'right -> 'right

    val values
      :  ('left, 'right) t
      -> left_default:'left
      -> right_default:'right
      -> 'left * 'right
  end

  val invariants : (_, _, _) t -> bool
  val comparator_s : ('a, _, 'cmp) t -> ('a, 'cmp) Comparator.Module.t
  val comparator : ('a, _, 'cmp) t -> ('a, 'cmp) Comparator.t
  val globalize0 : ('key, 'data, 'cmp) t -> ('key, 'data, 'cmp) t
  val empty : 'a 'b 'cmp. ('a, 'cmp) Comparator.Module.t -> ('a, 'b, 'cmp) t
  val singleton : ('a, 'cmp) Comparator.Module.t -> 'a -> 'b -> ('a, 'b, 'cmp) t

  val of_alist
    :  ('a, 'cmp) Comparator.Module.t
    -> ('a * 'b) list
    -> [ `Ok of ('a, 'b, 'cmp) t | `Duplicate_key of 'a ]

  val of_alist_or_error
    :  ('a, 'cmp) Comparator.Module.t
    -> ('a * 'b) list
    -> ('a, 'b, 'cmp) t Or_error.t

  val of_alist_exn : ('a, 'cmp) Comparator.Module.t -> ('a * 'b) list -> ('a, 'b, 'cmp) t

  val of_alist_multi
    :  ('a, 'cmp) Comparator.Module.t
    -> ('a * 'b) list
    -> ('a, 'b list, 'cmp) t

  val of_alist_multi_nonempty
    :  ('a, 'cmp) Comparator.Module.t
    -> ('a * 'b) list
    -> ('a, 'b Nonempty_list.t, 'cmp) t

  val of_alist_fold
    :  ('a, 'cmp) Comparator.Module.t
    -> ('a * 'b) list
    -> init:'c
    -> f:('c -> 'b -> 'c)
    -> ('a, 'c, 'cmp) t

  val of_alist_reduce
    :  ('a, 'cmp) Comparator.Module.t
    -> ('a * 'b) list
    -> f:('b -> 'b -> 'b)
    -> ('a, 'b, 'cmp) t

  val of_iteri
    :  ('a, 'cmp) Comparator.Module.t
    -> iteri:(f:(key:'a -> data:'b -> unit) -> unit)
    -> [ `Ok of ('a, 'b, 'cmp) t | `Duplicate_key of 'a ]

  val of_iteri_exn
    :  ('a, 'cmp) Comparator.Module.t
    -> iteri:(f:(key:'a -> data:'b -> unit) -> unit)
    -> ('a, 'b, 'cmp) t

  val of_sorted_array
    :  ('a, 'cmp) Comparator.Module.t
    -> ('a * 'b) array
    -> ('a, 'b, 'cmp) t Or_error.t

  val of_sorted_array_unchecked
    :  ('a, 'cmp) Comparator.Module.t
    -> ('a * 'b) array
    -> ('a, 'b, 'cmp) t

  val of_increasing_iterator_unchecked
    :  ('a, 'cmp) Comparator.Module.t
    -> len:int
    -> f:(int -> 'a * 'b)
    -> ('a, 'b, 'cmp) t

  val of_increasing_sequence
    :  ('k, 'cmp) Comparator.Module.t
    -> ('k * 'v) Sequence.t
    -> ('k, 'v, 'cmp) t Or_error.t

  val of_sequence
    :  ('k, 'cmp) Comparator.Module.t
    -> ('k * 'v) Sequence.t
    -> [ `Ok of ('k, 'v, 'cmp) t | `Duplicate_key of 'k ]

  val of_sequence_or_error
    :  ('a, 'cmp) Comparator.Module.t
    -> ('a * 'b) Sequence.t
    -> ('a, 'b, 'cmp) t Or_error.t

  val of_sequence_exn
    :  ('a, 'cmp) Comparator.Module.t
    -> ('a * 'b) Sequence.t
    -> ('a, 'b, 'cmp) t

  val of_sequence_multi
    :  ('a, 'cmp) Comparator.Module.t
    -> ('a * 'b) Sequence.t
    -> ('a, 'b list, 'cmp) t

  val of_sequence_multi_nonempty
    :  ('a, 'cmp) Comparator.Module.t
    -> ('a * 'b) Sequence.t
    -> ('a, 'b Nonempty_list.t, 'cmp) t

  val of_sequence_fold
    :  ('a, 'cmp) Comparator.Module.t
    -> ('a * 'b) Sequence.t
    -> init:'c
    -> f:('c -> 'b -> 'c)
    -> ('a, 'c, 'cmp) t

  val of_sequence_reduce
    :  ('a, 'cmp) Comparator.Module.t
    -> ('a * 'b) Sequence.t
    -> f:('b -> 'b -> 'b)
    -> ('a, 'b, 'cmp) t

  val of_list_with_key
    :  ('k, 'cmp) Comparator.Module.t
    -> 'v list
    -> get_key:('v -> 'k)
    -> [ `Ok of ('k, 'v, 'cmp) t | `Duplicate_key of 'k ]

  val of_list_with_key_or_error
    :  ('k, 'cmp) Comparator.Module.t
    -> 'v list
    -> get_key:('v -> 'k)
    -> ('k, 'v, 'cmp) t Or_error.t

  val of_list_with_key_exn
    :  ('k, 'cmp) Comparator.Module.t
    -> 'v list
    -> get_key:('v -> 'k)
    -> ('k, 'v, 'cmp) t

  val of_list_with_key_multi
    :  ('k, 'cmp) Comparator.Module.t
    -> 'v list
    -> get_key:('v -> 'k)
    -> ('k, 'v list, 'cmp) t

  val of_list_with_key_multi_nonempty
    :  ('k, 'cmp) Comparator.Module.t
    -> 'v list
    -> get_key:('v -> 'k)
    -> ('k, 'v Nonempty_list.t, 'cmp) t

  val of_list_with_key_fold
    :  ('k, 'cmp) Comparator.Module.t
    -> 'v list
    -> get_key:('v -> 'k)
    -> init:'acc
    -> f:('acc -> 'v -> 'acc)
    -> ('k, 'acc, 'cmp) t

  val of_list_with_key_reduce
    :  ('k, 'cmp) Comparator.Module.t
    -> 'v list
    -> get_key:('v -> 'k)
    -> f:('v -> 'v -> 'v)
    -> ('k, 'v, 'cmp) t

  val is_empty : (_, _, _) t -> bool
  val length : (_, _, _) t -> int
  val set : ('k, 'v, 'cmp) t -> key:'k -> data:'v -> ('k, 'v, 'cmp) t
  val add : ('k, 'v, 'cmp) t -> key:'k -> data:'v -> ('k, 'v, 'cmp) t Or_duplicate.t
  val add_exn : ('k, 'v, 'cmp) t -> key:'k -> data:'v -> ('k, 'v, 'cmp) t
  val add_multi : ('k, 'v list, 'cmp) t -> key:'k -> data:'v -> ('k, 'v list, 'cmp) t

  val add_multi_nonempty
    :  ('k, 'v Nonempty_list.t, 'cmp) t
    -> key:'k
    -> data:'v
    -> ('k, 'v Nonempty_list.t, 'cmp) t

  val remove_multi : ('k, 'v list, 'cmp) t -> 'k -> ('k, 'v list, 'cmp) t

  val remove_multi_nonempty
    :  ('k, 'v Nonempty_list.t, 'cmp) t
    -> 'k
    -> ('k, 'v Nonempty_list.t, 'cmp) t

  val find_multi : ('k, 'v list, 'cmp) t -> 'k -> 'v list
  val find_multi_nonempty : ('k, 'v Nonempty_list.t, 'cmp) t -> 'k -> 'v list
  val change : ('k, 'v, 'cmp) t -> 'k -> f:('v option -> 'v option) -> ('k, 'v, 'cmp) t

  val change_or_null
    :  ('k, 'v, 'cmp) t
    -> 'k
    -> f:('v or_null -> 'v or_null)
    -> ('k, 'v, 'cmp) t

  val update : ('k, 'v, 'cmp) t -> 'k -> f:('v option -> 'v) -> ('k, 'v, 'cmp) t
  val update_or_null : ('k, 'v, 'cmp) t -> 'k -> f:('v or_null -> 'v) -> ('k, 'v, 'cmp) t

  val update_and_return
    :  ('k, 'v, 'cmp) t
    -> 'k
    -> f:('v option -> 'v)
    -> 'v * ('k, 'v, 'cmp) t

  val change_and_return
    :  ('k, 'v, 'cmp) t
    -> 'k
    -> f:('v option -> 'v option)
    -> 'v option * ('k, 'v, 'cmp) t

  val find : ('k, 'v, 'cmp) t -> 'k -> 'v option
  val find_or_null : ('k, 'v, 'cmp) t -> 'k -> 'v or_null
  val find_exn : ?here:Stdlib.Lexing.position -> ('k, 'v, 'cmp) t -> 'k -> 'v
  val remove : ('k, 'v, 'cmp) t -> 'k -> ('k, 'v, 'cmp) t
  val mem : ('k, _, 'cmp) t -> 'k -> bool
  val iter_keys : ('k, _, _) t -> f:('k -> unit) -> unit
  val iter : (_, 'v, _) t -> f:('v -> unit) -> unit
  val iteri : ('k, 'v, _) t -> f:(key:'k -> data:'v -> unit) -> unit

  val iteri_until
    :  ('k, 'v, _) t
    -> f:(key:'k -> data:'v -> Continue_or_stop.t)
    -> Finished_or_unfinished.t

  val iter2
    :  ('k, 'v1, 'cmp) t
    -> ('k, 'v2, 'cmp) t
    -> f:(key:'k -> data:('v1, 'v2) Merge_element.t -> unit)
    -> unit

  val map : ('k, 'v1, 'cmp) t -> f:('v1 -> 'v2) -> ('k, 'v2, 'cmp) t
  val mapi : ('k, 'v1, 'cmp) t -> f:(key:'k -> data:'v1 -> 'v2) -> ('k, 'v2, 'cmp) t

  val map_keys
    :  ('k2, 'cmp2) Comparator.Module.t
    -> ('k1, 'v, 'cmp1) t
    -> f:('k1 -> 'k2)
    -> [ `Ok of ('k2, 'v, 'cmp2) t | `Duplicate_key of 'k2 ]

  val map_keys_exn
    :  ('k2, 'cmp2) Comparator.Module.t
    -> ('k1, 'v, 'cmp1) t
    -> f:('k1 -> 'k2)
    -> ('k2, 'v, 'cmp2) t

  val fold : ('k, 'v, _) t -> init:'acc -> f:(key:'k -> data:'v -> 'acc -> 'acc) -> 'acc

  val fold_until
    :  ('k, 'v, _) t
    -> init:'acc
    -> f:(key:'k -> data:'v -> 'acc -> ('acc, 'final) Container.Continue_or_stop.t)
    -> finish:('acc -> 'final)
    -> 'final

  val fold_right
    :  ('k, 'v, _) t
    -> init:'acc
    -> f:(key:'k -> data:'v -> 'acc -> 'acc)
    -> 'acc

  val fold2
    :  ('k, 'v1, 'cmp) t
    -> ('k, 'v2, 'cmp) t
    -> init:'acc
    -> f:(key:'k -> data:('v1, 'v2) Merge_element.t -> 'acc -> 'acc)
    -> 'acc

  val filter_keys : ('k, 'v, 'cmp) t -> f:('k -> bool) -> ('k, 'v, 'cmp) t
  val filter : ('k, 'v, 'cmp) t -> f:('v -> bool) -> ('k, 'v, 'cmp) t
  val filteri : ('k, 'v, 'cmp) t -> f:(key:'k -> data:'v -> bool) -> ('k, 'v, 'cmp) t
  val filter_map : ('k, 'v1, 'cmp) t -> f:('v1 -> 'v2 option) -> ('k, 'v2, 'cmp) t

  val filter_mapi
    :  ('k, 'v1, 'cmp) t
    -> f:(key:'k -> data:'v1 -> 'v2 option)
    -> ('k, 'v2, 'cmp) t

  val filter_map_or_null
    :  ('k, 'v1, 'cmp) t
    -> f:('v1 -> 'v2 or_null)
    -> ('k, 'v2, 'cmp) t

  val filter_mapi_or_null
    :  ('k, 'v1, 'cmp) t
    -> f:(key:'k -> data:'v1 -> 'v2 or_null)
    -> ('k, 'v2, 'cmp) t

  val filter_opt : ('k, 'v option, 'cmp) t -> ('k, 'v, 'cmp) t

  val partition_mapi
    :  ('k, 'v1, 'cmp) t
    -> f:(key:'k -> data:'v1 -> ('v2, 'v3) Either.t)
    -> ('k, 'v2, 'cmp) t * ('k, 'v3, 'cmp) t

  val partition_map
    :  ('k, 'v1, 'cmp) t
    -> f:('v1 -> ('v2, 'v3) Either.t)
    -> ('k, 'v2, 'cmp) t * ('k, 'v3, 'cmp) t

  val partition_result
    :  ('k, ('ok, 'error) Result.t, 'cmp) t
    -> ('k, 'ok, 'cmp) t * ('k, 'error, 'cmp) t

  val partitioni_tf
    :  ('k, 'v, 'cmp) t
    -> f:(key:'k -> data:'v -> bool)
    -> ('k, 'v, 'cmp) t * ('k, 'v, 'cmp) t

  val partition_tf
    :  ('k, 'v, 'cmp) t
    -> f:('v -> bool)
    -> ('k, 'v, 'cmp) t * ('k, 'v, 'cmp) t

  val combine_errors : ('k, 'v Or_error.t, 'cmp) t -> ('k, 'v, 'cmp) t Or_error.t
  val zip : ('k, 'v1, 'cmp) t -> ('k, 'v2, 'cmp) t -> ('k, 'v1 * 'v2, 'cmp) t Or_error.t
  val zip_exn : ('k, 'v1, 'cmp) t -> ('k, 'v2, 'cmp) t -> ('k, 'v1 * 'v2, 'cmp) t
  val unzip : ('k, 'v1 * 'v2, 'cmp) t -> ('k, 'v1, 'cmp) t * ('k, 'v2, 'cmp) t
  val compare_direct : ('v -> 'v -> int) -> ('k, 'v, 'cmp) t -> ('k, 'v, 'cmp) t -> int
  val hash_fold_direct : 'k Hash.folder -> 'v Hash.folder -> ('k, 'v, 'cmp) t Hash.folder
  val equal : ('v -> 'v -> bool) -> ('k, 'v, 'cmp) t -> ('k, 'v, 'cmp) t -> bool
  val keys : ('k, _, _) t -> 'k list
  val data : (_, 'v, _) t -> 'v list

  val to_alist
    :  ?key_order:[ `Increasing | `Decreasing ]
    -> ('k, 'v, _) t
    -> ('k * 'v) list

  val merge
    :  ('k, 'v1, 'cmp) t
    -> ('k, 'v2, 'cmp) t
    -> f:(key:'k -> ('v1, 'v2) Merge_element.t -> 'v3 option)
    -> ('k, 'v3, 'cmp) t

  val merge_disjoint_exn : ('k, 'v, 'cmp) t -> ('k, 'v, 'cmp) t -> ('k, 'v, 'cmp) t

  val merge_skewed
    :  ('k, 'v, 'cmp) t
    -> ('k, 'v, 'cmp) t
    -> combine:(key:'k -> 'v -> 'v -> 'v)
    -> ('k, 'v, 'cmp) t

  val merge_by_case
    :  ('k, 'v1, 'cmp) t
    -> ('k, 'v2, 'cmp) t
    -> first:('k, 'v1, 'v3) When_unmatched.t
    -> second:('k, 'v2, 'v3) When_unmatched.t
    -> both:('k, 'v1, 'v2, 'v3) When_matched.t
    -> ('k, 'v3, 'cmp) t

  val merge_aligned
    :  ('k, 'v1, 'cmp) t
    -> ('k, 'v2, 'cmp) t
    -> f:(key:'k -> 'v1 -> 'v2 -> 'v)
    -> ('k, 'v, 'cmp) t Or_error.t

  val symmetric_diff
    :  ('k, 'v, 'cmp) t
    -> ('k, 'v, 'cmp) t
    -> data_equal:('v -> 'v -> bool)
    -> ('k, 'v) Symmetric_diff_element.t Sequence.t

  val fold_symmetric_diff
    :  ('k, 'v, 'cmp) t
    -> ('k, 'v, 'cmp) t
    -> data_equal:('v -> 'v -> bool)
    -> init:'acc
    -> f:('acc -> ('k, 'v) Symmetric_diff_element.t -> 'acc)
    -> 'acc

  val min_elt : ('k, 'v, _) t -> ('k * 'v) option
  val min_elt_exn : ('k, 'v, _) t -> 'k * 'v
  val max_elt : ('k, 'v, _) t -> ('k * 'v) option
  val max_elt_exn : ('k, 'v, _) t -> 'k * 'v

  val transpose_keys
    :  ('k2, 'cmp2) Comparator.Module.t
    -> ('k1, ('k2, 'v, 'cmp2) t, 'cmp1) t
    -> ('k2, ('k1, 'v, 'cmp1) t, 'cmp2) t

  val for_all : ('k, 'v, _) t -> f:('v -> bool) -> bool
  val for_alli : ('k, 'v, _) t -> f:(key:'k -> data:'v -> bool) -> bool
  val exists : ('k, 'v, _) t -> f:('v -> bool) -> bool
  val existsi : ('k, 'v, _) t -> f:(key:'k -> data:'v -> bool) -> bool
  val count : ('k, 'v, _) t -> f:('v -> bool) -> int
  val counti : ('k, 'v, _) t -> f:(key:'k -> data:'v -> bool) -> int

  val sum
    :  (module Container.Summable with type t = 'a)
    -> ('k, 'v, _) t
    -> f:('v -> 'a)
    -> 'a

  val sumi
    :  (module Container.Summable with type t = 'a)
    -> ('k, 'v, _) t
    -> f:(key:'k -> data:'v -> 'a)
    -> 'a

  val split
    :  ('k, 'v, 'cmp) t
    -> 'k
    -> ('k, 'v, 'cmp) t * ('k * 'v) option * ('k, 'v, 'cmp) t

  val split_le_gt : ('k, 'v, 'cmp) t -> 'k -> ('k, 'v, 'cmp) t * ('k, 'v, 'cmp) t
  val split_lt_ge : ('k, 'v, 'cmp) t -> 'k -> ('k, 'v, 'cmp) t * ('k, 'v, 'cmp) t
  val split_n : ('k, 'v, 'cmp) t -> int -> ('k, 'v, 'cmp) t * ('k, 'v, 'cmp) t
  val count_lt : ('k, 'v, 'cmp) t -> 'k -> int
  val count_le : ('k, 'v, 'cmp) t -> 'k -> int
  val count_gt : ('k, 'v, 'cmp) t -> 'k -> int
  val count_ge : ('k, 'v, 'cmp) t -> 'k -> int

  val append
    :  lower_part:('k, 'v, 'cmp) t
    -> upper_part:('k, 'v, 'cmp) t
    -> [ `Ok of ('k, 'v, 'cmp) t | `Overlapping_key_ranges ]

  val subrange
    :  ('k, 'v, 'cmp) t
    -> lower_bound:'k Maybe_bound.t
    -> upper_bound:'k Maybe_bound.t
    -> ('k, 'v, 'cmp) t

  val fold_range_inclusive
    :  ('k, 'v, 'cmp) t
    -> min:'k
    -> max:'k
    -> init:'acc
    -> f:(key:'k -> data:'v -> 'acc -> 'acc)
    -> 'acc

  val range_to_alist : ('k, 'v, 'cmp) t -> min:'k -> max:'k -> ('k * 'v) list

  val closest_key
    :  ('k, 'v, 'cmp) t
    -> [ `Greater_or_equal_to | `Greater_than | `Less_or_equal_to | `Less_than ]
    -> 'k
    -> ('k * 'v) option

  val nth : ('k, 'v, _) t -> int -> ('k * 'v) option
  val nth_exn : ('k, 'v, _) t -> int -> 'k * 'v
  val rank : ('k, 'v, 'cmp) t -> 'k -> int option

  val to_sequence
    :  ?order:[ `Increasing_key | `Decreasing_key ]
    -> ?keys_greater_or_equal_to:'k
    -> ?keys_less_or_equal_to:'k
    -> ('k, 'v, 'cmp) t
    -> ('k * 'v) Sequence.t

  val binary_search
    :  ('k, 'v, 'cmp) t
    -> compare:(key:'k -> data:'v -> 'key -> int)
    -> [ `Last_strictly_less_than
       | `Last_less_than_or_equal_to
       | `Last_equal_to
       | `First_equal_to
       | `First_greater_than_or_equal_to
       | `First_strictly_greater_than
       ]
    -> 'key
    -> ('k * 'v) option

  val binary_search_segmented
    :  ('k, 'v, 'cmp) t
    -> segment_of:(key:'k -> data:'v -> [ `Left | `Right ])
    -> [ `Last_on_left | `First_on_right ]
    -> ('k * 'v) option

  val binary_search_subrange
    :  ('k, 'v, 'cmp) t
    -> compare:(key:'k -> data:'v -> 'bound -> int)
    -> lower_bound:'bound Maybe_bound.t
    -> upper_bound:'bound Maybe_bound.t
    -> ('k, 'v, 'cmp) t

  module Make_applicative_traversals : functor (A : Applicative.Lazy_applicative) -> sig
    val mapi
      :  ('k, 'v1, 'cmp) t
      -> f:(key:'k -> data:'v1 -> 'v2 A.t)
      -> ('k, 'v2, 'cmp) t A.t

    val filter_mapi
      :  ('k, 'v1, 'cmp) t
      -> f:(key:'k -> data:'v1 -> 'v2 option A.t)
      -> ('k, 'v2, 'cmp) t A.t
  end

  module M : functor
      (K : sig
         type t
         type comparator_witness
       end)
      -> sig
    type nonrec 'v t = (K.t, 'v, K.comparator_witness) t
  end

  include For_deriving with type ('key, 'value, 'cmp) t := ('key, 'value, 'cmp) t

  module Tree : sig
    type weight

    type (+'k, +'v, 'cmp) t = private
      | Empty
      | Leaf of
          { key : 'k
          ; data : 'v
          }
      | Node of
          { left : ('k, 'v, 'cmp) t
          ; key : 'k
          ; data : 'v
          ; right : ('k, 'v, 'cmp) t
          ; weight : weight
          }
    [@@sexp.phantom: 'cmp]

    include sig
      [@@@ocaml.warning "-32"]

      val sexp_of_t
        :  ('k -> Sexplib0.Sexp.t)
        -> ('v -> Sexplib0.Sexp.t)
        -> ('k, 'v, 'cmp) t
        -> Sexplib0.Sexp.t
    end
    [@@merlin.hide]

    val t_of_sexp_direct
      :  comparator:('k, 'cmp) Comparator.t
      -> (Sexp.t -> 'k)
      -> (Sexp.t -> 'v)
      -> Sexp.t
      -> ('k, 'v, 'cmp) t

    val globalize : _ -> _ -> _ -> ('k, 'v, 'cmp) t -> ('k, 'v, 'cmp) t

    include
      Creators_and_accessors_and_transformers_generic
      with type ('a, 'b, 'c) t := ('a, 'b, 'c) t
      with type ('a, 'b, 'c) map := ('a, 'b, 'c) t
      with type ('a, 'b, 'c) tree := ('a, 'b, 'c) t
      with type 'k key := 'k
      with type 'k map_key := 'k
      with type 'c cmp := 'c
      with type ('a, 'b, 'c) create_options := ('a, 'b, 'c) With_comparator.t
      with type ('a, 'b, 'c) access_options := ('a, 'b, 'c) With_comparator.t

    val empty_without_value_restriction : (_, _, _) t

    module Build_increasing : sig
      type ('a, 'b, 'c) tree := ('a, 'b, 'c) t
      type ('k, 'v, 'w) t

      val empty : ('k, 'v, 'w) t
      val get_empty : unit -> ('k, 'v, 'w) t

      val add_exn
        :  ('k, 'v, 'w) t
        -> comparator:('k, 'w) Comparator.t
        -> key:'k
        -> data:'v
        -> ('k, 'v, 'w) t

      val to_tree : ('k, 'v, 'w) t -> ('k, 'v, 'w) tree
    end

    module Enum : Enum with type ('k, 'v, 'cmp) tree := ('k, 'v, 'cmp) t

    module Expert : sig
      type nonrec ('k, 'v, 'cmp) t = ('k, 'v, 'cmp) t

      include sig
        [@@@ocaml.warning "-32"]

        include Ppx_compare_lib.Equal.S3 with type ('k, 'v, 'cmp) t := ('k, 'v, 'cmp) t

        val sexp_of_t
          :  ('k -> Sexplib0.Sexp.t)
          -> ('v -> Sexplib0.Sexp.t)
          -> ('cmp -> Sexplib0.Sexp.t)
          -> ('k, 'v, 'cmp) t
          -> Sexplib0.Sexp.t
      end
      [@@merlin.hide]

      val balance_invariants : (_, _, _) t -> bool

      val order_invariants
        :  comparator:('k, 'cmp) Comparator.t
        -> ('k, 'v, 'cmp) t
        -> bool

      val are_balanced : ('k, 'v, 'cmp) t -> ('k, 'v, 'cmp) t -> bool
      val need_rebalance_at_most_once : ('k, 'v, 'cmp) t -> ('k, 'v, 'cmp) t -> bool

      val create_assuming_balanced_unchecked
        :  ('k, 'v, 'cmp) t
        -> 'k
        -> 'v
        -> ('k, 'v, 'cmp) t
        -> ('k, 'v, 'cmp) t

      val create_and_rebalance_at_most_once_unchecked
        :  ('k, 'v, 'cmp) t
        -> 'k
        -> 'v
        -> ('k, 'v, 'cmp) t
        -> ('k, 'v, 'cmp) t

      val create_and_rebalance_unchecked
        :  ('k, 'v, 'cmp) t
        -> 'k
        -> 'v
        -> ('k, 'v, 'cmp) t
        -> ('k, 'v, 'cmp) t

      val concat_and_rebalance_at_most_once_unchecked
        :  ('k, 'v, 'cmp) t
        -> ('k, 'v, 'cmp) t
        -> ('k, 'v, 'cmp) t

      val concat_and_rebalance_unchecked
        :  ('k, 'v, 'cmp) t
        -> ('k, 'v, 'cmp) t
        -> ('k, 'v, 'cmp) t

      val singleton : 'k -> 'v -> ('k, 'v, 'cmp) t
      val empty : ('k, 'v, 'cmp) t
      val length_of_weight : weight -> int
    end
  end

  module Using_comparator : sig
    type nonrec ('k, +'v, 'cmp) t = ('k, 'v, 'cmp) t [@@sexp.phantom: 'cmp]

    include sig
      [@@@ocaml.warning "-32"]

      val sexp_of_t
        :  ('k -> Sexplib0.Sexp.t)
        -> ('v -> Sexplib0.Sexp.t)
        -> ('k, 'v, 'cmp) t
        -> Sexplib0.Sexp.t
    end
    [@@merlin.hide]

    val t_of_sexp_direct
      :  comparator:('k, 'cmp) Comparator.t
      -> (Sexp.t -> 'k)
      -> (Sexp.t -> 'v)
      -> Sexp.t
      -> ('k, 'v, 'cmp) t

    include
      Creators_and_accessors_and_transformers_generic
      with type ('a, 'b, 'c) t := ('a, 'b, 'c) t
      with type ('a, 'b, 'c) map := ('a, 'b, 'c) t
      with type ('a, 'b, 'c) tree := ('a, 'b, 'c) Tree.t
      with type 'k key := 'k
      with type 'k map_key := 'k
      with type 'c cmp := 'c
      with type ('a, 'b, 'c) access_options := ('a, 'b, 'c) Without_comparator.t
      with type ('a, 'b, 'c) create_options := ('a, 'b, 'c) With_comparator.t

    val comparator : ('a, _, 'cmp) t -> ('a, 'cmp) Comparator.t

    val hash_fold_direct
      :  'k Hash.folder
      -> 'v Hash.folder
      -> ('k, 'v, 'cmp) t Hash.folder

    module Empty_without_value_restriction : functor (K : Comparator.S1) -> sig
      val empty : ('a K.t, 'v, K.comparator_witness) t
    end

    module Tree = Tree
  end

  module Poly :
    S_poly
    with type ('key, +'value) t = ('key, 'value, Comparator.Poly.comparator_witness) t
     and type ('key, +'value) map := ('key, 'value, Comparator.Poly.comparator_witness) t
     and type ('key, +'value) tree =
      ('key, 'value, Comparator.Poly.comparator_witness) Using_comparator.Tree.t
     and type comparator_witness = Comparator.Poly.comparator_witness

  val of_tree
    :  ('k, 'cmp) Comparator.Module.t
    -> ('k, 'v, 'cmp) Using_comparator.Tree.t
    -> ('k, 'v, 'cmp) t

  val to_tree : ('k, 'v, 'cmp) t -> ('k, 'v, 'cmp) Using_comparator.Tree.t
end
