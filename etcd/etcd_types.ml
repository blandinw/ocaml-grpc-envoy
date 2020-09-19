[@@@ocaml.warning "-27-30-39"]


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

let rec default_response_header 
  ?cluster_id:((cluster_id:int64) = 0L)
  ?member_id:((member_id:int64) = 0L)
  ?revision:((revision:int64) = 0L)
  ?raft_term:((raft_term:int64) = 0L)
  () : response_header  = {
  cluster_id;
  member_id;
  revision;
  raft_term;
}

let rec default_key_value 
  ?key:((key:bytes) = Bytes.create 0)
  ?create_revision:((create_revision:int64) = 0L)
  ?mod_revision:((mod_revision:int64) = 0L)
  ?version:((version:int64) = 0L)
  ?value:((value:bytes) = Bytes.create 0)
  ?lease:((lease:int64) = 0L)
  () : key_value  = {
  key;
  create_revision;
  mod_revision;
  version;
  value;
  lease;
}

let rec default_range_request_sort_order () = (None:range_request_sort_order)

let rec default_range_request_sort_target () = (Key:range_request_sort_target)

let rec default_range_request 
  ?key:((key:bytes) = Bytes.create 0)
  ?range_end:((range_end:bytes) = Bytes.create 0)
  ?limit:((limit:int64) = 0L)
  ?revision:((revision:int64) = 0L)
  ?sort_order:((sort_order:range_request_sort_order) = default_range_request_sort_order ())
  ?sort_target:((sort_target:range_request_sort_target) = default_range_request_sort_target ())
  ?serializable:((serializable:bool) = false)
  ?keys_only:((keys_only:bool) = false)
  ?count_only:((count_only:bool) = false)
  ?min_mod_revision:((min_mod_revision:int64) = 0L)
  ?max_mod_revision:((max_mod_revision:int64) = 0L)
  ?min_create_revision:((min_create_revision:int64) = 0L)
  ?max_create_revision:((max_create_revision:int64) = 0L)
  () : range_request  = {
  key;
  range_end;
  limit;
  revision;
  sort_order;
  sort_target;
  serializable;
  keys_only;
  count_only;
  min_mod_revision;
  max_mod_revision;
  min_create_revision;
  max_create_revision;
}

let rec default_range_response 
  ?header:((header:response_header option) = None)
  ?kvs:((kvs:key_value list) = [])
  ?more:((more:bool) = false)
  ?count:((count:int64) = 0L)
  () : range_response  = {
  header;
  kvs;
  more;
  count;
}

let rec default_put_request 
  ?key:((key:bytes) = Bytes.create 0)
  ?value:((value:bytes) = Bytes.create 0)
  ?lease:((lease:int64) = 0L)
  ?prev_kv:((prev_kv:bool) = false)
  ?ignore_value:((ignore_value:bool) = false)
  ?ignore_lease:((ignore_lease:bool) = false)
  () : put_request  = {
  key;
  value;
  lease;
  prev_kv;
  ignore_value;
  ignore_lease;
}

let rec default_put_response 
  ?header:((header:response_header option) = None)
  ?prev_kv:((prev_kv:key_value option) = None)
  () : put_response  = {
  header;
  prev_kv;
}
