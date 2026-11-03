open! Import0
include Stdlib.Printf

let failwithf fmt = ksprintf (fun s () -> failwith s) fmt
let invalid_argf fmt = ksprintf (fun s () -> invalid_arg s) fmt
