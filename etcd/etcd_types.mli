(** etcd.proto Types *)



(** {2 Types} *)

type response_header = {
  cluster_id : int64;
  member_id : int64;
  revision : int64;
  raft_term : int64;
}

type key_value = {
  key : bytes;
  create_revision : int64;
  mod_revision : int64;
  version : int64;
  value : bytes;
  lease : int64;
}

type range_request_sort_order =
  | None 
  | Ascend 
  | Descend 

type range_request_sort_target =
  | Key 
  | Version 
  | Create 
  | Mod 
  | Value 

type range_request = {
  key : bytes;
  range_end : bytes;
  limit : int64;
  revision : int64;
  sort_order : range_request_sort_order;
  sort_target : range_request_sort_target;
  serializable : bool;
  keys_only : bool;
  count_only : bool;
  min_mod_revision : int64;
  max_mod_revision : int64;
  min_create_revision : int64;
  max_create_revision : int64;
}

type range_response = {
  header : response_header option;
  kvs : key_value list;
  more : bool;
  count : int64;
}

type put_request = {
  key : bytes;
  value : bytes;
  lease : int64;
  prev_kv : bool;
  ignore_value : bool;
  ignore_lease : bool;
}

type put_response = {
  header : response_header option;
  prev_kv : key_value option;
}


(** {2 Default values} *)

val default_response_header : 
  ?cluster_id:int64 ->
  ?member_id:int64 ->
  ?revision:int64 ->
  ?raft_term:int64 ->
  unit ->
  response_header
(** [default_response_header ()] is the default value for type [response_header] *)

val default_key_value : 
  ?key:bytes ->
  ?create_revision:int64 ->
  ?mod_revision:int64 ->
  ?version:int64 ->
  ?value:bytes ->
  ?lease:int64 ->
  unit ->
  key_value
(** [default_key_value ()] is the default value for type [key_value] *)

val default_range_request_sort_order : unit -> range_request_sort_order
(** [default_range_request_sort_order ()] is the default value for type [range_request_sort_order] *)

val default_range_request_sort_target : unit -> range_request_sort_target
(** [default_range_request_sort_target ()] is the default value for type [range_request_sort_target] *)

val default_range_request : 
  ?key:bytes ->
  ?range_end:bytes ->
  ?limit:int64 ->
  ?revision:int64 ->
  ?sort_order:range_request_sort_order ->
  ?sort_target:range_request_sort_target ->
  ?serializable:bool ->
  ?keys_only:bool ->
  ?count_only:bool ->
  ?min_mod_revision:int64 ->
  ?max_mod_revision:int64 ->
  ?min_create_revision:int64 ->
  ?max_create_revision:int64 ->
  unit ->
  range_request
(** [default_range_request ()] is the default value for type [range_request] *)

val default_range_response : 
  ?header:response_header option ->
  ?kvs:key_value list ->
  ?more:bool ->
  ?count:int64 ->
  unit ->
  range_response
(** [default_range_response ()] is the default value for type [range_response] *)

val default_put_request : 
  ?key:bytes ->
  ?value:bytes ->
  ?lease:int64 ->
  ?prev_kv:bool ->
  ?ignore_value:bool ->
  ?ignore_lease:bool ->
  unit ->
  put_request
(** [default_put_request ()] is the default value for type [put_request] *)

val default_put_response : 
  ?header:response_header option ->
  ?prev_kv:key_value option ->
  unit ->
  put_response
(** [default_put_response ()] is the default value for type [put_response] *)
