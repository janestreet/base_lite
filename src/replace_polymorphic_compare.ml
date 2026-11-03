[@@@warning "-preprocessor"]

include Replace_polymorphic_compare_intf.Definitions

module Bool_replace_polymorphic_compare = struct
  type t = bool

  include struct
    let _ = fun (_ : t) -> ()

    external ( = ) : t -> t -> bool = "%equal"
    external ( <> ) : t -> t -> bool = "%notequal"
    external ( < ) : t -> t -> bool = "%lessthan"
    external ( > ) : t -> t -> bool = "%greaterthan"
    external ( <= ) : t -> t -> bool = "%lessequal"
    external ( >= ) : t -> t -> bool = "%greaterequal"
    external compare : t -> t -> int = "%compare"
    external equal : t -> t -> bool = "%equal"

    let ascending x y = compare x y
    let _ = ascending
    let descending x y = compare y x
    let _ = descending
    let max x y = Bool0.select (x >= y) x y
    let _ = max
    let min x y = Bool0.select (x <= y) x y
    let _ = min
    let _ = max
    let _ = min
  end [@@merlin.hide]
end

module Bytes_replace_polymorphic_compare = struct
  type t = bytes

  include struct
    let _ = fun (_ : t) -> ()

    external ( = ) : t -> t -> bool = "%equal"
    external ( <> ) : t -> t -> bool = "%notequal"
    external ( < ) : t -> t -> bool = "%lessthan"
    external ( > ) : t -> t -> bool = "%greaterthan"
    external ( <= ) : t -> t -> bool = "%lessequal"
    external ( >= ) : t -> t -> bool = "%greaterequal"
    external compare : t -> t -> int = "%compare"
    external equal : t -> t -> bool = "%equal"

    let ascending x y = compare x y
    let _ = ascending
    let descending x y = compare y x
    let _ = descending
    let max x y = Bool0.select (x >= y) x y
    let _ = max
    let min x y = Bool0.select (x <= y) x y
    let _ = min
    let _ = max
    let _ = min
  end [@@merlin.hide]
end

module Char_replace_polymorphic_compare = struct
  type t = char

  include struct
    let _ = fun (_ : t) -> ()

    external ( = ) : t -> t -> bool = "%equal"
    external ( <> ) : t -> t -> bool = "%notequal"
    external ( < ) : t -> t -> bool = "%lessthan"
    external ( > ) : t -> t -> bool = "%greaterthan"
    external ( <= ) : t -> t -> bool = "%lessequal"
    external ( >= ) : t -> t -> bool = "%greaterequal"
    external compare : t -> t -> int = "%compare"
    external equal : t -> t -> bool = "%equal"

    let ascending x y = compare x y
    let _ = ascending
    let descending x y = compare y x
    let _ = descending
    let max x y = Bool0.select (x >= y) x y
    let _ = max
    let min x y = Bool0.select (x <= y) x y
    let _ = min
    let _ = max
    let _ = min
  end [@@merlin.hide]
end

module Float_replace_polymorphic_compare = struct
  type t = float

  include struct
    let _ = fun (_ : t) -> ()

    external ( = ) : t -> t -> bool = "%equal"
    external ( <> ) : t -> t -> bool = "%notequal"
    external ( < ) : t -> t -> bool = "%lessthan"
    external ( > ) : t -> t -> bool = "%greaterthan"
    external ( <= ) : t -> t -> bool = "%lessequal"
    external ( >= ) : t -> t -> bool = "%greaterequal"
    external compare : t -> t -> int = "%compare"
    external equal : t -> t -> bool = "%equal"

    let ascending x y = compare x y
    let _ = ascending
    let descending x y = compare y x
    let _ = descending
    let max x y = Bool0.select (x >= y) x y
    let _ = max
    let min x y = Bool0.select (x <= y) x y
    let _ = min
    let _ = max
    let _ = min
  end [@@merlin.hide]
end

module Int32_replace_polymorphic_compare = struct
  type t = int32

  include struct
    let _ = fun (_ : t) -> ()

    external ( = ) : t -> t -> bool = "%equal"
    external ( <> ) : t -> t -> bool = "%notequal"
    external ( < ) : t -> t -> bool = "%lessthan"
    external ( > ) : t -> t -> bool = "%greaterthan"
    external ( <= ) : t -> t -> bool = "%lessequal"
    external ( >= ) : t -> t -> bool = "%greaterequal"
    external compare : t -> t -> int = "%compare"
    external equal : t -> t -> bool = "%equal"

    let ascending x y = compare x y
    let _ = ascending
    let descending x y = compare y x
    let _ = descending
    let max x y = Bool0.select (x >= y) x y
    let _ = max
    let min x y = Bool0.select (x <= y) x y
    let _ = min
    let _ = max
    let _ = min
  end [@@merlin.hide]
end

module Int64_replace_polymorphic_compare = struct
  type t = int64

  include struct
    let _ = fun (_ : t) -> ()

    external ( = ) : t -> t -> bool = "%equal"
    external ( <> ) : t -> t -> bool = "%notequal"
    external ( < ) : t -> t -> bool = "%lessthan"
    external ( > ) : t -> t -> bool = "%greaterthan"
    external ( <= ) : t -> t -> bool = "%lessequal"
    external ( >= ) : t -> t -> bool = "%greaterequal"
    external compare : t -> t -> int = "%compare"
    external equal : t -> t -> bool = "%equal"

    let ascending x y = compare x y
    let _ = ascending
    let descending x y = compare y x
    let _ = descending
    let max x y = Bool0.select (x >= y) x y
    let _ = max
    let min x y = Bool0.select (x <= y) x y
    let _ = min
    let _ = max
    let _ = min
  end [@@merlin.hide]
end

module Int_replace_polymorphic_compare = struct
  type t = int

  include struct
    let _ = fun (_ : t) -> ()

    external ( = ) : t -> t -> bool = "%equal"
    external ( <> ) : t -> t -> bool = "%notequal"
    external ( < ) : t -> t -> bool = "%lessthan"
    external ( > ) : t -> t -> bool = "%greaterthan"
    external ( <= ) : t -> t -> bool = "%lessequal"
    external ( >= ) : t -> t -> bool = "%greaterequal"
    external compare : t -> t -> int = "%compare"
    external equal : t -> t -> bool = "%equal"

    let ascending x y = compare x y
    let _ = ascending
    let descending x y = compare y x
    let _ = descending
    let max x y = Bool0.select (x >= y) x y
    let _ = max
    let min x y = Bool0.select (x <= y) x y
    let _ = min
    let _ = max
    let _ = min
  end [@@merlin.hide]
end

module Nativeint_replace_polymorphic_compare = struct
  type t = nativeint

  include struct
    let _ = fun (_ : t) -> ()

    external ( = ) : t -> t -> bool = "%equal"
    external ( <> ) : t -> t -> bool = "%notequal"
    external ( < ) : t -> t -> bool = "%lessthan"
    external ( > ) : t -> t -> bool = "%greaterthan"
    external ( <= ) : t -> t -> bool = "%lessequal"
    external ( >= ) : t -> t -> bool = "%greaterequal"
    external compare : t -> t -> int = "%compare"
    external equal : t -> t -> bool = "%equal"

    let ascending x y = compare x y
    let _ = ascending
    let descending x y = compare y x
    let _ = descending
    let max x y = Bool0.select (x >= y) x y
    let _ = max
    let min x y = Bool0.select (x <= y) x y
    let _ = min
    let _ = max
    let _ = min
  end [@@merlin.hide]
end

module String_replace_polymorphic_compare = struct
  type t = string

  include struct
    let _ = fun (_ : t) -> ()

    external ( = ) : t -> t -> bool = "%equal"
    external ( <> ) : t -> t -> bool = "%notequal"
    external ( < ) : t -> t -> bool = "%lessthan"
    external ( > ) : t -> t -> bool = "%greaterthan"
    external ( <= ) : t -> t -> bool = "%lessequal"
    external ( >= ) : t -> t -> bool = "%greaterequal"
    external compare : t -> t -> int = "%compare"
    external equal : t -> t -> bool = "%equal"

    let ascending x y = compare x y
    let _ = ascending
    let descending x y = compare y x
    let _ = descending
    let max x y = Bool0.select (x >= y) x y
    let _ = max
    let min x y = Bool0.select (x <= y) x y
    let _ = min
    let _ = max
    let _ = min
  end [@@merlin.hide]
end

module Uchar_replace_polymorphic_compare = struct
  type t = Stdlib.Uchar.t

  include struct
    let _ = fun (_ : t) -> ()

    external ( = ) : t -> t -> bool = "%equal"
    external ( <> ) : t -> t -> bool = "%notequal"
    external ( < ) : t -> t -> bool = "%lessthan"
    external ( > ) : t -> t -> bool = "%greaterthan"
    external ( <= ) : t -> t -> bool = "%lessequal"
    external ( >= ) : t -> t -> bool = "%greaterequal"
    external compare : t -> t -> int = "%compare"
    external equal : t -> t -> bool = "%equal"

    let ascending x y = compare x y
    let _ = ascending
    let descending x y = compare y x
    let _ = descending
    let max x y = Bool0.select (x >= y) x y
    let _ = max
    let min x y = Bool0.select (x <= y) x y
    let _ = min
    let _ = max
    let _ = min
  end [@@merlin.hide]
end
