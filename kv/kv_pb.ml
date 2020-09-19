[@@@ocaml.warning "-27-30-39"]

type get_request_mutable = {
  mutable key : string;
}

let default_get_request_mutable () : get_request_mutable = {
  key = "";
}

type get_response_mutable = {
  mutable value : string;
}

let default_get_response_mutable () : get_response_mutable = {
  value = "";
}

type set_request_mutable = {
  mutable key : string;
  mutable value : string;
}

let default_set_request_mutable () : set_request_mutable = {
  key = "";
  value = "";
}

type set_response_mutable = {
  mutable ok : bool;
}

let default_set_response_mutable () : set_response_mutable = {
  ok = false;
}


let rec decode_get_request d =
  let v = default_get_request_mutable () in
  let continue__= ref true in
  while !continue__ do
    match Pbrt.Decoder.key d with
    | None -> (
    ); continue__ := false
    | Some (1, Pbrt.Bytes) -> begin
      v.key <- Pbrt.Decoder.string d;
    end
    | Some (1, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(get_request), field(1)" pk
    | Some (_, payload_kind) -> Pbrt.Decoder.skip d payload_kind
  done;
  ({
    Kv_types.key = v.key;
  } : Kv_types.get_request)

let rec decode_get_response d =
  let v = default_get_response_mutable () in
  let continue__= ref true in
  while !continue__ do
    match Pbrt.Decoder.key d with
    | None -> (
    ); continue__ := false
    | Some (1, Pbrt.Bytes) -> begin
      v.value <- Pbrt.Decoder.string d;
    end
    | Some (1, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(get_response), field(1)" pk
    | Some (_, payload_kind) -> Pbrt.Decoder.skip d payload_kind
  done;
  ({
    Kv_types.value = v.value;
  } : Kv_types.get_response)

let rec decode_set_request d =
  let v = default_set_request_mutable () in
  let continue__= ref true in
  while !continue__ do
    match Pbrt.Decoder.key d with
    | None -> (
    ); continue__ := false
    | Some (1, Pbrt.Bytes) -> begin
      v.key <- Pbrt.Decoder.string d;
    end
    | Some (1, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(set_request), field(1)" pk
    | Some (2, Pbrt.Bytes) -> begin
      v.value <- Pbrt.Decoder.string d;
    end
    | Some (2, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(set_request), field(2)" pk
    | Some (_, payload_kind) -> Pbrt.Decoder.skip d payload_kind
  done;
  ({
    Kv_types.key = v.key;
    Kv_types.value = v.value;
  } : Kv_types.set_request)

let rec decode_set_response d =
  let v = default_set_response_mutable () in
  let continue__= ref true in
  while !continue__ do
    match Pbrt.Decoder.key d with
    | None -> (
    ); continue__ := false
    | Some (1, Pbrt.Varint) -> begin
      v.ok <- Pbrt.Decoder.bool d;
    end
    | Some (1, pk) -> 
      Pbrt.Decoder.unexpected_payload "Message(set_response), field(1)" pk
    | Some (_, payload_kind) -> Pbrt.Decoder.skip d payload_kind
  done;
  ({
    Kv_types.ok = v.ok;
  } : Kv_types.set_response)

let rec encode_get_request (v:Kv_types.get_request) encoder = 
  Pbrt.Encoder.key (1, Pbrt.Bytes) encoder; 
  Pbrt.Encoder.string v.Kv_types.key encoder;
  ()

let rec encode_get_response (v:Kv_types.get_response) encoder = 
  Pbrt.Encoder.key (1, Pbrt.Bytes) encoder; 
  Pbrt.Encoder.string v.Kv_types.value encoder;
  ()

let rec encode_set_request (v:Kv_types.set_request) encoder = 
  Pbrt.Encoder.key (1, Pbrt.Bytes) encoder; 
  Pbrt.Encoder.string v.Kv_types.key encoder;
  Pbrt.Encoder.key (2, Pbrt.Bytes) encoder; 
  Pbrt.Encoder.string v.Kv_types.value encoder;
  ()

let rec encode_set_response (v:Kv_types.set_response) encoder = 
  Pbrt.Encoder.key (1, Pbrt.Varint) encoder; 
  Pbrt.Encoder.bool v.Kv_types.ok encoder;
  ()
