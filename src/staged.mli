open! Import0

type +'a t

external stage : 'a -> 'a t = "%identity"
external unstage : 'a t -> 'a = "%identity"
