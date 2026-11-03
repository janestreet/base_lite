val get_argv : unit -> string array

val argv : string array
[@@deprecated
  "[since 2019-08] Use [Sys.get_argv] instead, which has the correct behavior when \
   [caml_sys_modify_argv] is called."]

val interactive : bool ref
val os_type : string
val unix : bool
val win32 : bool
val cygwin : bool

type backend_type = Sys0.backend_type =
  | Native
  | Bytecode
  | Other of string

val backend_type : backend_type
val word_size_in_bits : int
val int_size_in_bits : int
val big_endian : bool
val max_string_length : int
val max_array_length : int
val runtime_variant : unit -> string
val runtime_parameters : unit -> string
val ocaml_version : string
val enable_runtime_warnings : bool -> unit
val runtime_warnings_enabled : unit -> bool
val getenv : string -> string option
val getenv_exn : string -> string
external opaque_identity : 'a. 'a -> 'a = "%opaque"
external opaque_identity_global : 'a. 'a -> 'a = "%opaque"
