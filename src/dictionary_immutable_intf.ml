open! Import0
module Either = Either0
module Nonempty_list = Nonempty_list_type.Nonempty_list
module Result = Result0

module Definitions = struct
  module type Accessors = sig
    type 'key key
    type ('key, 'data, 'phantom) t
    type ('fn, 'key, 'data, 'phantom) accessor

    val is_empty : (_, _, _) t -> bool
    val length : (_, _, _) t -> int
    val to_alist : ('key, 'data, _) t -> ('key key * 'data) list
    val keys : ('key, _, _) t -> 'key key list
    val data : (_, 'data, _) t -> 'data list
    val to_sequence : ('key, 'data, 'phantom) t -> ('key key * 'data) Sequence.t
    val mem : (('key, _, 'phantom) t -> 'key key -> bool, 'key, 'data, 'phantom) accessor

    val find
      : ( ('key, 'data, 'phantom) t -> 'key key -> 'data option
          , 'key
          , 'data
          , 'phantom )
          accessor

    val find_exn
      : ( here:[%call_pos] -> ('key, 'data, 'phantom) t -> 'key key -> 'data
          , 'key
          , 'data
          , 'phantom )
          accessor

    val find_multi
      : ( ('key, 'data list, 'phantom) t -> 'key key -> 'data list
          , 'key
          , 'data
          , 'phantom )
          accessor

    val find_multi_nonempty
      : ( ('key, 'data Nonempty_list.t, 'phantom) t -> 'key key -> 'data list
          , 'key
          , 'data
          , 'phantom )
          accessor

    val fold
      :  ('key, 'data, _) t
      -> init:'acc
      -> f:(key:'key key -> data:'data -> 'acc -> 'acc)
      -> 'acc

    val fold_until
      :  ('key, 'data, _) t
      -> init:'acc
      -> f:
           (key:'key key
            -> data:'data
            -> 'acc
            -> ('acc, 'final) Container.Continue_or_stop.t)
      -> finish:('acc -> 'final)
      -> 'final

    val for_all : ('key, 'data, _) t -> f:('data -> bool) -> bool
    val for_alli : ('key, 'data, _) t -> f:(key:'key key -> data:'data -> bool) -> bool
    val exists : ('key, 'data, _) t -> f:('data -> bool) -> bool
    val existsi : ('key, 'data, _) t -> f:(key:'key key -> data:'data -> bool) -> bool
    val count : ('key, 'data, _) t -> f:('data -> bool) -> int
    val counti : ('key, 'data, _) t -> f:(key:'key key -> data:'data -> bool) -> int

    val sum
      :  (module Container.Summable with type t = 'a)
      -> ('key, 'data, _) t
      -> f:('data -> 'a)
      -> 'a

    val sumi
      :  (module Container.Summable with type t = 'a)
      -> ('key, 'data, _) t
      -> f:(key:'key key -> data:'data -> 'a)
      -> 'a

    val min_elt : ('key, 'data, _) t -> ('key key * 'data) option
    val min_elt_exn : ('key, 'data, _) t -> 'key key * 'data
    val max_elt : ('key, 'data, _) t -> ('key key * 'data) option
    val max_elt_exn : ('key, 'data, _) t -> 'key key * 'data
    val iter_keys : ('key, _, _) t -> f:('key key -> unit) -> unit
    val iter : (_, 'data, _) t -> f:('data -> unit) -> unit
    val iteri : ('key, 'data, _) t -> f:(key:'key key -> data:'data -> unit) -> unit

    val symmetric_diff
      : ( ('key, 'data, 'phantom) t
          -> ('key, 'data, 'phantom) t
          -> data_equal:('data -> 'data -> bool)
          -> ('key key * [ `Left of 'data | `Right of 'data | `Unequal of 'data * 'data ])
               Sequence.t
          , 'key
          , 'data
          , 'phantom )
          accessor

    val fold_symmetric_diff
      : ( ('key, 'data, 'phantom) t
          -> ('key, 'data, 'phantom) t
          -> data_equal:('data -> 'data -> bool)
          -> init:'acc
          -> f:
               ('acc
                -> 'key key
                   * [ `Left of 'data | `Right of 'data | `Unequal of 'data * 'data ]
                -> 'acc)
          -> 'acc
          , 'key
          , 'data
          , 'phantom )
          accessor
  end

  module type Accessors1 = sig
    type key
    type 'data t

    include
      Accessors
      with type (_, 'data, _) t := 'data t
       and type _ key := key
       and type ('fn, _, _, _) accessor := 'fn
  end

  module type Accessors2 = sig
    type ('key, 'data) t
    type ('fn, 'key, 'data) accessor

    include
      Accessors
      with type ('key, 'data, _) t := ('key, 'data) t
       and type 'key key := 'key
       and type ('fn, 'key, 'data, _) accessor := ('fn, 'key, 'data) accessor
  end

  module type Accessors3 = sig
    type ('key, 'data, 'phantom) t
    type ('fn, 'key, 'data, 'phantom) accessor

    include
      Accessors
      with type ('key, 'data, 'phantom) t := ('key, 'data, 'phantom) t
       and type 'key key := 'key
       and type ('fn, 'key, 'data, 'phantom) accessor :=
        ('fn, 'key, 'data, 'phantom) accessor
  end

  module type Transformers = sig
    type 'key key
    type ('key, 'data, 'phantom) t
    type ('fn, 'key, 'data, 'phantom) transformer

    val add
      : ( ('key, 'data, 'phantom) t
          -> key:'key key
          -> data:'data
          -> [ `Ok of ('key, 'data, 'phantom) t | `Duplicate ]
          , 'key
          , 'data
          , 'phantom )
          transformer

    val add_exn
      : ( ('key, 'data, 'phantom) t
          -> key:'key key
          -> data:'data
          -> ('key, 'data, 'phantom) t
          , 'key
          , 'data
          , 'phantom )
          transformer

    val set
      : ( ('key, 'data, 'phantom) t
          -> key:'key key
          -> data:'data
          -> ('key, 'data, 'phantom) t
          , 'key
          , 'data
          , 'phantom )
          transformer

    val remove
      : ( ('key, 'data, 'phantom) t -> 'key key -> ('key, 'data, 'phantom) t
          , 'key
          , 'data
          , 'phantom )
          transformer

    val change
      : ( ('key, 'data, 'phantom) t
          -> 'key key
          -> f:('data option -> 'data option)
          -> ('key, 'data, 'phantom) t
          , 'key
          , 'data
          , 'phantom )
          transformer

    val update
      : ( ('key, 'data, 'phantom) t
          -> 'key key
          -> f:('data option -> 'data)
          -> ('key, 'data, 'phantom) t
          , 'key
          , 'data
          , 'phantom )
          transformer

    val update_and_return
      : ( ('key, 'data, 'phantom) t
          -> 'key key
          -> f:('data option -> 'data)
          -> 'data * ('key, 'data, 'phantom) t
          , 'key
          , 'data
          , 'phantom )
          transformer

    val change_and_return
      : ( ('key, 'data, 'phantom) t
          -> 'key key
          -> f:('data option -> 'data option)
          -> 'data option * ('key, 'data, 'phantom) t
          , 'key
          , 'data
          , 'phantom )
          transformer

    val add_multi
      : ( ('key, 'data list, 'phantom) t
          -> key:'key key
          -> data:'data
          -> ('key, 'data list, 'phantom) t
          , 'key
          , 'data
          , 'phantom )
          transformer

    val add_multi_nonempty
      : ( ('key, 'data Nonempty_list.t, 'phantom) t
          -> key:'key key
          -> data:'data
          -> ('key, 'data Nonempty_list.t, 'phantom) t
          , 'key
          , 'data
          , 'phantom )
          transformer

    val remove_multi
      : ( ('key, 'data list, 'phantom) t -> 'key key -> ('key, 'data list, 'phantom) t
          , 'key
          , 'data
          , 'phantom )
          transformer

    val remove_multi_nonempty
      : ( ('key, 'data Nonempty_list.t, 'phantom) t
          -> 'key key
          -> ('key, 'data Nonempty_list.t, 'phantom) t
          , 'key
          , 'data
          , 'phantom )
          transformer

    val map
      :  ('key, 'data1, 'phantom) t
      -> f:('data1 -> 'data2)
      -> ('key, 'data2, 'phantom) t

    val mapi
      :  ('key, 'data1, 'phantom) t
      -> f:(key:'key key -> data:'data1 -> 'data2)
      -> ('key, 'data2, 'phantom) t

    val filter_keys
      :  ('key, 'data, 'phantom) t
      -> f:('key key -> bool)
      -> ('key, 'data, 'phantom) t

    val filter
      :  ('key, 'data, 'phantom) t
      -> f:('data -> bool)
      -> ('key, 'data, 'phantom) t

    val filteri
      :  ('key, 'data, 'phantom) t
      -> f:(key:'key key -> data:'data -> bool)
      -> ('key, 'data, 'phantom) t

    val filter_map
      :  ('key, 'data1, 'phantom) t
      -> f:('data1 -> 'data2 option)
      -> ('key, 'data2, 'phantom) t

    val filter_mapi
      :  ('key, 'data1, 'phantom) t
      -> f:(key:'key key -> data:'data1 -> 'data2 option)
      -> ('key, 'data2, 'phantom) t

    val partition_tf
      :  ('key, 'data, 'phantom) t
      -> f:('data -> bool)
      -> ('key, 'data, 'phantom) t * ('key, 'data, 'phantom) t

    val partitioni_tf
      :  ('key, 'data, 'phantom) t
      -> f:(key:'key key -> data:'data -> bool)
      -> ('key, 'data, 'phantom) t * ('key, 'data, 'phantom) t

    val partition_map
      :  ('key, 'data1, 'phantom) t
      -> f:('data1 -> ('data2, 'data3) Either.t)
      -> ('key, 'data2, 'phantom) t * ('key, 'data3, 'phantom) t

    val partition_mapi
      :  ('key, 'data1, 'phantom) t
      -> f:(key:'key key -> data:'data1 -> ('data2, 'data3) Either.t)
      -> ('key, 'data2, 'phantom) t * ('key, 'data3, 'phantom) t

    val partition_result
      :  ('key, ('ok, 'error) Result.t, 'phantom) t
      -> ('key, 'ok, 'phantom) t * ('key, 'error, 'phantom) t

    val combine_errors
      : ( ('key, 'data Or_error.t, 'phantom) t -> ('key, 'data, 'phantom) t Or_error.t
          , 'key
          , 'data
          , 'phantom )
          transformer

    val unzip
      :  ('key, 'data1 * 'data2, 'phantom) t
      -> ('key, 'data1, 'phantom) t * ('key, 'data2, 'phantom) t

    val merge
      : ( ('key, 'data1, 'phantom) t
          -> ('key, 'data2, 'phantom) t
          -> f:
               (key:'key key
                -> [ `Left of 'data1 | `Right of 'data2 | `Both of 'data1 * 'data2 ]
                -> 'data3 option)
          -> ('key, 'data3, 'phantom) t
          , 'key
          , 'data
          , 'phantom )
          transformer

    val merge_disjoint_exn
      : ( ('key, 'data, 'phantom) t
          -> ('key, 'data, 'phantom) t
          -> ('key, 'data, 'phantom) t
          , 'key
          , 'data
          , 'phantom )
          transformer

    val merge_skewed
      : ( ('key, 'data, 'phantom) t
          -> ('key, 'data, 'phantom) t
          -> combine:(key:'key key -> 'data -> 'data -> 'data)
          -> ('key, 'data, 'phantom) t
          , 'key
          , 'data
          , 'phantom )
          transformer
  end

  module type Transformers1 = sig
    type key
    type 'data t

    include
      Transformers
      with type (_, 'data, _) t := 'data t
       and type _ key := key
       and type ('fn, _, _, _) transformer := 'fn
  end

  module type Transformers2 = sig
    type ('key, 'data) t
    type ('fn, 'key, 'data) transformer

    include
      Transformers
      with type ('key, 'data, _) t := ('key, 'data) t
       and type 'key key := 'key
       and type ('fn, 'key, 'data, _) transformer := ('fn, 'key, 'data) transformer
  end

  module type Transformers3 = sig
    type ('key, 'data, 'phantom) t
    type ('fn, 'key, 'data, 'phantom) transformer

    include
      Transformers
      with type ('key, 'data, 'phantom) t := ('key, 'data, 'phantom) t
       and type 'key key := 'key
       and type ('fn, 'key, 'data, 'phantom) transformer :=
        ('fn, 'key, 'data, 'phantom) transformer
  end

  module type Creators = sig
    type 'key key
    type ('key, 'data, 'phantom) t
    type ('fn, 'key, 'data, 'phantom) creator

    val empty : (('key, 'data, 'phantom) t, 'key, 'data, 'phantom) creator

    val singleton
      : ('key key -> 'data -> ('key, 'data, 'phantom) t, 'key, 'data, 'phantom) creator

    val of_alist
      : ( ('key key * 'data) list
          -> [ `Ok of ('key, 'data, 'phantom) t | `Duplicate_key of 'key key ]
          , 'key
          , 'data
          , 'phantom )
          creator

    val of_alist_or_error
      : ( ('key key * 'data) list -> ('key, 'data, 'phantom) t Or_error.t
          , 'key
          , 'data
          , 'phantom )
          creator

    val of_alist_exn
      : ( ('key key * 'data) list -> ('key, 'data, 'phantom) t
          , 'key
          , 'data
          , 'phantom )
          creator

    val of_alist_multi
      : ( ('key key * 'data) list -> ('key, 'data list, 'phantom) t
          , 'key
          , 'data
          , 'phantom )
          creator

    val of_alist_multi_nonempty
      : ( ('key key * 'data) list -> ('key, 'data Nonempty_list.t, 'phantom) t
          , 'key
          , 'data
          , 'phantom )
          creator

    val of_alist_fold
      : ( ('key key * 'data) list
          -> init:'acc
          -> f:('acc -> 'data -> 'acc)
          -> ('key, 'acc, 'phantom) t
          , 'key
          , 'data
          , 'phantom )
          creator

    val of_alist_reduce
      : ( ('key key * 'data) list
          -> f:('data -> 'data -> 'data)
          -> ('key, 'data, 'phantom) t
          , 'key
          , 'data
          , 'phantom )
          creator

    val of_sequence
      : ( ('key key * 'data) Sequence.t
          -> [ `Ok of ('key, 'data, 'phantom) t | `Duplicate_key of 'key key ]
          , 'key
          , 'data
          , 'phantom )
          creator

    val of_sequence_or_error
      : ( ('key key * 'data) Sequence.t -> ('key, 'data, 'phantom) t Or_error.t
          , 'key
          , 'data
          , 'phantom )
          creator

    val of_sequence_exn
      : ( ('key key * 'data) Sequence.t -> ('key, 'data, 'phantom) t
          , 'key
          , 'data
          , 'phantom )
          creator

    val of_sequence_multi
      : ( ('key key * 'data) Sequence.t -> ('key, 'data list, 'phantom) t
          , 'key
          , 'data
          , 'phantom )
          creator

    val of_sequence_multi_nonempty
      : ( ('key key * 'data) Sequence.t -> ('key, 'data Nonempty_list.t, 'phantom) t
          , 'key
          , 'data
          , 'phantom )
          creator

    val of_sequence_fold
      : ( ('key key * 'data) Sequence.t
          -> init:'c
          -> f:('c -> 'data -> 'c)
          -> ('key, 'c, 'phantom) t
          , 'key
          , 'data
          , 'phantom )
          creator

    val of_sequence_reduce
      : ( ('key key * 'data) Sequence.t
          -> f:('data -> 'data -> 'data)
          -> ('key, 'data, 'phantom) t
          , 'key
          , 'data
          , 'phantom )
          creator

    val of_list_with_key
      : ( 'data list
          -> get_key:('data -> 'key key)
          -> [ `Ok of ('key, 'data, 'phantom) t | `Duplicate_key of 'key key ]
          , 'key
          , 'data
          , 'phantom )
          creator

    val of_list_with_key_or_error
      : ( 'data list -> get_key:('data -> 'key key) -> ('key, 'data, 'phantom) t Or_error.t
          , 'key
          , 'data
          , 'phantom )
          creator

    val of_list_with_key_exn
      : ( 'data list -> get_key:('data -> 'key key) -> ('key, 'data, 'phantom) t
          , 'key
          , 'data
          , 'phantom )
          creator

    val of_list_with_key_multi
      : ( 'data list -> get_key:('data -> 'key key) -> ('key, 'data list, 'phantom) t
          , 'key
          , 'data
          , 'phantom )
          creator

    val of_list_with_key_multi_nonempty
      : ( 'data list
          -> get_key:('data -> 'key key)
          -> ('key, 'data Nonempty_list.t, 'phantom) t
          , 'key
          , 'data
          , 'phantom )
          creator

    val of_iteri
      : ( iteri:(f:(key:'key key -> data:'data -> unit) -> unit)
          -> [ `Ok of ('key, 'data, 'phantom) t | `Duplicate_key of 'key key ]
          , 'key
          , 'data
          , 'phantom )
          creator

    val of_iteri_exn
      : ( iteri:(f:(key:'key key -> data:'data -> unit) -> unit)
          -> ('key, 'data, 'phantom) t
          , 'key
          , 'data
          , 'phantom )
          creator
  end

  module type Creators1 = sig
    type key
    type 'data t

    include
      Creators
      with type (_, 'data, _) t := 'data t
       and type _ key := key
       and type ('fn, _, _, _) creator := 'fn
  end

  module type Creators2 = sig
    type ('key, 'data) t
    type ('fn, 'key, 'data) creator

    include
      Creators
      with type ('key, 'data, _) t := ('key, 'data) t
       and type 'key key := 'key
       and type ('fn, 'key, 'data, _) creator := ('fn, 'key, 'data) creator
  end

  module type Creators3 = sig
    type ('key, 'data, 'phantom) t
    type ('fn, 'key, 'data, 'phantom) creator

    include
      Creators
      with type ('key, 'data, 'phantom) t := ('key, 'data, 'phantom) t
       and type 'key key := 'key
       and type ('fn, 'key, 'data, 'phantom) creator :=
        ('fn, 'key, 'data, 'phantom) creator
  end

  module type S = sig
    type 'key key
    type ('key, 'data, 'phantom) t
    type ('fn, 'key, 'data, 'phantom) accessor
    type ('fn, 'key, 'data, 'phantom) creator

    include
      Accessors
      with type ('key, 'data, 'phantom) t := ('key, 'data, 'phantom) t
       and type 'key key := 'key key
       and type ('fn, 'key, 'data, 'phantom) accessor :=
        ('fn, 'key, 'data, 'phantom) accessor

    include
      Transformers
      with type ('key, 'data, 'phantom) t := ('key, 'data, 'phantom) t
       and type 'key key := 'key key
       and type ('fn, 'key, 'data, 'phantom) transformer :=
        ('fn, 'key, 'data, 'phantom) accessor

    include
      Creators
      with type ('key, 'data, 'phantom) t := ('key, 'data, 'phantom) t
       and type 'key key := 'key key
       and type ('fn, 'key, 'data, 'phantom) creator :=
        ('fn, 'key, 'data, 'phantom) creator
  end

  module type S1 = sig
    type key
    type 'data t

    include
      S
      with type (_, 'data, _) t := 'data t
       and type _ key := key
       and type ('fn, _, _, _) accessor := 'fn
       and type ('fn, _, _, _) creator := 'fn
  end

  module type S2 = sig
    type ('key, 'data) t
    type ('fn, 'key, 'data) accessor
    type ('fn, 'key, 'data) creator

    include
      S
      with type ('key, 'data, _) t := ('key, 'data) t
       and type 'key key := 'key
       and type ('fn, 'key, 'data, _) accessor := ('fn, 'key, 'data) accessor
       and type ('fn, 'key, 'data, _) creator := ('fn, 'key, 'data) creator
  end

  module type S3 = sig
    type ('key, 'data, 'phantom) t
    type ('fn, 'key, 'data, 'phantom) accessor
    type ('fn, 'key, 'data, 'phantom) creator

    include
      S
      with type ('key, 'data, 'phantom) t := ('key, 'data, 'phantom) t
       and type 'key key := 'key
       and type ('fn, 'key, 'data, 'phantom) accessor :=
        ('fn, 'key, 'data, 'phantom) accessor
       and type ('fn, 'key, 'data, 'phantom) creator :=
        ('fn, 'key, 'data, 'phantom) creator
  end
end

module type Dictionary_immutable = sig
  include module type of struct
    include Definitions
  end
end
