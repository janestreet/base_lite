open! Import0

type 'a t = 'a

external stage : 'a -> 'a = "%identity"
external unstage : 'a -> 'a = "%identity"
