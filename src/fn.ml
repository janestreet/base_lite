open! Import0

let const c _ = c

external ignore : 'a. 'a -> unit = "%ignore"

let non f x = not (f x)

let forever f =
  let rec forever () =
    f ();
    forever ()
  in
  try forever () with
  | e -> e
;;

external id : 'a. 'a -> 'a = "%identity"
external ( |> ) : 'a 'b. 'a -> ('a -> 'b) -> 'b = "%revapply"

let compose f g x = f (g x)
let flip f x y = f y x
let rec apply_n_times ~n f x = if n <= 0 then x else apply_n_times ~n:(n - 1) f (f x)
