[@@@warning "-preprocessor"]

module Definitions = struct
  module type S = sig
    type t

    include sig
      [@@@ocaml.warning "-32"]

      external ( = ) : t -> t -> bool = "%equal"
      external ( <> ) : t -> t -> bool = "%notequal"
      external ( < ) : t -> t -> bool = "%lessthan"
      external ( > ) : t -> t -> bool = "%greaterthan"
      external ( <= ) : t -> t -> bool = "%lessequal"
      external ( >= ) : t -> t -> bool = "%greaterequal"
      external compare : t -> t -> int = "%compare"
      external compare__local : t -> t -> int = "%compare"
      external equal : t -> t -> bool = "%equal"
      external equal__local : t -> t -> bool = "%equal"
      val ascending : t -> t -> int
      val descending : t -> t -> int
      val max : t -> t -> t
      val min : t -> t -> t
      val max__local : t -> t -> t
      val min__local : t -> t -> t
    end
    [@@merlin.hide]
  end
end

module type Replace_polymorphic_compare = sig
  include module type of struct
    include Definitions
  end

  module Bool_replace_polymorphic_compare : S with type t := bool
  module Bytes_replace_polymorphic_compare : S with type t := bytes
  module Char_replace_polymorphic_compare : S with type t := char
  module Float_replace_polymorphic_compare : S with type t := float
  module Int32_replace_polymorphic_compare : S with type t := int32
  module Int64_replace_polymorphic_compare : S with type t := int64
  module Int_replace_polymorphic_compare : S with type t := int
  module Nativeint_replace_polymorphic_compare : S with type t := nativeint
  module String_replace_polymorphic_compare : S with type t := string
  module Uchar_replace_polymorphic_compare : S with type t := Stdlib.Uchar.t
end
