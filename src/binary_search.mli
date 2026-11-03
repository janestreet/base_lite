open! Import0

val binary_search
  : 'elt 'key 't.
  ?pos:int
  -> ?len:int
  -> 't
  -> length:('t -> int)
  -> get:('t -> int -> 'elt)
  -> compare:('elt -> 'key -> int)
  -> [ `Last_strictly_less_than
     | `Last_less_than_or_equal_to
     | `Last_equal_to
     | `First_equal_to
     | `First_greater_than_or_equal_to
     | `First_strictly_greater_than
     ]
  -> 'key
  -> int option

val binary_search_segmented
  : 'elt 't.
  ?pos:int
  -> ?len:int
  -> 't
  -> length:('t -> int)
  -> get:('t -> int -> 'elt)
  -> segment_of:('elt -> [ `Left | `Right ])
  -> [ `Last_on_left | `First_on_right ]
  -> int option
