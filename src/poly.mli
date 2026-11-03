external compare : 'a -> 'a -> int = "%compare"
val ascending : 'a -> 'a -> int
val descending : 'a -> 'a -> int
external ( < ) : 'a -> 'a -> bool = "%lessthan"
external ( <= ) : 'a -> 'a -> bool = "%lessequal"
external ( <> ) : 'a -> 'a -> bool = "%notequal"
external ( = ) : 'a -> 'a -> bool = "%equal"
external ( > ) : 'a -> 'a -> bool = "%greaterthan"
external ( >= ) : 'a -> 'a -> bool = "%greaterequal"
external equal : 'a -> 'a -> bool = "%equal"
val min : 'a -> 'a -> 'a
val max : 'a -> 'a -> 'a
