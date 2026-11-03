open! Import0
module Nothing = Nothing0
module Option = Option0

module Int = struct
  type t = int

  let max (x : t) y = if x > y then x else y
end

type ('k, 'v) t =
  | Empty
  | Node of
      { mutable left : ('k, 'v) t
      ; key : 'k
      ; mutable value : 'v
      ; mutable height : int
      ; mutable right : ('k, 'v) t
      }
  | Leaf of
      { key : 'k
      ; mutable value : 'v
      }

let empty = Empty
let get_empty () = Empty

let is_empty = function
  | Empty -> true
  | Leaf _ | Node _ -> false
;;

let height = function
  | Empty -> 0
  | Leaf _ -> 1
  | Node { left = _; key = _; value = _; height; right = _ } -> height
;;

let invariant compare =
  let rec inv = function
    | Empty | Leaf _ -> ()
    | Node { left; key = k; value = _; height = h; right } ->
      let hl, hr = height left, height right in
      inv left;
      inv right;
      legal_left_key k left;
      legal_right_key k right;
      assert (h = Int.max hl hr + 1);
      assert (abs (hl - hr) <= 2)
  and legal_left_key key = function
    | Empty -> ()
    | Leaf { key = left_key; value = _ }
    | Node { left = _; key = left_key; value = _; height = _; right = _ } ->
      assert (compare left_key key < 0)
  and legal_right_key key = function
    | Empty -> ()
    | Leaf { key = right_key; value = _ }
    | Node { left = _; key = right_key; value = _; height = _; right = _ } ->
      assert (compare right_key key > 0)
  in
  inv
;;

let invariant t ~compare = invariant compare t

let update_height = function
  | Node ({ left; key = _; value = _; height = old_height; right } as x) ->
    let new_height = Int.max (height left) (height right) + 1 in
    if new_height <> old_height then x.height <- new_height
  | Empty | Leaf _ -> assert false
;;

let balance tree =
  match tree with
  | Empty | Leaf _ -> tree
  | Node ({ left; key = _; value = _; height = _; right } as root_node) ->
    let hl = height left
    and hr = height right in
    if hl > hr + 2
    then (
      match left with
      | Empty | Leaf _ -> assert false
      | Node
          ({ left = left_node_left
           ; key = _
           ; value = _
           ; height = _
           ; right = left_node_right
           } as left_node) ->
        if height left_node_left >= height left_node_right
        then (
          root_node.left <- left_node_right;
          left_node.right <- tree;
          update_height tree;
          update_height left;
          left)
        else (
          match left_node_right with
          | Empty | Leaf _ -> assert false
          | Node
              ({ left = lr_left; key = _; value = _; height = _; right = lr_right } as
               lr_node) ->
            left_node.right <- lr_left;
            root_node.left <- lr_right;
            lr_node.right <- tree;
            lr_node.left <- left;
            update_height left;
            update_height tree;
            update_height left_node_right;
            left_node_right))
    else if hr > hl + 2
    then (
      match right with
      | Empty | Leaf _ -> assert false
      | Node
          ({ left = right_node_left
           ; key = _
           ; value = _
           ; height = _
           ; right = right_node_right
           } as right_node) ->
        if height right_node_right >= height right_node_left
        then (
          root_node.right <- right_node_left;
          right_node.left <- tree;
          update_height tree;
          update_height right;
          right)
        else (
          match right_node_left with
          | Empty | Leaf _ -> assert false
          | Node
              ({ left = rl_left; key = _; value = _; height = _; right = rl_right } as
               rl_node) ->
            right_node.left <- rl_right;
            root_node.right <- rl_left;
            rl_node.left <- tree;
            rl_node.right <- right;
            update_height right;
            update_height tree;
            update_height right_node_left;
            right_node_left))
    else (
      update_height tree;
      tree)
;;

let rec add t ~replace ~compare ~added ~key:k ~data:v =
  match t with
  | Empty ->
    added := true;
    Leaf { key = k; value = v }
  | Leaf ({ key = k'; value = _ } as r) ->
    let c = compare k' k in
    if c = 0
    then (
      added := false;
      if replace then r.value <- v;
      t)
    else (
      added := true;
      if c < 0
      then Node { left = t; key = k; value = v; height = 2; right = Empty }
      else Node { left = Empty; key = k; value = v; height = 2; right = t })
  | Node ({ left; key = k'; value = _; height = _; right } as r) ->
    let c = compare k k' in
    if c = 0
    then (
      added := false;
      if replace then r.value <- v;
      t)
    else (
      if c < 0
      then (
        let left' = add left ~replace ~added ~compare ~key:k ~data:v in
        if not (phys_equal left' left) then r.left <- left')
      else (
        let right' = add right ~replace ~added ~compare ~key:k ~data:v in
        if not (phys_equal right' right) then r.right <- right');
      if !added then balance t else t)
;;

let rec findi_and_call_impl
  : type k v a b r if_ in_.
    (k, v) t
    -> compare:(k -> k -> int)
    -> k
    -> a
    -> b
    -> call_if_found:(if_found:if_ -> key:k -> data:v -> a -> b -> r)
    -> call_if_not_found:(if_not_found:in_ -> k -> a -> b -> r)
    -> if_found:if_
    -> if_not_found:in_
    -> r
  =
  fun t ~compare k arg1 arg2 ~call_if_found ~call_if_not_found ~if_found ~if_not_found ->
  match t with
  | Empty -> call_if_not_found ~if_not_found k arg1 arg2
  | Leaf { key = k'; value = v } ->
    if compare k k' = 0
    then call_if_found ~if_found ~key:k' ~data:v arg1 arg2
    else call_if_not_found ~if_not_found k arg1 arg2
  | Node { left; key = k'; value = v; height = _; right } ->
    let c = compare k k' in
    if c = 0
    then call_if_found ~if_found ~key:k' ~data:v arg1 arg2
    else
      findi_and_call_impl
        (if c < 0 then left else right)
        ~compare
        k
        arg1
        arg2
        ~call_if_found
        ~call_if_not_found
        ~if_found
        ~if_not_found
;;

let find_and_call =
  let call_if_found ~if_found ~key:_ ~data () () = if_found data in
  let call_if_not_found ~if_not_found key () () = if_not_found key in
  fun t ~compare k ~if_found ~if_not_found ->
    findi_and_call_impl
      t
      ~compare
      k
      ()
      ()
      ~call_if_found
      ~call_if_not_found
      ~if_found
      ~if_not_found
;;

let findi_and_call =
  let call_if_found ~if_found ~key ~data () () = if_found ~key ~data in
  let call_if_not_found ~if_not_found key () () = if_not_found key in
  fun t ~compare k ~if_found ~if_not_found ->
    findi_and_call_impl
      t
      ~compare
      k
      ()
      ()
      ~call_if_found
      ~call_if_not_found
      ~if_found
      ~if_not_found
;;

let find_and_call1 =
  let call_if_found ~if_found ~key:_ ~data arg () = if_found data arg in
  let call_if_not_found ~if_not_found key arg () = if_not_found key arg in
  fun t ~compare k ~a ~if_found ~if_not_found ->
    findi_and_call_impl
      t
      ~compare
      k
      a
      ()
      ~call_if_found
      ~call_if_not_found
      ~if_found
      ~if_not_found
;;

let findi_and_call1 =
  let call_if_found ~if_found ~key ~data arg () = if_found ~key ~data arg in
  let call_if_not_found ~if_not_found key arg () = if_not_found key arg in
  fun t ~compare k ~a ~if_found ~if_not_found ->
    findi_and_call_impl
      t
      ~compare
      k
      a
      ()
      ~call_if_found
      ~call_if_not_found
      ~if_found
      ~if_not_found
;;

let find_and_call2 =
  let call_if_found ~if_found ~key:_ ~data arg1 arg2 = if_found data arg1 arg2 in
  let call_if_not_found ~if_not_found key arg1 arg2 = if_not_found key arg1 arg2 in
  fun t ~compare k ~a ~b ~if_found ~if_not_found ->
    findi_and_call_impl
      t
      ~compare
      k
      a
      b
      ~call_if_found
      ~call_if_not_found
      ~if_found
      ~if_not_found
;;

let findi_and_call2 =
  let call_if_found ~if_found ~key ~data arg1 arg2 = if_found ~key ~data arg1 arg2 in
  let call_if_not_found ~if_not_found key arg1 arg2 = if_not_found key arg1 arg2 in
  fun t ~compare k ~a ~b ~if_found ~if_not_found ->
    findi_and_call_impl
      t
      ~compare
      k
      a
      b
      ~call_if_found
      ~call_if_not_found
      ~if_found
      ~if_not_found
;;

let find =
  let if_found v : _ Option.t Modes.t = { modal = Some v } in
  let if_not_found _ : _ Option.t Modes.t = { modal = None } in
  fun t ~compare k -> (find_and_call t ~compare k ~if_found ~if_not_found).modal
;;

let mem =
  let if_found _ = true in
  let if_not_found _ = false in
  fun t ~compare k -> find_and_call t ~compare k ~if_found ~if_not_found
;;

let rec remove =
  let rec min_elt tree =
    match tree with
    | Empty -> Empty
    | Leaf _ -> tree
    | Node { left = Empty; key = _; value = _; height = _; right = _ } -> tree
    | Node { left; key = _; value = _; height = _; right = _ } -> min_elt left
  in
  let rec remove_min_elt tree =
    match tree with
    | Empty -> assert false
    | Leaf _ -> Empty
    | Node { left = Empty; key = _; value = _; height = _; right } -> right
    | Node { left = Leaf _; key = k; value = v; height = _; right = Empty } ->
      Leaf { key = k; value = v }
    | Node ({ left; key = _; value = _; height = _; right = _ } as r) ->
      r.left <- remove_min_elt left;
      balance tree
  in
  let merge t1 t2 =
    match t1, t2 with
    | Empty, t -> t
    | t, Empty -> t
    | _, _ ->
      let tree = min_elt t2 in
      balance
        (match tree with
         | Empty -> assert false
         | Leaf { key = k; value = v } ->
           let t2 = remove_min_elt t2 in
           Node
             { left = t1
             ; key = k
             ; value = v
             ; height = Int.max (height t1) (height t2) + 1
             ; right = t2
             }
         | Node r ->
           r.right <- remove_min_elt t2;
           r.left <- t1;
           tree)
  in
  fun t ~removed ~compare k ->
    match t with
    | Empty ->
      removed := false;
      Empty
    | Leaf { key = k'; value = _ } ->
      if compare k k' = 0
      then (
        removed := true;
        Empty)
      else (
        removed := false;
        t)
    | Node ({ left; key = k'; value = _; height = _; right } as r) ->
      let c = compare k k' in
      if c = 0
      then (
        removed := true;
        merge left right)
      else (
        if c < 0
        then (
          let left' = remove left ~removed ~compare k in
          if not (phys_equal left' left) then r.left <- left')
        else (
          let right' = remove right ~removed ~compare k in
          if not (phys_equal right' right) then r.right <- right');
        if !removed then balance t else t)
;;

let rec fold t ~init ~f =
  match t with
  | Empty -> init
  | Leaf { key; value = data } -> f ~key ~data init
  | Node
      { left = Leaf { key = lkey; value = ldata }
      ; key
      ; value = data
      ; height = _
      ; right = Leaf { key = rkey; value = rdata }
      } -> f ~key:rkey ~data:rdata (f ~key ~data (f ~key:lkey ~data:ldata init))
  | Node
      { left = Leaf { key = lkey; value = ldata }
      ; key
      ; value = data
      ; height = _
      ; right = Empty
      } -> f ~key ~data (f ~key:lkey ~data:ldata init)
  | Node
      { left = Empty
      ; key
      ; value = data
      ; height = _
      ; right = Leaf { key = rkey; value = rdata }
      } -> f ~key:rkey ~data:rdata (f ~key ~data init)
  | Node
      { left; key; value = data; height = _; right = Leaf { key = rkey; value = rdata } }
    -> f ~key:rkey ~data:rdata (f ~key ~data (fold left ~init ~f))
  | Node
      { left = Leaf { key = lkey; value = ldata }; key; value = data; height = _; right }
    -> fold right ~init:(f ~key ~data (f ~key:lkey ~data:ldata init)) ~f
  | Node { left; key; value = data; height = _; right } ->
    fold right ~init:(f ~key ~data (fold left ~init ~f)) ~f
;;

let rec iter t ~f =
  match t with
  | Empty -> ()
  | Leaf { key; value = data } -> f ~key ~data
  | Node { left; key; value = data; height = _; right } ->
    iter left ~f;
    f ~key ~data;
    iter right ~f
;;

let rec exists t ~f =
  match t with
  | Empty -> false
  | Leaf { key; value = data } -> f ~key ~data
  | Node { left; key; value = data; height = _; right } ->
    exists left ~f || f ~key ~data || exists right ~f
;;

let rec mapi_inplace t ~f =
  match t with
  | Empty -> ()
  | Leaf ({ key; value } as t) -> t.value <- f ~key ~data:value
  | Node ({ left; key; value; height = _; right } as t) ->
    mapi_inplace ~f left;
    t.value <- f ~key ~data:value;
    mapi_inplace ~f right
;;

let choose_exn = function
  | Empty ->
    (match invalid_arg "[Avltree.choose_exn] of empty hashtbl" with
     | (_ : Nothing.t) -> .)
  | Leaf { key; value; _ } | Node { key; value; _ } -> key, value
;;

let rec first t =
  match t with
  | Empty -> None
  | Leaf { key = k; value = v }
  | Node { left = Empty; key = k; value = v; height = _; right = _ } -> Some (k, v)
  | Node { left = l; key = _; value = _; height = _; right = _ } -> first l
;;

let rec last t =
  match t with
  | Empty -> None
  | Leaf { key = k; value = v }
  | Node { left = _; key = k; value = v; height = _; right = Empty } -> Some (k, v)
  | Node { left = _; key = _; value = _; height = _; right = r } -> last r
;;
