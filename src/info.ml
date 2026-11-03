open! Import0
include Info0

module Utf8 = struct
  let to_string_hum t =
    match Internal_repr.of_info t with
    | String s -> s
    | _message -> String.Utf8.to_string (Sexp.Utf8.to_string_hum (sexp_of_t t))
  ;;

  let to_string_mach t = String.Utf8.to_string (Sexp.Utf8.to_string_mach (sexp_of_t t))
end
