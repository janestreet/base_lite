open! Import0

type 'a t = 'a Stdlib.Queue.t

let create = Stdlib.Queue.create
let clear __eta_0 = Stdlib.Queue.clear __eta_0
let copy = Stdlib.Queue.copy
let is_empty = Stdlib.Queue.is_empty
let length = Stdlib.Queue.length
let peek __eta_0 = Stdlib.Queue.peek __eta_0
let pop __eta_0 = Stdlib.Queue.pop __eta_0
let push = Stdlib.Queue.push
let transfer __eta_0 __eta_1 = Stdlib.Queue.transfer __eta_0 __eta_1
let iter t ~f = Stdlib.Queue.iter f t
let fold t ~init ~f = Stdlib.Queue.fold f init t
