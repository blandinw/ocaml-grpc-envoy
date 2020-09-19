[@@@ocaml.warning "-27-30-39"]

type response_header_mutable = {
  mutable cluster_id : int64;
  mutable member_id : int64;
  mutable revision : int64;
  mutable raft_term : int64;
}

let default_response_header_mutable () : response_header_mutable = {
  cluster_id = 0L;
  member_id = 0L;
  revision = 0L;
  raft_term = 0L;
}

type key_value_mutable = {
  mutable key : bytes;
  mutable create_revision : int64;
  mutable mod_revision : int64;
  mutable version : int64;
  mutable value : bytes;
  mutable lease : int64;
}

let default_key_value_mutable () : key_value_mutable = {
  key = Bytes.create 0;
  create_revision = 0L;
  mod_revision = 0L;
  version = 0L;
  value = Bytes.create 0;
  lease = 0L;
}

type range_request_mutable = {
  mutable key : bytes;
  mutable range_end : bytes;
  mutable limit : int64;
  mutable revision : int64;
  mutable sort_order : Etcd_types.range_request_sort_order;
  mutable sort_target : Etcd_types.range_request_sort_target;
  mutable serializable : bool;
  mutable keys_only : bool;
  mutable count_only : bool;
  mutable min_mod_revision : int64;
  mutable max_mod_revision : int64;
  mutable min_create_revision : int64;
  mutable max_create_revision : int64;
}

let default_range_request_mutable () : range_request_mutable = {
  key = Bytes.create 0;
  range_end = Bytes.create 0;
  limit = 0L;
  revision = 0L;
  sort_order = Etcd_types.default_range_request_sort_order ();
  sort_target = Etcd_types.default_range_request_sort_target ();
  serializable = false;
  keys_only = false;
  count_only = false;
  min_mod_revision = 0L;
  max_mod_revision = 0L;
  min_create_revision = 0L;
  max_create_revision = 0L;
}

type range_response_mutable = {
  mutable header : Etcd_types.response_header option;
  mutable kvs : Etcd_types.key_value list;
  mutable more : bool;
  mutable count : int64;
}

let default_range_response_mutable () : range_response_mutable = {
  header = None;
  kvs = [];
  more = false;
  count = 0L;
}

type put_request_mutable = {
  mutable key : bytes;
  mutable value : bytes;
  mutable lease : int64;
  mutable prev_kv : bool;
  mutable ignore_value : bool;
  mutable ignore_lease : bool;
}

let default_put_request_mutable () : put_request_mutable = {
  key = Bytes.create 0;
  value = Bytes.create 0;
  lease = 0L;
  prev_kv = false;
  ignore_value = false;
  ignore_lease = false;
}

type put_response_mutable = {
  mutable header : Etcd_types.response_header option;
  mutable prev_kv : Etcd_types.key_value option;
}

let default_put_response_mutable () : put_response_mutable = {
  header = None;
  prev_kv = None;
}


let rec decode_response_header d =
  let v = default_response_header_mutable () in
  let continue__= ref true in
  while !continue__ do
    match Pbrt.Decoder.key d with
    | None -> (
    ); continue__ := false
    | Some (1, Pbrt.Varint) -> begin
      v.cluster_id <- Pbrt.Decoder.int64_as_varint d;
    end
    | Some (1, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(response_header), field(1)" pk
    | Some (2, Pbrt.Varint) -> begin
      v.member_id <- Pbrt.Decoder.int64_as_varint d;
    end
    | Some (2, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(response_header), field(2)" pk
    | Some (3, Pbrt.Varint) -> begin
      v.revision <- Pbrt.Decoder.int64_as_varint d;
    end
    | Some (3, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(response_header), field(3)" pk
    | Some (4, Pbrt.Varint) -> begin
      v.raft_term <- Pbrt.Decoder.int64_as_varint d;
    end
    | Some (4, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(response_header), field(4)" pk
    | Some (_, payload_kind) -> Pbrt.Decoder.skip d payload_kind
  done;
  ({
    Etcd_types.cluster_id = v.cluster_id;
    Etcd_types.member_id = v.member_id;
    Etcd_types.revision = v.revision;
    Etcd_types.raft_term = v.raft_term;
  } : Etcd_types.response_header)

let rec decode_key_value d =
  let v = default_key_value_mutable () in
  let continue__= ref true in
  while !continue__ do
    match Pbrt.Decoder.key d with
    | None -> (
    ); continue__ := false
    | Some (1, Pbrt.Bytes) -> begin
      v.key <- Pbrt.Decoder.bytes d;
    end
    | Some (1, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(key_value), field(1)" pk
    | Some (2, Pbrt.Varint) -> begin
      v.create_revision <- Pbrt.Decoder.int64_as_varint d;
    end
    | Some (2, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(key_value), field(2)" pk
    | Some (3, Pbrt.Varint) -> begin
      v.mod_revision <- Pbrt.Decoder.int64_as_varint d;
    end
    | Some (3, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(key_value), field(3)" pk
    | Some (4, Pbrt.Varint) -> begin
      v.version <- Pbrt.Decoder.int64_as_varint d;
    end
    | Some (4, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(key_value), field(4)" pk
    | Some (5, Pbrt.Bytes) -> begin
      v.value <- Pbrt.Decoder.bytes d;
    end
    | Some (5, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(key_value), field(5)" pk
    | Some (6, Pbrt.Varint) -> begin
      v.lease <- Pbrt.Decoder.int64_as_varint d;
    end
    | Some (6, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(key_value), field(6)" pk
    | Some (_, payload_kind) -> Pbrt.Decoder.skip d payload_kind
  done;
  ({
    Etcd_types.key = v.key;
    Etcd_types.create_revision = v.create_revision;
    Etcd_types.mod_revision = v.mod_revision;
    Etcd_types.version = v.version;
    Etcd_types.value = v.value;
    Etcd_types.lease = v.lease;
  } : Etcd_types.key_value)

let rec decode_range_request_sort_order d = 
  match Pbrt.Decoder.int_as_varint d with
  | 0 -> (Etcd_types.None:Etcd_types.range_request_sort_order)
  | 1 -> (Etcd_types.Ascend:Etcd_types.range_request_sort_order)
  | 2 -> (Etcd_types.Descend:Etcd_types.range_request_sort_order)
  | _ -> Pbrt.Decoder.malformed_variant "range_request_sort_order"

let rec decode_range_request_sort_target d = 
  match Pbrt.Decoder.int_as_varint d with
  | 0 -> (Etcd_types.Key:Etcd_types.range_request_sort_target)
  | 1 -> (Etcd_types.Version:Etcd_types.range_request_sort_target)
  | 2 -> (Etcd_types.Create:Etcd_types.range_request_sort_target)
  | 3 -> (Etcd_types.Mod:Etcd_types.range_request_sort_target)
  | 4 -> (Etcd_types.Value:Etcd_types.range_request_sort_target)
  | _ -> Pbrt.Decoder.malformed_variant "range_request_sort_target"

let rec decode_range_request d =
  let v = default_range_request_mutable () in
  let continue__= ref true in
  while !continue__ do
    match Pbrt.Decoder.key d with
    | None -> (
    ); continue__ := false
    | Some (1, Pbrt.Bytes) -> begin
      v.key <- Pbrt.Decoder.bytes d;
    end
    | Some (1, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(range_request), field(1)" pk
    | Some (2, Pbrt.Bytes) -> begin
      v.range_end <- Pbrt.Decoder.bytes d;
    end
    | Some (2, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(range_request), field(2)" pk
    | Some (3, Pbrt.Varint) -> begin
      v.limit <- Pbrt.Decoder.int64_as_varint d;
    end
    | Some (3, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(range_request), field(3)" pk
    | Some (4, Pbrt.Varint) -> begin
      v.revision <- Pbrt.Decoder.int64_as_varint d;
    end
    | Some (4, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(range_request), field(4)" pk
    | Some (5, Pbrt.Varint) -> begin
      v.sort_order <- decode_range_request_sort_order d;
    end
    | Some (5, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(range_request), field(5)" pk
    | Some (6, Pbrt.Varint) -> begin
      v.sort_target <- decode_range_request_sort_target d;
    end
    | Some (6, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(range_request), field(6)" pk
    | Some (7, Pbrt.Varint) -> begin
      v.serializable <- Pbrt.Decoder.bool d;
    end
    | Some (7, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(range_request), field(7)" pk
    | Some (8, Pbrt.Varint) -> begin
      v.keys_only <- Pbrt.Decoder.bool d;
    end
    | Some (8, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(range_request), field(8)" pk
    | Some (9, Pbrt.Varint) -> begin
      v.count_only <- Pbrt.Decoder.bool d;
    end
    | Some (9, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(range_request), field(9)" pk
    | Some (10, Pbrt.Varint) -> begin
      v.min_mod_revision <- Pbrt.Decoder.int64_as_varint d;
    end
    | Some (10, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(range_request), field(10)" pk
    | Some (11, Pbrt.Varint) -> begin
      v.max_mod_revision <- Pbrt.Decoder.int64_as_varint d;
    end
    | Some (11, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(range_request), field(11)" pk
    | Some (12, Pbrt.Varint) -> begin
      v.min_create_revision <- Pbrt.Decoder.int64_as_varint d;
    end
    | Some (12, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(range_request), field(12)" pk
    | Some (13, Pbrt.Varint) -> begin
      v.max_create_revision <- Pbrt.Decoder.int64_as_varint d;
    end
    | Some (13, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(range_request), field(13)" pk
    | Some (_, payload_kind) -> Pbrt.Decoder.skip d payload_kind
  done;
  ({
    Etcd_types.key = v.key;
    Etcd_types.range_end = v.range_end;
    Etcd_types.limit = v.limit;
    Etcd_types.revision = v.revision;
    Etcd_types.sort_order = v.sort_order;
    Etcd_types.sort_target = v.sort_target;
    Etcd_types.serializable = v.serializable;
    Etcd_types.keys_only = v.keys_only;
    Etcd_types.count_only = v.count_only;
    Etcd_types.min_mod_revision = v.min_mod_revision;
    Etcd_types.max_mod_revision = v.max_mod_revision;
    Etcd_types.min_create_revision = v.min_create_revision;
    Etcd_types.max_create_revision = v.max_create_revision;
  } : Etcd_types.range_request)

let rec decode_range_response d =
  let v = default_range_response_mutable () in
  let continue__= ref true in
  while !continue__ do
    match Pbrt.Decoder.key d with
    | None -> (
      v.kvs <- List.rev v.kvs;
    ); continue__ := false
    | Some (1, Pbrt.Bytes) -> begin
      v.header <- Some (decode_response_header (Pbrt.Decoder.nested d));
    end
    | Some (1, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(range_response), field(1)" pk
    | Some (2, Pbrt.Bytes) -> begin
      v.kvs <- (decode_key_value (Pbrt.Decoder.nested d)) :: v.kvs;
    end
    | Some (2, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(range_response), field(2)" pk
    | Some (3, Pbrt.Varint) -> begin
      v.more <- Pbrt.Decoder.bool d;
    end
    | Some (3, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(range_response), field(3)" pk
    | Some (4, Pbrt.Varint) -> begin
      v.count <- Pbrt.Decoder.int64_as_varint d;
    end
    | Some (4, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(range_response), field(4)" pk
    | Some (_, payload_kind) -> Pbrt.Decoder.skip d payload_kind
  done;
  ({
    Etcd_types.header = v.header;
    Etcd_types.kvs = v.kvs;
    Etcd_types.more = v.more;
    Etcd_types.count = v.count;
  } : Etcd_types.range_response)

let rec decode_put_request d =
  let v = default_put_request_mutable () in
  let continue__= ref true in
  while !continue__ do
    match Pbrt.Decoder.key d with
    | None -> (
    ); continue__ := false
    | Some (1, Pbrt.Bytes) -> begin
      v.key <- Pbrt.Decoder.bytes d;
    end
    | Some (1, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(put_request), field(1)" pk
    | Some (2, Pbrt.Bytes) -> begin
      v.value <- Pbrt.Decoder.bytes d;
    end
    | Some (2, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(put_request), field(2)" pk
    | Some (3, Pbrt.Varint) -> begin
      v.lease <- Pbrt.Decoder.int64_as_varint d;
    end
    | Some (3, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(put_request), field(3)" pk
    | Some (4, Pbrt.Varint) -> begin
      v.prev_kv <- Pbrt.Decoder.bool d;
    end
    | Some (4, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(put_request), field(4)" pk
    | Some (5, Pbrt.Varint) -> begin
      v.ignore_value <- Pbrt.Decoder.bool d;
    end
    | Some (5, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(put_request), field(5)" pk
    | Some (6, Pbrt.Varint) -> begin
      v.ignore_lease <- Pbrt.Decoder.bool d;
    end
    | Some (6, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(put_request), field(6)" pk
    | Some (_, payload_kind) -> Pbrt.Decoder.skip d payload_kind
  done;
  ({
    Etcd_types.key = v.key;
    Etcd_types.value = v.value;
    Etcd_types.lease = v.lease;
    Etcd_types.prev_kv = v.prev_kv;
    Etcd_types.ignore_value = v.ignore_value;
    Etcd_types.ignore_lease = v.ignore_lease;
  } : Etcd_types.put_request)

let rec decode_put_response d =
  let v = default_put_response_mutable () in
  let continue__= ref true in
  while !continue__ do
    match Pbrt.Decoder.key d with
    | None -> (
    ); continue__ := false
    | Some (1, Pbrt.Bytes) -> begin
      v.header <- Some (decode_response_header (Pbrt.Decoder.nested d));
    end
    | Some (1, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(put_response), field(1)" pk
    | Some (2, Pbrt.Bytes) -> begin
      v.prev_kv <- Some (decode_key_value (Pbrt.Decoder.nested d));
    end
    | Some (2, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(put_response), field(2)" pk
    | Some (_, payload_kind) -> Pbrt.Decoder.skip d payload_kind
  done;
  ({
    Etcd_types.header = v.header;
    Etcd_types.prev_kv = v.prev_kv;
  } : Etcd_types.put_response)

let rec encode_response_header (v:Etcd_types.response_header) encoder = 
  Pbrt.Encoder.key (1, Pbrt.Varint) encoder; 
  Pbrt.Encoder.int64_as_varint v.Etcd_types.cluster_id encoder;
  Pbrt.Encoder.key (2, Pbrt.Varint) encoder; 
  Pbrt.Encoder.int64_as_varint v.Etcd_types.member_id encoder;
  Pbrt.Encoder.key (3, Pbrt.Varint) encoder; 
  Pbrt.Encoder.int64_as_varint v.Etcd_types.revision encoder;
  Pbrt.Encoder.key (4, Pbrt.Varint) encoder; 
  Pbrt.Encoder.int64_as_varint v.Etcd_types.raft_term encoder;
  ()

let rec encode_key_value (v:Etcd_types.key_value) encoder = 
  Pbrt.Encoder.key (1, Pbrt.Bytes) encoder; 
  Pbrt.Encoder.bytes v.Etcd_types.key encoder;
  Pbrt.Encoder.key (2, Pbrt.Varint) encoder; 
  Pbrt.Encoder.int64_as_varint v.Etcd_types.create_revision encoder;
  Pbrt.Encoder.key (3, Pbrt.Varint) encoder; 
  Pbrt.Encoder.int64_as_varint v.Etcd_types.mod_revision encoder;
  Pbrt.Encoder.key (4, Pbrt.Varint) encoder; 
  Pbrt.Encoder.int64_as_varint v.Etcd_types.version encoder;
  Pbrt.Encoder.key (5, Pbrt.Bytes) encoder; 
  Pbrt.Encoder.bytes v.Etcd_types.value encoder;
  Pbrt.Encoder.key (6, Pbrt.Varint) encoder; 
  Pbrt.Encoder.int64_as_varint v.Etcd_types.lease encoder;
  ()

let rec encode_range_request_sort_order (v:Etcd_types.range_request_sort_order) encoder =
  match v with
  | Etcd_types.None -> Pbrt.Encoder.int_as_varint (0) encoder
  | Etcd_types.Ascend -> Pbrt.Encoder.int_as_varint 1 encoder
  | Etcd_types.Descend -> Pbrt.Encoder.int_as_varint 2 encoder

let rec encode_range_request_sort_target (v:Etcd_types.range_request_sort_target) encoder =
  match v with
  | Etcd_types.Key -> Pbrt.Encoder.int_as_varint (0) encoder
  | Etcd_types.Version -> Pbrt.Encoder.int_as_varint 1 encoder
  | Etcd_types.Create -> Pbrt.Encoder.int_as_varint 2 encoder
  | Etcd_types.Mod -> Pbrt.Encoder.int_as_varint 3 encoder
  | Etcd_types.Value -> Pbrt.Encoder.int_as_varint 4 encoder

let rec encode_range_request (v:Etcd_types.range_request) encoder = 
  Pbrt.Encoder.key (1, Pbrt.Bytes) encoder; 
  Pbrt.Encoder.bytes v.Etcd_types.key encoder;
  Pbrt.Encoder.key (2, Pbrt.Bytes) encoder; 
  Pbrt.Encoder.bytes v.Etcd_types.range_end encoder;
  Pbrt.Encoder.key (3, Pbrt.Varint) encoder; 
  Pbrt.Encoder.int64_as_varint v.Etcd_types.limit encoder;
  Pbrt.Encoder.key (4, Pbrt.Varint) encoder; 
  Pbrt.Encoder.int64_as_varint v.Etcd_types.revision encoder;
  Pbrt.Encoder.key (5, Pbrt.Varint) encoder; 
  encode_range_request_sort_order v.Etcd_types.sort_order encoder;
  Pbrt.Encoder.key (6, Pbrt.Varint) encoder; 
  encode_range_request_sort_target v.Etcd_types.sort_target encoder;
  Pbrt.Encoder.key (7, Pbrt.Varint) encoder; 
  Pbrt.Encoder.bool v.Etcd_types.serializable encoder;
  Pbrt.Encoder.key (8, Pbrt.Varint) encoder; 
  Pbrt.Encoder.bool v.Etcd_types.keys_only encoder;
  Pbrt.Encoder.key (9, Pbrt.Varint) encoder; 
  Pbrt.Encoder.bool v.Etcd_types.count_only encoder;
  Pbrt.Encoder.key (10, Pbrt.Varint) encoder; 
  Pbrt.Encoder.int64_as_varint v.Etcd_types.min_mod_revision encoder;
  Pbrt.Encoder.key (11, Pbrt.Varint) encoder; 
  Pbrt.Encoder.int64_as_varint v.Etcd_types.max_mod_revision encoder;
  Pbrt.Encoder.key (12, Pbrt.Varint) encoder; 
  Pbrt.Encoder.int64_as_varint v.Etcd_types.min_create_revision encoder;
  Pbrt.Encoder.key (13, Pbrt.Varint) encoder; 
  Pbrt.Encoder.int64_as_varint v.Etcd_types.max_create_revision encoder;
  ()

let rec encode_range_response (v:Etcd_types.range_response) encoder = 
  begin match v.Etcd_types.header with
  | Some x -> 
    Pbrt.Encoder.key (1, Pbrt.Bytes) encoder; 
    Pbrt.Encoder.nested (encode_response_header x) encoder;
  | None -> ();
  end;
  List.iter (fun x -> 
    Pbrt.Encoder.key (2, Pbrt.Bytes) encoder; 
    Pbrt.Encoder.nested (encode_key_value x) encoder;
  ) v.Etcd_types.kvs;
  Pbrt.Encoder.key (3, Pbrt.Varint) encoder; 
  Pbrt.Encoder.bool v.Etcd_types.more encoder;
  Pbrt.Encoder.key (4, Pbrt.Varint) encoder; 
  Pbrt.Encoder.int64_as_varint v.Etcd_types.count encoder;
  ()

let rec encode_put_request (v:Etcd_types.put_request) encoder = 
  Pbrt.Encoder.key (1, Pbrt.Bytes) encoder; 
  Pbrt.Encoder.bytes v.Etcd_types.key encoder;
  Pbrt.Encoder.key (2, Pbrt.Bytes) encoder; 
  Pbrt.Encoder.bytes v.Etcd_types.value encoder;
  Pbrt.Encoder.key (3, Pbrt.Varint) encoder; 
  Pbrt.Encoder.int64_as_varint v.Etcd_types.lease encoder;
  Pbrt.Encoder.key (4, Pbrt.Varint) encoder; 
  Pbrt.Encoder.bool v.Etcd_types.prev_kv encoder;
  Pbrt.Encoder.key (5, Pbrt.Varint) encoder; 
  Pbrt.Encoder.bool v.Etcd_types.ignore_value encoder;
  Pbrt.Encoder.key (6, Pbrt.Varint) encoder; 
  Pbrt.Encoder.bool v.Etcd_types.ignore_lease encoder;
  ()

let rec encode_put_response (v:Etcd_types.put_response) encoder = 
  begin match v.Etcd_types.header with
  | Some x -> 
    Pbrt.Encoder.key (1, Pbrt.Bytes) encoder; 
    Pbrt.Encoder.nested (encode_response_header x) encoder;
  | None -> ();
  end;
  begin match v.Etcd_types.prev_kv with
  | Some x -> 
    Pbrt.Encoder.key (2, Pbrt.Bytes) encoder; 
    Pbrt.Encoder.nested (encode_key_value x) encoder;
  | None -> ();
  end;
  ()
