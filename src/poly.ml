module Bool = Bool0

external ( < ) : 'a -> 'a -> bool = "%lessthan"
external ( <= ) : 'a -> 'a -> bool = "%lessequal"
external ( <> ) : 'a -> 'a -> bool = "%notequal"
external ( = ) : 'a -> 'a -> bool = "%equal"
external ( > ) : 'a -> 'a -> bool = "%greaterthan"
external ( >= ) : 'a -> 'a -> bool = "%greaterequal"
external ascending : 'a -> 'a -> int = "%compare"
external compare : 'a -> 'a -> int = "%compare"
external equal : 'a -> 'a -> bool = "%equal"

let descending x y = compare y x
let max x y = Bool.select (x >= y) x y
let min x y = Bool.select (x <= y) x y
