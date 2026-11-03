open! Import0
module Either = Either0

module Definitions = struct
  module Merge_into_action = struct
    type 'data t =
      | Remove
      | Set_to of 'data
  end

  module type Accessors = sig
    type 'key key
    type ('key, 'data, 'phantom) t
    type ('fn, 'key, 'data, 'phantom) accessor

    val is_empty : (_, _, 'phantom) t -> bool
    val length : (_, _, 'phantom) t -> int
    val to_alist : ('key, 'data, 'phantom) t -> ('key key * 'data) list
    val keys : ('key, _, 'phantom) t -> 'key key list
    val data : (_, 'data, 'phantom) t -> 'data list
    val clear : (_, _, 'phantom) t -> unit
    val copy : ('key, 'data, 'phantom) t -> ('key, 'data, 'phantom) t

    val mem
      : (('key, 'data, 'phantom) t -> 'key key -> bool, 'key, 'data, 'phantom) accessor

    val find
      : 'key 'data 'phantom.
      ( ('key, 'data, 'phantom) t -> 'key key -> 'data option
        , 'key
        , 'data
        , 'phantom )
        accessor

    val find_exn
      : 'key 'data 'phantom.
      (('key, 'data, 'phantom) t -> 'key key -> 'data, 'key, 'data, 'phantom) accessor

    val find_or_add
      : ( ('key, 'data, 'phantom) t -> 'key key -> default:(unit -> 'data) -> 'data
          , 'key
          , 'data
          , 'phantom )
          accessor

    val findi_or_add
      : ( ('key, 'data, 'phantom) t -> 'key key -> default:('key key -> 'data) -> 'data
          , 'key
          , 'data
          , 'phantom )
          accessor

    val find_and_call
      : 'key 'data 'phantom 'c.
      ( ('key, 'data, 'phantom) t
        -> 'key key
        -> if_found:('data -> 'c)
        -> if_not_found:('key key -> 'c)
        -> 'c
        , 'key
        , 'data
        , 'phantom )
        accessor

    val findi_and_call
      : 'key 'data 'phantom 'c.
      ( ('key, 'data, 'phantom) t
        -> 'key key
        -> if_found:(key:'key key -> data:'data -> 'c)
        -> if_not_found:('key key -> 'c)
        -> 'c
        , 'key
        , 'data
        , 'phantom )
        accessor

    val find_and_remove
      : ( ('key, 'data, 'phantom) t -> 'key key -> 'data option
          , 'key
          , 'data
          , 'phantom )
          accessor

    val add
      : ( ('key, 'data, 'phantom) t -> key:'key key -> data:'data -> [ `Ok | `Duplicate ]
          , 'key
          , 'data
          , 'phantom )
          accessor

    val add_exn
      : ( ('key, 'data, 'phantom) t -> key:'key key -> data:'data -> unit
          , 'key
          , 'data
          , 'phantom )
          accessor

    val set
      : ( ('key, 'data, 'phantom) t -> key:'key key -> data:'data -> unit
          , 'key
          , 'data
          , 'phantom )
          accessor

    val remove
      : (('key, 'data, 'phantom) t -> 'key key -> unit, 'key, 'data, 'phantom) accessor

    val change
      : ( ('key, 'data, 'phantom) t -> 'key key -> f:('data option -> 'data option) -> unit
          , 'key
          , 'data
          , 'phantom )
          accessor

    val update
      : ( ('key, 'data, 'phantom) t -> 'key key -> f:('data option -> 'data) -> unit
          , 'key
          , 'data
          , 'phantom )
          accessor

    val update_and_return
      :  ('key, 'data, 'phantom) t
      -> 'key key
      -> f:('data option -> 'data)
      -> 'data

    val incr
      : ( ?by:int -> ?remove_if_zero:bool -> ('key, int, 'phantom) t -> 'key key -> unit
          , 'key
          , 'data
          , 'phantom )
          accessor

    val decr
      : ( ?by:int -> ?remove_if_zero:bool -> ('key, int, 'phantom) t -> 'key key -> unit
          , 'key
          , 'data
          , 'phantom )
          accessor

    val add_multi
      : ( ('key, 'data list, 'phantom) t -> key:'key key -> data:'data -> unit
          , 'key
          , 'data
          , 'phantom )
          accessor

    val remove_multi
      : (('key, _ list, 'phantom) t -> 'key key -> unit, 'key, 'data, 'phantom) accessor

    val find_multi
      : ( ('key, 'data list, 'phantom) t -> 'key key -> 'data list
          , 'key
          , 'data
          , 'phantom )
          accessor

    val fold
      :  ('key, 'data, 'phantom) t
      -> init:'acc
      -> f:(key:'key key -> data:'data -> 'acc -> 'acc)
      -> 'acc

    val for_all : (_, 'data, 'phantom) t -> f:('data -> bool) -> bool

    val for_alli
      :  ('key, 'data, 'phantom) t
      -> f:(key:'key key -> data:'data -> bool)
      -> bool

    val exists : (_, 'data, 'phantom) t -> f:('data -> bool) -> bool

    val existsi
      :  ('key, 'data, 'phantom) t
      -> f:(key:'key key -> data:'data -> bool)
      -> bool

    val count : (_, 'data, 'phantom) t -> f:('data -> bool) -> int

    val counti
      :  ('key, 'data, 'phantom) t
      -> f:(key:'key key -> data:'data -> bool)
      -> int

    val choose : ('key, 'data, 'phantom) t -> ('key key * 'data) option
    val choose_exn : ('key, 'data, 'phantom) t -> 'key key * 'data

    val choose_randomly
      :  ?random_state:Random.State.t
      -> ('key, 'data, 'phantom) t
      -> ('key key * 'data) option

    val choose_randomly_exn
      :  ?random_state:Random.State.t
      -> ('key, 'data, 'phantom) t
      -> 'key key * 'data

    val iter_keys : ('key, _, 'phantom) t -> f:('key key -> unit) -> unit
    val iter : (_, 'data, 'phantom) t -> f:('data -> unit) -> unit

    val iteri
      :  ('key, 'data, 'phantom) t
      -> f:(key:'key key -> data:'data -> unit)
      -> unit

    val map : ('key, 'data, 'phantom) t -> f:('data -> 'c) -> ('key, 'c, 'phantom) t

    val mapi
      :  ('key, 'data, 'phantom) t
      -> f:(key:'key key -> data:'data -> 'c)
      -> ('key, 'c, 'phantom) t

    val map_inplace : (_, 'data, 'phantom) t -> f:('data -> 'data) -> unit

    val mapi_inplace
      :  ('key, 'data, 'phantom) t
      -> f:(key:'key key -> data:'data -> 'data)
      -> unit

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

    val filter_keys_inplace : ('key, _, 'phantom) t -> f:('key key -> bool) -> unit
    val filter_inplace : (_, 'data, 'phantom) t -> f:('data -> bool) -> unit

    val filteri_inplace
      :  ('key, 'data, 'phantom) t
      -> f:(key:'key key -> data:'data -> bool)
      -> unit

    val filter_map
      :  ('key, 'data, 'phantom) t
      -> f:('data -> 'c option)
      -> ('key, 'c, 'phantom) t

    val filter_mapi
      :  ('key, 'data, 'phantom) t
      -> f:(key:'key key -> data:'data -> 'c option)
      -> ('key, 'c, 'phantom) t

    val filter_map_inplace : (_, 'data, 'phantom) t -> f:('data -> 'data option) -> unit

    val filter_mapi_inplace
      :  ('key, 'data, 'phantom) t
      -> f:(key:'key key -> data:'data -> 'data option)
      -> unit

    val partition_tf
      :  ('key, 'data, 'phantom) t
      -> f:('data -> bool)
      -> ('key, 'data, 'phantom) t * ('key, 'data, 'phantom) t

    val partitioni_tf
      :  ('key, 'data, 'phantom) t
      -> f:(key:'key key -> data:'data -> bool)
      -> ('key, 'data, 'phantom) t * ('key, 'data, 'phantom) t

    val partition_map
      :  ('key, 'data, 'phantom) t
      -> f:('data -> ('c, 'd) Either.t)
      -> ('key, 'c, 'phantom) t * ('key, 'd, 'phantom) t

    val partition_mapi
      :  ('key, 'data, 'phantom) t
      -> f:(key:'key key -> data:'data -> ('c, 'd) Either.t)
      -> ('key, 'c, 'phantom) t * ('key, 'd, 'phantom) t

    val merge
      : ( ('key, 'data1, 'phantom) t
          -> ('key, 'data2, 'phantom) t
          -> f:
               (key:'key key
                -> [ `Left of 'data1 | `Right of 'data2 | `Both of 'data1 * 'data2 ]
                -> 'data3 option)
          -> ('key, 'data3, 'phantom) t
          , 'key
          , 'data3
          , 'phantom )
          accessor

    val merge_into
      : ( src:('key, 'data1, 'phantom) t
          -> dst:('key, 'data2, 'phantom) t
          -> f:(key:'key key -> 'data1 -> 'data2 option -> 'data2 Merge_into_action.t)
          -> unit
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

  module type Creators = sig
    type 'key key
    type ('key, 'data, 'phantom) t
    type ('fn, 'key, 'data, 'phantom) creator

    val create : (unit -> ('key, 'data, 'phantom) t, 'key, 'data, 'phantom) creator

    val of_alist
      : ( ('key key * 'data) list
          -> [ `Ok of ('key, 'data, 'phantom) t | `Duplicate_key of 'key key ]
          , 'key
          , 'data
          , 'phantom )
          creator

    val of_alist_report_all_dups
      : ( ('key key * 'data) list
          -> [ `Ok of ('key, 'data, 'phantom) t | `Duplicate_keys of 'key key list ]
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
          , 'data list
          , 'phantom )
          creator

    val create_mapped
      : ( get_key:('a -> 'key key)
          -> get_data:('a -> 'data)
          -> 'a list
          -> [ `Ok of ('key, 'data, 'phantom) t | `Duplicate_keys of 'key key list ]
          , 'key
          , 'data
          , 'phantom )
          creator

    val create_with_key
      : ( get_key:('data -> 'key key)
          -> 'data list
          -> [ `Ok of ('key, 'data, 'phantom) t | `Duplicate_keys of 'key key list ]
          , 'key
          , 'data
          , 'phantom )
          creator

    val create_with_key_or_error
      : ( get_key:('data -> 'key key) -> 'data list -> ('key, 'data, 'phantom) t Or_error.t
          , 'key
          , 'data
          , 'phantom )
          creator

    val create_with_key_exn
      : ( get_key:('data -> 'key key) -> 'data list -> ('key, 'data, 'phantom) t
          , 'key
          , 'data
          , 'phantom )
          creator

    val group
      : ( get_key:('a -> 'key key)
          -> get_data:('a -> 'data)
          -> combine:('data -> 'data -> 'data)
          -> 'a list
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

module type Dictionary_mutable = sig
  include module type of struct
    include Definitions
  end
end
