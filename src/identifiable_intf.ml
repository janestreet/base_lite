open! Import0

module Definitions = struct
  module type Arg = sig
    type t

    include sig
      [@@@ocaml.warning "-32"]

      include Ppx_compare_lib.Comparable.S with type t := t
      include Ppx_hash_lib.Hashable.S with type t := t
      include Sexplib0.Sexpable.S with type t := t
    end
    [@@merlin.hide]

    include Stringable.S with type t := t

    val module_name : string
  end

  module type Arg_with_comparator = sig
    include Arg
    include Comparator.S with type t := t
  end

  module type S = sig
    type t

    include sig
      [@@@ocaml.warning "-32"]

      include Ppx_hash_lib.Hashable.S with type t := t
      include Sexplib0.Sexpable.S with type t := t
    end
    [@@merlin.hide]

    include Stringable.S with type t := t
    include Comparable.S with type t := t
    include Pretty_printer.S with type t := t

    val hashable : t Hashable.t
  end
end

module type Identifiable = sig
  include module type of struct
    include Definitions
  end

  module Make : functor (M : Arg) -> S with type t := M.t

  module Make_using_comparator : functor (M : Arg_with_comparator) ->
    S with type t := M.t with type comparator_witness := M.comparator_witness
end
